//
//  AddNewProjectViewController.m
//  Tiime
//
//  Created by Brandon Beecroft on 10/23/14.
//  Copyright (c) 2014 Awesometistic, LLC. All rights reserved.
//

#import "AddNewProjectViewController.h"
#import "ProjectController.h"

@interface AddNewProjectViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *projectNameField;
@property (weak, nonatomic) IBOutlet UITextField *clientNameField;
@property (weak, nonatomic) IBOutlet UITextField *projectNoteField;

@end

@implementation AddNewProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.projectNameField becomeFirstResponder];
}

- (IBAction)cancel:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveProject:(id)sender {
    NSLog(@"save project");

    NSString *projectName = self.projectNameField.text;
    NSString *projectNote = self.projectNoteField.text;
    NSString *clientName = self.clientNameField.text;

    [[ProjectController sharedInstance] addNewProject:projectName forClient:clientName withProjectNote:projectNote];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
