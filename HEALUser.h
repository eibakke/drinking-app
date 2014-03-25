//
//  HEALUser.h
//  drinkingApp
//
//  Created by Eivind Bakke on 3/3/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HEALNight.h"

@interface HEALUser : NSObject
{
 
   
}

typedef enum
{
    MALE,
    FEMALE
} sexes;

@property(nonatomic, setter = sex:) sexes sex;
@property(nonatomic) int weight;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) HEALNight *currentNight;
@property(nonatomic) float BAC;

-(void)makeNight:(HEALNight*)night;



@end
