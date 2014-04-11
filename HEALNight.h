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

-(void) reset;
-(void) resetStartTime;

@end
