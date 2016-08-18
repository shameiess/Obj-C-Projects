//
//  FeedModel.h
//  dev-interview-homework
//
//  Created by Kevin Nguyen on 8/10/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//


@interface Feed : NSObject

@property (nonatomic) NSNumber *identifier;
@property (nonatomic) NSString *mainDescription;
@property (nonatomic) NSString *mainTitle;
//@property (nonatomic, copy) NSDate *timestamp;
@property (nonatomic) NSString *timestamp;
//@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic,strong) NSString *imageURL;
@property (nonatomic) NSString *dateTime;
//@property (nonatomic) NSDate *dateTime;
@property (nonatomic) NSString *locationLine1;
@property (nonatomic) NSString *locationline2;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSString*)formatDate:(NSString *)dateTime;

@end

#pragma example
/*
 {
 "id": 1,
 "description": "Rebel Forces spotted on Hoth. Quell their rebellion for the Empire.",
 "title": "Stop Rebel Forces",
 "timestamp": "2015-06-18T17:02:02.614Z",
 "image": "https://raw.githubusercontent.com/phunware/services-interview-resources/master/images/Battle_of_Hoth.jpg",
 "date": "2015-06-18T23:30:00.000Z",
 "locationline1": "Hoth",
 "locationline2": "Anoat System"
 },
 */