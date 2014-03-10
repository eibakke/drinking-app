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
    bool first;

    NSTimer *timer;
    
    double sexVal;
    
    double weight;
    
    NSString *sex;

    int mainInt;

    float startTime;

    float currentTime;
    
    NSUserDefaults *defaults;
}

@end

@implementation HEALMainViewController

- (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countUp) userInfo:nil repeats:YES];
}

- (float)getTimeSec:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMMM dd, yyyy, hh:mm aa"];
    NSString *nicerDate = [dateFormat stringFromDate:date];
    NSDate *timeDate = [dateFormat dateFromString:nicerDate];
    return [timeDate timeIntervalSince1970];
}

- (void)setLabel:(NSDate*)date
{
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"hh:mm a"];
    NSString *t = [dFormatter stringFromDate: date];
    [timeLabel setText:[NSString stringWithFormat:@"%@%@", @"Drinking since: ", t]];
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    if([self.user getUserSex] == nil)
    {
        [self alertUser:@"Please enter weight and sex in settings."];
    } else {
        
//        weight = [[defaults objectForKey:@"userWeight"] doubleValue];
//        sex = [defaults stringForKey:@"userSex"];
//        if ([sex isEqualToString:@"F"]) {
//            sexVal = 0.66;
//        }
//        else{
//            sexVal = 0.73;
//        }
        double value = [sender value];
        [myLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
        [self.user setDrinks:(int)value];
        if (first){
            first = false;
            NSDate *myDate = [[NSDate alloc] init];
            startTime = [self getTimeSec:myDate];
            [self setLabel:myDate];
            [self startTimer];
            [self countUp];
        } else {
            [self countUp];
        }
        [self setLabels];
    }
}

- (IBAction)addNight:(UIButton *)sender
{
    [timer invalidate];
    timer = nil;
    first = true;
    [bacLabel setText:@"0.000"];
    [timeLabel setText:@"Ready to start? Press the plus below!"];
}

- (void)countUp
{
//    NSDate *cTime = [NSDate date];
//    currentTime = [self getTimeSec:cTime];
//    float labelVal = [[myLabel text] floatValue];
    [bacLabel setText:[NSString stringWithFormat:@"%f", [self.user getUserBAC]]];
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue
{
    [self setLabels];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    return self;
}

- (void) setLabels
{
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
    
    defaults = [NSUserDefaults standardUserDefaults];
    first = true;
    
	NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
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
    
//    if([segue.identifier isEqualToString:@"stateSegue"]){
//        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
//        DrunkStateViewController *controller = (DrunkStateViewController *)navController.topViewController;
//        controller.labelText = @"Test";
//        
//    }
    
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