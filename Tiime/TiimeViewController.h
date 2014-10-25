//
//  TiimeViewController.h
//  Tiime
//
//  Created by Brandon Beecroft on 10/22/14.
//  Copyright (c) 2014 Awesometistic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiimeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *mainTitleNavigationBar;
@property (weak, nonatomic) IBOutlet UILabel *subTitleNavigationBar;
@property (nonatomic, strong) NSArray *userProjects;

// timer properties
@property (nonatomic, assign) BOOL timeHasStarted;

@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger second;


@end
