//
//  HEALUser.h
//  drinkingApp
//
//  Created by Eivind Bakke on 3/3/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HEALNight.h"

@interface HEALUser : NSObject
{
    NSString *userSex;
    NSNumber *userWeight;
    NSString *userName;
    HEALNight *userNight;
}

-(void)makeNight:(HEALNight*)night;
//-(NSNumber*)getUserBAC;

@end
