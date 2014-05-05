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
    DANGER
} intoxState;


// State of intoxication specific properties
@property(nonatomic, assign) intoxState state;
@property(strong, nonatomic) NSString *stateAsString;
@property(nonatomic) float wheelFill;
@property(strong, nonatomic) UIColor *wheelColorTint;

// General relevant user properties
@property(nonatomic, assign) sexes sex;
@property(nonatomic) int weight;
@property(strong, nonatomic) NSString *name;
@property(nonatomic) float BAC;
@property(strong, nonatomic) HEALNight* currentNight;

// SMS specific properties
@property(strong, nonatomic) NSString* smsMessage;
@property(strong, nonatomic) NSString* sosContact;
@property(strong, nonatomic) NSString* contactNumber;
@property(nonatomic, assign) intoxState smsState;
@property(nonatomic) BOOL autoSMS;

@end
