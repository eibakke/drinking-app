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
#import <QuartzCore/QuartzCore.h>
#import "CERoundProgressView.h"


@interface HEALMainViewController : UIViewController <MFMessageComposeViewControllerDelegate> {
    
}
@property (strong, nonatomic) HEALUser *user;
@property (weak, nonatomic) IBOutlet UIStepper *drinkStepper;
@property (weak, nonatomic) IBOutlet UILabel *drinkLabel;
@property (weak, nonatomic) IBOutlet UILabel *bacLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet CERoundProgressView *roundProgressView;


- (IBAction)valueChanged:(UIStepper *)sender;
- (IBAction)threeLinesButtonClicked:(id)sender;
- (IBAction)swipedLeft:(id)sender;
- (IBAction)swipedRight:(id)sender;
- (IBAction)runAddValueChanged:(id)sender;

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue;

@end
