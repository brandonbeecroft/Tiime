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
    UIButton *button = (UIButton *)[self viewWithTag:100];
    [button addTarget:self action:@selector(timeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)timeButtonTapped:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(customCellStartTimer:)]) {
        [self.delegate customCellStartTimer:self];
    }
}

@end
