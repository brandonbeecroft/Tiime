//
//  CustomCellTableViewCell.h
//  Tiime
//
//  Created by Brandon Beecroft on 10/23/14.
//  Copyright (c) 2014 Awesometistic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *projectName;
@property (strong, nonatomic) IBOutlet UILabel *clientName;
@property (strong, nonatomic) IBOutlet UILabel *projectTime;
@property (strong, nonatomic) IBOutlet UIButton *timerButton;

@end
