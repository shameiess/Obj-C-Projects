//
//  POI.m
//  Mapping-POI-List-View
//
//  Created by Kevin Nguyen on 8/25/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POI.h"
#import <AFNetworking.h>


@implementation POI

@synthesize identifier,uuid,position,address,stop_id,cta_stop_name,direction,routes,inter_modal,ward,latitude,longitude,title,subtitle,coordinate;//,location;

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self != nil) {
        self.identifier = dictionary[@"_id"];
        self.uuid = dictionary[@"_uuid"];
        self.position = dictionary[@"_position"];
        self.address = dictionary[@"_address"];
        self.stop_id = dictionary[@"stop_id"];
        self.cta_stop_name = dictionary[@"cta_stop_name"];
        self.direction = dictionary[@"direction"];
        self.routes = dictionary[@"routes"];
        self.inter_modal = dictionary[@"inter_modal"];
        self.ward = dictionary[@"ward"];
        self.latitude = dictionary[@"latitude"];
        self.longitude = dictionary[@"longitude"];
        
        self.coordinate = CLLocationCoordinate2DMake([dictionary[@"latitude"] doubleValue], [dictionary[@"longitude"] doubleValue]);
        self.title = dictionary[@"cta_stop_name"];
        self.subtitle = dictionary[@"inter_modal"];
        
        //self.location = dictionary[@"location"];
    }
    return self;
}

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description
{
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = placeName;
        subtitle = description;
    }
    return self;
}

- (void)getJSONFeed:(NSString*)url withObjectForKey:(NSString*)key completion:(void(^)(NSDictionary *json, BOOL success))completion {
    NSURL *URL = [NSURL URLWithString:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@", responseObject);
        
        for (NSDictionary* item in [responseObject objectForKey:key]) {
            if (completion)
                completion(item, YES);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
//         UIAlertController *alert = [UIAlertController
//                                     alertControllerWithTitle:@"Failure"
//                                     message:[error localizedDescription]
//                                     preferredStyle:UIAlertControllerStyleAlert];
//                
//        [self.presentViewController:alert animated:YES completion:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        completion(nil, NO);
    }];
}

@end
