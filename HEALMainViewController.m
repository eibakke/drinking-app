//
//  HEALMainViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALMainViewController.h"

@interface HEALMainViewController ()

@end

@implementation HEALMainViewController

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue {
    [self setLabels];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    return self;
}

// An example of how to get user settings from NSUserDefaults
- (void) setLabels{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"userWeight"] != nil) {
        self.weightText.text = [[defaults objectForKey:@"userWeight"] stringValue];
    }
    if([defaults objectForKey:@"userSex"] != nil) {
        self.sexText.text = [defaults objectForKey:@"userSex"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ONLY WHILE IN DEV: This little snippet clears all the settings in the beginning, so that it'll be as if you've opened the app for the very first time.
	NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
