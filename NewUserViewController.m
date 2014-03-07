//
//  NewUserViewController.m
//  drinkingApp
//
//  Created by Leo Zoeckler on 3/6/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "NewUserViewController.h"
#import "HEALUser.h"
#import "HEALMainViewController.h"

@interface NewUserViewController ()
{
    NSCharacterSet *notDigits;
    HEALUser *newUser;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)doneButton:(id)sender;

@end

@implementation NewUserViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

// Called when the doneButton is pressed
- (IBAction)doneButton:(id)sender{
    
    defaults = [NSUserDefaults standardUserDefaults];
    notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    // Check user input and pop up alerts with directions if the user input is invalid
    if (([[self.weightTextField text] isEqualToString:@""]) || ([[self.weightTextField text] rangeOfCharacterFromSet:notDigits].location != NSNotFound)) {
        [self alertUser:@"Please enter a whole number for weight in lbs."];
    } else if(!([[self.sexTextField text] isEqualToString:@"M"] || [[self.sexTextField text] isEqualToString:@"F"])){
        [self alertUser:@"Please enter F or M for sex."];
    }
    
    // If user input is in order store the textfield values and proceed to main view
    if (([[self.weightTextField text] rangeOfCharacterFromSet:notDigits].location == NSNotFound) && ([[self.sexTextField text] isEqualToString:@"M"] || [[self.sexTextField text] isEqualToString:@"F"])) {
        
        NSNumber *weight = [NSNumber numberWithDouble:[[self.weightTextField text] doubleValue]];
        [defaults setObject:weight forKey:@"userWeight"];
        [defaults setObject:[self.sexTextField text] forKey:@"userSex"];
        [defaults setObject:[self.nameTextField text] forKey:@"userName"];
        
        newUser = [[HEALUser alloc] init];
        [newUser setUserName:[self.nameTextField text]];
        [newUser setUserSex:[self.sexTextField text]];
        [newUser setUserWeight:weight];
        
        @try {
            [defaults synchronize];
        }
        @catch (NSException *exception) {
            NSLog(@"Data save failed.");
        }
        [self performSegueWithIdentifier:@"newToMainSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"newToMainSegue"]){
        HEALMainViewController *controller = [segue destinationViewController];
        controller->user = newUser;

    }
    
}

- (void)alertUser:(NSString*) alertMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
    // We want the textfields to delegate back to this view controller
    [[self weightTextField] setDelegate:self];
    [[self sexTextField] setDelegate:self];
    [[self nameTextField] setDelegate:self];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground:)];
    [self.view addGestureRecognizer:tapBackground];
}

- (void)tapBackground:(UIGestureRecognizer *)gestureRecognizer;
{
    [[self nameTextField] resignFirstResponder];
    [[self sexTextField] resignFirstResponder];
    [[self weightTextField] resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Move the whole view up a little when editing a textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

// Move it back down when done editing
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

// The animation with bool for moving up or down. Source: user Amagrammer at stackoverflow. Post URL: http://stackoverflow.com/questions/1247113/iphone-keyboard-covers-uitextfield
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80;
    const float movementDuration = 0.1f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


@end
