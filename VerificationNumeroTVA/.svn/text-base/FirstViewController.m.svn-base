//
//  VerificationNumeroTVAViewController.m
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SDZcheckVatService.h"
#import "FirstViewController.h"
#import "CSRegex.h"


#pragma mark -
@implementation FirstViewController

#pragma mark - Properties

@synthesize tvaNumField;
@synthesize tvaPrefixLabel;

// iPodView
@synthesize countryPicker;

// iPadView
@synthesize tableView, lastIndexPath;

@synthesize countryList;
@synthesize checkVATButton;
@synthesize VATFormatLabel;

@synthesize VATCodesDictionnary;
@synthesize sVatNumber;
@synthesize sCountryCode;

// Localisation
@synthesize VATNumberLabel;
@synthesize MemberStateLabel;


@synthesize backgroundImageView;



#pragma mark - Gestion de la saisie ds le textField
- (IBAction) textFieldDoneEditing:(id) sender
{
    [self updateCheckButtonStatusWithIndex:-1];
    [sender resignFirstResponder];
    
}

- (IBAction) backgroundClick:(id) sender
{
    [self updateCheckButtonStatusWithIndex:-1 ];

    [tvaNumField resignFirstResponder];
    [countryPicker resignFirstResponder];
}

     

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    // Check if the added string contains lowercase characters.
    // If so, those characters are replaced by uppercase characters.
    // But this has the effect of losing the editing point
    // (only when trying to edit with lowercase characters),
    // because the text of the UITextField is modified.
    // That is why we only replace the text when this is really needed.
    NSRange lowercaseCharRange;
    lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        
        tvaNumField.text = [tvaNumField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    
    return YES;
}

#pragma mark - Picker data Source method

- (void)countryPicker:(CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code
{
    [self updateCheckButtonStatusWithIndex:-1]; // le pays a changé, la regex est peut etre désormais valide ... 
}


- (void) updateDescription:(NSString *) description regex:(NSString *)regex
{       
    NSString *fullDescription = [[NSString alloc] initWithFormat:@"%@: %@" , regex, description];
    VATFormatLabel.text = fullDescription;
    [fullDescription release];
}




#pragma mark - Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)myTableView 
{
	// There is only one section.
	return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView  numberOfRowsInSection:(NSInteger)section 
{
    return [countryList count];
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier.
	UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier.
	if (cell == nil) {
		// Use the default cell style.
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
	}
	
    NSUInteger row= [indexPath row];
    NSUInteger oldRow = [self.lastIndexPath row];
    
    // Set up the cell.
	NSArray *info = [VATCodesDictionnary objectForKey:[countryList objectAtIndex:indexPath.row]];
    cell.textLabel.text = [info objectAtIndex:0];
	cell.accessoryType = (row == oldRow && self.lastIndexPath != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
	return cell;
}

- (void)tableView:(UITableView *)myTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int newRow = [indexPath row];
    int oldRow = (self.lastIndexPath != nil) ? [self.lastIndexPath row] : -1;
    
    if (newRow != oldRow)
    {
        UITableViewCell *newCell = [myTableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [myTableView cellForRowAtIndexPath:lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        self.lastIndexPath = indexPath;
    }
    
    [myTableView deselectRowAtIndexPath:indexPath animated:YES]; 
    
    [self updateCheckButtonStatusWithIndex:([indexPath row])]; // le pays a changé, la regex est peut etre désormais valide ... 
  
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [Helpers languageSelectedStringForKey:@"LABEL_MEMBER_STATE"];
}



#pragma mark - VatVerification method

- (NSInteger)getSelectedRow
{
    NSInteger selectedRow;

    // iPodView
    if (self.countryPicker)
    {
        selectedRow = [self.countryPicker selectedRowInComponent:0];
    }
    
    // iPadView
    if ( self.tableView)
    {
        if ( self.lastIndexPath ) 
        {
            selectedRow = [self.lastIndexPath row]; 
        }
        else
        {
            selectedRow = 0;
        }
    }
    
    return selectedRow;
}

- (Boolean) isFormallyValidVatNumber
{
    
//#ifdef DEBUG
//    NSLog(@"[isFormallyValidVatNumber]: in %@ at line %d, countryCode <%@>", NSStringFromSelector(_cmd), __LINE__, sCountryCode);
//#endif
    
    Boolean bMatch;
    
    
    // recuperation de la regex...
    NSInteger selectedRow = [self getSelectedRow];
    
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



- (void) sendCheckVatRequest
{
    // Rq: le sVatNumber ne contient PAS le prefixe du pays...
    // KO [service checkVat:self action:@selector(handleCheckVatResponse:) countryCode:@"FR" vatNumber:@"test"];
    // OK [service checkVat:self action:@selector(handleCheckVatResponse:) countryCode:@"FR" vatNumber:@"93956513147"];
    // Quand il fallait enlever le prefixe... [service checkVat:self action:@selector(handleCheckVatResponse:) countryCode:sCountryCode vatNumber:[sVatNumber substringWithRange:NSMakeRange(2, ([sVatNumber length]-2 )) ]];

    SDZcheckVatService *service = [[SDZcheckVatService new] init];
    [service checkVat:self action:@selector(handleCheckVatResponse:) countryCode:sCountryCode vatNumber:sVatNumber];
}


- (IBAction)checkVatNumber
{
    if ( [AppDelegate checkForNetworkAndWS ] != nil )
    {
        [self displayNetworkRequestedForCheckVat];
        return;
    }
    
    // le reseau est OK... 
    [self updateVatDataWithIndex:-1];
    
    if ( [self isFormallyValidVatNumber] == true)
    {
        // on bloque l'utilisation de la combo...
        self.countryPicker.userInteractionEnabled = NO;
        
		nbNetworkErrorDisplayed =0;
        
        HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
        
        SDZcheckVatService *service = [[SDZcheckVatService new] init];
        [service checkVat:self action:@selector(handleCheckVatResponse:) countryCode:sCountryCode vatNumber:sVatNumber];
        
#ifdef DEBUG
        NSLog(@"[checkVatNumber]: in %@ at line %d, sCountryCode<%@>, sVatNumber<%@>", NSStringFromSelector(_cmd), __LINE__, sCountryCode, sVatNumber);
#endif
        
    }
}



- (void) handleCheckVatResponse: (id) value
{
    // on reactive l'utilisation de la combo...
    self.countryPicker.userInteractionEnabled = YES;
    [HUD hide:YES];
    
    if (value == nil)
    {
		[self displayErrorInCheckVatResponse: value];
        return;
    }
    
    if ([value isKindOfClass:[NSError class] ])
    {
		[self displayErrorInCheckVatResponse: value];
        return;
    }
    
    if ([ value  isKindOfClass:[SoapFault class]] )
    {        
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


#pragma mark - display answers

- (void) displayNetworkRequestedForCheckVat 
{
//#ifdef DEBUG
//    NSLog(@"[displayNetworkRequestedForCheckVat]: in %@ at line %d", NSStringFromSelector(_cmd), __LINE__);
//#endif
    
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
//#ifdef DEBUG
//    NSLog(@"[displayCheckVatResponse]: in %@ at line %d", NSStringFromSelector(_cmd), __LINE__);
//#endif
    
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


#pragma mark - userSettings

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
        
        // on l'affiche en blanc s'il y a la bkground image
        if ( self.backgroundImageView.image )
        {
            self.VATFormatLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        }
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
    
    // iPodView
    MemberStateLabel.text = [Helpers languageSelectedStringForKey:@"LABEL_MEMBER_STATE"];
    
    // iPadView
    if (self.tableView)
    {
        [self.tableView reloadData];
    }
    
    [checkVATButton setTitle:[Helpers languageSelectedStringForKey:@"BUTTON_VERIFY_ENABLED"]  forState:UIControlStateNormal];
    [checkVATButton setTitle:[Helpers languageSelectedStringForKey:@"BUTTON_VERIFY_DISABLED"] forState:UIControlStateDisabled];
    
    [self updateTitle];
    [self displayDescription];
    
}

#pragma mark - View lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // define image
        self.tabBarItem.image = [UIImage imageNamed:@"06-magnify.png"];
        self.tabBarItem.tag = 1;
 
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"VATIdentificationNumberStructure" ofType:@"plist"];
        
        VATCodesDictionnary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        /* TODO KO sur < 4.x
         self.countryList = [[VATCodesDictionnary allKeys] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
         NSString *str1 = obj1;
         NSString *str2 = obj2;
         return [str1 caseInsensitiveCompare:str2]; }];;
         */
        
        BOOL reverseSort = NO;
        self.countryList = [[VATCodesDictionnary allKeys] sortedArrayUsingFunction:alphabeticSort context:&reverseSort];

        // a faire ds le initWithNibName et par la suite 
        [self updateTitle];

    }
    return self;
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
    
    [super viewDidLoad];

	nbNetworkErrorDisplayed = 0;

    // backgroundImageView Default@2x.png

// ne passe pas en memoire !!!
//    NSString *deviceType = [UIDevice currentDevice].model;
//    
//    if ([deviceType rangeOfString:@"iPhone"].location != NSNotFound) {
//        // It's an iPhone
//        self.backgroundImageView.image = [UIImage imageNamed:@"Default@2x.png"];
//    }
    
     
    // iPadView
    if ( self.tableView)
    {
        NSIndexPath *indexPath=[NSIndexPath  indexPathForRow:0 inSection:0];
        [self performSelector:@selector(tableView:didSelectRowAtIndexPath:) withObject:self.tableView withObject:indexPath];
        
    }
    
   
    [self updateCheckButtonStatusWithIndex:-1];
    
    // localisation & user settings
    [self updateViewBasedOnUserSettings];  
 
    
    [AppDelegate startReachability];    
}


- (void) updateCheckButtonStatusWithIndex:(NSInteger) selectedRow
{
    [self updateVatDataWithIndex:selectedRow];
    
    if ( [self isFormallyValidVatNumber] ) {
        [checkVATButton setEnabled: YES];
    }
    else {
        [checkVATButton setEnabled: NO];
    }
}

- (void) updateVatDataWithIndex:(NSInteger) selectedRow
{
    if ( selectedRow == -1 )
    { 
         selectedRow = [self getSelectedRow];
    }
    sCountryCode=[ self.countryList objectAtIndex:selectedRow];
    tvaPrefixLabel.text= sCountryCode;
    
    sVatNumber=[[NSString alloc] initWithFormat:@"%@" , [tvaNumField text] ];  
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


- (void)dealloc
{
    [HUD            release];
    
    
    [tvaNumField    release];
    [tvaPrefixLabel release];
    
    // iPadView
    [tableView      release];
    [lastIndexPath  release];
    
    // iPodView
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
    
    [backgroundImageView release];
    
    [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    if ( self.backgroundImageView.image)
    {
        [self.backgroundImageView.image release];
        self.backgroundImageView.image = nil;
    }
}


#ifdef __IPHONE_3_0
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
#else
    - (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {    
        UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
#endif
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
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
    }
 

    


@end
