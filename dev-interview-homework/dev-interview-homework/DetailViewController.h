//
//  DetailViewController.h
//  dev-interview-homework
//
//  Created by Kevin Nguyen on 8/11/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface DetailViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) Feed *feedDetail;
@property (strong, nonatomic) UIScrollView *scrollView;

@end
