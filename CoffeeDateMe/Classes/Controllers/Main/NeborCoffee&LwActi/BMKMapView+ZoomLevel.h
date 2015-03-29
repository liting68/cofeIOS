//
//  MAMapView+ZoomLevel.h
//  Yujia001
//
//  Created by 潘淑娟 on 14-1-26.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "BMKMapView.h"
#import "BMapKit.h"

@interface BMKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
- (NSUInteger)getZoomLevel;
-(void)zoomToFitMapAnnotations;
@end
