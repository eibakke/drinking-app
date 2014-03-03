//
//  stepperViewController.h
//  Test0
//
//  Created by Leo Zoeckler on 2/20/14.
//  Copyright (c) 2014 Leo Zoeckler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface stepperViewController : UIViewController {
    
    IBOutlet UILabel *myLabel;
    
    IBOutlet UILabel *bacLabel;
    
    IBOutlet UILabel *timeLabel;
    
    bool first;
    
    NSTimer *timer;
    
    int mainInt;
    
    float startTime;
    
    float currentTime;
    
}

- (IBAction)valueChanged:(UIStepper *)sender;

- (IBAction)addNight:(UIButton *)sender;

- (void)countUp;

- (void)startTimer;

@end
