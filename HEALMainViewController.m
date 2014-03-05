//
//  HEALMainViewController.m
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALMainViewController.h"

@interface HEALMainViewController () {

bool first;

NSTimer *timer;
    
double sex;
    
double weight;
    
NSString *sexy;

int mainInt;

float startTime;

float currentTime;
    
NSUserDefaults *defaults;
    
}

@end

@implementation HEALMainViewController

- (void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countUp) userInfo:nil repeats:YES];
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    if(![defaults objectForKey:@"userSex"] || ![defaults objectForKey:@"userWeight"])
    {
        [self alertUser:@"Please enter weight and sex in settings."];
    } else {
        
        weight = [[defaults objectForKey:@"userWeight"] doubleValue];
        sexy = [defaults stringForKey:@"userSex"];
        if ([sexy isEqualToString:@"F"]) {
            sex = 0.66;
        }
        else{
            sex = 0.73;
        }
        double value = [sender value];
        [myLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
        if (first){
            first = false;
            NSDate *myDate = [[NSDate alloc] init];
            NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
            [dFormatter setDateFormat:@"hh:mm a"];
            NSString *t = [dFormatter stringFromDate: myDate];
            [timeLabel setText:[NSString stringWithFormat:@"%@%@", @"Drinking since: ", t]];
            NSDateFormatter *startFormat = [[NSDateFormatter alloc] init];
            [startFormat setDateFormat:@"cccc, MMMM dd, yyyy, hh:mm aa"];
            NSString *nicerDate = [startFormat stringFromDate:myDate];
            NSDate *startDate = [startFormat dateFromString:nicerDate];
            startTime = [startDate timeIntervalSince1970];
            [self startTimer];
            [self countUp];
        } else {
            [self countUp];
        }
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

- (void) countUp {
    NSDate *cTime = [NSDate date];
    NSDateFormatter *currentFormat = [[NSDateFormatter alloc] init];
    [currentFormat setDateFormat:@"cccc, MMMM dd, yyyy, hh:mm aa"];
    NSString *nicerDate = [currentFormat stringFromDate:cTime];
    NSDate *currentDate = [currentFormat dateFromString:nicerDate];
    currentTime = [currentDate timeIntervalSince1970];
    float labelVal = [[myLabel text] floatValue];
    [bacLabel setText:[NSString stringWithFormat:@"%f", (((labelVal * 3.084) / (sex * weight)) - (0.15 * ((currentTime - startTime)/ 3600)))]];
}

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

-(void)alertUser:(NSString*) alertMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
//    if([segue.identifier isEqualToString:@"stateSegue"]){
//        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
//        DrunkStateViewController *controller = (DrunkStateViewController *)navController.topViewController;
//        controller.labelText = @"Test";
//        
//    }
    
}

@end
