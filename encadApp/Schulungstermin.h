//
//  Schulungstermin.h
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 12.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Schulungstermin : NSManagedObject

@property (nonatomic, retain) NSString * datum;
@property (nonatomic, retain) NSString * orts_name;
@property (nonatomic, retain) NSString * schulungs_name;
@property (nonatomic, retain) NSString * dauer;
@property (nonatomic, retain) NSString * datenblatt_name;
@property (nonatomic, retain) NSString * zusatz;

@end
