//
//  AppDelegate.h
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 11.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

- (void)saveContext;

-(void)runScriptOperations;

-(void)runSchulungScripts;

-(void)runSchulungsterminScripts;

-(void)runWebinarScripts;

-(void)runVeranstaltungScripts;

@end

