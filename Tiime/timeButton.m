//
//  timeButton.m
//  Tiime
//
//  Created by Brandon Beecroft on 10/23/14.
//  Copyright (c) 2014 Awesometistic, LLC. All rights reserved.
//

#import "timeButton.h"
#import "StyleKit.h"

@implementation timeButton

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [StyleKit drawTimeIconWithFrame:CGRectMake(0, 0, 22, 22)];
}

@end
