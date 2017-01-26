//
//  ViewController.m
//  Geofence-Notifications
//
//  Created by Kevin Nguyen on 9/28/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;

    [self setUpMap];
}

- (void)setUpMap {
    //self.title = @"Map";
    
    // Sets initial map view over region
    MKCoordinateRegion region;
    region.center.latitude = 30.347912;
    region.center.longitude = -97.752379;
    region.span.longitudeDelta  = 0.050;
    region.span.latitudeDelta  = 0.050;
    [self.mapView setRegion:region animated:YES];
    
    // Test geofence notifications
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationCoordinate2D pinCoordinate = CLLocationCoordinate2DMake(30.347912,
                                                                      -97.752379);
    // Draws Circular geofence region
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:pinCoordinate radius:1000];
    [self.mapView addOverlay:circle];
    
    // Test pin
    MKPointAnnotation *pinAnnotation = [[MKPointAnnotation alloc] init];
    pinAnnotation.coordinate = pinCoordinate;
    pinAnnotation.title = @"Kevin's House";
    pinAnnotation.subtitle = @"Best House";
    [self.mapView addAnnotation:pinAnnotation];
    
    // Region monitoring
    CLRegion *kevinRegion = [[CLCircularRegion alloc]initWithCenter:pinCoordinate
                                                             radius:100.0
                                                         identifier:@"Kevin's Condo"];
    [self.locationManager startMonitoringForRegion:kevinRegion];
}

// Renders circle
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    circleRenderer.strokeColor = [UIColor blackColor];
    circleRenderer.fillColor = [UIColor greenColor];
    circleRenderer.alpha = 0.5f;
    return circleRenderer;
}

@end
