//
//  HEALMainViewController.h
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEALDrunkStateViewController.h"
#import "HEALUser.h"
#import "HEALEditSettingsViewController.h"
#import "HEALEditSMSSettingsViewController.h"
#import "MessageUI/MessageUI.h"
#import <QuartzCore/QuartzCore.h>
#import "CERoundProgressView.h"


@interface HEALMainViewController : UIViewController <MFMessageComposeViewControllerDelegate, UIGestureRecognizerDelegate> {
    
}
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) HEALUser *user;
@property (weak, nonatomic) IBOutlet UIStepper *drinkStepper;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet CERoundProgressView *roundProgressView;
@property (weak, nonatomic) IBOutlet UIButton *nightButton;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIImageView *centerView;
@property (weak, nonatomic) IBOutlet UIImageView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *smsSettingsButton;



- (IBAction)rightViewButtonClicked:(id)sender;


- (IBAction)valueChanged:(UIStepper *)sender;
- (IBAction)threeLinesButtonClicked:(id)sender;
- (IBAction)runAddValueChanged:(id)sender;

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue;

@end
