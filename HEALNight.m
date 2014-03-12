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

-(void)setStartTime
{
    NSDate *myDate = [[NSDate alloc] init];
    self.startTime = [NSNumber numberWithFloat:[self getTimeSec:myDate]];
}

-(float)getTimeSec:(NSDate*)date
{
    return [date timeIntervalSince1970];
}

-(void)reset
{
    self.drinks = 0;
    self.startTime = nil;
}
@end
