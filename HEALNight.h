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



//@property(strong,nonatomic)NSArray *messageArray;
@property(nonatomic) int soberMessageNumber;
@property(nonatomic) int tipsyMessageNumber;
@property(nonatomic) int drunkMessageNumber;

@property(nonatomic) NSString *soberMessage;
@property(nonatomic) NSString *tipsyMessage;
@property(nonatomic) NSString *drunkMessage;


-(void) reset;
-(void) resetStartTime;
-(void) setDrunkStateMessages;



@end
