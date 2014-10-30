//
//  CustomCellTableViewCell.m
//  Tiime
//
//  Created by Brandon Beecroft on 10/23/14.
//  Copyright (c) 2014 Awesometistic, LLC. All rights reserved.
//

#import "CustomCellTableViewCell.h"

@implementation CustomCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.timerButton addTarget:self action:@selector(timeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)timeButtonTapped:(UIButton *)sender {
    self.isTimerActive = !self.isTimerActive;

    if (self.isTimerActive) {
        [self.delegate customCellInvokeTimer:self withTag:(int)self.timerButton.tag];
    } else {
        [self.delegate customCellStopTimer:self withTag:(int)self.timerButton.tag];
    }
}

@end
