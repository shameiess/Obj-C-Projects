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
@property (weak, nonatomic) IBOutlet UILabel *detailDate;
@property (weak, nonatomic) IBOutlet UITextView *detailDescription;
- (IBAction)shareButton:(id)sender;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _feedDetail.mainTitle;
    [self loadDetail];
    
}

- (void)loadDetail {
    if ([self.feedDetail.imageURL isKindOfClass:NSString.class]) {
        [self.detailImage setImageWithURL:[NSURL URLWithString:_feedDetail.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder_nomoon.png"]];
    }
    else {
        [self.detailImage setImage:[UIImage imageNamed:@"placeholder_nomoon.png"]];
    }
    
    self.detailDate.text = [_feedDetail formatDate:_feedDetail.dateTime];
    self.detailTitle.text = _feedDetail.mainTitle;
    self.detailDescription.text = _feedDetail.mainDescription;
}

- (IBAction)shareButton:(id)sender {
    NSString *sharedTitle = [_feedDetail.mainTitle stringByAppendingString:@"\n"];;
    NSString *sharedDescription = [_feedDetail.mainDescription stringByAppendingString:@"\n"];
    NSString *sharedDate = [NSString stringWithFormat:@"Date: %@", [_feedDetail formatDate:_feedDetail.dateTime]];
    UIImage *sharedImage = [UIImage alloc];
    if ([self.feedDetail.imageURL isKindOfClass:NSString.class]) {
        sharedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_feedDetail.imageURL]]];
    }
    else {
        sharedImage = [UIImage imageNamed:@"placeholder_nomoon.png"];
    }
    
    NSArray *itemsToShare = @[sharedTitle, sharedDescription, sharedDate, sharedImage];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [avc setValue:sharedTitle forKey:@"subject"];
    avc.excludedActivityTypes = @[UIActivityTypePostToFacebook];
    [self presentViewController:avc animated:YES completion:nil];
}

@end
