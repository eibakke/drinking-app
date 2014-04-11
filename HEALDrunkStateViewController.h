//
//  HEALDrunkStateViewController.h
//  drinkingApp
//
//  Created by Haroon Bokhary on 3/3/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEALUser.h"

@interface HEALDrunkStateViewController : UIViewController {
    NSString *labelText;
    
}

@property (weak, nonatomic) IBOutlet UITextView *stateDetails;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) id parent;
@property (strong, nonatomic) HEALUser *user;
@property (weak, nonatomic) IBOutlet UILabel *bacLabel;



@property (weak, nonatomic) IBOutlet UIStepper *drinkStepper;



@end
