//
//  LazyNSMutableArray.m
//  VerificationNumeroTVA
//
//  Created by Olivier Guieu on 29/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "LazyNSMutableArray.h"
#define MAX_HISTORY_SIZE 50

@implementation LazyNSMutableArray
@synthesize  backingStore;

- (id)init
{
    self = [super init];
    if (self) {        
        bLoaded=FALSE;
        bDirty=FALSE;
        /*
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *selectedOption = [defaults objectForKey:@"historySize"];
        maxItems  = [ selectedOption intValue];
         */
    }
    
    return self;
}

- (void)dealloc
{
    [backingStore release];
    [super dealloc];
}


- (void) loadHistory
{
    if ( bLoaded == FALSE)
    {        
        NSString *filePath = [Helpers dataFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSMutableData *rData = [[NSMutableData alloc]
                                    initWithContentsOfFile:filePath];
            NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:rData];
            if (oldSavedArray != nil)
                backingStore = [[NSMutableArray alloc] initWithArray:oldSavedArray];
            else
                backingStore = [[NSMutableArray alloc] init];
            
        }
        else
        {
            backingStore=[[NSMutableArray alloc] initWithCapacity:0];
        }
            
        bLoaded=TRUE;
        bDirty=FALSE;
    }
    
    [self applyMaxLimit];
}

- (void) addToHistory:(VIESResponse*) viesResponse {
    
    [self loadHistory];  
    
    // on veut au + maxItems-1 ds listOfresults
    while ( [backingStore count] >= MAX_HISTORY_SIZE )
    {
        [backingStore removeObjectAtIndex:0];
    }
    
    [backingStore addObject:viesResponse];
    bDirty=TRUE;      
}

- (void) saveHistory
{
    BOOL bResWriteToFile;
    
    if (bLoaded == TRUE ) 
    {
        if ( bDirty == TRUE )
        {
            NSData* viesData = [NSKeyedArchiver archivedDataWithRootObject:backingStore];
            bResWriteToFile = [viesData writeToFile:[Helpers dataFilePath] atomically:YES];
            
            bDirty = FALSE;
            
#ifdef DEBUG
            NSLog(@"[saveHistory]: in %@ at line %d: <%d>", NSStringFromSelector(_cmd), __LINE__, bResWriteToFile);
#endif
        }

        bLoaded = FALSE;
        [backingStore release];
    }
}

- (void) applyMaxLimit
{
    if (bLoaded == TRUE )
    {
        while ( [backingStore count] > MAX_HISTORY_SIZE )
        {
            [backingStore removeObjectAtIndex:0];
            bDirty=TRUE;
        }
    }          
}

- (void) emptyHistory
{
    [backingStore removeAllObjects];
    bDirty=TRUE;
}

- (int) getHistoryCount
{
    [self loadHistory];  
    return [backingStore count];    
}

- (void) removeItemAtIndex: (int) index
{
    [self loadHistory]; 
    [backingStore removeObjectAtIndex:index];   
    bDirty=TRUE;
}

- (id)   objectAtIndex: (int) row
{
    [self loadHistory]; 
    return [backingStore objectAtIndex:row];   
}
@end
