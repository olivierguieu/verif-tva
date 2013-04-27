//
//  VIESResponseCell.m
//  VerificationNumeroTVA
//
//  Created by olivierguieu on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VIESResponseCell.h"

@implementation VIESResponseCell

@synthesize VATNumberLabel;
@synthesize CountryLabel;
@synthesize CountryValue;
@synthesize VATNumberValue;
@synthesize ImageView;
@synthesize NameLabel;
@synthesize NameValue;
@synthesize AddressLabel;
@synthesize AddressValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
    
    [VATNumberLabel release];
    [CountryLabel release];
    [CountryValue release];
    [VATNumberValue release];
    
    [NameLabel release];
    [NameValue release];
    [AddressLabel release];
    [AddressValue release];
    
    ImageView = nil;
}  

@end
