//
//  PDFController.h
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 18.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schulung.h"
#import "Schulungstermin.h"
#import "Veranstaltung.h"

@interface PDFController : UIViewController

@property (strong,nonatomic) Schulung *audition;
@property (strong, nonatomic) Schulungstermin *auditionDate;
@property (strong,nonatomic) Veranstaltung *event;

@property (strong,nonatomic) NSString *backgroundPicture;

@end
