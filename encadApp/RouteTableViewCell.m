//
//  RouteTableViewCell.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 24.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "RouteTableViewCell.h"

@implementation RouteTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.mapView.delegate=self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:_step.polyline];
    renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    renderer.lineWidth = 4.f;
    return  renderer;
}

@end
