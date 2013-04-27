//
//  VIESResponse.m
//  VerificationNumeroTVA
//
//  Created by olivierguieu on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VIESResponse.h"

@implementation VIESResponse

@synthesize IsValidVATNumber;
@synthesize Name;
@synthesize Address;
@synthesize CountryCode;
@synthesize VATNumber;
@synthesize RequestDate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithData:(Boolean)isValidVATNumber Name:(NSString*)name Address:(NSString*)address CountryCode:(NSString*)countryCode VATNumber:(NSString*)vATNumber RequestDate:(NSDate*) requestDate
{
    self = [super init];
    if (self) {
        // Initialization code here.

        self.IsValidVATNumber = isValidVATNumber;
        self.Name = name;
        self.Address = address;
        self.CountryCode = countryCode;
        self.VATNumber = vATNumber;
        self.RequestDate = requestDate;
    }
    
    return self;
}

#pragma mark -
#pragma mark encoding/decoding

static NSString *IsValidVATNumberKey = @"IsValidVATNumber";
static NSString *NameKey = @"Name";
static NSString *AddressKey = @"Address";
static NSString *CountryCodeKey = @"CountryCode";
static NSString *VATNumberKey = @"VATNumber";
static NSString *RequestDateKey = @"RequestDate";


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        
        IsValidVATNumber = [decoder decodeBoolForKey:IsValidVATNumberKey];
        Name = [[decoder decodeObjectForKey:NameKey] retain];
        Address = [[decoder decodeObjectForKey:AddressKey] retain];
        CountryCode = [[decoder decodeObjectForKey:CountryCodeKey] retain];
        VATNumber = [[decoder decodeObjectForKey:VATNumberKey] retain];
        RequestDate = [[decoder decodeObjectForKey:RequestDateKey] retain];
        
    }
    return self;
}   

- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeBool:IsValidVATNumber forKey:IsValidVATNumberKey];
    [encoder encodeObject:Name forKey:NameKey];    
    [encoder encodeObject:Address forKey:AddressKey];
    [encoder encodeObject:CountryCode forKey:CountryCodeKey];
    [encoder encodeObject:VATNumber forKey:VATNumberKey];
    [encoder encodeObject:RequestDate forKey:RequestDateKey];
}

@end
