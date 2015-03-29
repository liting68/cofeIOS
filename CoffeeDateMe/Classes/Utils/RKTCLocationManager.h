//
//  RKTCLocationManager.h
//  HKSportMap
//
//  Created by AsOne on 13-2-1.
//  Copyright (c) 2013年 AsOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol RKTCLLCationDelegate <NSObject>
@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end

@interface RKTCLocationManager : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
	//id _delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id <RKTCLLCationDelegate> delegate;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

- (void)stopUpdatingLocation:(NSString *)state;

@end