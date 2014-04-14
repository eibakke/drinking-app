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

typedef enum
{
    MALE,
    FEMALE
} sexes;

typedef enum
{
    SOBER,
    TIPSY,
    DRUNK,
    DANGER,
    DEAD
} intoxState;

@property(nonatomic, assign) intoxState state;
@property(nonatomic, assign) intoxState lastState;
@property(nonatomic, assign) sexes sex;
@property(nonatomic) int weight;
@property(strong, nonatomic) NSString *smsMessage;
@property(strong, nonatomic) NSString *sosContact;
@property(nonatomic) long contactNumber;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) HEALNight *currentNight;
@property(nonatomic) float BAC;

-(void)makeNight:(HEALNight*)night;
-(NSString*)stateAsString;



@end
