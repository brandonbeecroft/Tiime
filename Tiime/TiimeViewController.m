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

-(void)customCellStartTimer:(CustomCellTableViewCell *)customCell {
    // execute timer functions
    // TEMP:
    //customCell.projectTime.text = @"0:00";

    // check to see if another timer is going.

    // if timer is going, stop that time

    // start new timer once other timer is stopped
    self.timeHasStarted = !self.timeHasStarted;

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
