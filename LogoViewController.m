//
//  LogoViewController.m
//  drinkingApp
//
//  Created by Leo Zoeckler on 3/6/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "LogoViewController.h"

@interface LogoViewController ()
{
NSUserDefaults *defaults;
}
@end

@implementation LogoViewController

- (void)checkSettings
{
    [NSThread sleepForTimeInterval:2.0f];
    if (![defaults objectForKey:@"userSex"] || ![defaults objectForKey:@"userWeight"]) {
        [self performSegueWithIdentifier:@"newUserSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"mainSegue" sender:self];
    }
}

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
    defaults = [NSUserDefaults standardUserDefaults];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated{
    [self checkSettings];
}
@end
