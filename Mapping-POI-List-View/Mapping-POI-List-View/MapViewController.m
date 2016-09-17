//
//  MapViewController.m
//  Mapping-POI-List-View
//
//  Created by Kevin Nguyen on 8/25/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "MapViewController.h"
#import <AFNetworking.h>
#import "POI.h"
#import <Realm/Realm.h>
#import "DetailViewController.h"

#define URL @"https://s3.amazonaws.com/mmios8week/bus.json"

@interface MapViewController () <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)segmentSelected:(UISegmentedControl *)sender;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSArray *sortedArray;

@end

@implementation MapViewController

BOOL isSearching;

-(void)viewDidLoad {
    [super viewDidLoad];

    [self setUp];
    POI *feed = [[POI alloc] init];
    [feed getJSONFeed:URL withObjectForKey:@"row" completion:^(NSDictionary *json, BOOL success) {
         if (success) {
             POI *poi = [[POI alloc] initWithDictionary:json];
             [self.array addObject:poi];
             //POI *pin = [[POI alloc] initWithCoordinates:poi.coordinate placeName:poi.cta_stop_name description:poi.inter_modal];
             //[self.mapView addAnnotation:pin];
             //[self viewWillAppear:YES];
         }
        //Sorts to alphabetical for list view
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cta_stop_name"
                                                      ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        self.sortedArray = [_array sortedArrayUsingDescriptors:sortDescriptors];
        [self.mapView addAnnotations:_sortedArray];
        [self.listView reloadData];
     }];
}



#pragma mark MKMapView delegate methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString* PinAnnotationIdentifier = @"PinAnnotationIdentifier";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:PinAnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinAnnotationIdentifier];
        if ([[annotation subtitle] isEqualToString:@"Metra"]) {
            pinView.pinTintColor = [UIColor colorWithRed:0.10 green:0.44 blue:0.68 alpha:1.0];
        }
        else {
            pinView.pinTintColor = [MKPinAnnotationView purplePinColor];
        }
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//    DetailViewController *dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [dvc view];
    POI *poiAnnotation = (POI *) view.annotation;
    NSLog(@"%@", poiAnnotation.uuid);
    NSLog(@"%@", poiAnnotation.routes);
    
    dvc.title = poiAnnotation.cta_stop_name;
    dvc.addressLabel.text = poiAnnotation.address;
    dvc.routesLabel.text = poiAnnotation.routes;
    dvc.directionLabel.text = poiAnnotation.direction;
    dvc.intermodalLabel.text = poiAnnotation.inter_modal;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark UITableView delegate and datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sortedArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    POI *poiCell = [_sortedArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = poiCell.cta_stop_name;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Available routes:\n%@", poiCell.routes];
    //Needs work scrolling up and down makes all cell image blue
    if ([poiCell.inter_modal isEqualToString:@"Metra"]) {
        cell.imageView.image = [UIImage imageNamed:@"bluesquare"];
    }
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segue"])
    {
        NSIndexPath *indexPath = [self.listView indexPathForSelectedRow];
        DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
        detailViewController.details = [self.sortedArray objectAtIndex:indexPath.row];
    }
}

#pragma mark segment
- (IBAction)segmentSelected:(UISegmentedControl *)sender {
    switch (_segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Map Pressed");
            self.title = @"Map";
            [self.listView setHidden:YES];
            break;
        case 1:
            NSLog(@"List Pressed");
            self.title = @"List";
            [self.listView setHidden:NO];
            break;
        default:
            break;
    }
}

- (void)setUp {
    self.array = [[NSMutableArray alloc] init];
    self.mapView.delegate = self;
    [self setUpInitialView];
    self.listView.delegate = self;
    self.listView.dataSource = self;
    [self.listView setHidden:YES];
}

- (void)setUpInitialView {
    self.title = @"Map";
    
    // Sets initial map view over Chicago
    MKCoordinateRegion region;
    region.center.latitude = 41.881832;
    region.center.longitude = -87.623177;
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


