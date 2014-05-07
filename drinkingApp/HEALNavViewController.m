//
//  HEALNavViewController.m
//  drinkingApp
//
//  Created by Eivind Morris Bakke on 5/7/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALNavViewController.h"
#import "HEALUser.h"
#import "HEALMainViewController.h"

@interface HEALNavViewController () {
    HEALUser* newUser;
}

@end

@implementation HEALNavViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        [self checkSettings];
//    }
//    return self;
//}

- (void)checkSettings
{
    NSLog(@"YES IT IS CALLED!");
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    if (![defaults objectForKey:@"userWeight"]) {
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
        newUser.smsState = [defaults doubleForKey:@"smsState"];
        newUser.contactNumber = [defaults stringForKey:@"contactNumber"];
        newUser.autoSMS = [defaults boolForKey:@"autoSMS"];
    }
    
    HEALMainViewController* mainViewController = self.viewControllers[0];
    
    mainViewController.user = newUser;
    
    [self setViewControllers:@[mainViewController]];
}

- (void)viewDidLoad
{
    [self checkSettings];
}
@end
