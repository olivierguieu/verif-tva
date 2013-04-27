//
//  SecondViewController.m
//  VerificationNumeroTVA
//
//  Created by olivierguieu on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // define image
        self.tabBarItem.image = [UIImage imageNamed:@"20-gear2.png"];
        self.tabBarItem.tag = 2;
              
        
        // a faire ds le initWithNibName et par la suite 
        [self updateTitle];
        
        //self.delegate = AppDelegate;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad]; 
    [self updateViewBasedOnUserSettings];      
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - userSettings

// updates localized title of toolbar item
- (void) updateTitle {
    self.title = [Helpers languageSelectedStringForKey:@"SETTINGS_LABEL"];
}



- (void) updateViewBasedOnUserSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];

    [self updateTitle];
}


@end
