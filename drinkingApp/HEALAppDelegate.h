//
//  HEALAppDelegate.h
//  drinkingApp
//
//  Created by Eivind Bakke on 2/24/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HEALAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
