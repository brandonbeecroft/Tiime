//
//  TiimeTableViewController.h
//  Tiime
//
//  Created by Brandon Beecroft on 10/22/14.
//  Copyright (c) 2014 Awesometistic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiimeTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *mainTitleNavigationBar;
@property (weak, nonatomic) IBOutlet UILabel *subTitleNavigationBar;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL timeHasStarted;

@end
