//
//  VerificationNumeroTVAAppDelegate.h
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIESResponse.h"
#import "LazyNSMutableArray.h"


@class FirstViewController;
@class Reachability;

@interface VerificationNumeroTVAAppDelegate : NSObject <UIApplicationDelegate, UIAccelerometerDelegate,UITabBarControllerDelegate>
{
    Reachability*       hostReach;
    Boolean             bECWSUnavailable;
    
    IBOutlet UITabBarController *tabBarController;
     
    int                 selectedLanguage;
    
    LazyNSMutableArray      *listOfResults;

    // SplashView
    UIImageView *splashView;
    
    //ShakeStuff
    BOOL histeresisExcited;
    UIAcceleration* lastAcceleration;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, assign) Boolean bECWSUnavailable;
@property (nonatomic, retain) LazyNSMutableArray *listOfResults;
@property (nonatomic, assign) int selectedLanguage;



#pragma mark - Localization
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

#pragma mark - SplashView
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

#pragma mark - ShakeStuff
@property(nonatomic, retain) UIAcceleration* lastAcceleration;

#pragma mark - ReachabilityStuff
- (void)startReachability;
- (NSString *) checkForNetworkAndWS;
- (void) updateWSReachability: (Reachability*) curReach;

- (void) updateBadgeValue;
- (void) updateSelectedLanguageBasedOnUserSettings;



@end
