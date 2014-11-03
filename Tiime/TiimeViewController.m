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
@property (nonatomic, assign) NSNumber *totalSessionSeconds;
//@property (nonatomic, strong) PFObject *myObj;

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
    self.customCell.projectID = project.objectId;
    
    self.customCell.timerButton.tag = indexPath.row;

    // query last session and return the time here.
    NSString *projTimeTemp = [project objectForKey:@"projectTime"];
    int number = [[project objectForKey:@"projectTime"] intValue];
    
    if (projTimeTemp == nil) {
        self.customCell.projectTime.text = [NSString stringWithFormat:@"0:00"];
    } else {
        //do conversion from the number of seconds to hh:mm:ss
        self.customCell.projectTime.text = [self timeFormatted:number];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"More" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        // show UIActionSheet
//    }];
//    moreAction.backgroundColor = [UIColor greenColor];
//    
//    UITableViewRowAction *flagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Flag" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        // flag the row
//    }];
//    flagAction.backgroundColor = [UIColor yellowColor];
//    
//    return @[moreAction, flagAction];
//}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete row");
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        NSMutableArray *mutableUserProjects = self.userProjects.mutableCopy;
        
        [self.userProjects[indexPath.row] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self queryProjectList:tableView];
            }
        }];
        
        [mutableUserProjects removeObjectAtIndex:indexPath.row];
        self.userProjects = mutableUserProjects;
        
    }
    [tableView endUpdates];
}

-(void)queryProjectList:(UITableView *)tableView {

    if ([PFUser currentUser].objectId == nil) {
        NSLog(@"current user was nil");
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Projects"];
        [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.userProjects = objects;
                [tableView reloadData];
            }
        }];
    }
}


#pragma mark - Work with Timer

-(void)customCellInvokeTimer:(CustomCellTableViewCell *)customCell withTag:(int)tag{

    // cancel any existing timers
    [LTimer freeTimerWithTag:tag];
    
    
    // animate timer icon
    // TODO
    
    
    // assign the the objects to work with
    self.session = [PFObject objectWithClassName:@"Sessions"];
    self.project = self.userProjects[tag];
    self.totalSessionSeconds = 0;
    
    
    // set flag of session start
    self.session[@"hasStarted"] = @YES;
    self.session[@"parent"] = self.project;
    [self.session saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"session started and saved");
    }];


    // load the last completed total time from Parse and show it
    //TEMP
    
    
    //animate time to show

    
    // start new timer once other timer is stopped
    [LTimer LTimerWithTimeInterval:1 target:self userInfo:nil repeats:YES tag:(int)tag fireBlock:^(LTimer *timer, id userInfo) {
    
        NSInteger total = self.totalSessionSeconds.integerValue;
        total++;
        self.totalSessionSeconds = [NSNumber numberWithInteger:total];
        
        self.second += 1;
        if (self.second > 59) {
            self.minute++;
            self.second = 0;
        }

        if (self.minute > 59) {
            self.hour++;
            self.minute = 0;
        }
        
        // change format to account for seconds/minutes/hours less than double digits to have a 0 in front of them.
        customCell.projectTime.text = [NSString stringWithFormat:@"%lu:%lu:%lu",(long)self.hour, (long)self.minute, (long)self.second];
    }];
}

-(void)customCellStopTimer:(CustomCellTableViewCell *)customCell withTag:(int)tag {
    NSLog(@"timer should stop");

    // stop timer
    [LTimer freeTimerWithTag:tag];

    // animate hide of timer
    
    

    self.session[@"numberOfSeconds"] = self.totalSessionSeconds;
    self.session[@"sessionDate"] = [NSDate date];
    self.session[@"hasStopped"] = @YES;
    
    self.session[@"parent"] = self.project;
    
    [self.session saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"session saved");
            self.session = nil;
        }
    }];
    
    // TODO:
    // query project and assign session time to total time.
    // save new value.
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId = %@",customCell.projectID];
    PFQuery *query = [PFQuery queryWithClassName:@"Projects" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //self.myObj = objects[0];
        PFObject *proj = objects[0];
        NSInteger projTotal = [proj[@"projectTime"] integerValue];
        NSInteger sessionTotal = self.totalSessionSeconds.integerValue;
        NSInteger newTotal = projTotal + sessionTotal;
        
        NSNumber *convertedTotal = [NSNumber numberWithInteger:newTotal];
        
        [proj setObject:convertedTotal forKey:@"projectTime"];
        [proj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                //error occured
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"Save error encountered" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
    }];
    
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    self.second = seconds;
    self.minute = minutes;
    self.hour = hours;

    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

@end
