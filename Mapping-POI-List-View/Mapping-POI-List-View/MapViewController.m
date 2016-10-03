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
#import "DetailViewController.h"

NSString * const URL = @"https://s3.amazonaws.com/mmios8week/bus.json";

@interface MapTableViewController () <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSArray *displayedArray;
@property (strong, nonatomic) NSMutableArray *filteredArray;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)segmentSelected:(UISegmentedControl *)sender;

@property (nonatomic, strong) id previewingContext; // Force Touch preview

@end

@implementation MapTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    self.array = [[NSMutableArray alloc] init];
    self.filteredArray = [[NSMutableArray alloc] init];
    
    [self setUpMapView];
    [self setUpTableView];
    
    POI *feed = [[POI alloc] init];
    [feed getJSONFeed:URL withObjectForKey:@"row" completion:^(NSDictionary *json, BOOL success) {
         if (success) {
             POI *poi = [[POI alloc] initWithDictionary:json];
             [self.array addObject:poi];
         }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cta_stop_name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        [self.array sortUsingDescriptors:@[sortDescriptor]];
        self.displayedArray = _array;
        [self.mapView addAnnotations:_array];
        [self.tableView reloadData];
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
    DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [dvc view];
    
    POI *poiAnnotation = (POI *) view.annotation;
    dvc.title = poiAnnotation.cta_stop_name;
    dvc.routesLabel.text = poiAnnotation.routes;
    dvc.directionLabel.text = poiAnnotation.direction;
    dvc.intermodalLabel.text = poiAnnotation.inter_modal;
    [poiAnnotation toStreetAddress:[poiAnnotation latitude] withLongitude:[poiAnnotation longitude] completion:^(NSString* address) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dvc.addressLabel.text = address;
        });
    }];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark UITableView delegate and datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    POI *poi = [_displayedArray objectAtIndex:indexPath.row];

    cell.textLabel.text = poi.cta_stop_name;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Available routes:\n%@", poi.routes];
    
    //Needs work scrolling up and down makes all cell image blue
    if ([poi.inter_modal isEqualToString:@"Metra"]) {
        cell.imageView.image = [UIImage imageNamed:@"bluesquare"];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
        detailViewController.details = [self.displayedArray objectAtIndex:indexPath.row];
    }
}

#pragma mark Search filter
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    
    if (![searchString isEqualToString:@""]) {
        [self.filteredArray removeAllObjects];
        for (POI *poi in self.array) {
            if ([poi.cta_stop_name localizedCaseInsensitiveContainsString:searchString] == YES) {
                [self.filteredArray addObject:poi];
            }
        }
        self.displayedArray = _filteredArray;
    }
    else {
        self.displayedArray = _array;
    }
    [self.tableView reloadData];
}

#pragma mark Segment action
- (IBAction)segmentSelected:(UISegmentedControl *)sender {
    switch (_segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Map Pressed");
            self.title = @"Map";
            [self.tableView setHidden:YES];
            break;
        case 1:
            NSLog(@"List Pressed");
            self.title = @"List";
            [self.tableView setHidden:NO];
            break;
        default:
            break;
    }
}

#pragma mark Force Touch capability for table cell
- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    if ([self.presentedViewController isKindOfClass:[DetailViewController class]]) {
        return nil;
    }
    
    CGPoint cellPosition = [self.tableView convertPoint:location fromView:self.view];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPosition];
    
    if (path) {
        NSLog(@"Path: %@", path);
        UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:path];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        DetailViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        previewController.details = [self.displayedArray objectAtIndex:path.row];
        
        previewingContext.sourceRect = tableCell.frame;
        return previewController;
    }
    return nil;
}

- (void)previewingContext:(id )previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

# pragma mark Setup
- (void)setUpMapView {
    self.title = @"Map";
    self.mapView.delegate = self;
    
    // Sets initial map view over Chicago
    MKCoordinateRegion region;
    region.center.latitude = 41.881832;
    region.center.longitude = -87.623177;
    region.span.longitudeDelta  = 0.050;
    region.span.latitudeDelta  = 0.050;
    [self.mapView setRegion:region animated:YES];
}

- (void)setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setHidden:YES];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
}


@end


