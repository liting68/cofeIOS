//
//  CafeMapViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "BMKMapView.h"
#import "BMKLocationService.h"
#import "BMapKit.h"
#import "MapBar.h"

@interface CafeMapViewController : BaseViewController<BMKMapViewDelegate,BMKRouteSearchDelegate>
{
     BMKRouteSearch* _routesearch;
}
@property (strong, nonatomic )NSString * cafeTitle;

@property (strong, nonatomic) BMKMapView * mapView; ////地图

//@property (strong, nonatomic) BMKLocationService* locService;

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@property (assign, nonatomic) CLLocationCoordinate2D currentCoordinate;

@property(strong,nonatomic) MapBar * mapBar;

////
@property (strong, nonatomic) NSString * fromAddr;
@property (strong,nonatomic)  NSString * toAddr;
@property (strong, nonatomic) NSString * fromCity;
@property (strong, nonatomic) NSString * toCity;


- (void)startLocationService;

@end
