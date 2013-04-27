//
//  VerificationNumeroTVAViewController.h
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerificationNumeroTVAAppDelegate.h"




@interface VerificationNumeroTVAViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    
    // Display
    IBOutlet UITextField  *tvaNumField;
    IBOutlet UILabel      *tvaPrefixLabel;
    
    IBOutlet UIPickerView *countryPicker;
    IBOutlet UIButton     *checkVATButton;
    IBOutlet UILabel      *VATFormatLabel;
    
    IBOutlet UILabel      *VATNumberLabel;
    IBOutlet UILabel      *MemberStateLabel;
    
    NSArray *countryList;
    

    NSString            *sCountryCode;
    NSString            *sVatNumber;
    
    NSDictionary        *VATCodesDictionnary;
	NSInteger           nbNetworkErrorDisplayed;
    
    
    Boolean             displayRegexAndHelpForVatStructure;
    Boolean             verifyRegexBeforeCheckingVIES;
}


#pragma - input handling

@property(nonatomic, retain) UITextField    *tvaNumField;
@property(nonatomic, retain) UILabel        *tvaPrefixLabel;
@property(nonatomic, retain) UIPickerView   *countryPicker;
@property(nonatomic, retain) NSArray        *countryList;
@property(nonatomic, retain) UIButton       *checkVATButton;
@property(nonatomic, retain) UILabel        *VATFormatLabel;
@property(nonatomic, retain) NSDictionary   *VATCodesDictionnary;
@property(nonatomic, retain) NSString       *sCountryCode;
@property(nonatomic, retain) NSString       *sVatNumber;

// Localisation
@property(nonatomic, retain) UILabel        *VATNumberLabel;
@property(nonatomic, retain) UILabel        *MemberStateLabel;



- (IBAction) backgroundClick:(id) sender;
- (IBAction) textFieldDoneEditing:(id) sender;


NSInteger alphabeticSort(id string1, id string2, void *reverse);

- (IBAction)checkVatNumber;
- (Boolean)isFormallyValidVatNumber; 

- (void)awakeFromNib;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void) updateVatData;
- (void) displayNetworkRequestedForCheckVat;
- (void) updateCheckButtonStatus;
- (void) displayErrorInCheckVatResponse: (id) error;
- (void) displayCheckVatResponse: (VIESResponse *) viesResponse;

- (void) updateTitle;

- (void) displayDescription;
- (void) updateDescription:(NSString *) description regex:(NSString *)regex;

- (void) updateViewBasedOnUserSettings;

@end
