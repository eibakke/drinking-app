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
}

@property(strong, nonatomic) NSString *userSex;
@property(strong, nonatomic) NSNumber *userWeight;
@property(strong, nonatomic) NSString *userName;
@property(strong, nonatomic) HEALNight *currentNight;


-(void)setDrinks:(int)drinks;
-(void)setUserSex:(NSString *)sex;
-(int)getDrinks;

-(void)makeNight:(HEALNight*)night;
-(float)getUserBAC;

-(id)init:(NSString*)userName userSex:(NSString*)userSex userWeight:(NSNumber*)userWeight;

@end
