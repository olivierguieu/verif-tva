//
//  Helpers.h
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define sYES @"YES"
#define sNO @"NO"

#define SPANISH_LANGUAGE    3
#define ITALIAN_LANGUAGE    2
#define ENGLISH_LANGUAGE    1
#define FRENCH_LANGUAGE     0


#ifdef TARGET_IPHONE_SIMULATOR
    #define DEBUG 1
#endif

@interface Helpers : NSObject {
    
}

+ (NSString *)dataFilePath;
+ (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

+ (NSString*) languageSelectedStringForKey:(NSString*) key;
+ (NSString*) languageSelectedStringForKey:(NSString*) key selectedLanguage:(int) selectedLanguage;

// cf http://www.btjones.com/2010/05/nsuserdefaults-nil-setting-problem/
// The problem is if your application settings are never opened in the Settings app, when using NSUserDefaults to retrieve setting values within your application, they will be nil even if a DefaultValue is set in your settings bundle.
+ (void)setupDefaults;
+ (void) setupDefaultsForPlist: (NSString *) pList;

+ (NSString *) getWSURL;
+ (NSString *) formatDate: (NSDate *) date ;
@end
