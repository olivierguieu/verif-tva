//
//  VIESResponse.h
//  VerificationNumeroTVA
//
//  Created by olivierguieu on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIESResponse : NSObject<NSCoding>
{
    Boolean             IsValidVATNumber;   
    NSString            *Name;
    NSString            *Address;
    NSString            *CountryCode;
    NSString            *VATNumber;
    NSDate              *RequestDate;
}

@property (nonatomic, assign)   Boolean             IsValidVATNumber;
@property (nonatomic, retain)   NSString            *Name;
@property (nonatomic, retain)   NSString            *Address;
@property (nonatomic, retain)   NSString            *CountryCode;
@property (nonatomic, retain)   NSString            *VATNumber;
@property (nonatomic, retain)   NSDate              *RequestDate;

- (id)initWithData:(Boolean)IsValidVATNumber Name:(NSString*)Name Address:(NSString*)Address CountryCode:(NSString*)CountryCode VATNumber:(NSString*)VATNumber RequestDate:(NSDate*) RequestDate;


@end
