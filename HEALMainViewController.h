//
//  HEALMainViewController.h
//  drinkingApp
//
//  Created by Eivind Bakke on 2/26/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HEALMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *weightText;
@property (weak, nonatomic) IBOutlet UILabel *sexText;

-(IBAction)unwindToMain:(UIStoryboardSegue *)segue;
@end
