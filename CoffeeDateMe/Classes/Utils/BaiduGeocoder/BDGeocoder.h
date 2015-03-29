//
//  Geocoder.h
//  Snooke
//
//  Created by AsOne on 13-4-7.
//  Copyright (c) 2013年 AsOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "BDPlacemark.h"

typedef enum {
	BDGeocoderZeroResultsError = 1,
	BDGeocoderOverQueryLimitError,
	BDGeocoderRequestDeniedError,
	BDGeocoderInvalidRequestError,
    BDGeocoderJSONParsingError
} BDGecoderError;


typedef void (^BDGeocoderCompletionHandler)(BDPlacemark *placemark, NSHTTPURLResponse *urlResponse, NSError *error);

@interface BDGeocoder : NSOperation


+ (BDGeocoder*)reverseGeocode:(CLLocationCoordinate2D)coordinate completion:(BDGeocoderCompletionHandler)block;

- (BDGeocoder*)initWithCoordinate:(CLLocationCoordinate2D)coordinate completion:(BDGeocoderCompletionHandler)block;

- (void)start;
- (void)cancel;

@end