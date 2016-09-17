//
//  DetailViewController.m
//  Mapping-POI-List-View
//
//  Created by Kevin Nguyen on 8/29/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize details;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = details.cta_stop_name;
    self.addressLabel.text = details.address;
    self.routesLabel.text = details.routes;
    self.directionLabel.text = details.direction;
    self.intermodalLabel.text = details.inter_modal;
}


@end
