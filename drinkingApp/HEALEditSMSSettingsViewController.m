//
//  HEALEditSMSSettingsViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 4/14/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALEditSMSSettingsViewController.h"

@interface HEALEditSMSSettingsViewController () {
    intoxState smsState;
    BOOL sendAutoSMS;
}

@end

@implementation HEALEditSMSSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"empty.png"]];
    
    // We want the textfields to delegate back to this view controller
    [[self emergencyMessageTextField] setDelegate:self];
    [[self contactNameTextField] setDelegate:self];
    [[self contactNumberTextField] setDelegate:self];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground:)];
    [self.view addGestureRecognizer:tapBackground];
    [self initializeUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initializeUI];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self doneButtonPressed:self];
}

- (void)initializeUI
{
    [self.enableRadioButton setSelected:self.user.autoSMS];
    
    if (self.user.contactNumber != nil) {
        self.contactNumberTextField.text = self.user.contactNumber;
    }
    if (self.user.sosContact != nil) {
        self.contactNameTextField.text = self.user.sosContact;
    }
    if (self.user.smsMessage != nil) {
        self.emergencyMessageTextField.text = self.user.smsMessage;
    }
    
    if (self.user.smsState == TIPSY) {
        [self.tipsyRadioButton setSelected:YES];
    } else if (self.user.smsState == DRUNK) {
        [self.drunkRadioButton setSelected:YES];
    } else if (self.user.smsState == DANGER) {
        [self.dangerRadioButton setSelected:YES];
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    
    if (self.enableRadioButton.isSelected) {
        sendAutoSMS = YES;
    } else sendAutoSMS = NO;
    
    if (self.tipsyRadioButton.isSelected){
        smsState = TIPSY;
    } else if (self.drunkRadioButton.isSelected){
        smsState = DRUNK;
    } else if (self.dangerRadioButton.isSelected){
        smsState = DANGER;
    }
    if ([self validInput]) {
        [self updateUser];
//        [self performSegueWithIdentifier:@"unwindToMain" sender:self];
    }
}

- (void)updateUser
{
    self.user.contactNumber = self.contactNumberTextField.text ;
    self.user.sosContact = self.contactNameTextField.text;
    self.user.smsMessage = self.emergencyMessageTextField.text;
    self.user.smsState = smsState;
    self.user.autoSMS = sendAutoSMS;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sendAutoSMS forKey:@"autoSMS"];
    [defaults setInteger:smsState forKey:@"smsState"];
    [defaults setObject:self.contactNumberTextField.text forKey:@"contactNumber"];
    [defaults setObject:self.contactNameTextField.text forKey:@"sosContact"];
    [defaults setObject:self.emergencyMessageTextField.text forKey:@"smsMessage"];
    
    @try {
        [defaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"Data save failed.");
    }
    
}

- (BOOL)validInput
{
    NSError *error = NULL;
    NSRegularExpression *phoneNumberFormat = [NSRegularExpression regularExpressionWithPattern:@"\\d{10}"
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:&error];
    
    NSRange textRange = NSMakeRange(0, self.contactNumberTextField.text.length);
    
    NSRange matchRange = [phoneNumberFormat rangeOfFirstMatchInString:self.contactNumberTextField.text options:NSMatchingReportProgress range:textRange];
    
    BOOL validPhoneNumber = NO;
    
    if (matchRange.location != NSNotFound){
        validPhoneNumber = YES;
    } else {
        [self alertUser:@"Invalid phone number entered"];
    }
    
    return validPhoneNumber;
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

- (void)tapBackground:(UIGestureRecognizer *)gestureRecognizer;
{
    [[self contactNameTextField] resignFirstResponder];
    [[self contactNumberTextField] resignFirstResponder];
    [[self emergencyMessageTextField] resignFirstResponder];
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
