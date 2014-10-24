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

@interface TiimeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TiimeViewController

static NSString *cellId = @"Cell";

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self queryProjectList:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *today = [NSDate date];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:today dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];

    self.mainTitleNavigationBar.text = dateString;
    self.subTitleNavigationBar.text = @"0:14 hrs today";

    //[self.tableView registerClass:[CustomCellTableViewCell class] forCellReuseIdentifier:cellId];
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


    CustomCellTableViewCell * customCell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    PFObject *project = [self.userProjects objectAtIndex:indexPath.row];

    customCell.projectName.text = [project objectForKey:@"projectName"];
    customCell.clientName.text = [project objectForKey:@"clientName"];
    customCell.projectTime.text = @"12:45:03";

    customCell.timerButton.tag = indexPath.row;
    [customCell.timerButton addTarget:self action:@selector(timeChange:) forControlEvents:UIControlEventTouchUpInside];
    customCell.projectTime.tag = indexPath.row;

    return customCell;
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

-(void)timeChange:(UIButton *)button {
    NSLog(@"Button at row: %lu", button.tag);
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
