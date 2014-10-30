//
//  CustomCellTableViewCell.h
//  Tiime
//
//  Created by Brandon Beecroft on 10/23/14.
//  Copyright (c) 2014 Awesometistic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeButtonDelegate;

@interface CustomCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *projectName;
@property (strong, nonatomic) IBOutlet UILabel *clientName;
@property (strong, nonatomic) IBOutlet UILabel *projectTime;
@property (strong, nonatomic) IBOutlet UIButton *timerButton;
@property (strong, nonatomic) NSString *projectID;
@property (nonatomic, assign) BOOL isTimerActive;

@property (nonatomic, assign) id<TimeButtonDelegate>delegate;

@end

@protocol TimeButtonDelegate <NSObject>

@required
-(void)customCellInvokeTimer:(CustomCellTableViewCell *)customCell withTag:(int)tag;
-(void)customCellStopTimer:(CustomCellTableViewCell *)customCell withTag:(int)tag;

@end
