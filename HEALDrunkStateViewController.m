//
//  HEALDrunkStateViewController.m
//  drinkingApp
//
//  Created by Haroon Bokhary on 3/3/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALDrunkStateViewController.h"


@interface HEALDrunkStateViewController ()

@end


@implementation HEALDrunkStateViewController
//@synthesize messageLabel;

- (void)viewDidLoad
{
    [_messageLabel setFont:[UIFont fontWithName:@"Cambria" size: 32]];
    [_bacLabel setFont:[UIFont fontWithName:@"Cambria" size: 32]];

    
    [super viewDidLoad];

    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    
   
   // [messageLabel setFont:[UIFont fontWithName:@"Cambria" size: messageLabel.font.pointSize]];
    
    //[messageLabel setFont:[UIFont fontWithName:@"Cambria" size:40]];
    
    
    self.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self.user stateAsString], @"State.png"]];
    
    [self.bacLabel setText:[NSString stringWithFormat:@"%f", self.user.BAC]];
    
    if (self.user.state == SOBER){
        
        [self.messageLabel setText: self.user.currentNight.soberMessage];
    }
    else if (self.user.state == TIPSY)
    {
        [self.messageLabel setText:[NSString stringWithFormat:@"%@", self.user.currentNight.tipsyMessage]];
    }
    else if (self.user.state == DRUNK)
    {
        [self.messageLabel setText:[NSString stringWithFormat:@"%@", self.user.currentNight.drunkMessage]];
    }
    else{
        [self.messageLabel setText:[NSString stringWithFormat:@"%@", self.user.currentNight.drunkMessage]];
    }
        

}
@end



