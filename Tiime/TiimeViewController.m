//
//  TiimeViewController.m
//  Tiime
//
//  Created by Brandon Beecroft on 10/22/14.
//  Copyright (c) 2014 Awesometistic, LLC. All rights reserved.
//
#import <Parse/Parse.h>
#import "TiimeViewController.h"
#import "CustomCellTableViewCell.h"
#import "LTimer.h"

@interface TiimeViewController () <UITableViewDataSource, UITableViewDelegate, TimeButtonDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CustomCellTableViewCell *customCell;

@end

@implementation TiimeViewController

static NSString *cellId = @"Cell";

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryProjectList:self.tableView];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *today = [NSDate date];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:today dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];

    self.mainTitleNavigationBar.text = dateString;
    self.subTitleNavigationBar.text = @"0:14 hrs today";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.userProjects.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    self.customCell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    self.customCell.delegate = self;

    PFObject *project = [self.userProjects objectAtIndex:indexPath.row];

    self.customCell.projectName.text = [project objectForKey:@"projectName"];
    self.customCell.clientName.text = [project objectForKey:@"clientName"];

    // query last session and return the time here.
    NSString *projTimeTemp = [project objectForKey:@"projectTime"];
    if (projTimeTemp == nil) {
        self.customCell.projectTime.text = [NSString stringWithFormat:@"0:00"];
    } else {
        self.customCell.projectTime.text = [NSString stringWithFormat:@"%@",projTimeTemp];
    }

    return self.customCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

// remove inset for separator on cells
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)queryProjectList:(UITableView *)tableView {

    if ([PFUser currentUser].objectId == nil) {
        NSLog(@"current user was nil");
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Projects"];
        [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // do something with objects?
                NSLog(@"Object count: %li",objects.count);
                self.userProjects = objects;
                [tableView reloadData];
            }
        }];
    }
}

-(void)customCellInvokeTimer:(CustomCellTableViewCell *)customCell withTag:(long)tag{

    // testing
    //NSLog(@"%i",tag);

    // check to see if another timer is going.

    // if timer is going, stop that time

    // animate timer icon

    // load the last completed time from Parse and show it
    //TEMP
    self.second = 0;
    self.minute = 0;
    self.hour = 0;

    //animate time to show

    // start new timer once other timer is stopped
    [LTimer LTimerWithTimeInterval:1 target:self userInfo:nil repeats:YES tag:(int)tag fireBlock:^(LTimer *timer, id userInfo) {
        //customCell.projectTime.text = [NSString stringWithFormat:@"%ld", [customCell.projectTime.text integerValue] + 1];
        self.second = self.second + 1;
        if (self.second > 59) {
            self.minute++;
            self.second = 0;
        }

        if (self.minute > 59) {
            self.hour++;
            self.minute = 0;
        }
        // change format to account for seconds/minutes/hours less than double digits to have a 0 in front of them.
        customCell.projectTime.text = [NSString stringWithFormat:@"%lu:%lu:%lu",self.hour, self.minute, self.second];
    }];

    NSLog(@"the timer is running");
}

-(void)customCellStopTimer:(CustomCellTableViewCell *)customCell withTag:(long)tag {
    NSLog(@"timer should stop");

    // stop timer
    [LTimer freeTimerWithTag:tag];

    // animate hide of timer

    // save second, minute, and hour value to Parse

}

//-(void)increaseTimeForCell:(CustomCellTableViewCell *)cell {
//    NSLog(@"time is increasing");
//    cell.projectTime.text = [NSString stringWithFormat:@"%ld:0%ld", (long)self.minute, (long)self.second];
//
//    if (self.second > 0 ) {
//        self.second++;
//    }
//
//    if (self.minute > 0) {
//        if (self.second == 59) {
//            self.second = 0;
//            self.minute++;
//        }
//    }
//
//    if (self.timeHasStarted) {
//        [self performSelector:@selector(increaseTimeForCell:) withObject:nil afterDelay:1.0];
//    }
//}


@end
