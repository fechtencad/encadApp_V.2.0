//
//  EventSignInController.h
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 18.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webinar.h"
#import "Veranstaltung.h"

@interface EventSignInController : UIViewController

@property (nonatomic,strong) Webinar *webinar;
@property (nonatomic,strong) Veranstaltung *event;


@end
