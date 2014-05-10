//
//  HEALNight.m
//  drinkingApp
//
//  Created by Eivind Bakke on 3/5/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALNight.h"

@interface HEALNight (){
    // Arrays holding the constant messages to be shown in DrunkStateViewController
    NSArray* soberMessageArray;
    NSArray* tipsyMessageArray;
    NSArray* drunkMessageArray;
    NSArray* dangerMessageArray;

    
    // Helper structure to hold messages for a given night
    NSArray* sessionMessages;
}

@end

@implementation HEALNight

//############################################ Initialize the StateMessageArrays, Messages for the Night, and whether an SMS has been sent that night ############################################
- (id)init
{
    self = [super init];
    
    if (self) {
        self.sosSent = FALSE;
        
        soberMessageArray = @[@"Call Your Grandma!", @"Walk Your Dog", @"Drive Your Car", @"Write Some Code", @"Live A Little", @"Fold Laundry", @"Pick Up Cantonese "];
        tipsyMessageArray = @[@"Avoid Karaoke", @"Share A Childhood Story", @"Dance", @"Not drive"];
        drunkMessageArray = @[@"Order Jimmy Johns", @"Ponder Meaning of Life", @"Drink Some Water", @"Eat Some Food", @"Kagin?", @"Not Text That Number"];
        dangerMessageArray = @[@"Go home", @"Relax", @"Stop drinking", @"Call SafeWalk", @"Definitely not drive"];

        [self generateMessages];
    }
    return self;
}
// Chooses a random message for each state from the message array for each state, and puts them in an array where the index corresponds to the state
- (void)generateMessages
{
    NSString* soberMessage = soberMessageArray[[self randomNumberBetweenMin:0 Max:[soberMessageArray count] - 1]];
    NSString* tipsyMessage = tipsyMessageArray[[self randomNumberBetweenMin:0 Max:[tipsyMessageArray count] - 1]];
    NSString* drunkMessage = drunkMessageArray[[self randomNumberBetweenMin:0 Max:[drunkMessageArray count] - 1]];
    NSString* dangerMessage = dangerMessageArray[[self randomNumberBetweenMin:0 Max:[dangerMessageArray count] - 1]];
    
    
    
    sessionMessages = @[soberMessage, tipsyMessage, drunkMessage, dangerMessage];
}

// Generate random numbers within range min to max
- (long)randomNumberBetweenMin:(long)min Max:(long)max
{
    return ( (arc4random() % (max-min+1)) + min );
}

// Returns a random message per night for a given state
- (NSString*)stateMessage:(int)state
{
    return [sessionMessages objectAtIndex:state];
}

//############################################ Reset Every Property of the night ############################################
- (void)reset
{
    self.drinks = 0;
    self.startTime = 0;
    self.sosSent = FALSE;
    [self generateMessages];
}


@end
