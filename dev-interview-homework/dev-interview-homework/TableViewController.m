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


static NSString *feedJSON = @"https://raw.githubusercontent.com/phunware/dev-interview-homework/master/feed.json";


@interface TableViewController ()

@property (strong, nonatomic) NSMutableArray *feedObjectsArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DEV APP";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchFeed];
}

- (void)fetchFeed {
    
    NSURL *URL = [NSURL URLWithString:feedJSON];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.feedObjectsArray = responseObject;
        //NSLog(@"The Array: %@",self.feedObjectsArray);
        
        //        for (NSDictionary* item in responseObject) {
        //            Feed *feed = [[Feed alloc] initWithDictionary:item];
        //            NSLog(@"%@", feed);
        //            [self.feedObjectsArray addObject:feed];
        //        }
        //
        //        NSLog(@"%@", [[_feedObjectsArray objectAtIndex:1] description]);
        
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
    return [self.feedObjectsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //cell.titleLabel.text = [[_feedObjectsArray objectAtIndex:indexPath.row] title];
    
    NSDictionary *tempDictionary= [self.feedObjectsArray objectAtIndex:indexPath.row];
    
    NSURL *url = [[NSURL alloc] initWithString:[tempDictionary objectForKey:@"image"]];
    [cell.imageDisplay setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cell.dateLabel.text = [tempDictionary objectForKey:@"date"];
    cell.titleLabel.text = [tempDictionary objectForKey:@"title"];
    cell.locationLabel.text = [tempDictionary objectForKey:@"locationline1"];
    cell.descriptionLabel.text = [tempDictionary objectForKey:@"description"];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
        detailViewController.feedDetail = [self.feedObjectsArray objectAtIndex:indexPath.row];
    }
}


@end
