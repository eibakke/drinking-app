//
//  HEALEditSMSSettingsViewController.h
//  drinkingApp
//
//  Created by Eivind Bakke on 4/14/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import "HEALUser.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface HEALEditSMSSettingsViewController : UIViewController <UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *contactNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emergencyMessageTextField;

@property (weak, nonatomic) IBOutlet RadioButton *disableRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *enableRadioButton;

@property (weak, nonatomic) IBOutlet RadioButton *tipsyRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *drunkRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *dangerRadioButton;

@property (strong, nonatomic) HEALUser *user;

- (IBAction)doneButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *addContact;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

- (IBAction)showPicker:(id)sender;

@end
