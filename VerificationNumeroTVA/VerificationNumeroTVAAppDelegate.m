//
//  VerificationNumeroTVAAppDelegate.m
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlurryAnalytics.h"

@implementation VerificationNumeroTVAAppDelegate

@synthesize window=_window;
@synthesize tabBarController;
@synthesize bECWSUnavailable, listOfResults,  selectedLanguage, lastAcceleration;


#pragma mark - Exception Handling
void uncaughtExceptionHandler(NSException *exception) 
{
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //... 
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [FlurryAnalytics startSession:@"GZ78CKMWIC372UUHL9G4"];
    
    // Creation des controllers
    FirstViewController * myVerificationNumeroTVAViewController;   
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) 
    {
        myVerificationNumeroTVAViewController= [[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease]; 
    } 
    else
    {
        myVerificationNumeroTVAViewController= [[[FirstViewController alloc] initWithNibName:@"FirstViewController-ipad" bundle:nil] autorelease]; 
    }
    
    ThirdViewController *myThirdViewController=[[[ThirdViewController alloc] init] autorelease];
       
    SecondViewController *myNavigationController=[[[SecondViewController alloc] init] autorelease];
    
    IASKAppSettingsViewController *mySecondViewController = [[[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil] autorelease];
    mySecondViewController.showDoneButton = NO;
    
    [myNavigationController pushViewController:mySecondViewController animated:FALSE];

    
    self.tabBarController = [[UITabBarController alloc ] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = [[NSArray alloc ] initWithObjects:myVerificationNumeroTVAViewController, myThirdViewController,myNavigationController, nil];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // self.window.rootViewController = self.tabBarController;  - fails with pre 4.x version
    [self.window addSubview:[self.tabBarController view]];
    [self.window makeKeyAndVisible];
    
     
    
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];

    
    // cf http://www.btjones.com/2010/05/nsuserdefaults-nil-setting-problem/
    // The problem is if your application settings are never opened in the Settings app, when using NSUserDefaults to retrieve setting values within your application, they will be nil even if a DefaultValue is set in your settings bundle.
    [Helpers setupDefaults];  
     
	listOfResults = [[LazyNSMutableArray alloc]  init];
    [self updateBadgeValue];
    
        
    //  to detect shake events
    [UIAccelerometer sharedAccelerometer].delegate = self;
    
    
    //SpashView stuff
    CGRect myFrame =  [[[UIApplication sharedApplication] keyWindow] frame];
    splashView = [[UIImageView alloc]  initWithFrame:myFrame];
    
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        // iPod & iPhone
        //splashView = [[UIImageView alloc]  initWit  initWithFrame:CGRectMake(0,0, 320, 480)];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.3")) 
        {
            splashView.image = [UIImage imageNamed:@"Default.png"];       
        }        
        else
        {
            splashView.image = [UIImage imageNamed:@"Default.png"];  
        }
    }    
    else
    {
        // iPad
        //           splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
        splashView.image = [UIImage imageNamed:@"DefaultiPadBackGround.png"];            
    }
    
        
    
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self]; 
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        splashView.frame = CGRectMake(-60, -85, 440, 635);
    }
    else
    {
        splashView.frame = CGRectMake(-60, -85, 1000, 1500);       
    }
    [UIView commitAnimations];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */

    [listOfResults saveHistory];

}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    //[self updateViewBasedOnUserSettings];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[self updateViewBasedOnUserSettings];
    [self tabBarController:self.tabBarController didSelectViewController:self.tabBarController.selectedViewController ];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [listOfResults saveHistory];
}

- (void)dealloc
{
    [_window release];
    [tabBarController release];
     
    [listOfResults release];
    [hostReach release];
    
    [lastAcceleration release];
    [super dealloc];
}

#pragma mark - userSettings

- (void) updateSelectedLanguageBasedOnUserSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//#ifdef DEBUG    
//    NSString *key;
//    for (key in [defaults dictionaryRepresentation]) {
//        NSLog(@"in viewDidLoad: key <%@>, value <%@>", key, [defaults objectForKey:key]);
//    }
//#endif
    
    NSNumber *selectedOption = [defaults objectForKey:@"mulValue"];
    selectedLanguage  = [ selectedOption intValue];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // on force la maj de la langue d'affichage si jamais l'on vient du settings
   [self updateSelectedLanguageBasedOnUserSettings];

   // [viewController updateViewBasedOnUserSettings];
    
    if ( [viewController isKindOfClass:[FirstViewController class] ])
    {
        [(FirstViewController *) viewController updateViewBasedOnUserSettings]; 
    }
    if ( [viewController isKindOfClass:[SecondViewController class] ])
    {
        [(SecondViewController *) viewController updateViewBasedOnUserSettings]; 
    }
    if ( [viewController isKindOfClass:[ThirdViewController class] ])
    {
        ThirdViewController *tmpThirdViewController = (ThirdViewController*) viewController;
        [tmpThirdViewController.tableView reloadData ];
        [tmpThirdViewController updateViewBasedOnUserSettings];
    }
    
    // mise à jour des libelles des toolbar controls
    for(UIViewController *viewController in [self.tabBarController.viewControllers objectEnumerator])
    {
        if ( [viewController isKindOfClass:[ThirdViewController class] ]  )
        {
            [(ThirdViewController*) viewController updateTitle];
        }
        if ( [viewController isKindOfClass:[FirstViewController class] ] )
        {
            [(FirstViewController*) viewController updateTitle];
        }
        if ( [viewController isKindOfClass:[SecondViewController class] ] )
        {
            [(SecondViewController*) viewController updateTitle];
        }
    }
}


- (void)updateBadgeValue 
{
    // Affichage du badge .. 
    UITabBar *myTabBar = [ [self tabBarController ] tabBar];
    UITabBarItem *myTabBarItem;
    for ( myTabBarItem in [myTabBar items])
    {
//#ifdef DEBUG
//        NSLog(@"[handleCheckVatResponse]: in %@ at line %d, <%@>", NSStringFromSelector(_cmd), __LINE__, [myTabBarItem title]);
//#endif
        if ( [myTabBarItem tag] == 3 )
        {
            if ( [[AppDelegate listOfResults] getHistoryCount] > 0 ) 
                myTabBarItem.badgeValue = [[NSString alloc] initWithFormat:@"%d",[[AppDelegate listOfResults] getHistoryCount]];
            else
                myTabBarItem.badgeValue = nil;
                
        }
    }
    
    // on force le reload du tableview
    // mise à jour des libelles des toolbar controls
    for(UIViewController *viewController in [self.tabBarController.viewControllers objectEnumerator])
    {
        if ( [viewController isKindOfClass:[ThirdViewController class] ]  )
        {
            ThirdViewController *tmpThirdViewController = (ThirdViewController*) viewController;
            [tmpThirdViewController.tableView reloadData ];
            [tmpThirdViewController enableOrDisableStatusOfButtons];
        }
    }
}

#pragma mark - SplashView
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashView removeFromSuperview];
    [splashView release];
}


#pragma mark - ShakeStuff

// Ensures the shake is strong enough on at least two axes before declaring it a shake.
// "Strong enough" means "greater than a client-supplied threshold" in G's.
static BOOL L0AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) {
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
    
    return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    if (self.lastAcceleration) {
        if (!histeresisExcited && L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.7)) {
            histeresisExcited = YES;
            
            // Shake detected !! 
            UIViewController *viewController = [self.tabBarController selectedViewController];
            if ( [viewController isKindOfClass:[ThirdViewController class] ]  )
            {
                [(ThirdViewController*) viewController deleteHistoryButtonPressed:nil];
            }
            
        } else if (histeresisExcited && !L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.2)) {
            histeresisExcited = NO;
        }
    }
    
    self.lastAcceleration = acceleration;
}


#pragma mark - ReachabilityStuff

- (void)startReachability
{
    if ( hostReach == nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *base_URL = [defaults objectForKey:@"base_URL"];
        
        // EC website has to be reachable
        hostReach = [[Reachability reachabilityWithHostName:base_URL] retain];
        
        [hostReach startNotifier];
        [self updateWSReachability:hostReach];     
    }
}

// Inspiré de http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html

- (NSString *) checkForNetworkAndWS
{
    [self startReachability];

//#ifdef DEBUG
//        NSLog(@"[checkForNetwork]: in %@ at line %d: bECWSUnavailable = <%d>", NSStringFromSelector(_cmd), __LINE__,  self.bECWSUnavailable);
//#endif
    
    if ( self.bECWSUnavailable == FALSE)
        return (NSString *) nil;
    else 
        return ([[[NSString alloc] initWithString:@"KO"] autorelease]);

}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateWSReachability: curReach];
}

- (void) updateWSReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
	     NetworkStatus netStatus = [curReach currentReachabilityStatus];
        
        if ( netStatus == NotReachable )
        {
            bECWSUnavailable = TRUE;
        }      
        else
        {
            bECWSUnavailable = FALSE;
        }
    }
}




@end
