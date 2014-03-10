//
//  DrunkStateViewController.m
//  drinkingApp
//
//  Created by Haroon Bokhary on 3/3/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "DrunkStateViewController.h"


@interface DrunkStateViewController ()

@end

@implementation DrunkStateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if([self.user getUserBAC] < 0.06)
    {
        self.stateLabel.text = @"Tipsy";
        self.stateDetails.text = @"Slight euphoria \n \n Sense of relaxation \n \n Lower inhibitions \n \n Thought process slowed \n \n Lowered alertness";
    } else if(0.06 < [self.user getUserBAC] && [self.user getUserBAC] < 0.2){
        self.stateLabel.text = @"Drunk";
        self.stateDetails.text = @"Now you are drunk";
    } else if(0.2 < [self.user getUserBAC]) {
        self.stateLabel.text = @"Danger";
        self.stateDetails.text = @"Now you should stop drinking";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
