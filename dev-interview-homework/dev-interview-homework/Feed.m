//
//  FeedModel.m
//  dev-interview-homework
//
//  Created by Kevin Nguyen on 8/10/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"

@implementation Feed

@synthesize identifier,mainDescription,mainTitle,imageURL,dateTime,timestamp,locationLine1,locationline2;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        self.identifier = dictionary[@"id"];
        self.mainDescription = dictionary[@"description"];
        self.mainTitle = dictionary[@"title"];
        self.imageURL = dictionary[@"image"];
        self.dateTime = dictionary[@"date"];
        self.timestamp = dictionary[@"timestamp"];
        self.locationLine1 = dictionary[@"locationline1"];
        self.locationline2 = dictionary[@"locationline2"];
    }
    return self;
}

-(NSString*)formatDate:(NSString *)dateTimeString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *dte = [dateFormat dateFromString:dateTimeString];
    [dateFormat setDateFormat: @"MMM d, yyyy 'at' h:mm a"];
    NSString *finalStr = [dateFormat stringFromDate:dte];
    return finalStr;
}

@end


