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
   // NSLocalizedStringFromTable([NSString stringWithFormat:@"%@ %i", stateName, [self randomasdfkjaskdjfkasjdfkjasdf]], @"drunkMessages", @"");
    
    
    NSArray* messageArray=@[@"Sober Message 1",@"Sober Message 5",@"Sober Message 2",@"Sober Message 3",@"Sober Message 4", @"Tipsy Message1",@"Tipsy Message 2",@"Tipsy Message 3",@"Tipsy Message 4",@"Tipsy Message 5", @"Drunk Message1", @"Drunk Message2"];
    self.soberMessage = messageArray[[self randomNumberBetweenMin:0 Max:4]];
    self.tipsyMessage = messageArray[[self randomNumberBetweenMin:5 Max:9]];
    self.drunkMessage = messageArray[[self randomNumberBetweenMin:10 Max:11]];


}



@end
