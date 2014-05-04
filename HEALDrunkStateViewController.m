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
    [self.messageLabel setFont:[UIFont fontWithName:@"Cambria" size: 32]];
    [self.bacLabel setFont:[UIFont fontWithName:@"Cambria" size: 32]];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self.user stateAsString], @"State.png"]];
    
    [self.bacLabel setText:[NSString stringWithFormat:@"%f", self.user.BAC]];
    [self.messageLabel setText: [self.user.currentNight stateMessage:self.user.state]];
}
@end



