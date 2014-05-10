//
//  HEALEditSMSSettingsViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 4/14/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALEditSMSSettingsViewController.h"

@interface HEALEditSMSSettingsViewController () {
    NSString *contactName;
    NSString *contactNumber;
    BOOL sendAutoSMS;
    int smsState;
    BOOL popDown;
}

@end

@implementation HEALEditSMSSettingsViewController

- (void)viewDidLoad
{
    popDown = FALSE;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"empty.png"]];
    
    // We want the textfields to delegate back to this view controller
    [[self emergencyMessageTextField] setDelegate:self];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground:)];
    [self.view addGestureRecognizer:tapBackground];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initializeUI];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"sampleNavBar1.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self doneButtonPressed:self];
}

- (void)initializeUI
{
    [self.enableRadioButton setSelected:self.user.autoSMS];
    
    if (self.user.contactNumber != nil) {
        self.contactNumberTextField.text  = self.user.contactNumber;
    }
    if (self.user.sosContact != nil) {
        self.contactNameTextField.text = self.user.sosContact;
    }
    if (self.user.smsMessage != nil) {
        self.emergencyMessageTextField.text = self.user.smsMessage;
    }
    
    if (self.user.smsState == INTOXSTATE_TIPSY) {
        [self.tipsyRadioButton setSelected:YES];
        smsState = INTOXSTATE_TIPSY;
    } else if (self.user.smsState == INTOXSTATE_DRUNK) {
        [self.drunkRadioButton setSelected:YES];
        smsState = INTOXSTATE_DRUNK;
    } else if (self.user.smsState == INTOXSTATE_DANGER) {
        [self.dangerRadioButton setSelected:YES];
        smsState = INTOXSTATE_DANGER;
    }
}

- (IBAction)doneButtonPressed:(id)sender
{
    if (self.enableRadioButton.isSelected) {
        sendAutoSMS = YES;
    } else sendAutoSMS = NO;

    [self updateUser];
}

- (void)updateUser
{
    if (contactName != nil)
    {
        self.contactNameTextField.text = contactName;
    }
    
    if (contactNumber != nil)
    {
        self.contactNumberTextField.text = contactNumber;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:sendAutoSMS forKey:@"autoSMS"];
    [defaults setObject:self.contactNumberTextField.text forKey:@"contactNumber"];
    [defaults setObject:self.contactNameTextField.text forKey:@"sosContact"];
    [defaults setObject:self.emergencyMessageTextField.text forKey:@"smsMessage"];
    //[defaults setInteger:smsState forKey:@"smsState"];
    
    if ([self.tipsyRadioButton isSelected]){
        [defaults setInteger:INTOXSTATE_TIPSY forKey:@"smsState"];
        smsState = INTOXSTATE_TIPSY;
    } else if ([self.drunkRadioButton isSelected]){
        [defaults setInteger:INTOXSTATE_DRUNK forKey:@"smsState"];
        smsState = INTOXSTATE_DRUNK;
    } else if ([self.dangerRadioButton isSelected]){
        [defaults setInteger:INTOXSTATE_DANGER forKey:@"smsState"];
        smsState = INTOXSTATE_DANGER;
    }
    
    self.user.contactNumber = self.contactNumberTextField.text;
    self.user.sosContact = self.contactNameTextField.text;
    self.user.smsMessage = self.emergencyMessageTextField.text;
    self.user.autoSMS = sendAutoSMS;
    self.user.smsState = smsState;
    
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

- (void)tapBackground:(UIGestureRecognizer *)gestureRecognizer;
{
    if(popDown == TRUE)
    {
        [self doneButtonPressed:self];
    }

    [[self emergencyMessageTextField] resignFirstResponder];
    [[self contactNameTextField] resignFirstResponder];
    [[self contactNumberTextField] resignFirstResponder];
}

// To get the keyboard to collapse when return is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

// Move the whole view up a little when editing a textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    popDown = TRUE;
    [self animateTextField: textField up: YES];
}

// Move it back down when done editing
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    popDown = FALSE;
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




//////////////////////////////////////////GETTING CONTACT INFO FROM ADDRESSBOOK////////////////////////////////////////////////////

//presents the picker as a modal view controller
- (IBAction)showPicker:(id)sender
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:NULL] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];

    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
   // [self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}

//Responding to user actions in the people picker
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

//Displaying a person’s information

- (void)displayPerson:(ABRecordRef)person
{
    contactName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);

    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        contactNumber = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        contactNumber = @"[None]";
    }

    CFRelease(phoneNumbers);
    
    [self doneButtonPressed:self];
}

@end
