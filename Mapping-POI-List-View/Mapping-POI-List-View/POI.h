//
//  POI.h
//  Mapping-POI-List-View
//
//  Created by Kevin Nguyen on 8/25/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Realm/Realm.h>

@interface POI : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy ) NSString *subtitle;

@property (nonatomic) NSString *identifier;
@property (nonatomic,copy) NSString *uuid;
@property (nonatomic) NSString *position;
@property (nonatomic) NSString *address; //subtitle
@property (nonatomic) NSString *stop_id;
@property (nonatomic) NSString *cta_stop_name; //title
@property (nonatomic) NSString *direction;
@property (nonatomic) NSString *routes;
@property (nonatomic) NSString *inter_modal; //optional
@property (nonatomic) NSString *ward;
@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;

// Initializes the POI object from JSON
- (id)initWithDictionary:(NSDictionary*)dictionary;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;

- (void)toStreetAddress:(NSString*)latitude withLongitude:(NSString*)longitude
             completion:(void(^)(NSString*))completion;

// Consumes JSON feed from URL HTTP request
- (void)getJSONFeed:(NSString*)url withObjectForKey:(NSString*)key
         completion:(void(^)(NSDictionary *json, BOOL success))completion;

@end


//RLM_ARRAY_TYPE(POI)

