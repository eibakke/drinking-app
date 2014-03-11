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
        //self.stateLabel.text = @"Tipsy";
        //self.stateDetails.text = @"Slight euphoria \n \n Sense of relaxation \n \n Lower inhibitions \n \n Thought process slowed \n \n Lowered alertness";

        
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"TipsyInfo.jpg"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        
        
        
    } else if(0.06 < [self.user getUserBAC] && [self.user getUserBAC] < 0.2){
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"DrunkInfo.jpg"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        
    } else if(0.2 < [self.user getUserBAC]) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"DangerInfo.jpg"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
