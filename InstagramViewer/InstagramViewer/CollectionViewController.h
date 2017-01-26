//
//  CollectionViewController.h
//  InstagramViewer
//
//  Created by Kevin Nguyen on 1/6/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaViewController.h"

@interface CollectionViewController : UICollectionViewController <MediaViewControllerDelegate>

- (void)didDismissMediaViewController:(UIViewController*)vc;

@end
