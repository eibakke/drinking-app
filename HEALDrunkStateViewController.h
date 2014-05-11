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
}

@property (strong, nonatomic) HEALUser *user; // Needs to be able to access the user's info to display the correct info on the screen

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;   // Shows a message gotten from the user's current night
@property (weak, nonatomic) IBOutlet UILabel *bacLabel;         // Shows the user's BAC
@property (weak, nonatomic) IBOutlet UILabel *drinksLabel;      //Shows the user's Drink count
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView; // The ImageView that holds the background image
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView; // The ImageView that holds the drunk state header image
@property (weak, nonatomic) IBOutlet UILabel *shouldLabel;
@end
