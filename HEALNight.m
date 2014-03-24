//
//  HEALNight.m
//  drinkingApp
//
//  Created by Eivind Bakke on 3/5/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALNight.h"

@implementation HEALNight

-(id)init
{
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

-(void)resetStartTime
{
    NSDate *myDate = [[NSDate alloc] init];
    _startTime = [self getTimeSec:myDate];
}

-(float)getTimeSec:(NSDate*)date
{
    return [date timeIntervalSince1970];
}

-(void)reset
{
    self.drinks = 0;
    self.startTime = 0;
}
@end
