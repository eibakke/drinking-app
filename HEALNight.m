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
    
    
    NSArray* soberMessageArray=@[@"Call Your Grandma!",@"Walk Your Dog",@"Drive Your Car",@"Write Some Code",@"Live A Little", @"Fold Laundry",@"Pick Up Cantonese "];
     NSArray* tipsyMessageArray=@[@"Avoid Karaoke",@"Share An Irrelevant Childhood Story",@"Dance"];
     NSArray* drunkMessageArray=@[@"Order Jimmy Johns",@"Ponder Meaning of Life",@"Drink Some Water",@"Eat Some Food",@"Kagin?", @"Not Text That Number"];
//    self.soberMessage = soberMessageArray[[self randomNumberBetweenMin:0 Max:[soberMessageArray count]]];
//
//    self.tipsyMessage = tipsyMessageArray[[self randomNumberBetweenMin:0 Max:[tipsyMessageArray count]]];
//    self.drunkMessage = drunkMessageArray[[self randomNumberBetweenMin:0 Max:[drunkMessageArray count]]];

    
    
    self.soberMessage = soberMessageArray[[self randomNumberBetweenMin:0 Max:6]];
    
    self.tipsyMessage = tipsyMessageArray[[self randomNumberBetweenMin:0 Max:2]];
    self.drunkMessage = drunkMessageArray[[self randomNumberBetweenMin:0 Max:5]];

}



@end
