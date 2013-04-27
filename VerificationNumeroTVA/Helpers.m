//
//  Helpers.m
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#define kFilename           @"data.plist"



@implementation Helpers

+ (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
        
    NSString *sRes = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:kFilename]];

    return [sRes autorelease];
}

+ (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
        return (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);

}

#pragma mark -
#pragma mark localization
+(NSString*) languageSelectedStringForKey:(NSString*) key selectedLanguage:(int) selectedLanguage
{
   
    // Default
  	NSString *path;
    
    switch (selectedLanguage) {
        case ENGLISH_LANGUAGE:
            path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            break;
        case ITALIAN_LANGUAGE:
            path = [[NSBundle mainBundle] pathForResource:@"it" ofType:@"lproj"];
            break;
        case SPANISH_LANGUAGE:
            path = [[NSBundle mainBundle] pathForResource:@"es" ofType:@"lproj"];
            break;
        case FRENCH_LANGUAGE:
            path = [[NSBundle mainBundle] pathForResource:@"fr" ofType:@"lproj"];
            break;
            
        default:
            path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            break;
    }
    
	NSBundle* languageBundle = [NSBundle bundleWithPath:path];
	NSString* str=[languageBundle localizedStringForKey:key value:@"" table:nil];
	return str;  
}

+ (NSString*) languageSelectedStringForKey:(NSString*) key
{
    return [Helpers languageSelectedStringForKey:key selectedLanguage:[AppDelegate selectedLanguage]];
    
}


#pragma mark -
#pragma mark user settings

// cf http://www.btjones.com/2010/05/nsuserdefaults-nil-setting-problem/
// The problem is if your application settings are never opened in the Settings app, when using NSUserDefaults to retrieve setting values within your application, they will be nil even if a DefaultValue is set in your settings bundle.

+ (void)setupDefaults {
    
    [Helpers setupDefaultsForPlist:@"Root.plist"];
    [Helpers setupDefaultsForPlist:@"Complete.plist"];
    
 
}

+ (void) setupDefaultsForPlist: (NSString*) pList {
    //get the plist location from the settings bundle
    NSString *settingsPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *plistPath = [settingsPath stringByAppendingPathComponent:pList];
    
    //get the preference specifiers array which contains the settings
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
    
    //use the shared defaults object
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //for each preference item, set its default if there is no value set
    for(NSDictionary *item in preferencesArray) {
        
        //get the item key, if there is no key then we can skip it
        NSString *key = [item objectForKey:@"Key"];
        if (key) {
            
            //check to see if the value and default value are set
            //if a default value exists and the value is not set, use the default
            id value = [defaults objectForKey:key];
            id defaultValue = [item objectForKey:@"DefaultValue"];
            if(defaultValue && !value) {
                [defaults setObject:defaultValue forKey:key];
            }
        }
    }
    
    //write the changes to disk
    [defaults synchronize];
}

#pragma mark -
#pragma mark Formatting WS URL
 + (NSString *) getWSURL
{
    return @"http://ec.europa.eu/taxation_customs/vies/services/checkVatService";
   
    /*
    //what needs to be returned .... self.serviceUrl = @"http://ec.europa.eu/taxation_customs/vies/services/checkVatService";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *base_URL = [defaults objectForKey:@"base_URL"];
    NSString *wsdl_URL = [defaults objectForKey:@"wsdl_URL"];
    
    NSString *fullURL=[[[NSString alloc] initWithFormat:@"http://%@/%@",base_URL, wsdl_URL] autorelease];
    return  fullURL;
    */
}


#pragma mark -
#pragma mark Formatting date
+ (NSString *) formatDate: (NSDate *) date  {
    //Create the dateformatter object           
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    //Set the required date format
    [formatter setDateFormat:@"yy/MM/dd"];  
    NSString* sDate = [formatter stringFromDate:date];
    return sDate;
}
@end
