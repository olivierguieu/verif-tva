//
//  main.m
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>


int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([VerificationNumeroTVAAppDelegate class]));
    [pool release];
    
    return retVal;
    
}