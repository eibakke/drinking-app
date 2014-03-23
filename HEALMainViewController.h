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
#import "MessageUI/MessageUI.h"


@interface HEALMainViewController : UIViewController <MFMessageComposeViewControllerDelegate> {
    
    IBOutlet UIStepper *drinkStepper;
    IBOutlet UILabel *drinkLabel;
    IBOutlet UILabel *bacLabel;
    IBOutlet UILabel *timeLabel;
    __weak IBOutlet UIButton *stateButton;
}

@property (strong, nonatomic) HEALUser *user;

-(IBAction)valueChanged:(UIStepper *)sender;

-(IBAction)addNight:(UIButton *)sender;

-(IBAction)unwindToMain:(UIStoryboardSegue *)segue;

-(IBAction)sendSMS:(id)sender;

@end
