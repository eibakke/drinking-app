//
//  HEALEditSettingsViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALEditSettingsViewController.h"

@interface HEALEditSettingsViewController ()
{
    NSUserDefaults *defaults;
    NSCharacterSet *notDigits;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)doneButton:(id)sender;

@end

@implementation HEALEditSettingsViewController

// To get the keyboard to collapse when return is pressed
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
    } else if(!([[self.sexTextField text] isEqualToString:@"M"] || [[self.sexTextField text] isEqualToString:@"F"] || [[self.sexTextField text] isEqualToString:@"m"] || [[self.sexTextField text] isEqualToString:@"f"])){
        [self alertUser:@"Please enter F or M for sex."];
    }
    
    // If user input is in order store the textfield values and unwind back to the main view
    if (([[self.weightTextField text] rangeOfCharacterFromSet:notDigits].location == NSNotFound) && ([[self.sexTextField text] isEqualToString:@"M"] || [[self.sexTextField text] isEqualToString:@"F"] || [[self.sexTextField text] isEqualToString:@"m"] || [[self.sexTextField text] isEqualToString:@"f"])) {
        
        NSNumber *weight = [NSNumber numberWithDouble:[[self.weightTextField text] doubleValue]];
        [defaults setObject:weight forKey:@"userWeight"];
        [defaults setObject:[self.sexTextField text] forKey:@"userSex"];
        [defaults setObject:[self.nameTextField text] forKey:@"userName"];
        
        self.user.weight = [[self.weightTextField text] intValue];
        self.user.sex = [self.sexTextField text];
        self.user.name = [self.nameTextField text];
        [self performSegueWithIdentifier:@"backToMain" sender:self];
        
        @try {
            [defaults synchronize];
        }
        @catch (NSException *exception) {
            NSLog(@"Data save failed.");
        }
        
    }
}

-(void)alertUser:(NSString*) alertMessage{
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
    
    // We want the textfields to delegate back to this view controller
    [[self weightTextField] setDelegate:self];
    [[self sexTextField] setDelegate:self];
    [[self nameTextField] setDelegate:self];
    
    // Set the text in the textfields to come from the user defaults, if they have been set yet
    defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"userWeight"] != nil) {
        self.weightTextField.text = [[defaults objectForKey:@"userWeight"] stringValue];
    }
    if([defaults objectForKey:@"userSex"] != nil) {
        self.sexTextField.text = [defaults objectForKey:@"userSex"];
    }
    if([defaults objectForKey:@"userName"] != nil) {
        self.nameTextField.text = [defaults objectForKey:@"userName"];
    }
    
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
    const int movementDistance = 50;
    const float movementDuration = 0.1f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end