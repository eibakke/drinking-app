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
@property(strong, nonatomic)NSMutableArray* progFillArray;
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
        _progFillArray = [[NSMutableArray alloc] init];
        NSNumber *num1 = [NSNumber numberWithFloat:0.0f];
        NSNumber *num2 = [NSNumber numberWithFloat:0.0f];
        NSNumber *num3 = [NSNumber numberWithFloat:0.0f];
        NSNumber *num4 = [NSNumber numberWithFloat:0.0f];
        [_progFillArray addObject:num1];
        [_progFillArray addObject:num2];
        [_progFillArray addObject:num3];
        [_progFillArray addObject:num4];
        _smsState = DANGER;
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
    self.lastState = self.state;
    [self updateState];
    
    return(MAX(0, _BAC));
}

-(void)updateState
{
    if (_BAC < 0.02) {
        self.state = SOBER;
        [_progFillArray replaceObjectAtIndex:SOBER withObject:[NSNumber numberWithFloat: _BAC*50]];
    } else if (0.02 < _BAC && _BAC < 0.06) {
        self.state = TIPSY;
        [_progFillArray replaceObjectAtIndex:TIPSY withObject:[NSNumber numberWithFloat: (_BAC-0.02)*25]];
    } else if (0.06 < _BAC && _BAC < 0.2) {
        self.state = DRUNK;
        [_progFillArray replaceObjectAtIndex:DRUNK withObject:[NSNumber numberWithFloat: (_BAC-0.06)*1/0.14]];
    } else if (0.2 < _BAC && _BAC < 4.0) {
        self.state = DANGER;
        [_progFillArray replaceObjectAtIndex:DANGER withObject:[NSNumber numberWithFloat: (_BAC-0.2)*1/0.8]];
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


-(float)getWheelFill:(intoxState)state
{
    return [[self.progFillArray objectAtIndex:state] floatValue];
}



@end