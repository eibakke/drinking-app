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
   // [[self contactNameTextField] setDelegate:self];
   // [[self contactNumberTextField] setDelegate:self];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground:)];
    [self.view addGestureRecognizer:tapBackground];
    [self initializeUI];
    
   //[self.firstName setFont:[UIFont fontWithName:@"Cambria" size: 11]];
   // [self.phoneNumber setFont:[UIFont fontWithName:@"Cambria" size: 11]];
   // [self.addContact setFont:[UIFont fontWithName:@"Cambria" size: 16]];
    
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
        self.phoneNumber.text  = self.user.contactNumber;
    }
    if (self.user.sosContact != nil) {
        self.firstName.text = self.user.sosContact;
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
    //if ([self validInput]) {
     //   [self updateUser];
//        [self performSegueWithIdentifier:@"unwindToMain" sender:self];
    //}
}

- (void)updateUser
{
    self.user.contactNumber = self.phoneNumber.text; //edited
    self.user.sosContact = self.firstName.text; //edited
    self.user.smsMessage = self.emergencyMessageTextField.text;
    self.user.smsState = smsState;
    self.user.autoSMS = sendAutoSMS;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sendAutoSMS forKey:@"autoSMS"];
    [defaults setInteger:smsState forKey:@"smsState"];
    [defaults setObject:self.contactNumber forKey:@"contactNumber"];
    [defaults setObject:self.contactName forKey:@"sosContact"];
    [defaults setObject:self.emergencyMessageTextField.text forKey:@"smsMessage"];
    
    @try {
        [defaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"Data save failed.");
    }
    
}

//NEED TO CHANGE THIS TO SAVE CONTACT INFO CORRECTLY
/*
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
*/
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

   // [[self contactNameTextField] resignFirstResponder];
  //  [[self contactNumberTextField] resignFirstResponder];
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




//GETTING CONTACT INFO FROM ADDRESSBOOK

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
    _contactName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    self.firstName.text = _contactName;
    //self.contactNameTextField.text = name;
    
    _contactNumber = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        _contactNumber = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        _contactNumber = @"[None]";
    }
    self.phoneNumber.text = self.contactNumber;
    

    
    CFRelease(phoneNumbers);
}


@end
