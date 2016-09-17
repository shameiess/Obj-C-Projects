//
//  DetailViewController.h
//  Mapping-POI-List-View
//
//  Created by Kevin Nguyen on 8/29/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POI.h"

@interface DetailViewController : UIViewController

@property (strong,nonatomic) POI *details;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *routesLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UILabel *intermodalLabel;

//- (id)init;
//- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle;

@end
