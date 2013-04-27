//
//  VIESResponseCell.h
//  VerificationNumeroTVA
//
//  Created by olivierguieu on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIESResponseCell : UITableViewCell {
    UILabel *VATNumberLabel;
    UILabel *CountryLabel;
    
    UILabel *CountryValue;
    UILabel *VATNumberValue;
    
    UILabel *NameLabel;    
    UILabel *NameValue;

    UILabel *AddressLabel;    
    UILabel *AddressValue;  
    
    UIImageView *ImageView;
}

@property (nonatomic, retain) IBOutlet UILabel *VATNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *CountryLabel;
@property (nonatomic, retain) IBOutlet UILabel *CountryValue;
@property (nonatomic, retain) IBOutlet UILabel *VATNumberValue;

@property (nonatomic, retain) IBOutlet UILabel *NameLabel;
@property (nonatomic, retain) IBOutlet UILabel *NameValue;
@property (nonatomic, retain) IBOutlet UILabel *AddressLabel;
@property (nonatomic, retain) IBOutlet UILabel *AddressValue;


@property (nonatomic, retain) IBOutlet UIImageView *ImageView;
@end
