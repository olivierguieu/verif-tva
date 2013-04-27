//  ThirdViewController.m
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThirdViewController.h"
#import "VIESResponseCell.h"

@implementation ThirdViewController

@synthesize tableView;
@synthesize navigationItem;


#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // define image
        self.tabBarItem.image = [UIImage imageNamed:@"11-clock.png"];
        self.tabBarItem.tag = 3;
        
        self.tableView.delegate = self;       
        self.navigationItem = [[UINavigationItem alloc]init];
        
        // a faire ds le initWithNibName et par la suite 
        [self updateTitle];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateViewBasedOnUserSettings];
    
    // Do any additional setup after loading the view from its nib.

//    // TODO A REMETTRE ? 
//    //Petit fix pour forcer l'affichage des uibarbuttonitem ds le simulateur 4.X
//    UIBarButtonItem *rightButton= [navigationItem rightBarButtonItem];
//    if (rightButton == nil) 
//    {
//        UIBarButtonItem *myRightButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteHistoryButtonPressed:)];
//        [navigationItem setRightBarButtonItem:myRightButton];
//        [myRightButton release];
//    }
//    UIBarButtonItem *leftButton= [navigationItem leftBarButtonItem];
//    if (leftButton == nil) 
//    {
//        UIBarButtonItem *myLeftButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showEmailModalView)];
//        [navigationItem setLeftBarButtonItem:myLeftButton];
//        [myLeftButton release];
//    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [tableView              release];  
    [navigationItem         release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Table Data Source Methods

- (VIESResponseCell *) createNewCell {
    
    VIESResponseCell *newCell=nil;
    NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:@"VIESResponseCell" owner:self options:nil];
    
    NSObject *nibItem;
    for (nibItem in nibItems)
    {
        if ( [nibItem isKindOfClass:[VIESResponseCell class]] ) 
        {
            newCell = (VIESResponseCell *) nibItem;
            break;
        }
    }
    return  newCell;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    // Ajout de la demande et de sa réponse
    return [[AppDelegate listOfResults] getHistoryCount];
}


- (CGFloat) tableView:(UITableView *)myTableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    VIESResponseCell *cell = (VIESResponseCell *) [self tableView: myTableView cellForRowAtIndexPath: indexPath];
    return cell.bounds.size.height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ControlRowIdentifier = @"ControlRowIdentifier";
    
    VIESResponseCell *cell = [self.tableView 
                             dequeueReusableCellWithIdentifier:ControlRowIdentifier];
    
    if (cell == nil) {
        cell = [self createNewCell];
    }
 
    NSUInteger row = [indexPath row];
    LazyNSMutableArray *lRes = [AppDelegate listOfResults];
    VIESResponse *viesResponse = [lRes objectAtIndex:row];

    cell.VATNumberLabel.text = [[NSString alloc] initWithFormat:@"%@",[Helpers languageSelectedStringForKey:@"LABEL_VAT_NUMBER"]];
    
    cell.CountryLabel.text = [[NSString alloc] initWithFormat:@"%@",[Helpers languageSelectedStringForKey:@"LABEL_MEMBER_STATE"]];
    
    NSString *sFirtsRowLabel = [[NSString alloc] initWithFormat:@"%@ - (%@ %@)",viesResponse.CountryCode,[Helpers languageSelectedStringForKey:@"VERIFIED"], [Helpers formatDate:viesResponse.RequestDate]];

    cell.VATNumberValue.text = viesResponse.VATNumber;
    cell.CountryValue.text = sFirtsRowLabel;    

    cell.NameLabel.text=[[NSString alloc] initWithFormat:@"%@",[Helpers languageSelectedStringForKey:@"LABEL_NAME"]];
    cell.NameValue.text=viesResponse.Name;
    
    cell.AddressLabel.text=[[NSString alloc] initWithFormat:@"%@",[Helpers languageSelectedStringForKey:@"LABEL_ADDRESS"]];
    cell.AddressValue.text=viesResponse.Address;
    
    // image
    if ( viesResponse.IsValidVATNumber )
    {
        UIImage *imageForOK=[UIImage imageNamed:@"ok.png"];
        cell.ImageView.image=imageForOK;
    }
    else
    {
        UIImage *imageForKO=[UIImage imageNamed:@"ko.png"];
        cell.ImageView.image=imageForKO;   
    }

    return cell;
} 


#pragma mark - deletingRows
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // Ajout de la demande et de sa réponse
        [[AppDelegate listOfResults] removeItemAtIndex:[indexPath row]];
                
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        
        [self enableOrDisableStatusOfButtons];
        [AppDelegate updateBadgeValue];
    }  
}


#pragma mark - userSettings

- (void) updateTitle {
    
    NSString *title =  [Helpers languageSelectedStringForKey:@"HISTORY_LABEL"];
    
    self.title = title;
    [self.navigationItem setTitle:title];
}

- (void) updateViewBasedOnUserSettings
{    
   // [tableView reloadData];
    
    [self updateTitle];
    [self enableOrDisableStatusOfButtons];
}



#pragma mark - mngts of buttons

- (void) enableOrDisableStatusOfButtons
{
    int count = [[AppDelegate listOfResults] getHistoryCount];

    UIBarButtonItem *rightButton= [navigationItem rightBarButtonItem];
    UIBarButtonItem *leftButton= [navigationItem leftBarButtonItem];
    
    [rightButton setEnabled: (count>0)?YES:FALSE];
    [leftButton setEnabled: (count>0)?YES:FALSE];
 
}



#pragma mark - delete History button
- (IBAction)deleteHistoryButtonPressed:(id) sender
{   
    // avec la mise en place du shake on peut etre appele sans click .... 
    if ( [[AppDelegate listOfResults] getHistoryCount] > 0 )
    {
        // on demande d'abord une confirmation du delete ...   
//#ifdef DEBUG
//        NSLog(@"[deleteHistoryButtonPressed]: in %@ at line %d", NSStringFromSelector(_cmd), __LINE__);
//#endif
        
        NSString *msg = nil;
        msg = [[NSString alloc] initWithFormat:@"%@",[Helpers languageSelectedStringForKey:@"CONFIRM_DELETION_HISTORY"]];
        
        UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:[Helpers languageSelectedStringForKey:@""] message:msg delegate:self  cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        
        [alert show];
        [alert release];
        [msg release];

    }
    
}



- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
//#ifdef DEBUG
//    NSLog(@"[alertView]: in %@ at line %d", NSStringFromSelector(_cmd), __LINE__);
//#endif
     
    // the user clicked one of the OK button
    if (buttonIndex == 0)
    {
        [AppDelegate updateSelectedLanguageBasedOnUserSettings];
        [[AppDelegate listOfResults] emptyHistory];
        
        [self.tableView reloadData];
        
        [self enableOrDisableStatusOfButtons];
        [AppDelegate updateBadgeValue];
    }
}

#pragma mark - sendMail button

-(void) showEmailModalView {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self; 
    
    [picker setSubject:[Helpers languageSelectedStringForKey:@"FROM_VERIFTVA"] ];
    
    // Fill out the email body text
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];   
    NSString *defaulteMail = [defaults objectForKey:@"defaulteMail"];
    if ( ! [defaulteMail isEqualToString:@"()"])
    {
        NSArray *arrayOfRecipients= [[NSArray alloc] initWithObjects:defaulteMail, nil];
        [picker  setToRecipients:arrayOfRecipients];
        [arrayOfRecipients release];
    }

//#if 0
//    // exemple a utiliser pour ajouter par exemple un CSV... 
//    // Adding the application logo... 
//    NSString* pathToImageFile = [[NSBundle mainBundle] pathForResource:@"EuropeanUnion-57" ofType:@"png" inDirectory:@"."];
//    UIImage* image = [UIImage imageWithContentsOfFile:pathToImageFile];
//    NSData *data = UIImagePNGRepresentation(image);
//    [picker addAttachmentData:data mimeType:@"image/png" 
//                       fileName:@"EuropeanUnion-57.png"];
//#endif
    
     // test 
    NSMutableString *emailBody;
    if ([[AppDelegate listOfResults] getHistoryCount] == 0)
    {
        emailBody= [[NSMutableString alloc] initWithFormat:@"<p>%@</p>", [Helpers languageSelectedStringForKey:@"EMPTY_HISTORY" ]];
    }
    else
    {
        emailBody= [[NSMutableString alloc] initWithFormat:@"<table border=\"2\" bordercolor=GREY Style=\"dashed\"><caption>%@</caption><tr><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th></tr>",[Helpers languageSelectedStringForKey:@"HEADER_FOR_HISTORY"],[Helpers languageSelectedStringForKey:@"STATUS"],[Helpers languageSelectedStringForKey:@"LABEL_MEMBER_STATE"] ,[Helpers languageSelectedStringForKey:@"LABEL_VAT_NUMBER"],[Helpers languageSelectedStringForKey:@"LABEL_NAME"],[Helpers languageSelectedStringForKey:@"LABEL_ADDRESS"],[Helpers languageSelectedStringForKey:@"VERIFIED_ON_THE" ]];
    
//#ifdef DEBUG
//        NSLog(@"[showEmailModalView]: in %@ at line %d, emailBody %@", NSStringFromSelector(_cmd), __LINE__, emailBody);
//#endif
              
        VIESResponse *viesResponse;
        NSMutableArray *AllResponses = [[AppDelegate listOfResults] backingStore];
        for (viesResponse in AllResponses ) {
           
            NSString* sDate = [Helpers formatDate:viesResponse.RequestDate];
            
            NSString *stmp;
            if (viesResponse.IsValidVATNumber)
            {
                stmp = [[NSString  alloc] initWithFormat:@"<tr><th><font color=\"green\">%@</font></th><td align=\"center\">%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>",@"OK",viesResponse.CountryCode,viesResponse.VATNumber,viesResponse.Name,viesResponse.Address, sDate];
                
            }
            else
            {
                stmp = [[NSString  alloc] initWithFormat:@"<tr><th><font color=\"red\">%@</font></th><td align=\"center\">%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>",@"KO",viesResponse.CountryCode,viesResponse.VATNumber,viesResponse.Name,viesResponse.Address, sDate];
                
            }
            
            [emailBody appendString:stmp];
            [stmp release];
            
#ifdef DEBUG
            NSLog(@"[showEmailModalView]: in %@ at line %d, emailBody %@", NSStringFromSelector(_cmd), __LINE__, emailBody);
#endif
         }
        [emailBody appendString:@"</table>"];
        
#ifdef DEBUG
        NSLog(@"[showEmailModalView]: in %@ at line %d, emailBody %@", NSStringFromSelector(_cmd), __LINE__, emailBody);
#endif
    }

    [picker setMessageBody:emailBody isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
    
    picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
    
    [emailBody release];
    
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            NSString *msg=[Helpers languageSelectedStringForKey:@"ERROR_SENDING_MAIL"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:msg
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            [msg release];
        }
            
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}



- (IBAction)sendMailButtonPressed:(id) sender
{
    [self showEmailModalView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [Helpers shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}


@end
