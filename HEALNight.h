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

@property(strong, nonatomic) NSNumber *drinks;
@property(strong, nonatomic) NSNumber *startTime;

-(void) setStartTime;

@end
