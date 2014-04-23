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


//generate random numbers within range
-(int)randomNumberBetweenMin:(int)min Max:(int)max
{
    return ( (arc4random() % (max-min+1)) + min );
}


-(void)setDrunkStateMessages
{
    //self.soberMessageNumber = [self randomNumberBetweenMin:1 Max:1];
    self.soberMessageNumber = 722;
    self.tipsyMessageNumber = [self randomNumberBetweenMin:2 Max:2];
    self.drunkMessageNumber = [self randomNumberBetweenMin:3 Max:3];
    
    
    NSArray* messageArray=@[@"Sober Message", @"Tipsy Message", @"Drunk Message"];
    self.soberMessage = messageArray[[self randomNumberBetweenMin:0 Max:0]];
    self.drunkMessage = messageArray[[self randomNumberBetweenMin:1 Max:1]];
    self.tipsyMessage = messageArray[[self randomNumberBetweenMin:2 Max:2]];


}



@end
