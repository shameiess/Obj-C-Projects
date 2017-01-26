//
//  MediaViewController.h
//  InstagramViewer
//
//  Created by Kevin Nguyen on 1/11/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramKit.h"

@protocol MediaViewControllerDelegate <NSObject>

- (void)didDismissMediaViewController:(UIViewController*)vc;

@end

@interface MediaViewController : UIViewController

- (void)setMedia:(InstagramMedia *)media;

@property (nonatomic, weak) id<MediaViewControllerDelegate> delegate;

@end
