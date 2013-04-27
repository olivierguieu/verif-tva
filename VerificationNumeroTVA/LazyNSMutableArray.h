//
//  LazyNSMutableArray.h
//  VerificationNumeroTVA
//
//  Created by Olivier Guieu on 29/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VIESResponse.h"


@interface LazyNSMutableArray : NSObject
{
    NSMutableArray      *backingStore;
    
    Boolean             bLoaded;
    Boolean             bDirty;
    int                 maxItems;
}

@property (nonatomic, retain) NSMutableArray *backingStore;

- (id)   init;
- (void) loadHistory;
- (void) addToHistory: (VIESResponse*) viesResponse;
- (void) saveHistory;
- (void) applyMaxLimit;
- (void) emptyHistory;
- (int)  getHistoryCount;
- (void) removeItemAtIndex: (int) index;
- (id)   objectAtIndex: (int) row;

@end
