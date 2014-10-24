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

@property (nonatomic, assign) BOOL timeHasStarted;

@property (nonatomic, strong) NSArray *userProjects;

@property (nonatomic, assign) NSInteger hours;
@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, assign) NSInteger seconds;



@end
