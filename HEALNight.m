//
//  HEALNight.m
//  drinkingApp
//
//  Created by Eivind Bakke on 3/5/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALNight.h"

@interface HEALNight (){
    NSArray* soberMessageArray;
    NSArray* tipsyMessageArray;
    NSArray* drunkMessageArray;
    NSArray* sessionMessages;
}

@end

@implementation HEALNight

- (id)init

{
    self = [super init];
    
    if (self) {
        self.sosSent = FALSE;
        soberMessageArray = @[@"Call Your Grandma!",@"Walk Your Dog",@"Drive Your Car",@"Write Some Code",@"Live A Little", @"Fold Laundry",@"Pick Up Cantonese "];
        tipsyMessageArray = @[@"Avoid Karaoke",@"Share An Irrelevant Childhood Story",@"Dance"];
        drunkMessageArray = @[@"Order Jimmy Johns",@"Ponder Meaning of Life",@"Drink Some Water",@"Eat Some Food",@"Kagin?", @"Not Text That Number"];

        [self generateMessages];
    }
    return self;
}

- (void)resetStartTime
{
    NSDate *myDate = [[NSDate alloc] init];
    _startTime = [myDate timeIntervalSince1970];
}



- (void)reset
{
    self.drinks = 0;
    self.startTime = 0;
    self.sosSent = FALSE;
    [self generateMessages];
    [self resetStartTime];
}

- (void)generateMessages
{
    NSString* soberMessage = soberMessageArray[[self randomNumberBetweenMin:0 Max:[soberMessageArray count] - 1]];
    NSString* tipsyMessage = tipsyMessageArray[[self randomNumberBetweenMin:0 Max:[tipsyMessageArray count] - 1]];
    NSString* drunkMessage = drunkMessageArray[[self randomNumberBetweenMin:0 Max:[drunkMessageArray count] - 1]];
    
    sessionMessages = @[soberMessage, tipsyMessage, drunkMessage];
}

// Generate random numbers within range
- (long)randomNumberBetweenMin:(long)min Max:(long)max
{
    return ( (arc4random() % (max-min+1)) + min );
}

// Returns a random message per night for a given state
- (NSString*)stateMessage:(int)state
{    
    return [sessionMessages objectAtIndex:state];
}
@end
