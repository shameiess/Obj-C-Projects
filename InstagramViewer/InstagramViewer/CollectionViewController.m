//
//  CollectionViewController.m
//  InstagramViewer
//
//  Created by Kevin Nguyen on 1/6/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

#import "CollectionViewController.h"
#import "InstagramKit.h"
#import "InstagramMedia.h"
#import "AFNetworking.h"
#import "IVCell.h"
#import "LoginViewController.h"
#import "MediaViewController.h"

#define kNumberOfCellsInARow 3

@interface CollectionViewController () <UISearchBarDelegate>

@property (nonatomic, strong)   NSMutableArray *mediaArray;
@property (nonatomic, strong)   NSMutableArray *favorites;
@property (nonatomic, strong)   InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, strong)   InstagramEngine *instagramEngine;
@property (nonatomic, strong)   UIVisualEffectView *blurEffectView;
@property (nonatomic, strong)   UIRefreshControl *refreshControl;

- (IBAction)loginTapped:(id)sender;
- (IBAction)refreshTapped:(id)sender;

- (void)didDismissMediaViewController:(UIViewController*)vc;

@end

@implementation CollectionViewController

static NSString * const segueIdentifier = @"media";
static NSString * const reuseIdentifier = @"IVCELL";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.instagramEngine = [InstagramEngine sharedEngine];
    self.mediaArray = [[NSMutableArray alloc] init];
    self.favorites = [[NSMutableArray alloc] init];
    
    NSString *restoreID = [self restorationIdentifier];
    if ([restoreID isEqualToString:@"SearchCollectionViewController"]) {
        [self initSearchBar];
        [self requestTagFeed:@""];
    }
    if ([restoreID isEqualToString:@"CollectionViewController"]) {
        [self loadMedia];
    }
    
    [self initBlurEffect];
    [self initRefreshControl];
    [self updateCollectionViewLayout];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userAuthenticationChanged:)
                                                 name:InstagramKitUserAuthenticationChangedNotification
                                               object:nil];
}

- (void)loadMedia
{
    self.currentPaginationInfo = nil;
    
    BOOL isSessionValid = [self.instagramEngine isSessionValid];
    [self setTitle: (isSessionValid) ? @"My Feed" : @"Popular Media"];
    [self.navigationItem.leftBarButtonItem setTitle: (isSessionValid) ? @"Log out" : @"Log in"];
    [self.navigationItem.rightBarButtonItem setEnabled: isSessionValid];
    [self.mediaArray removeAllObjects];
    [self.collectionView reloadData];
    
    if (isSessionValid) {
        [self requestSelfFeed];
    }
    else {
        [self requestPopularMedia];
    }
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark Instagram API Calls

- (void)requestPopularMedia
{
    [self.instagramEngine getPopularMediaWithSuccess:^(NSArray *media, InstagramPaginationInfo * paginationInfo) {
        [self.mediaArray addObjectsFromArray:media];
        NSLog(@"REQUEST POPULAR MEDIA: %@", _mediaArray);
        [self.collectionView reloadData];
    }
                                                failure:^(NSError *error, NSInteger statusCode) {
                                                    NSLog(@"Load Popular Media Failed");
                                                }];
}

- (void)requestSelfFeed
{
    [self.instagramEngine getSelfRecentMediaWithSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        [self.mediaArray addObjectsFromArray:media];
        NSLog(@"REQUEST SELF FEED: %@", _mediaArray);
        [self.collectionView reloadData];
    }
                                                failure:^(NSError *error, NSInteger statusCode) {
                                                    NSLog(@"Load Self Media Failed");
                                                }];
}

- (void)requestTagFeed:(NSString *)tag {
    [self.instagramEngine getMediaWithTagName:tag withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        [self.mediaArray addObjectsFromArray:media];
        NSLog(@"REQUEST TAG FEED: %@", _mediaArray);
        [self.collectionView reloadData];
    }
                                                failure:^(NSError * error, NSInteger statusCode) {
                                                    NSLog(@"Load Media With Tag Name Failed");
                                                }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Display a message when the collection view is empty
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSString *restoreID = [self restorationIdentifier];
    if ([restoreID isEqualToString:@"SearchCollectionViewController"]) {
        messageLabel.text = @"No results found!\n\n\nHELLO.";
    }
    if ([restoreID isEqualToString:@"CollectionViewController"]) {
        messageLabel.text = @"No data is currently available. Please pull down to refresh or log in to authenticate!\n\n\nHELLO.";
    }
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Copperplate" size:20];
    [messageLabel sizeToFit];
    self.collectionView.backgroundView = messageLabel;
    
    if (self.mediaArray.count > 0) {
        [messageLabel setHidden:YES];
        return self.mediaArray.count;
    } else {
        // Display a message when the collection view is empty
        [messageLabel setHidden:NO];
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    InstagramMedia *media = self.mediaArray[indexPath.row];
    [cell setImageUrl:media.thumbnailURL];
    
    CGRect btnRect = CGRectMake(cell.frame.size.width-30, cell.frame.size.height-30, 30, 30);
    UIButton *favoriteButton = [[UIButton alloc] initWithFrame:btnRect];
    
    [favoriteButton setTitle:@"✩" forState:UIControlStateNormal];
    [favoriteButton setTitle:@"✭" forState:UIControlStateSelected];

    NSLog(@"CHECKING NSUSERDEFAULTS(favorites):");
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"];
    NSMutableArray *defaultFavorites = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    for (InstagramMedia *favorite in defaultFavorites) {
        if ([favorite.link isEqualToString:media.link]) {
            NSLog(@"this worked! %ld", (long)indexPath.row);
            favoriteButton.selected = YES;

        } else {
            NSLog(@"Not %ld", (long)indexPath.row);
            favoriteButton.selected = NO;
        }
    }
    
    [cell.contentView addSubview:favoriteButton];
    
    [favoriteButton addTarget:self action:@selector(favoriteButtonTappedFromCell:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (IBAction)favoriteButtonTappedFromCell:(UIButton *)sender
{
    IVCell *cell = (IVCell*)[[sender superview] superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    InstagramMedia *media = self.mediaArray[indexPath.row];
    
    if (sender.selected) {
        [sender setSelected:NO];
        [sender setTitle:@"✩" forState:UIControlStateNormal];
        NSLog(@"Unfavorited: %@", media.link);
        [self.favorites removeObject:media];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.favorites];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"favorites"];
    }
    else {
        [sender setSelected:YES];
        [sender setTitle:@"✭" forState:UIControlStateSelected];
        NSLog(@"Favorited: %@", media.link);
        [self.favorites addObject:media];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.favorites];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"favorites"];
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.blurEffectView];
    }
    
    InstagramMedia *selected = self.mediaArray[indexPath.row];
    [self performSegueWithIdentifier:segueIdentifier sender:self.mediaArray[indexPath.row]];
    NSLog(@"didSelectItemAtIndexPath+performSegueWithIdentifier: %@", selected.link);
}

#pragma mark <UISearchBarDelegate>

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.mediaArray removeAllObjects];
    self.title = searchBar.text;
    [self requestTagFeed:searchBar.text];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

#pragma mark UI/UX

- (void)updateCollectionViewLayout
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat size = floor((CGRectGetWidth(self.collectionView.bounds)-1) / kNumberOfCellsInARow);
    layout.itemSize = CGSizeMake(size, size);
}

- (void)initSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), 44)];
    searchBar.delegate = self;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    searchBar.translucent = YES;
    searchBar.barTintColor = [UIColor whiteColor];
    [self.collectionView addSubview:searchBar];
}

- (void)initRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(loadMedia)
                  forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
}

- (void)initBlurEffect {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurEffectView.frame = self.view.bounds;
    self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark @IBAction/VC Transitions

- (IBAction)loginTapped:(id)sender {
    if (![self.instagramEngine isSessionValid]) {
        UINavigationController *loginNavigationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationViewController"];
        [self presentViewController:loginNavigationViewController animated:YES completion:nil];
    }
    else {
        [self.instagramEngine logout];
        NSString *message = @"Sucessfully logged out.";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        int duration = 1; // duration in seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

- (void)userAuthenticationChanged:(NSNotification *)notification
{
    [self loadMedia];
}

- (IBAction)refreshTapped:(id)sender {
    [self.mediaArray removeAllObjects];
    [self requestSelfFeed];
}

- (void)didDismissMediaViewController:(UIViewController*)vc
{
    NSLog(@"Dismissed Media View Controller to Collection View");
    [self.blurEffectView removeFromSuperview];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString: segueIdentifier]) {
        MediaViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        vc.delegate = self;
        InstagramMedia *selected = [self.mediaArray objectAtIndex:indexPath.row];
        NSLog(@"prepareForSegue: %@", selected.link);
        vc.media = selected;
    }
}

@end
