//
//  ProjectController.m
//  Projeect
//
//  Created by Brandon Beecroft on 10/7/14.
//  Copyright (c) 2014 Awesometistic, LLC. All rights reserved.
//

#import "ProjectController.h"

@interface ProjectController ()

@property (nonatomic, strong) NSArray *userProjects;

@end

@implementation ProjectController

+ (ProjectController *)sharedInstance {
    static ProjectController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ProjectController alloc] init];
    });
    return sharedInstance;
}

-(void)addNewProject:(NSString *)projectName forClient:(NSString *)clientName withProjectNote:(NSString *)projectNote {

    PFObject *newProject = [PFObject objectWithClassName:@"Projects"];
    [newProject setObject:[PFUser currentUser] forKey:@"createdBy"];
    newProject[@"projectName"] = projectName;
    newProject[@"clientName"] = clientName;
    newProject[@"projectNote"] = projectNote;

    [newProject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFRelation *relation = [[PFUser currentUser] relationForKey:@"usersProjects"];
            [relation addObject:newProject];
            [newProject saveEventually];
        }
    }];
}

-(void)sync{
    // save the managedObjectContext
    //[[Stack sharedInstance].managedObjectContext save:nil];
}


//    // objects representing new projects
//    PFObject *newProject = [PFObject objectWithClassName:@"Projects"];
//
//    // assign to the the user the new object
//    [newProject setObject:[PFUser currentUser] forKey:@"createdBy"];
//
//    // give the object a attribute
//    newProject[@"projectName"] = @"Projeect App Test";
//
//    [newProject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            PFRelation *relation = [[PFUser currentUser] relationForKey:@"userprojects"];
//            [relation addObject:newProject];
//            [newProject saveEventually];
//        }
//    }];


@end
