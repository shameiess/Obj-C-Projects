//
//  DetailViewController.m
//  dev-interview-homework
//
//  Created by Kevin Nguyen on 8/11/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailTitle.text = [self.feedDetail objectForKey:@"title"];

    [self.detailImage setImageWithURL:[NSURL URLWithString:[self.feedDetail objectForKey:@"image"]]];

//    NSURL *url = [[NSURL alloc] initWithString:[NSDictionary objectForKey:@"image"]];
//    [self.detailImageDisplay setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];}

}
@end
