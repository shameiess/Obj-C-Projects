//
//  MediaViewController.m
//  InstagramViewer
//
//  Created by Kevin Nguyen on 1/11/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

#import "MediaViewController.h"
#import "UIImageView+AFNetworking.h"


@interface MediaViewController ()

@property (nonatomic, strong)        InstagramMedia *media;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)shareButton:(id)sender;

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(swipeDown:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
    [self.imageView setImageWithURL:self.media.standardResolutionImageURL];
}

- (void)share:(id)sender {
    NSLog(@"SHARED");
}

- (void)swipeDown:(UIGestureRecognizer *)sender
{
    NSLog(@"TRIED TO SWIPE DOWN");
    [self.delegate didDismissMediaViewController:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)shareButton:(id)sender {
    NSString *textToShare = @"LA LA LAND";
    //NSURL *myWebsite = [NSURL URLWithString:self.media.standardResolutionImageURL];
    
    NSArray *objectsToShare = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}
@end
