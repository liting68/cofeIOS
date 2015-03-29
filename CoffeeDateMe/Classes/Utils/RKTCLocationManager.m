//
//  RKTCLocationManager.m
//  HKSportMap
//
//  Created by AsOne on 13-2-1.
//  Copyright (c) 2013年 AsOne. All rights reserved.
//

#import "RKTCLocationManager.h"

@implementation RKTCLocationManager
@synthesize locationManager = _locationManager;
@synthesize delegate = _delegate;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    [self.delegate locationUpdate:newLocation];
}


- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	[self.delegate locationError:error];
}

- (void)stopUpdatingLocation:(NSString *)state{
    [_locationManager stopUpdatingLocation];
    [_locationManager stopMonitoringSignificantLocationChanges];
    _locationManager.delegate = nil;
}

@end
