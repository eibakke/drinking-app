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
    HEALUser *newUser;
}
@end

@implementation LogoViewController

- (void)checkSettings
{
    [NSThread sleepForTimeInterval:2.0f];
    if ([defaults objectForKey:@"userSex"] == nil) {
        [self performSegueWithIdentifier:@"newUserSegue" sender:self];
    } else {
        newUser = [[HEALUser alloc] init:[defaults objectForKey:@"userName"] userSex:[defaults objectForKey:@"userSex"] userWeight:[defaults objectForKey:@"userWeight"]];

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"mainSegue"]){
        HEALMainViewController *controller = [segue destinationViewController];
        controller.user = newUser;
    
    }
    
}
@end
