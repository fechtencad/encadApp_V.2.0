//
//  AppDelegate.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 11.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface AppDelegate ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) NSString *jsonExchangeServerPath;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"http://www.encad-akademie.de/" forKey:@"serverPath"];
    [defaults synchronize];
    
    _jsonExchangeServerPath = [[defaults stringForKey:@"serverPath"] stringByAppendingString:@"JsonExchange/"];

    //Turn of WebKitDiscImageCache
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self runScriptOperations];
    
    return YES;
}

-(void)runScriptOperations{
    [self runSchulungScripts];
    
    [self runSchulungsterminScripts];
    
    [self runWebinarScripts];
    
    [self runVeranstaltungScripts];
}

-(void)runSchulungScripts{
    NSString *jsonString = [_jsonExchangeServerPath stringByAppendingString:@"audits.json"];
    NSString *entityName = @"Schulung";
    
    [self initDataDownloadForURLString:jsonString forEntityName:entityName checkVersion:YES];
}

-(void)runSchulungsterminScripts{
    NSString *jsonString = [_jsonExchangeServerPath  stringByAppendingString:@"auditions.json"];
    NSString *entityName = @"Schulungstermin";
    
    [self initDataDownloadForURLString:jsonString forEntityName:entityName checkVersion:YES];
}

-(void)runWebinarScripts{
    NSString *jsonString = [_jsonExchangeServerPath  stringByAppendingString:@"webinar.json"];
    NSString *entityName = @"Webinar";
    
    [self initDataDownloadForURLString:jsonString forEntityName:entityName checkVersion:NO];
}

-(void)runVeranstaltungScripts{
    NSString *jsonString = [_jsonExchangeServerPath  stringByAppendingString:@"event.json"];
    NSString *entityName = @"Veranstaltung";
    
    [self initDataDownloadForURLString:jsonString forEntityName:entityName checkVersion:NO];
}


-(void)initDataDownloadForURLString:(NSString*)inURL forEntityName:(NSString*)entityName checkVersion:(BOOL)check{
    if(check){
        BOOL updateJson = [self checkForNewFileVersionOnServerByURL:inURL withEntityName:entityName];
        if(updateJson){
            [self fillInDataByURLString:inURL forEntityName:entityName];
            [self setSyncFlagForEntity:entityName];
        }
    }
    else{
        [self clearDataForUpdatewithEntityName:entityName];
        [self fillInDataByURLString:inURL forEntityName:entityName];
        [self setSyncFlagForEntity:entityName];
    }
    NSError *theError;
    [self.managedObjectContext save:&theError];
    if(theError != nil){
        NSLog(@"Failed to save Data; %@",theError);
    }
}

-(BOOL)checkForNewFileVersionOnServerByURL:(NSString*)inURL withEntityName:(NSString*)name{
    
    // create a HTTP request to get the file information from the web server
    NSURL* url = [NSURL URLWithString:inURL];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    
    NSHTTPURLResponse* response;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:nil];
    
    // get the last modified info from the HTTP header
    NSString* httpLastModified = nil;
    if ([response respondsToSelector:@selector(allHeaderFields)])
    {
        httpLastModified = [[response allHeaderFields]
                            objectForKey:@"Last-Modified"];
    }
    
    // setup a date formatter to query the server file's modified date
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSDate *serverFileDate = [df dateFromString:httpLastModified];
    if(serverFileDate==nil){
        NSLog(@"Couldn't get the version-date for the database-file from server!");
        return NO;
    }
    
    NSDate *syncDate = (NSDate*)[[NSUserDefaults standardUserDefaults]objectForKey:[@"syncDate" stringByAppendingString:name]];
    
    if([syncDate compare:serverFileDate]==NSOrderedAscending){
        NSLog(@"Found a new version (%@) after last sync on: %@",serverFileDate,syncDate);
        [self clearDataForUpdatewithEntityName:name];
        return YES;
    }
    if(syncDate==nil){
        NSLog(@"Initial CoreData Import");
        return YES;
    }
    NSLog(@"Snyced DataBase on %@ is up to Date with ServerFile: %@",syncDate,serverFileDate);
    return NO;
}

-(void)clearDataForUpdatewithEntityName:(NSString*)name{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Could not delete Entity Objects");
    }
    
    for (NSManagedObject *currentObject in fetchedObjects) {
        [self.managedObjectContext deleteObject:currentObject];
    }
    
    [self saveContext];
    
}

-(void)fillInDataByURLString:(NSString*)inURL forEntityName:(NSString*)inEntityName{
    @try{
        NSError *theError;
        NSURL *theUrl = [NSURL URLWithString:inURL];
        NSData *theData = [NSData dataWithContentsOfURL:theUrl options:0 error:&theError];
        
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&theError];
        
        if(!jsonObject){
            NSLog(@"There was a Problem retriving the Json File: %@", theError);
        }
        else{
            for(NSDictionary *dict in jsonObject){
                [self createObjectFromDictionary:dict forEntityName:inEntityName];
            }
            [self saveContext];
        }
    }
    @catch(NSException *exception){
        if([exception isMemberOfClass:NSInvalidArgumentException.class]){
            NSLog(@"Couldn't get a connection to server, data is nil. Abort download!");
        }
    }

    
}

-(void)setSyncFlagForEntity:(NSString*)entityName{
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    [[NSUserDefaults standardUserDefaults] setObject:destinationDate forKey:[@"syncDate" stringByAppendingString:entityName]];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)createObjectFromDictionary:(NSDictionary *)inDictionary forEntityName:(NSString*)inEntityName{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:inEntityName inManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *attributes = [[NSEntityDescription entityForName:inEntityName inManagedObjectContext:self.managedObjectContext] attributesByName];
    
    for(NSString *attr in attributes){
        [object setValue:[inDictionary valueForKey:attr] forKey:attr];
    }
    NSLog(@"Successfully updated CoreData: %@",object);
}

#pragma mark - Application Delegates
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "encad-consulting.encadApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"encadApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
