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

@interface HEALEditSMSSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet RadioButton *disableRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *enableRadioButton;

@property (weak, nonatomic) IBOutlet RadioButton *tipsyRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *drunkRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *dangerRadioButton;

@property (weak, nonatomic) IBOutlet UITextField *contactNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactNumberTextField;
@property (weak, nonatomic) IBOutlet UITextView *emergencyMessageTextView;

@property (strong, nonatomic) HEALUser *User;
@end
