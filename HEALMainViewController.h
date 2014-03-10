//
//  HEALMainViewController.h
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrunkStateViewController.h"
#import "HEALUser.h"


@interface HEALMainViewController : UIViewController {
    
    IBOutlet UILabel *myLabel;
    IBOutlet UILabel *bacLabel;
    IBOutlet UILabel *timeLabel;
    __weak IBOutlet UIButton *stateButton;
    
    @public HEALUser *user;
}

- (IBAction)valueChanged:(UIStepper *)sender;

- (IBAction)addNight:(UIButton *)sender;

- (void)countUp;

- (void)startTimer;

- (float)getTimeSec:(NSDate*)date;

- (void)setLabel:(NSDate*)date;

-(IBAction)unwindToMain:(UIStoryboardSegue *)segue;

@end
