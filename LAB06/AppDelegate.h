//
//  AppDelegate.h
//  LAB06
//
//  Created by Elizabeth Martínez Gómez on 13/02/15.
//  Copyright (c) 2015 Elizabeth Martínez Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NSMutableArray *maNames;
NSMutableArray *maImgs;
NSMutableArray *maAddress;
NSMutableArray *maTime;

NSMutableArray *maLatitud;
NSMutableArray *maLongitud;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end

