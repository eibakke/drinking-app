//
//  HEALUser.h
//  drinkingApp
//
//  Created by Eivind Bakke on 3/3/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HEALUser : NSObject

@property(strong, nonatomic) NSString *userSex;
@property(strong,nonatomic) NSNumber *userWeight;
@property(strong,nonatomic) NSString *userName;

-(NSNumber*)getUserBAC;

@end
