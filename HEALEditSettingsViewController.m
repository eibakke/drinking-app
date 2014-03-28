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
    sexes newSex;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)doneButton:(id)sender;

@end

@implementation HEALEditSettingsViewController



// Called when the doneButton is pressed
- (IBAction)doneButton:(id)sender{
    
    [self setNewSex];
    
    if ([self validInfoEntered]) {
        
            // If user input is in order store the textfield values and unwind back to the main view
        if ([self userInfoUpdated] && (self.user.currentNight.drinks != 0)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Changing your data will start a new night."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
        else if([self userInfoUpdated] && (self.user.currentNight.drinks == 0)) {
            [self updateUser];
            [self performSegueWithIdentifier:@"backToMain" sender:self];
        }
        
        else {
            [self performSegueWithIdentifier:@"backToMain" sender:self];
        }
        
    }
}

-(void)setNewSex
{
    if ([self.maleRadioButton isSelected])
    {
        newSex = MALE;
    }
    else if([self.femaleRadioButton isSelected])
    {
        newSex = FEMALE;
    }
}

// Check user input and pop up alerts with directions if the user input is invalid
-(BOOL)validInfoEntered {
    
    notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if (([[self.weightTextField text] isEqualToString:@""]) || ([[self.weightTextField text] rangeOfCharacterFromSet:notDigits].location != NSNotFound)) {
        [self alertUser:@"Please enter a whole number for weight in lbs."];
        return NO;
    }
    
    return YES;
}


// Checks if the info the user has entered is different from what is stored
-(BOOL)userInfoUpdated {
    int currWeight = self.user.weight;
    sexes currSex = self.user.sex;
    
    if ((currWeight == [[self.weightTextField text] intValue]) && (currSex == newSex)) {
        return NO;
    } else {
        return YES;
    }
}

-(void)updateUser {
    
    NSNumber *weight = [NSNumber numberWithDouble:[[self.weightTextField text] doubleValue]];
    [defaults setObject:weight forKey:@"userWeight"];
    [defaults setObject:[self.nameTextField text] forKey:@"userName"];
    
    if ([self.maleRadioButton isSelected])
    {
        [defaults setObject:@"M" forKey:@"userSex"];
    }
    else if([self.femaleRadioButton isSelected])
    {
        [defaults setObject:@"F" forKey:@"userSex"];
    }
    
    self.user.weight = [[self.weightTextField text] intValue];
    self.user.name = [self.nameTextField text];
    
    self.user.sex = newSex;
    
    @try {
        [defaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"Data save failed.");
    }
}

-(void)alertUser:(NSString*) alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self updateUser];
        [self.user.currentNight reset];
        [self performSegueWithIdentifier:@"backToMain" sender:self];
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
	
    self.navigationItem.hidesBackButton = YES;
    
    // We want the textfields to delegate back to this view controller
    [[self weightTextField] setDelegate:self];
    [[self nameTextField] setDelegate:self];
    
    // Set the text in the textfields to come from the user defaults, if they have been set yet
    defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"userWeight"] != nil) {
        self.weightTextField.text = [[defaults objectForKey:@"userWeight"] stringValue];
    }
    if([[defaults objectForKey:@"userSex"] isEqualToString:@"F"])
    {
        [self.femaleRadioButton setSelected:YES];
    } else if([[defaults objectForKey:@"userSex"] isEqualToString:@"M"])
    {
        [self.maleRadioButton setSelected:YES];
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
    [[self weightTextField] resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// To get the keyboard to collapse when return is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
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