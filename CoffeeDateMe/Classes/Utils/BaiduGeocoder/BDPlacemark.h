//
//  Placemark.h
//  Snooke
//
//  Created by AsOne on 13-4-7.
//  Copyright (c) 2013年 AsOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BDPlacemark : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic, strong, readonly) NSString *city;
@property (nonatomic, strong, readonly) NSString *formattedAddress;
@property (nonatomic, strong, readonly) NSString *district;
@property (nonatomic, strong, readonly) NSString *province;
@property (nonatomic, strong, readonly) NSString *street;
@property (nonatomic, strong, readonly) NSString *streetNumber;
@property (nonatomic, strong, readonly) NSString *cityCode;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong, readonly) CLLocation *location;

@end