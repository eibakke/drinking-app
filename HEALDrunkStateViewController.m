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

//############################################ Everything here is basically UI setup ############################################
// Set fonts of all labels to be Cambria, size 32
- (void)viewDidLoad
{
    [self.shouldLabel setFont:[UIFont fontWithName:@"Cambria" size: 32]];
    [self.messageLabel setFont:[UIFont fontWithName:@"Cambria" size: 32]];
    [self.bacLabel setFont:[UIFont fontWithName:@"Cambria" size: 26]];
    [self.drinksLabel setFont:[UIFont fontWithName:@"Cambria" size: 26]];

}

// Every time this viewcontroller's view appears, we want to display information pertinent to the user's state
- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"empty.png"]];
    self.headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Header.png", [self.user stateAsString]]];
    
    NSString *roundedBAC = [NSString stringWithFormat:@"%.3f", self.user.BAC];
    [self.bacLabel setText:[NSString stringWithFormat:@"Current BAC: %@", roundedBAC]];
    
    [self.messageLabel setText: [self.user.currentNight stateMessage:self.user.state]];
    [self.messageLabel setTextColor:self.user.stateColor];
    
    [self.drinksLabel setText:[NSString stringWithFormat:@"Number of Drinks: %d", self.user.currentNight.drinks]];

}
@end



