//
//  HEALEditSettingsViewController.h
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEALUser.h"
#import "RadioButton.h"
#import "HEALMainViewController.h"

@interface HEALEditSettingsViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *weightWarningLabel;

@property (weak, nonatomic) IBOutlet RadioButton *maleRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *femaleRadioButton;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;

@property (strong, nonatomic) HEALUser *user;

@end
