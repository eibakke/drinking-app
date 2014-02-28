//
//  HEALEditSettingsViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALEditSettingsViewController.h"

@interface HEALEditSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneButton:(id)sender;

@end

@implementation HEALEditSettingsViewController

// To get the keyboard to collapse when return is pressed
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

// Called when the doneButton is pressed
- (IBAction)doneButton:(id)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    // Check user input and pop up alerts with directions if the user input is invalid
    if (([[self.weightTextField text] isEqualToString:@""]) || ([[self.weightTextField text] rangeOfCharacterFromSet:notDigits].location != NSNotFound)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                        message:@"Please enter a whole number for weight."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if(!([[self.sexTextField text] isEqualToString:@"M"] || [[self.sexTextField text] isEqualToString:@"F"])){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                        message:@"Please enter F or M for sex."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // If user input is in order store the textfield values and unwind back to the main view
    if (([[self.weightTextField text] rangeOfCharacterFromSet:notDigits].location == NSNotFound) && ([[self.sexTextField text] isEqualToString:@"M"] || [[self.sexTextField text] isEqualToString:@"F"])) {
        
        NSNumber *weight = [NSNumber numberWithDouble:[[self.weightTextField text] doubleValue]];
        [defaults setObject:weight forKey:@"userWeight"];
        [defaults setObject:[self.sexTextField text] forKey:@"userSex"];
        [defaults setObject:[self.nameTextField text] forKey:@"userName"];
        @try {
            [defaults synchronize];
        }
        @catch (NSException *exception) {
            NSLog(@"Data save failed.");
        }
        [self performSegueWithIdentifier:@"unwindToMain" sender:self];
    }
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
    
    // Set the placeholder text in the textfields to come from the user defaults, if they have been set yet
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"userWeight"] != nil) {
        self.weightTextField.placeholder = [[defaults objectForKey:@"userWeight"] stringValue];
    }
    if([defaults objectForKey:@"userSex"] != nil) {
        self.sexTextField.placeholder = [defaults objectForKey:@"userSex"];
    }
    if([defaults objectForKey:@"userName"] != nil) {
        self.nameTextField.placeholder = [defaults objectForKey:@"userName"];
    }
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
