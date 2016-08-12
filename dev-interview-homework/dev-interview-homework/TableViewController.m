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

static NSString *feedJSON = @"https://raw.githubusercontent.com/phunware/dev-interview-homework/master/feed.json";


@interface TableViewController ()

@property (strong, nonatomic) NSMutableArray *feedObjectsArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.feedObjectsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDictionary objectForKey:@"title"];
    cell.detailTextLabel.text = [tempDictionary objectForKey:@"description"];
    //cell.imageView.image = [tempDictionary objectForKey:@"image"];
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
