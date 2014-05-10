//
//  HEALUser.m
//  drinkingApp
//
//  Created by Eivind Bakke on 3/3/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALUser.h"
#import "HEALNight.h"

@interface HEALUser (){
    float userSexMetVal;
}
@property(strong, nonatomic)NSArray* intoxStateArray;
@end

@implementation HEALUser

//############################################ Constants ############################################
static float const TIPSY_LOWER_BAC_LIMIT = 0.02;
static float const DRUNK_LOWER_BAC_LIMIT = 0.06;
static float const DANGER_LOWER_BAC_LIMIT = 0.2;

static float const MALE_ALC_MET_VAL = 0.73;
static float const FEMALE_ALC_MET_VAL = 0.66;

static int const MILLI_SEC_PR_HOUR = 3600000;


//############################################ Initialize the user's night object, array of states as strings, and whether the state for sms sending to be DANGER ############################################
- (id)init
{
    self = [super init];
    
    if (self) {
        self.currentNight = [[HEALNight alloc] init];
        self.intoxStateArray = @[@"Sober", @"Tipsy", @"Drunk", @"Danger"];
        self.smsState = INTOXSTATE_DANGER;
        self.smsMessage = @"I've had a fair amount to drink!";
    }
    return self;
}

//############################################ Methods for assigning and calculating the user's properties ############################################

// Calculates and returns the user's current BAC
- (float)BAC
{
    NSDate *cTime = [NSDate date];
    
    double timeDrinking = ([cTime timeIntervalSince1970] - self.currentNight.startTime)/MILLI_SEC_PR_HOUR;
    float drinkFactor = self.currentNight.drinks * 3.084;
    float userFactor = userSexMetVal * self.weight;
    
    float tempBAC = (drinkFactor / userFactor) - (0.15 * timeDrinking);
    
    return(MAX(0, tempBAC)); // Because we never want to return a negative BAC.
}

// Returns the user's state of intoxication based on the user's BAC
- (intoxState)state
{
    if (self.BAC < TIPSY_LOWER_BAC_LIMIT) {
        self.wheelColorTint = [UIColor colorWithRed:(90/255.0) green:(80/255.0) blue:(80/255.0) alpha:.2];
        return INTOXSTATE_SOBER;
    } else if (TIPSY_LOWER_BAC_LIMIT <= self.BAC && self.BAC < DRUNK_LOWER_BAC_LIMIT) {
        self.wheelColorTint = [UIColor colorWithRed:(90/255.0) green:(80/255.0) blue:(80/255.0) alpha:.4];
        return INTOXSTATE_TIPSY;
    } else if (DRUNK_LOWER_BAC_LIMIT <= self.BAC && self.BAC < DANGER_LOWER_BAC_LIMIT) {
        self.wheelColorTint = [UIColor colorWithRed:(90/255.0) green:(80/255.0) blue:(80/255.0) alpha:.6];
        return INTOXSTATE_DRUNK;
    } else {
        self.wheelColorTint = [UIColor colorWithRed:(120/255.0) green:(80/255.0) blue:(80/255.0) alpha:1];
        return INTOXSTATE_DANGER;
    }
}

// Returns the name of the user's current state as a string
- (NSString*)stateAsString
{
    return [self.intoxStateArray objectAtIndex:self.state];
}

// When the user's sex is assigned we also want to set the sex specific alcohol metabolism value
- (void)setSex:(sexes)sex
{
    _sex = sex;
    if(sex == SEXES_FEMALE){
        userSexMetVal = FEMALE_ALC_MET_VAL;
    } else {
        userSexMetVal = MALE_ALC_MET_VAL;
    }
}

// Returns a float used by MainViewController to set how full the circular progress bar is. We want it to be full (ie. 1 <= ) when the user is in the DANGER state
- (float)wheelFill
{
    return self.BAC / DANGER_LOWER_BAC_LIMIT;
}
@end