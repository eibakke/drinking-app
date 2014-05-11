//
//  HEALEditSMSSettingsViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 4/14/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALEditSMSSettingsViewController.h"
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface HEALEditSMSSettingsViewController () {
    NSString *contactName;
    NSString *contactNumber;
    NSString *smsMessage;
    BOOL sendAutoSMS;
    int smsState;
}

@end

@implementation HEALEditSMSSettingsViewController

//############################################ Setup and Initialize SubViews and User Interaction When View Loads ############################################

// Reinitializes the UI whenever the view appears.
- (void)viewWillAppear:(BOOL)animated
{
    [self setupUI];
}

// Runs doneButtonPressed whenever the view disappers. For instance when the back button is pressed
- (void) viewWillDisappear:(BOOL)animated
{
    [self doneButtonPressed:self];
}

// Sets the contents of the text fields and the checked radio buttons, as well as the background image and the navigation bar
- (void)setupUI
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"empty.png"]];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"emptyNav.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [self.contactNameLabel setFont:[UIFont fontWithName:@"Cambria" size: 20]];
    [self.contactNumberLabel setFont:[UIFont fontWithName:@"Cambria" size: 20]];
    [self.autoSMSLabel setFont:[UIFont fontWithName:@"Cambria" size:22]];
    [self.smsStateLabel setFont:[UIFont fontWithName:@"Cambria" size:22]];
    self.enableRadioButton.titleLabel.font = [UIFont fontWithName:@"Cambria" size:18];
    self.disableRadioButton.titleLabel.font = [UIFont fontWithName:@"Cambria" size:18];
    self.drunkRadioButton.titleLabel.font = [UIFont fontWithName:@"Cambria" size:18];
    self.dangerRadioButton.titleLabel.font = [UIFont fontWithName:@"Cambria" size:18];
    
    // We want the textfields to delegate back to this view controller
    [[self emergencyMessageTextField] setDelegate:self];

    [self.enableRadioButton setSelected:self.user.autoSMS];
    
    if (self.user.contactNumber != nil) {
        self.contactNumberLabel.text  = self.user.contactNumber;
    }
    if (self.user.sosContact != nil) {
        self.contactNameLabel.text = self.user.sosContact;
    }
    if (self.user.smsMessage != nil) {
        self.emergencyMessageTextField.text = self.user.smsMessage;
    }
    
    if (self.user.smsState == INTOXSTATE_DRUNK) {
        [self.drunkRadioButton setSelected:YES];
        smsState = INTOXSTATE_DRUNK;
    } else if (self.user.smsState == INTOXSTATE_DANGER) {
        [self.dangerRadioButton setSelected:YES];
        smsState = INTOXSTATE_DANGER;
    }
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground:)];
    [self.view addGestureRecognizer:tapBackground];
}

//############################################ Reactions to Buttons ############################################
// Sets local sendAutoSMS variable and runs updateUser
- (IBAction)doneButtonPressed:(id)sender
{
    if (self.enableRadioButton.isSelected) {
        sendAutoSMS = YES;
    } else sendAutoSMS = NO;

    [self updateUser];
}

// Runs when the background is tapped. Resigns the keyboards and runs doneButtonPressed if it's the first time the background
// has been tapped since text fields have been active.
- (void)tapBackground:(UIGestureRecognizer *)gestureRecognizer;
{
    [[self emergencyMessageTextField] resignFirstResponder];
}

// To get the keyboard to collapse when return is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

// Updates user properties, sets user defaults, sets the local smsState variable, and sets the contact name and number text fields.
- (void)updateUser
{
    if (contactName != nil) {
        self.contactNameLabel.text = contactName;
    }
    
    if (contactNumber != nil) {
        self.contactNumberLabel.text = contactNumber;
    }
    
    if (smsMessage != nil) {
        self.emergencyMessageTextField.text = smsMessage;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:sendAutoSMS forKey:@"autoSMS"];
    [defaults setObject:self.contactNumberLabel.text forKey:@"contactNumber"];
    [defaults setObject:self.contactNameLabel.text forKey:@"sosContact"];
    [defaults setObject:self.emergencyMessageTextField.text forKey:@"smsMessage"];
    
    if ([self.drunkRadioButton isSelected]){
        [defaults setInteger:INTOXSTATE_DRUNK forKey:@"smsState"];
        smsState = INTOXSTATE_DRUNK;
    } else if ([self.dangerRadioButton isSelected]){
        [defaults setInteger:INTOXSTATE_DANGER forKey:@"smsState"];
        smsState = INTOXSTATE_DANGER;
    }
    
    self.user.contactNumber = self.contactNumberLabel.text;
    self.user.sosContact = self.contactNameLabel.text;
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



//############################################ GETTING CONTACT INFO FROM ADDRESSBOOK ############################################

// Presents the picker as a modal view controller
- (IBAction)showPicker:(id)sender
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:NULL] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];

    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

// Responding to user actions in the people picker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// View Controller to pick contacts
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

// Displaying a person’s information
- (void)displayPerson:(ABRecordRef)person
{
    contactName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);

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
