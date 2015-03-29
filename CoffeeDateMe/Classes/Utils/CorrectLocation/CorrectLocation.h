//
//  CorrectLocation.h
//  Snooke
//
//  Created by 波罗密 on 14-5-20.
//  Copyright (c) 2014年 AsOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CorrectLocation : NSObject

+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

+(CLLocationCoordinate2D)transformToBaiduCoordinate2D:(NSDictionary *)pre;

@end
