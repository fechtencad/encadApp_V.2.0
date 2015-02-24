//
//  RouteTableViewCell.h
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 24.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RouteTableViewCell : UITableViewCell<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionAdviseLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) MKRouteStep *step;

@end
