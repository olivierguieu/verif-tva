//
//  VerificationNumeroTVAViewController.m
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SDZcheckVatService.h"
#import "VerificationNumeroTVAViewController.h"
#import "CSRegex.h"
#import "VerificationNumeroTVAAppDelegate.h"
#import "Helpers.h"



#pragma mark -

@implementation VerificationNumeroTVAViewController

#pragma mark -
#pragma mark Properties

@synthesize tvaNumField;
@synthesize tvaPrefixLabel;
@synthesize countryPicker;
@synthesize countryList;
@synthesize checkVATButton;
@synthesize VATFormatLabel;

@synthesize VATCodesDictionnary;
@synthesize sVatNumber;
@synthesize sCountryCode;

// Localisation
@synthesize VATNumberLabel;
@synthesize MemberStateLabel;


- (void)dealloc
{
    
    [tvaNumField    release];
    [tvaPrefixLabel release];
    
    [countryPicker  release];
    [countryList    release];
    
    [checkVATButton release];
    [VATFormatLabel release];

    [sVatNumber     release];
    [sCountryCode   release];
    
	[VATCodesDictionnary release];
    
    
    // Localisation
    [VATNumberLabel release];
    [MemberStateLabel release];

    [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Gestion de la saisie ds le textField
- (IBAction) textFieldDoneEditing:(id) sender
{
    [self updateCheckButtonStatus];
    [sender resignFirstResponder];
    
}

- (IBAction) backgroundClick:(id) sender
{
    [self updateCheckButtonStatus ];

    [tvaNumField resignFirstResponder];
    [countryPicker resignFirstResponder];
}

#pragma  mark -     
#pragma mark - Picker data Source method
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [countryList count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *info = [VATCodesDictionnary objectForKey:[countryList objectAtIndex:row]];
    return [info objectAtIndex:0];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [self updateCheckButtonStatus]; // le pays a changé, la regex est peut etre désormais valide ... 
}




- (void) updateDescription:(NSString *) description regex:(NSString *)regex
{       
    NSString *fullDescription = [[NSString alloc] initWithFormat:@"%@: %@" , regex, description];
    VATFormatLabel.text = fullDescription;
    [fullDescription release];
}


#pragma mark -
#pragma mark - VatVerification method
- (Boolean) isFormallyValidVatNumber
{
    
//#ifdef DEBUG
//    NSLog(@"[isFormallyValidVatNumber]: in %@ at line %d, countryCode <%@>", NSStringFromSelector(_cmd), __LINE__, sCountryCode);
//#endif
    
    Boolean bMatch;
    
    
    // recuperation de la regex...
    NSInteger selectedRow;
    selectedRow = [self.countryPicker selectedRowInComponent:0];
    NSString *selectedCountry = [ self.countryList objectAtIndex:selectedRow];
    
    NSArray *info = [VATCodesDictionnary objectForKey:selectedCountry];
    NSString *regex = [[NSString alloc] initWithFormat:@"%@" , [info objectAtIndex:1]];
    
    // on en profite pour mettre à jour l'info descriptive...
    NSString *description = [[NSString alloc] initWithFormat:@"%@" , [info objectAtIndex:2]];
    
    [self updateDescription:description regex:regex];
    
    NSString    *sFullVatNumber = [[NSString alloc] initWithFormat:@"%@%@",sCountryCode,sVatNumber];
    
    if (verifyRegexBeforeCheckingVIES == FALSE)
    {
        bMatch= ([sVatNumber length] > 0 );
        
    }
    else
    {
        bMatch = [sFullVatNumber matchedByPattern:regex];
    }
    
//#ifdef DEBUG
//    NSLog(@"[isFormallyValidVatNumber]: in %@ at line %d, regex <%@>", NSStringFromSelector(_cmd), __LINE__, regex);
//    NSLog(@"[isFormallyValidVatNumber]: in %@ at line %d, sVatNumber <%@>", NSStringFromSelector(_cmd), __LINE__, sVatNumber);
//    NSLog(@"[isFormallyValidVatNumber]: in %@ at line %d, res <%d>", NSStringFromSelector(_cmd), __LINE__, bMatch);
//#endif
    
    [regex release];
    [description release];
    [sFullVatNumber release];
    
    
    return bMatch;
}

- (void) updateVatData
{
    NSInteger selectedRow;
    selectedRow = [self.countryPicker selectedRowInComponent:0];
    
    sCountryCode=[ self.countryList objectAtIndex:selectedRow];
    tvaPrefixLabel.text= sCountryCode;
    
    sVatNumber=[[NSString alloc] initWithFormat:@"%@" , [tvaNumField text] ];
    
    
}

//@class VerificationNumeroTVAAppDelegate;
- (IBAction)checkVatNumber
{
    
#ifdef DEBUG
    NSLog(@"[checkVatNumber]: in %@ at line %d", NSStringFromSelector(_cmd), __LINE__);
#endif    
    
    

    
    if ( [AppDelegate checkForNetworkAndWS ] != nil )
    {
#ifdef DEBUG
        NSLog(@"[checkVatNumber]: in %@ at line %d: checkForNetwork = <%d>", NSStringFromSelector(_cmd), __LINE__, FALSE);
#endif
        [self displayNetworkRequestedForCheckVat];
        return;
   
    }
    
    // le reseau est OK... 
    [self updateVatData];
    
    if ( [self isFormallyValidVatNumber] == true)
    {
//#ifdef DEBUG
//        NSLog(@"[checkVatNumber]: in %@ at line %d", NSStringFromSelector(_cmd), __LINE__);
//#endif
        
        // on bloque l'utilisation de la combo...
        self.countryPicker.userInteractionEnabled = NO;
        
		nbNetworkErrorDisplayed =0;
        SDZcheckVatService *service = [[SDZcheckVatService new] init];
        
//#ifdef DEBUG
//        service.logging = true;
//#endif
        
        // Rq: le sVatNumber ne contient PAS le prefixe du pays...
        // KO [service checkVat:self action:@selector(handleCheckVatResponse:) countryCode:@"FR" vatNumber:@"test"];
        // OK [service checkVat:self action:@selector(handleCheckVatResponse:) countryCode:@"FR" vatNumber:@"93956513147"];
        // Quand il fallait enlever le prefixe... [service checkVat:self action:@selector(handleCheckVatResponse:) countryCode:sCountryCode vatNumber:[sVatNumber substringWithRange:NSMakeRange(2, ([sVatNumber length]-2 )) ]];
        [service checkVat:self action:@selector(handleCheckVatResponse:) countryCode:sCountryCode vatNumber:sVatNumber];
        
#ifdef DEBUG
        NSLog(@"[checkVatNumber]: in %@ at line %d, sCountryCode<%@>, sVatNumber<%@>", NSStringFromSelector(_cmd), __LINE__, sCountryCode, sVatNumber);
#endif
        
    }
#ifdef DEBUG    
    NSLog(@"[checkVatNumber]: in %@ at line %d", NSStringFromSelector(_cmd), __LINE__);
#endif
}



- (void) handleCheckVatResponse: (id) value
{
    // on reactive l'utilisation de la combo...
    self.countryPicker.userInteractionEnabled = YES;
    
    if (value == nil)
    {
        
//#ifdef DEBUG        
//        NSLog(@"[handleCheckVatResponse]: in %@ at line %d, error %@", NSStringFromSelector(_cmd), __LINE__, value);
//#endif
        
		[self displayErrorInCheckVatResponse: value];
        return;
    }
    
    if ([value isKindOfClass:[NSError class] ])
    {
        
//#ifdef DEBUG        
//        NSLog(@"[handleCheckVatResponse]: in %@ at line %d, error %@", NSStringFromSelector(_cmd), __LINE__, value);
//#endif
        
		[self displayErrorInCheckVatResponse: value];
        return;
    }
    
    if ([ value  isKindOfClass:[SoapFault class]] )
    {
        
//#ifdef DEBUG
//        NSLog(@"[handleCheckVatResponse]: in %@ at line %d, error %@", NSStringFromSelector(_cmd), __LINE__, value);
//#endif
        
		[self displayErrorInCheckVatResponse: value];
        
		return;
    }
    
    // handling results..
    NSMutableDictionary *strDico = value;
    Boolean bIsValidVAT = FALSE;
    NSString *name= [[NSString alloc] initWithFormat:@"%@",[Helpers languageSelectedStringForKey:@"UNKNOWN"]];
    NSString *address = [[NSString alloc] initWithFormat:@"%@",[Helpers languageSelectedStringForKey:@"UNKNOWN"]];
    
    NSString *key;
    for (key in strDico) {
        
//#ifdef DEBUG
//        NSLog(@"[handleCheckVatResponse]: key <%@>, value <%@>", key, [strDico objectForKey:key]);
//#endif
        
        if ( [key isEqualToString:@"valid"] && [[strDico objectForKey:key] isEqualToString:@"true"])  
        {
            bIsValidVAT = TRUE;
        }
        if ( [key isEqualToString:@"name"] )  
        {
            [name release];
            name=[[NSString alloc] initWithFormat:@"%@", [strDico objectForKey:key]];
        }
        if ( [key isEqualToString:@"address"] )  
        {
            [address release];
            address=[[NSString alloc] initWithFormat:@"%@", [strDico objectForKey:key]];
        }
        
    }
    
    // Ajout de la demande et de sa réponse
    VIESResponse *viesResponse=[[VIESResponse alloc] initWithData:bIsValidVAT Name:name Address:address CountryCode:sCountryCode VATNumber:sVatNumber RequestDate:[NSDate date]];
    [[AppDelegate listOfResults] addToHistory:viesResponse];
    
    [AppDelegate updateBadgeValue];
    
    [self displayCheckVatResponse:viesResponse];
    
    [name release];
    [address release];
}


#pragma mark -
#pragma mark display answers

- (void) displayNetworkRequestedForCheckVat 
{
#ifdef DEBUG
    NSLog(@"[displayNetworkRequestedForCheckVat]: in %@ at line %d", NSStringFromSelector(_cmd), __LINE__);
#endif
    
 	NSString *msg = [[NSString alloc] initWithFormat:@"%@",[Helpers languageSelectedStringForKey:@"NETWORK_ACCESS_IS_REQUESTED"]];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helpers languageSelectedStringForKey:@"NO_NETWORK"] message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	[alert show];
	[alert release];
	[msg release];
}

- (void) displayErrorInCheckVatResponse: (id) error
{
//#ifdef DEBUG
//    NSLog(@"[displayErrorInCheckVatResponse]: in %@ at line %d", NSStringFromSelector(_cmd), __LINE__);
//#endif
    
    if ( ++nbNetworkErrorDisplayed == 1)
	{
		NSString *msg = nil;
        if (error == nil)
        {   // WS is probably not available
            msg = [[NSString alloc] initWithFormat:[Helpers languageSelectedStringForKey:@"ERROR_ENCOUNTERED_NO_WS_MSG"] , error];		
        }
        else
        {
            msg = [[NSString alloc] initWithFormat:[Helpers languageSelectedStringForKey:@"ERROR_ENCOUNTERED_MSG"] , error];
		}
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helpers languageSelectedStringForKey:@"ERROR_ENCOUNTERED_TITLE"] message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		[msg release];
	}
	
}

- (void) displayCheckVatResponse: (VIESResponse *) viesResponse
{
#ifdef DEBUG
    NSLog(@"[displayCheckVatResponse]: in %@ at line %d", NSStringFromSelector(_cmd), __LINE__);
#endif
    
    NSMutableString *msg = nil;
    if ( viesResponse.IsValidVATNumber )
    {
        msg = [[NSMutableString alloc] initWithFormat:[Helpers languageSelectedStringForKey:@"VAT_VALIDATION_MSG_VALID"] , viesResponse.CountryCode, viesResponse.VATNumber];
        
        if ( [viesResponse.Name caseInsensitiveCompare:[Helpers languageSelectedStringForKey:@"UNKNOWN"]])
        {
            [msg appendFormat:@"\n(%@ - %@)",viesResponse.Name,viesResponse.Address];
        }
    }
    else
    {
        msg = [[NSMutableString alloc] initWithFormat:[Helpers languageSelectedStringForKey:@"VAT_VALIDATION_MSG_INVALID"] , viesResponse.CountryCode, viesResponse.VATNumber];
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helpers languageSelectedStringForKey:@"VAT_VALIDATION_TITLE"] message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
    [msg release];
}



#pragma mark -
#pragma mark userSettings

// updates localized title of toolbar item
- (void) updateTitle {
    self.title = [Helpers languageSelectedStringForKey:@"VERIFY_LABEL"];
}

// show or hide regex expression 
- (void) displayDescription
{
    if ( displayRegexAndHelpForVatStructure == TRUE )
    {
        [ self.VATFormatLabel setHidden:FALSE];
    }
    else
    {
        [ self.VATFormatLabel setHidden:TRUE];
    }
}

- (void) updateViewBasedOnUserSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
//#ifdef DEBUG    
//    NSString *key;
//    for (key in [defaults dictionaryRepresentation]) {
//        NSLog(@"in viewDidLoad: key <%@>, value <%@>", key, [defaults objectForKey:key]);
//    }
//#endif
    
    displayRegexAndHelpForVatStructure  = ([[defaults objectForKey:@"show_Regex"] isEqualToString:sYES]?TRUE:FALSE);  
    verifyRegexBeforeCheckingVIES  = ([[defaults objectForKey:@"verify_Regex"] isEqualToString:sYES]?TRUE:FALSE);
    
    [self isFormallyValidVatNumber];
    
    VATNumberLabel.text = [Helpers languageSelectedStringForKey:@"LABEL_VAT_NUMBER"];
    MemberStateLabel.text = [Helpers languageSelectedStringForKey:@"LABEL_MEMBER_STATE"];
    
    [checkVATButton setTitle:[Helpers languageSelectedStringForKey:@"BUTTON_VERIFY_ENABLED"]  forState:UIControlStateNormal];
    [checkVATButton setTitle:[Helpers languageSelectedStringForKey:@"BUTTON_VERIFY_DISABLED"] forState:UIControlStateDisabled];
    
    [self updateTitle];
    [self displayDescription];
    
}

#pragma mark - View lifecycle

- (void)awakeFromNib {
   [self updateTitle];
}

NSInteger alphabeticSort(id string1, id string2, void *reverse)
{
    if (*(BOOL *)reverse == YES) {
        return [string2 localizedCaseInsensitiveCompare:string1];
    }
    return [string1 localizedCaseInsensitiveCompare:string2];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
#ifdef DEBUG
    NSLog(@"[viewDidLoad]: in %@ at line %d.", NSStringFromSelector(_cmd), __LINE__);
#endif 
    
	nbNetworkErrorDisplayed = 0;

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"VATIdentificationNumberStructure" ofType:@"plist"];
    
    VATCodesDictionnary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    /* TODO KO sur < 4.x
    self.countryList = [[VATCodesDictionnary allKeys] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
        NSString *str1 = obj1;
        NSString *str2 = obj2;
        return [str1 caseInsensitiveCompare:str2]; }];;
      */
    
    BOOL reverseSort = NO;
    self.countryList = [[VATCodesDictionnary allKeys] sortedArrayUsingFunction:alphabeticSort context:&reverseSort];
    
    [self updateCheckButtonStatus];
    
    // localisation & user settings
    
#ifdef DEBUG
    NSLocale *locale = [NSLocale currentLocale];
    NSString *displayNameString = [locale displayNameForKey:NSLocaleIdentifier value:[locale localeIdentifier]];
    NSLog(@"in viewDidLoad: locale <%@>", displayNameString);
#endif

    [self updateViewBasedOnUserSettings];  
 
    [AppDelegate startReachability];

#ifdef DEBUG
    NSLog(@"[viewDidLoad]: in %@ at line %d.", NSStringFromSelector(_cmd), __LINE__);
#endif 
    
    [super viewDidLoad];
}






- (void) updateCheckButtonStatus
{
    [self updateVatData];
    
    if ( [self isFormallyValidVatNumber] ) {
        [checkVATButton setEnabled: YES];
    }
    else {
        [checkVATButton setEnabled: NO];
    }

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [Helpers shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#ifdef __IPHONE_3_0
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
#else
    - (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {    
        UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
#endif
        
        CGRect VATFormatLabelFramePortrait = CGRectMake(8,329,304,37);
        CGRect checkVATButtonFramePortrait = CGRectMake(8,366,303,37);
        
        CGRect VATFormatLabelFrameLandscape = CGRectMake(250,100,200,37);
        CGRect checkVATButtonFrameLandscape = CGRectMake(250,200,200,37);
              

        CGRect countryPickerPortrait = CGRectMake(-5, 105, 331, 216);
        CGRect countryPickerLandscape = CGRectMake(-5, 105, 200, 162);
        
        if (interfaceOrientation == UIInterfaceOrientationPortrait 
            || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            countryPicker.frame=countryPickerPortrait;
 
            VATFormatLabel.frame = VATFormatLabelFramePortrait;
            checkVATButton.frame = checkVATButtonFramePortrait;
        }
        else 
        {
            countryPicker.frame=countryPickerLandscape;
            
            VATFormatLabel.frame = VATFormatLabelFrameLandscape;
            checkVATButton.frame = checkVATButtonFrameLandscape;
        }
    }
 





@end
