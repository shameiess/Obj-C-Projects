//
//  AppDelegate.h
//  Geofence-Notifications
//
//  Created by Kevin Nguyen on 9/28/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

