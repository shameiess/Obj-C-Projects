//
//  ViewController.m
//  dev-interview-homework
//
//  Created by Kevin Nguyen on 8/10/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Feed.h"

#warning THIS VC IS MAINLY USED TO TEST CONSUMING JSON PAYLOAD

static NSString *feedJSON = @"https://raw.githubusercontent.com/phunware/dev-interview-homework/master/feed.json";

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *feedArray;

- (IBAction)getFeedJSON;

@end

@implementation ViewController

NSMutableArray *feedArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    feedArray = [[NSMutableArray alloc] init];
}

- (IBAction)getFeedJSON {
    NSURL *URL = [NSURL URLWithString:feedJSON];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        for (NSDictionary* item in responseObject) {
            Feed *feed = [[Feed alloc] initWithDictionary:item];
            [feedArray addObject:feed];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
}

@end
