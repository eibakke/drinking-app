//
//  HEALNight.h
//  drinkingApp
//
//  Created by Eivind Bakke on 3/5/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HEALNight : NSObject {
}

@property(nonatomic) int drinks;
@property(nonatomic) double startTime; // The time in milliseconds (since 1970) of when the user had their first drink
@property(nonatomic) bool sosSent; // Flags whether a user has sent an sos sms that night

- (void)reset; // Resets all the above and generates new random messages
- (NSString*)stateMessage:(int)state; // Method to get a message for a given state

@end
