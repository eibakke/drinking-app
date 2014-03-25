//
//  HEALNewUserViewController.h
//  drinkingApp
//
//  Created by Leo Zoeckler on 3/6/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@interface HEALNewUserViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet RadioButton *maleRadioButton;

-(IBAction)sex:(RadioButton*)sender; //new method for setting sex
@property (weak, nonatomic) IBOutlet RadioButton *femaleRadioButton;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end
