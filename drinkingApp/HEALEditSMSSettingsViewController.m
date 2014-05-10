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
    BOOL popDown;
}

@end

@implementation HEALEditSMSSettingsViewController

// Sets text field delegates, background image, and gesture recognizers.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"empty.png"]];
    
    [self.contactNameLabel setFont:[UIFont fontWithName:@"Cambria" size: 20]];
    [self.contactNumberLabel setFont:[UIFont fontWithName:@"Cambria" size: 20]];
    [self.autoSMSLabel setFont:[UIFont fontWithName:@"Cambria" size:22]];
    [self.smsStateLabel setFont:[UIFont fontWithName:@"Cambria" size:22]];
    [self.enableRadioButton setFont:[UIFont fontWithName:@"Cambria" size:18]];
    [self.disableRadioButton setFont:[UIFont fontWithName:@"Cambria" size:18]];
    [self.drunkRadioButton setFont:[UIFont fontWithName:@"Cambria" size:18]];
    [self.dangerRadioButton setFont:[UIFont fontWithName:@"Cambria" size:18]];
    
    // We want the textfields to delegate back to this view controller
    [[self emergencyMessageTextField] setDelegate:self];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground:)];
    [self.view addGestureRecognizer:tapBackground];
}

// Reinitializes the UI whenever the view appears.
- (void)viewWillAppear:(BOOL)animated
{
    popDown = FALSE;
    [self initializeUI];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"sampleNavBar1.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

// Runs doneButtonPressed whenever the view disappers.
- (void) viewWillDisappear:(BOOL)animated
{
    [self doneButtonPressed:self];
}

// Sets the contents of the text fields and the checked radio buttons.
- (void)initializeUI
{
    if (IS_WIDESCREEN) {
        [self.sosMessageHeader setHidden:NO];
    }
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
}

// Sets local sendAutoSMS variable and runs updateUser
- (IBAction)doneButtonPressed:(id)sender
{
    if (self.enableRadioButton.isSelected) {
        sendAutoSMS = YES;
    } else sendAutoSMS = NO;

    [self updateUser];
}

// Updates user properties, sets user defaults, sets the local smsState variable, and sets the contact name and number text fields.
- (void)updateUser
{
    if (contactName != nil)
    {
        self.contactNameLabel.text = contactName;
    }
    
    if (contactNumber != nil)
    {
        self.contactNumberLabel.text = contactNumber;
    }
    
    if (smsMessage != nil)
    {
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

// Runs when the background is tapped. Resigns the keyboards and runs doneButtonPressed if it's the first time the background
// has been tapped since text fields have been active.
- (void)tapBackground:(UIGestureRecognizer *)gestureRecognizer;
{
    if(popDown == TRUE)
    {
        [self doneButtonPressed:self];
    }

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
    popDown = TRUE;
   // [self animateTextField: textField up: YES];
}

// Move it back down when done editing
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    popDown = FALSE;
   // [self animateTextField: textField up: NO];
}
//
//// The animation with bool for moving up or down. Source: user Amagrammer at stackoverflow. Post URL: http://stackoverflow.com/questions/1247113/iphone-keyboard-covers-uitextfield
//- (void) animateTextField: (UITextField*) textField up: (BOOL) up
//{
//    const int movementDistance = 50;
//    const float movementDuration = 0.1f;
//    
//    int movement = (up ? -movementDistance : movementDistance);
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//}

//////////////////////////////////////////GETTING CONTACT INFO FROM ADDRESSBOOK////////////////////////////////////////////////////

//presents the picker as a modal view controller
- (IBAction)showPicker:(id)sender
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:NULL] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];

    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//Responding to user actions in the people picker
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// HAROON WHAT DOES THIS DO. !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
