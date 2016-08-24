//
//  FeedTableViewController.m
//  dev-interview-homework
//
//  Created by Kevin Nguyen on 8/11/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "TableViewController.h"
#import "AFNetworking.h"
#import "Feed.h"
#import "TableViewCell.h"
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Realm/Realm.h>

static NSString *feedJSON = @"https://raw.githubusercontent.com/phunware/dev-interview-homework/master/feed.json";

@interface TableViewController ()

@property (nonatomic, strong) RLMResults *array;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"DEV APP";
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Checks if there is a default realm and fetches feed if it doesn't exist
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (!realm) {
        [self fetchFeed];
    }
    self.array = [Feed allObjects];
    
}

- (void)fetchFeed {
    NSURL *URL = [NSURL URLWithString:feedJSON];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        for (NSDictionary* item in responseObject) {
            
            Feed *feed = [[Feed alloc] initWithDictionary:item];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addObject:feed];
            [realm commitWriteTransaction];
        }
        NSLog(@"%@", [RLMRealmConfiguration defaultConfiguration].fileURL);
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Feed *feed = [_array objectAtIndex:indexPath.row];
    
    if (![feed.imageURL isKindOfClass:NSNull.class]) {
        [cell.imageDisplay setImageWithURL:[NSURL URLWithString:feed.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder_nomoon.png"]];
    }
    else {
        [cell.imageDisplay setImage:[UIImage imageNamed:@"placeholder_nomoon.png"]];
    }
    
    cell.titleLabel.text = feed.title ;
    cell.dateLabel.text = [feed formatDate:feed.dateTime];
    cell.locationLabel.text = feed.locationLine1;
    cell.descriptionLabel.text = feed.description;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
        detailViewController.feedDetail = [self.array objectAtIndex:indexPath.row];
    }
}

@end
