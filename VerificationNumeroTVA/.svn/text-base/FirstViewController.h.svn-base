//
//  VerificationNumeroTVAViewController.h
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface FirstViewController : UIViewController <CountryPickerDelegate, UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate> {
    
    // Progress bar ...
    MBProgressHUD         *HUD;
        
    // Display
    IBOutlet UITextField  *tvaNumField;
    IBOutlet UILabel      *tvaPrefixLabel;
    
    // iPodView
    IBOutlet CountryPicker *countryPicker;
    
    // iPadView
    IBOutlet                UITableView *tableView;
    NSIndexPath            *lastIndexPath;
    
    IBOutlet UIButton     *checkVATButton;
    IBOutlet UILabel      *VATFormatLabel;
    
    IBOutlet UILabel      *VATNumberLabel;
    IBOutlet UILabel      *MemberStateLabel;
    
    // fond d'ecran
    IBOutlet UIImageView  *backgroundImageView;
    
    NSArray                 *countryList;   

    NSString                *sCountryCode;
    NSString                *sVatNumber;
    
    NSDictionary            *VATCodesDictionnary;
	NSInteger               nbNetworkErrorDisplayed; 
    
    Boolean                 displayRegexAndHelpForVatStructure;
    Boolean                 verifyRegexBeforeCheckingVIES;
}


#pragma - input handling

@property(nonatomic, retain) UITextField    *tvaNumField;
@property(nonatomic, retain) UILabel        *tvaPrefixLabel;
@property(nonatomic, retain) NSArray        *countryList;
@property(nonatomic, retain) UIButton       *checkVATButton;
@property(nonatomic, retain) UILabel        *VATFormatLabel;
@property(nonatomic, retain) NSDictionary   *VATCodesDictionnary;
@property(nonatomic, retain) NSString       *sCountryCode;
@property(nonatomic, retain) NSString       *sVatNumber;

// iPodView
@property(nonatomic, retain) CountryPicker   *countryPicker;

// iPadView
@property(nonatomic, retain) UITableView    *tableView;
@property(nonatomic, retain) NSIndexPath    *lastIndexPath;

// Localisation
@property(nonatomic, retain) UILabel        *VATNumberLabel;
@property(nonatomic, retain) UILabel        *MemberStateLabel;

@property(nonatomic, retain)  UIImageView  *backgroundImageView;

- (IBAction) backgroundClick:(id) sender;
- (IBAction) textFieldDoneEditing:(id) sender;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

NSInteger alphabeticSort(id string1, id string2, void *reverse);

- (IBAction)checkVatNumber;
- (Boolean)isFormallyValidVatNumber; 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void) displayNetworkRequestedForCheckVat;
- (void) updateVatDataWithIndex:(NSInteger) selectedRow;
- (void) updateCheckButtonStatusWithIndex:(NSInteger) selectedRow;
- (void) displayErrorInCheckVatResponse: (id) error;
- (void) displayCheckVatResponse: (VIESResponse *) viesResponse;

- (void) updateTitle;

- (void) displayDescription;
- (void) updateDescription:(NSString *) description regex:(NSString *)regex;

- (void) updateViewBasedOnUserSettings;


// iPadView
// tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (void)tableView:(UITableView *)myTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
