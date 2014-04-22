//
//  HEALLogoViewController.m
//  drinkingApp
//
//  Created by Leo Zoeckler on 3/6/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALLogoViewController.h"

@interface HEALLogoViewController ()
{
    NSUserDefaults *defaults;
    HEALUser *newUser;
}
@end

@implementation HEALLogoViewController

- (void)checkSettings
{
    [NSThread sleepForTimeInterval:1.0f];
    if ([defaults objectForKey:@"userSex"] == nil) {
        [self performSegueWithIdentifier:@"newUserSegue" sender:self];
    } else {
        newUser = [[HEALUser alloc] init];
        newUser.name = [defaults objectForKey:@"userName"];
        newUser.weight = [[defaults objectForKey:@"userWeight"]intValue];
        
        if ([[defaults objectForKey:@"userSex"] isEqualToString:@"F"]) {
            newUser.sex = FEMALE;
        } else {
            newUser.sex = MALE;
        }
        
        newUser.sosContact = [defaults objectForKey:@"sosContact"];
        newUser.smsMessage = [defaults objectForKey:@"smsMessage"];
        newUser.smsState = [defaults integerForKey:@"smsState"];
        newUser.contactNumber = [defaults stringForKey:@"contactNumber"];
        newUser.autoSMS = [defaults boolForKey:@"autoSMS"];

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
