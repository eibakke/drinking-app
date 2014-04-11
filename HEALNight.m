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
        self.sosSent = FALSE;
        
    }
    return self;
}

-(void)resetStartTime
{
    NSDate *myDate = [[NSDate alloc] init];
    _startTime = [myDate timeIntervalSince1970];
}

-(void)reset
{
    self.drinks = 0;
    self.startTime = 0;
    self.sosSent = FALSE;
}
@end
