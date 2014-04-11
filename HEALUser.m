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

-(void)makeNight:(HEALNight*)night
{
    self.currentNight = night;
}

-(id)init
{
    self = [super init];
    
    if (self) {
        self.currentNight = [[HEALNight alloc] init];
        self.intoxStateArray = @[@"Sober", @"Tipsy", @"Drunk", @"Danger", @"Dead"];
        self.smsMessage = @"I am drunk HELLLLLP";
        self.sosContact = @"STEVE";
    }
    return self;
}

-(float)BAC
{
    NSDate *cTime = [NSDate date];
    
    double timeDrinking = ([cTime timeIntervalSince1970] - self.currentNight.startTime)/3600000;
    float drinkFactor = self.currentNight.drinks * 3.084;
    float userFactor = userSexMetVal * self.weight;
    
    _BAC = (drinkFactor / userFactor) - (0.15 * timeDrinking);
    
    [self updateState];
    
    return(MAX(0, _BAC));
}

//-(void)setMessage:(NSString *)smsMessage
//{
//    _smsMessage = smsMessage;
//}

-(void)updateState
{
    if (_BAC < 0.02) {
        self.state = SOBER;
    } else if (0.02 < _BAC && _BAC < 0.06) {
        self.state = TIPSY;
    } else if (0.06 < _BAC && _BAC < 0.2) {
        self.state = DRUNK;
    } else if (0.2 < _BAC && _BAC < 4.0) {
        self.state = DANGER;
    } else {
        self.state = DEAD;
    }
}

-(NSString*)stateAsString
{
    return [self.intoxStateArray objectAtIndex:self.state];
}

-(void)setSex:(sexes)sex
{
    _sex = sex;
    if(sex == FEMALE)
    {
        userSexMetVal = 0.66;
    }
    else
    {
        userSexMetVal = 0.73;
    }
}


@end