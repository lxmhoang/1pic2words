//
//  AppDelegate.m
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)customizeAppearance
{
    // Create resizable images
//    UIImage *gradientImage44 = [[UIImage imageNamed:@"surf_gradient_textured_44.png"]
//                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    UIImage *gradientImage32 = [[UIImage imageNamed:@"surf_gradient_textured_32.png"]
//                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image for *all* UINavigationBars
//    [[UINavigationBar appearance] setBackgroundImage:gradientImage44
//                                       forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:gradientImage32
//                                       forBarMetrics:UIBarMetricsLandscapePhone];
//    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"]
//                                       forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"]
//                                       forBarMetrics:UIBarMetricsLandscapePhone];
//    
//
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObject: [UIColor blueColor]
                                                               forKey: UITextAttributeTextColor];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes: textAttributes
                                                forState: UIControlStateNormal];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:34.0/255.0 green:117.0/225.0 blue:185.0/255.0 alpha:1.0]];
    
    // Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Arial-Bold" size:0.0],
      UITextAttributeFont,
      nil]];
    
    
    
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,    NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"noitu.sqlite"];
}

- (void)spendCoin:(int)_amount
{
    
}

+ (void)test{
    
}

- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"noitu.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];

		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (void)sendAsyncDeviceTokenToServerWithStatus:(int)_status
{
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSLog(@"Version %@",version);
    
    NSLog(@"System Version %@",[[UIDevice currentDevice] systemVersion] );
    
        NSLog(@"device Version %@",[Utility machineName]);
    
    
    NSURL *url = [NSURL URLWithString:@"http://gohanvn.com/devices/createapi"];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
    NSString *coinStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"]];
    NSString *levelStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"level"]];
    
    NSString *stt = [NSString stringWithFormat:@"%d",_status];
    
    [request addPostValue:tokenStr forKey:@"token"];
    [request addPostValue:coinStr forKey:@"coin"];
    [request addPostValue:levelStr forKey:@"level"];
    [request addPostValue:stt forKey:@"status"];
    [request addPostValue:version forKey:@"app_version"];
    [request addPostValue:[[UIDevice currentDevice] systemVersion] forKey:@"ios_version"];
    [request addPostValue:[Utility machineName] forKey:@"device_version"];
    
    
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:tokenStr, @"token",coinStr,@"coin", levelStr,@"level",stt,@"status", nil];
//    
//    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc]init];
//    [arrayOfDicts addObject:dict];
//    
//    NSArray *info = [NSArray arrayWithArray:arrayOfDicts];
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info
//                                                       options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    [request addPostValue:jsonString forKey:@"Devices"];
//    NSLog(@"%@",dict);
    [request startAsynchronous];
}

- (void)sendSyncDeviceTokenToServerWithStatus:(int)_status
{
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSLog(@"Version %@",version);
    
    NSLog(@"System Version %@",[[UIDevice currentDevice] systemVersion] );
    
    NSLog(@"device Version %@",[Utility machineName]);
    NSURL *url = [NSURL URLWithString:@"http://gohanvn.com/devices/createapi"];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
    NSString *coinStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"]];
    NSString *levelStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"level"]];
    
    NSString *stt = [NSString stringWithFormat:@"%d",_status];
    
    [request addPostValue:tokenStr forKey:@"token"];
    [request addPostValue:coinStr forKey:@"coin"];
    [request addPostValue:levelStr forKey:@"level"];
    [request addPostValue:stt forKey:@"status"];
    [request addPostValue:version forKey:@"app_version"];
    [request addPostValue:[[UIDevice currentDevice] systemVersion] forKey:@"ios_version"];
    [request addPostValue:[Utility machineName] forKey:@"device_version"];
    [request startSynchronous];
    
    NSLog(@"response : %@",[request responseString]);
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"0");
    NSString *str =
    [NSString stringWithFormat:@"%@",deviceToken];
    str = [[str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
stringByReplacingOccurrencesOfString:@" "
withString:@""];
    NSLog(@"%@",str);
    
    dvTk = str;

        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self sendAsyncDeviceTokenToServerWithStatus:0];

}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (application.applicationState == UIApplicationStateActive){
        NSLog(@"Active State %@",userInfo);
        
    
        
        
//        NSString *action = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"action"]];
//        
//        
//        
//        if ([action isEqualToString:@"money"]){
//            int amount = [[[userInfo objectForKey:@"aps"] objectForKey:@"amount"] intValue];
//            int coins = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue];
//            
//            coins = coins+amount;
//            NSNumber *num = [NSNumber numberWithInt:coins];
//            NSLog(@" new coin : %d",[num intValue]);
//            [[NSUserDefaults standardUserDefaults] setObject:(id)num forKey:@"coins"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Congrat" message:[NSString stringWithFormat:@"Active You have just receive %d coins",amount] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
//            [alertView release];
//        }
    }
    
    if (application.applicationState == UIApplicationStateBackground){
                NSLog(@" background State %@",userInfo);
        NSString *action = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"action"]];
        
        
        
        if ([action isEqualToString:@"money"]){
            int amount = [[[userInfo objectForKey:@"aps"] objectForKey:@"amount"] intValue];
            int coins = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue];
            
            coins = coins+amount;
            NSNumber *num = [NSNumber numberWithInt:coins];
            NSLog(@" new coin : %d",[num intValue]);
            [[NSUserDefaults standardUserDefaults] setObject:(id)num forKey:@"coins"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Congratulation !" message:[NSString stringWithFormat:@"Background You have just received %d coins",amount] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];

            
//            self.window.rootViewController
        }
    }
    
    if (application.applicationState == UIApplicationStateInactive){
                NSLog(@"Inactive State %@",userInfo);
        NSString *action = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"action"]];
        
        
        
        if ([action isEqualToString:@"money"]){
            int amount = [[[userInfo objectForKey:@"aps"] objectForKey:@"amount"] intValue];
            int coins = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue];
            
            coins = coins+amount;
            NSNumber *num = [NSNumber numberWithInt:coins];
            NSLog(@" new coin : %d",[num intValue]);
            [[NSUserDefaults standardUserDefaults] setObject:(id)num forKey:@"coins"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Congratulation!" message:[NSString stringWithFormat:@"You have just received %d coins",amount] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            RootController *tmpRoot = (RootController *)self.window.rootViewController;
            [tmpRoot updateCoininVIew];
            
            if (tmpRoot.presentedViewController!=nil){
                PlayController *tmpPlay = (PlayController *)tmpRoot.presentedViewController;
                [tmpPlay updateCoininVIew];
            }

            
        }
    }
    // Do something
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [Appirater setAppId:@"627264994"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:YES];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    

    IAPHelper *iaphelper = [[IAPHelper alloc]init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:iaphelper];
    
//    ASIHTTPRequest *initRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kURLForData]];
//    [initRequest setDelegate:self];
//    [initRequest startAsynchronous];
    NSNumber *coin = [NSNumber numberWithInt:kInitialCoin];
    
    
  
   
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"coins"]==nil) {
        [[NSUserDefaults standardUserDefaults] setValue:coin forKey:@"coins"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"noads"]==nil) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"noads"];
    }
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"noads"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [thisAppIAPHelper sharedInstance];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
//    [[UINavigationBar appearanceWhenContainedIn:[PlayController class], nil] addButtonWithTitle:@"asdfasdf"];
    
    [self createEditableCopyOfDatabaseIfNeeded];
    [self customizeAppearance];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    SystemSoundID audioEffect;
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"xylophone_open" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    // call the following function when the sound is no longer used
    // (must be done AFTER the sound is done playing)

    
    

    [self.window makeKeyAndVisible];
    
    NSDictionary *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (localNotif) {
        NSDictionary *json = [localNotif objectForKey:@"aps"];
//        UIAlertView *aV = [[UIAlertView alloc]initWithTitle:@"Congrats" message:[NSString stringWithFormat:@"json : %@",json] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [aV show];
//        [aV release];
        
        NSString *action = [NSString stringWithFormat:@"%@",[json objectForKey:@"action"]];
        
        
        
        if ([action isEqualToString:@"money"]){
            int amount = [[json objectForKey:@"amount"] intValue];
            int coins = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue];
            
            coins = coins+amount;
            NSNumber *num = [NSNumber numberWithInt:coins];
            NSLog(@" new coin : %d",[num intValue]);
            [[NSUserDefaults standardUserDefaults] setObject:(id)num forKey:@"coins"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Congratulation!" message:[NSString stringWithFormat:@"You have just received %d coins",amount] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
        
        NSLog(@"JSON : %@",json);
        // Parse your string to dictionary
    }
    UIImageView *splash = [[UIImageView alloc] initWithFrame:self.window.bounds];
    if (IS_IPHONE_5){
        [splash setImage:[UIImage imageNamed:@"1136.png"]];
    }else{
        [splash setImage:[UIImage imageNamed:@"960.png"]];
    }
//    UIImageView	*splash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoHappiestBaby.png"]];
	splash.tag = 9999;
//	splash.frame = self.window.bounds;
	[self.window addSubview:splash];
    
    [UIView animateWithDuration:1.0 animations:^{
        splash.alpha = 0;
            }completion:^(BOOL finished) {
//                AudioServicesDisposeSystemSoundID(audioEffect);
                RootController *rootVC = [[RootController alloc]init];
                [self.window setRootViewController:rootVC];
    }];
    
    
    
    
    [Appirater appLaunched:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"1");
    [self sendSyncDeviceTokenToServerWithStatus:1];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
        NSLog(@"2");
//    [self sendAsyncDeviceTokenToServerWithStatus:2];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
        NSLog(@"3");
    [self sendAsyncDeviceTokenToServerWithStatus:3];
    [Appirater appEnteredForeground:YES];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
        NSLog(@"4");
//    [self sendAsyncDeviceTokenToServerWithStatus:4];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
        NSLog(@"5");
    [self sendSyncDeviceTokenToServerWithStatus:5];
    // Saves changes in the application's managed object context before the application terminates.
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kStringtagOfFocusedLabelInAnswerView];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark UINavigationController Delegate



#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"noitu" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"noitu.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark ASIHTTPRequestDelegate

- (void)setUpSqlite:(NSDictionary *)_dict
{
    NSString *dbPath = [self getDBPath];
    if (sqlite3_open([dbPath UTF8String], &_database) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
    }else{
//        [self getDataByID:_level];
    }
    
   
    NSString *query = @"delete from resources";
    const char *sqlStatement = [query UTF8String];
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(_database, sqlStatement, -1, &compiledStatement, nil) == SQLITE_OK) {
        // Loop through the results and add them to the feeds array
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            // Read the data from the result row
            NSLog(@"result is here");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    
    }
    
    NSDictionary *data = [_dict objectForKey:@"data"];
    for (NSDictionary *tmp in data)
    {
        NSLog(@"ROW : %@", tmp);
        
        int _id = [[tmp objectForKey:@"id"] intValue];
    
        NSString *leftString = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"leftString"]];
        int numcharLeft = [[tmp objectForKey:@"numcharLeft"] intValue];
        NSString *leftImage = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"leftImage"]];
        NSString *rightString  = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"rightString"]];
        int numcharRight = [[tmp objectForKey:@"numcharRight"] intValue];
        NSString * rightImage = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"rightImage"]];
        
        NSString *answer = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"answer"]];
        NSString *answerImage = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"answerImage"] ] ;
        if (!answerImage)
        {
            answerImage = @"";
        }
        
        NSString *leftSource = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"leftSource"]];
        
        NSString *rightSource = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"rightSource"]];
        
        int diffLevel = 0;
        NSString *chars = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"chars"]];
        
        int level = [[tmp objectForKey:@"level"] intValue];
        int available = [[tmp objectForKey:@"availabel"] intValue];
    
        const char *sql = [[NSString stringWithFormat:@"insert into resources(id,level,answer,answerImage,leftString,numcharLeft,leftImage,rightString, numcharRight, rightImage, diffLevel, chars, available, leftSource, rightSource)  VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"] UTF8String];
        
        sqlite3_stmt *updateStmt = nil;
        
        if(sqlite3_prepare_v2(_database, sql, -1, &updateStmt, NULL) != SQLITE_OK)
        {
           NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(_database));
            NSLog(@"error");
        }else{
            sqlite3_bind_int(updateStmt, 1, _id);
            sqlite3_bind_int(updateStmt, 2, level);
            sqlite3_bind_text(updateStmt, 3, [answer UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(updateStmt, 4, [answerImage UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(updateStmt, 5, [leftString UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_int(updateStmt, 6, numcharLeft);
            sqlite3_bind_text(updateStmt, 7, [leftImage UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(updateStmt, 8, [rightString UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_int(updateStmt, 9, numcharRight);
            sqlite3_bind_text(updateStmt, 10, [rightImage UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_int(updateStmt, 11, diffLevel);
            sqlite3_bind_text(updateStmt, 12, [chars UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_int(updateStmt, 13, available);
            sqlite3_bind_text(updateStmt, 14, [leftSource UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(updateStmt, 15, [rightSource UTF8String], -1, SQLITE_STATIC);
            NSLog(@"OK");
        }
        
        if (SQLITE_DONE != sqlite3_step(updateStmt)){
            NSLog(@"Error while creating database. '%s'", sqlite3_errmsg(_database));
        }
        sqlite3_reset(updateStmt);
        sqlite3_finalize(updateStmt);
    }
   
   
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if ([request responseStatusCode] == 200)
    {
        NSDictionary *responseDict = [[request responseString] JSONValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:responseDict] forKey:@"DictionaryKeys"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSLog(@"dict : %@", responseDict);
        if (sqlite3_open([[self getDBPath] UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }else{
            [self setUpSqlite:responseDict];
//            DownloadImageOperation *downloadImageOp = [[DownloadImageOperation alloc]init];
//            NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
//            myQueue.name = @"Download Queue";
//            [myQueue addOperation:downloadImageOp];
//            [downloadImageOp release];
        }
    }   
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error : %@",[request error]);
    NSDictionary * myDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"DictionaryKeys"];
    NSLog(@"Empty dic : %@", myDictionary);
    if (myDictionary == nil){
        NSLog(@"nilll");
    }
    
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
