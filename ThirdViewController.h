//
//  ThirdViewController.h
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"


@interface ThirdViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate > {
    
    IBOutlet    UITableView             *tableView;
    IBOutlet    UINavigationItem        *navigationItem;   
}




@property (nonatomic, retain) IBOutlet UITableView              *tableView;
@property (nonatomic, retain) IBOutlet UINavigationItem         *navigationItem;



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

// tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)tableView: (UITableView *)tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath *)indexPath;
- (CGFloat) tableView:(UITableView *)myTableView heightForRowAtIndexPath: (NSIndexPath *) indexPath ;


- (void) updateViewBasedOnUserSettings;
- (void) updateTitle;

// Buttons
- (void) enableOrDisableStatusOfButtons;
- (IBAction)deleteHistoryButtonPressed:(id) sender;
- (IBAction)sendMailButtonPressed:(id) sender;


@end
