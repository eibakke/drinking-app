//
//  stepperViewController.m
//  Test0
//
//  Created by Leo Zoeckler on 2/20/14.
//  Copyright (c) 2014 Leo Zoeckler. All rights reserved.
//

#import "stepperViewController.h"

@interface stepperViewController ()

@end

@implementation stepperViewController

- (void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countUp) userInfo:nil repeats:YES];
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    double value = [sender value];
    [myLabel setText:[NSString stringWithFormat:@"%@%@", @"Drinks consumed: ", [NSString stringWithFormat:@"%d", (int)value]]];
    if (first){
        NSDate *myDate = [[NSDate alloc] init];
        NSDateFormatter *startFormat = [[NSDateFormatter alloc] init];
        [startFormat setDateFormat:@"cccc, MMMM dd, yyyy, hh:mm aa"];
        NSString *nicerDate = [startFormat stringFromDate:myDate];
        NSDate *startDate = [startFormat dateFromString:nicerDate];
        startTime = [startDate timeIntervalSince1970];
        [self startTimer];
        first = false;
        float labelVal = [[myLabel text] floatValue];
        [bacLabel setText:[NSString stringWithFormat:@"%f", (((labelVal * 3.084) / 109.5))]];
    } else {
        NSDate *nowDate = [[NSDate alloc] init];
        NSDateFormatter *currentFormat = [[NSDateFormatter alloc] init];
        [currentFormat setDateFormat:@"cccc, MMMM dd, yyyy, hh:mm aa"];
        NSString *nicerDate = [currentFormat stringFromDate:nowDate];
        NSDate *currentDate = [currentFormat dateFromString:nicerDate];
        currentTime = [currentDate timeIntervalSince1970];
        float labelVal = [[myLabel text] floatValue];
        [bacLabel setText:[NSString stringWithFormat:@"%f", (((labelVal * 3.084) / 109.5) - (0.15 * ((currentTime - startTime)/ 3600)))]];
    }
}

- (IBAction)addNight:(UIButton *)sender
{
    first = true;
    mainInt = 0;
    [timeLabel setText:@"Ready to start? Press the plus below!"];
}

- (void) countUp {
    NSDate *cTime = [NSDate date];
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"hh:mm a"];
    NSString *t = [dFormatter stringFromDate: cTime];
    [timeLabel setText:[NSString stringWithFormat:@"%@%@", @"Drinking since: ", t]];
    mainInt += 1;
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
    first = true;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end