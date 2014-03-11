//
//  HEALMainViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALMainViewController.h"

@interface HEALMainViewController ()
{
    NSTimer *timer;
}

@end

@implementation HEALMainViewController

- (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countUp) userInfo:nil repeats:YES];
}


- (void)setDateLabel:(NSDate*)date
{
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"hh:mm a"];
    NSString *t = [dFormatter stringFromDate: date];
    [timeLabel setText:[NSString stringWithFormat:@"%@%@", @"Drinking since: ", t]];
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    if(self.user.userSex == nil)
    {
        [self alertUser:@"Please enter weight and sex in settings."];
        sender.value = 0;
    } else {
        if (timer == nil) {
            [self startTimer];
            [self.user.currentNight setStartTime];
        }
        self.user.currentNight.drinks = [NSNumber numberWithDouble:[sender value]];
        [self updateLabels];
    }
}

- (IBAction)addNight:(UIButton *)sender
{
    [timer invalidate];
    timer = nil;
    [bacLabel setText:@"0.000"];
    [timeLabel setText:@"Ready to start? Press the plus below!"];
}

- (void)countUp
{
    [bacLabel setText:[NSString stringWithFormat:@"%f", [self.user getUserBAC]]];
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue
{
    [self updateLabels];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    return self;
}

- (void) updateLabels
{
    [myLabel setText:[NSString stringWithFormat:@"%d", [self.user.currentNight.drinks intValue]]];
    [self setDateLabel:[NSDate dateWithTimeIntervalSince1970:[self.user.currentNight.startTime doubleValue]]];
    [self countUp];
    
    if([self.user getUserBAC] < 0.06)
    {
        [stateButton setTitle:@"Tipsy" forState:UIControlStateNormal];
    } else if (0.06 < [self.user getUserBAC] && [self.user getUserBAC] < 0.2)
    {
        [stateButton setTitle:@"Drunk" forState:UIControlStateNormal];
    } else if (0.2 < [self.user getUserBAC])
    {
        [stateButton setTitle:@"Danger" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertUser:(NSString*) alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toStateViewController"])
    {
        DrunkStateViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    }
    if([segue.identifier isEqualToString:@"toSettingsViewController"])
    {
        HEALEditSettingsViewController *controller = [segue destinationViewController];
        controller.user = self.user;
    }
    
}

@end