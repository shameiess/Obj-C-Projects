//
//  FavoritesCollectionViewController.m
//  InstagramViewer
//
//  Created by Kevin Nguyen on 1/12/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

#import "FavoritesCollectionViewController.h"
#import "InstagramKit.h"
#import "InstagramMedia.h"
#import "AFNetworking.h"
#import "IVCell.h"
#import "LoginViewController.h"
#import "MediaViewController.h"

@interface FavoritesCollectionViewController () <UISearchBarDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong)   NSMutableArray *favoritesArray;
@property (nonatomic, strong)   InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, weak)     InstagramEngine *instagramEngine;
- (IBAction)refresh:(id)sender;

@end


@implementation FavoritesCollectionViewController

static NSString * const reuseIdentifier = @"FAVCELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.collectionView registerClass:[IVCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.favoritesArray removeAllObjects];
    self.favoritesArray = [[NSMutableArray alloc] init];
    self.instagramEngine = [InstagramEngine sharedEngine];
    
    [self updateCollectionViewLayout];
    [self requestFavoritesFeed];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
        
    } else {
        if (sender.state == UIGestureRecognizerStateBegan) {
            NSLog(@"minimum duration elapsed");
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            // Cancel
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            // Delete from Favorites
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete From Favorites" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                InstagramMedia *media = self.favoritesArray[indexPath.row];
                NSLog(@"Long pressed, %@", media.link);
                [self.favoritesArray removeObject:media];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.favoritesArray];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"favorites"];
                NSLog(@"Deleted media: %@", media.link);
                [self.collectionView reloadData];
            }]];
            // Share
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self shareButton];
            }]];
            
            // Present action sheet.
            [self presentViewController:actionSheet animated:YES completion:nil];
        }
    }
}

- (void)shareButton {
    NSString *textToShare = @"LA LA LAND";
    NSArray *objectsToShare = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)requestFavoritesFeed
{
    NSLog(@"REQUEST FAVORITES FEED:");
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"];
    self.favoritesArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if (self.favoritesArray > 0) {
        [self.collectionView reloadData];
    }
}

#pragma mark <UICollectionViewDataSource>

- (void)updateCollectionViewLayout
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat size = floor((CGRectGetWidth(self.collectionView.bounds)-1) / 3);
    layout.itemSize = CGSizeMake(size, size);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Display a message when the collection view is empty
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    messageLabel.text = @"No favorites Yet!\n\n\nHELLO.";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Copperplate" size:20];
    [messageLabel sizeToFit];
    self.collectionView.backgroundView = messageLabel;
    
    if (self.favoritesArray.count > 0) {
        [messageLabel setHidden:YES];
        return self.favoritesArray.count;
    } else {
        // Display a message when the collection view is empty
        [messageLabel setHidden:NO];
        return 0;
    }}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    InstagramMedia *media = self.favoritesArray[indexPath.row];
    NSLog(@"%@", media);
    [cell setImageUrl:media.thumbnailURL];
    return cell;
}

- (IBAction)refresh:(id)sender {
    [self.favoritesArray removeAllObjects];
    [self requestFavoritesFeed];
}
@end
