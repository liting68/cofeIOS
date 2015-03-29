//
//  Placemark.m
//  Snooke
//
//  Created by AsOne on 13-4-7.
//  Copyright (c) 2013年 AsOne. All rights reserved.
//

#import "BDPlacemark.h"


@interface BDPlacemark ()

@property (nonatomic, strong, readwrite) NSString *formattedAddress;
@property (nonatomic, strong, readwrite) NSString *city;
@property (nonatomic, strong, readwrite) NSString *district;
@property (nonatomic, strong, readwrite) NSString *province;
@property (nonatomic, strong, readwrite) NSString *street;
@property (nonatomic, strong, readwrite) NSString *streetNumber;
@property (nonatomic, strong, readwrite) NSString *cityCode;

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong, readwrite) CLLocation *location;

@end


@implementation BDPlacemark

@synthesize formattedAddress, city, district, province, street, streetNumber, cityCode, coordinate, location;

- (id)initWithDictionary:(NSDictionary *)result {
    
    if(self = [super init]) {
        self.formattedAddress = [result objectForKey:@"formatted_address"];
        self.cityCode = [result objectForKey:@"cityCode"];
        
        self.city = [[result objectForKey:@"addressComponent"] objectForKey:@"city"]; 
        self.district = [[result objectForKey:@"addressComponent"] objectForKey:@"district"]; 
        self.province = [[result objectForKey:@"addressComponent"] objectForKey:@"province"];
        self.street = [[result objectForKey:@"addressComponent"] objectForKey:@"street"]; 
        self.streetNumber = [[result objectForKey:@"addressComponent"] objectForKey:@"street_number"]; 
 
        
        NSDictionary *locationDict = [result objectForKey:@"location"] ;
        CLLocationDegrees lat = [[locationDict objectForKey:@"lat"] doubleValue];
        CLLocationDegrees lng = [[locationDict objectForKey:@"lng"] doubleValue];
        self.coordinate = CLLocationCoordinate2DMake(lat, lng);
      
        CLLocation * myLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        self.location = myLocation;
        [myLocation release];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    BDPlacemark * place = [[BDPlacemark allocWithZone:zone]init];
    place.cityCode = self.cityCode;
    place.city = self.city;
    place.province = self.province;
    place.district = self.district;
    place.formattedAddress = self.formattedAddress;
    place.street = self.street;
    place.streetNumber = self.streetNumber;
    
    return place;
}

- (NSString*)description {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          formattedAddress, @"formattedAddress",
                          city?city:[NSNull null], @"city",
                          district?district:[NSNull null], @"district",
                          province?province:[NSNull null], @"province",
                          street?street:[NSNull null], @"street",
                          streetNumber?streetNumber:[NSNull null], @"streetNumber",
                          [NSString stringWithFormat:@"%f, %f", self.coordinate.latitude, self.coordinate.longitude], @"coordinate",
                          nil];
    
	return [dict description];
}

@end