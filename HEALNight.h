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

// What are all of these things for? I commented them out, they don't seem to be used anywhere... - Eivind

//@property(strong,nonatomic)NSArray *messageArray;
//@property(nonatomic) int soberMessageNumber;
//@property(nonatomic) int tipsyMessageNumber;
//@property(nonatomic) int drunkMessageNumber;
//
//@property(nonatomic) NSString *soberMessage;
//@property(nonatomic) NSString *tipsyMessage;
//@property(nonatomic) NSString *drunkMessage;





@end
