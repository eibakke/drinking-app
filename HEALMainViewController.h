//
//  HEALMainViewController.h
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HEALMainViewController : UIViewController {

IBOutlet UILabel *myLabel;

IBOutlet UILabel *bacLabel;

IBOutlet UILabel *timeLabel;

}

- (IBAction)valueChanged:(UIStepper *)sender;

- (IBAction)addNight:(UIButton *)sender;

- (void)countUp;

- (void)startTimer;

-(IBAction)unwindToMain:(UIStoryboardSegue *)segue;

@end
