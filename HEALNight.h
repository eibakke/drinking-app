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
@property(nonatomic) double startTime;
@property(nonatomic) bool sosSent;

- (void)reset;
- (NSString*)stateMessage:(int)state;

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
