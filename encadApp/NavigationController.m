//
//  NavigationController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 23.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//
// icons from icons8.com

#import "NavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RouteController.h"

@interface NavigationController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
}

@property (nonatomic) MKMapRect mapRect;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property BOOL routeFlag;
@property (nonatomic) MKDirectionsTransportType transportType;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *gpsEnabled;
@property (weak, nonatomic) IBOutlet UIButton *connectionSymbol;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationStartButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapTypeButton;
@property (strong, nonatomic) UIBarButtonItem *routeButton;

- (IBAction)pressedNavigationStart:(id)sender;
- (IBAction)pressedLayerButton:(id)sender;
- (IBAction)changedNavigationType:(UISegmentedControl *)sender;


@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set title
    self.navigationItem.title=@"So finden Sie uns";
    
    //set Button for Segue
    _routeButton = [[UIBarButtonItem alloc]initWithTitle:@"Route" style:UIBarButtonItemStyleDone target:self action:@selector(openRouteView)];
    _routeButton.enabled=NO;
    
    self.navigationItem.rightBarButtonItem=_routeButton;
    
    //set coordinates
    _coordinate = CLLocationCoordinate2DMake(48.35731841028257, 10.891345739364624);
    
    //add annotation
    [self addAnnotation:_coordinate withTitle:@"encad consulting GmbH" withSubtitle:@"Morellstraße 33, 86159 Augsburg"];
    
    
    //set transport type
    _transportType = MKDirectionsTransportTypeAutomobile;
    
    
    //set up controls
    _connectionSymbol.hidden=YES;
    _activityIndicator.hidesWhenStopped=YES;
    
    //set up map
    [self updateMapRecWithCoordinate:_coordinate isFirst:YES];
    [self.mapView setVisibleMapRect:_mapRect animated:YES];
    self.mapView.delegate=self;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    
    //ask for authorization
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //Ask for user-autorization only when App is in foreground
        [self.locationManager requestWhenInUseAuthorization];
    }
    
}

-(void)addAnnotation:(CLLocationCoordinate2D)inLocation withTitle:(NSString*)inTitle withSubtitle:(NSString *)inSubtitle{
    MKPointAnnotation *thePoint = [[MKPointAnnotation alloc]init];
    thePoint.coordinate=inLocation;
    thePoint.title=inTitle;
    thePoint.subtitle=inSubtitle;
    
    [self.mapView addAnnotation:thePoint];
    [self.mapView selectAnnotation:thePoint animated:YES];
    
}

-(void)updateMapRecWithCoordinate:(CLLocationCoordinate2D)inCoordinate isFirst:(BOOL)inIsFirst{
    MKMapPoint thePoint = MKMapPointForCoordinate(inCoordinate);
    MKMapRect theRect = MKMapRectNull;
    theRect = MKMapRectMake(thePoint.x, thePoint.y, 0.0, 0.0);
    self.mapRect = inIsFirst ? theRect : MKMapRectUnion(self.mapRect, theRect);
}


-(void)startNavigation{
    _connectionSymbol.hidden=NO;

    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation=YES;
    
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    // Make a directions request
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    
    // Start at our current location
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    [directionsRequest setSource:source];
    
    // Make the destination
    CLLocationCoordinate2D destinationCoords = self.coordinate;
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    [directionsRequest setDestination:destination];
    [directionsRequest setTransportType:_transportType];
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        // We're done
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
        // Now handle the result
        if (error) {
            NSString *title = @"GPS Fehler";
            NSString *message = @"Es wurde keine Route zu Uns gefunden! Bitte aktivieren Sie Ihre Standordbestimmung oder vergeben Sie die benötigten Rechte zur Standordbestimmung in den Einstellungen.";
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Einstellungen" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
                    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:settingsURL];
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
                [alert addAction:settings];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            return;
        }
        
        // So there wasn't an error - let's plot those routes
        _currentRoute = [response.routes firstObject];
        [self plotRouteOnMap:_currentRoute];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(80, 20, 80, 20);
        [self updateMapRecWithCoordinate:self.locationManager.location.coordinate isFirst:NO];
        [self.mapView setVisibleMapRect:self.mapRect edgePadding:insets animated:YES];
        
        //set controls
        _connectionSymbol.enabled=YES;
        _navigationStartButton.enabled=NO;
        _routeButton.enabled=YES;
    }];
    
}



-(void)openRouteView{
    [self performSegueWithIdentifier:@"route" sender:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - CLLLocation Delegate

-(void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
    // Check authorization status (with class method)
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // User has never been asked to decide on location authorization
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Requesting when in use auth");
        [self.locationManager requestWhenInUseAuthorization];
    }
    // User has denied location use (either for this app or for all apps
    else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Location services denied");
        NSString *title = @"GPS Fehler";
        NSString *message = @"Es wurde keine Route zu Uns gefunden! Bitte aktivieren Sie Ihre Standordbestimmung oder vergeben Sie die benötigten Rechte zur Standordbestimmung in den Einstellungen.";
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Einstellungen" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:settingsURL];
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            [alert addAction:settings];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


#pragma mark - Utility Methods

- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    // Update the ivar
    _routeOverlay = route.polyline;
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
}


#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"route"]){
        RouteController *vc = [segue destinationViewController];
        vc.route=_currentRoute;
    }
}

- (IBAction)pressedNavigationStart:(id)sender {
    [self startNavigation];
}

- (IBAction)pressedLayerButton:(id)sender {
    if(_mapView.mapType==MKMapTypeStandard){
        _mapView.mapType=MKMapTypeHybrid;
        _mapTypeButton.image=[UIImage imageNamed:@"layers_mid.png"];
    }
    else if(_mapView.mapType==MKMapTypeHybrid){
        _mapView.mapType=MKMapTypeSatellite;
        _mapTypeButton.image=[UIImage imageNamed:@"layers_bot.png"];
    }
    else if(_mapView.mapType==MKMapTypeSatellite){
        _mapView.mapType=MKMapTypeStandard;
        _mapTypeButton.image=[UIImage imageNamed:@"layers_top.png"];
    }
}

- (IBAction)changedNavigationType:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            _transportType = MKDirectionsTransportTypeAutomobile;
            break;
        case 1:
            _transportType = MKDirectionsTransportTypeAny;
            break;
        case 2:
            _transportType = MKDirectionsTransportTypeWalking;
            break;
            
        default:
            break;
    }
    _navigationStartButton.enabled=YES;
}


@end
