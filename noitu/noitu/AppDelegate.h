//
//  AppDelegate.h
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "Utility.h"

#import <UIKit/UIKit.h>
#import "RootController.h"
#import "sqlite3.h"
#import "MainNavigationController.h"
#import <StoreKit/StoreKit.h>
#import "IAPHelper.h"

#include <AudioToolbox/AudioToolbox.h>

#include "ASIFormDataRequest.h"

#import "NSString+SBJSON.h"

#import "DownloadImageOperation.h"
#import "JSON.h"
#import "Appirater.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, ASIHTTPRequestDelegate>
{
    MainNavigationController *nav;
    sqlite3 *_database;
    NSString *dvTk;
}



@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)spendCoin:(int)_amount;
+ (void)test;

@end
