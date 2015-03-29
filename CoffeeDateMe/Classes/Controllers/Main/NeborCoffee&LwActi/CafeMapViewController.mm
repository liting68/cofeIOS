//
//  CafeMapViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "CafeMapViewController.h"
#import "BMKPointAnnotation.h"
#import "BMKPinAnnotationView.h"
#import "BDGeocoder.h"
#import "BMKMapView+ZoomLevel.h"
#import "AppDelegate.h"
#import "BMKAnnotation.h"
#import "BmkPaopaoView.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@interface CafeMapViewController ()<MapBarDelegate>
{
     BMKPointAnnotation  * poingAnnotation;
     UILabel * addrLabel;
}
@end

@implementation CafeMapViewController

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self;
    
   // addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
   // addrLabel.backgroundColor = [UIColor clearColor];
   // addrLabel
    
    [self initMapView];
    
    [BDGeocoder reverseGeocode:self.coordinate completion:^(BDPlacemark *placemark, NSHTTPURLResponse *urlResponse, NSError *error) {
     
        self.toAddr = placemark.formattedAddress;
        self.toCity = placemark.city;
        
     //   poingAnnotation.title = self.toAddr;
      
        [self addAnnotationsWithLocation:self.coordinate];
        
        self.mapView.centerCoordinate = self.coordinate;
    
    }];
    
    [self initNavView];
    [self forNavBeTransparent];
    [self initBackButton];
    [self initTitleViewWithTitleString:self.cafeTitle];
}

-(void)viewWillAppear:(BOOL)animated {
   
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = self;
    
    [self panGestureEnable:NO];
    
    [self hideTabBar];
    
    // _locService.delegate = self;
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSuccess) name:K_LOCATIOIN_UPDATE_SUCCESS object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _routesearch.delegate = nil;
     /// _locService.delegate = nil;
    
    [self panGestureEnable:YES];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:K_LOCATIOIN_UPDATE_SUCCESS object:nil];
}

/*
- (void)startLocationService {
    
    if (!_locService) {
        
        _locService = [[BMKLocationService alloc]init];
    }

    _locService.delegate = self;
    
    [self performSelector:@selector(startLocation) withObject:nil afterDelay:1.0];
}*/

- (void)initMapView {
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0,K_UIMAINSCREEN_WIDTH ,self.view.bounds.size.height)];
    
    _mapView.zoomLevel = 15;
   
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;
    
    
    [self.view addSubview:_mapView];

    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MapBar" owner:nil options:nil];
    _mapBar = [nibView objectAtIndex:0];
    _mapBar.frame = CGRectMake(0, K_UIMAINSCREEN_HEIGHT  - 49, _mapBar.width, _mapBar.height);
    _mapBar.delegate = self;
    [self.view addSubview:_mapBar];
    
     [self updateSuccess];
    
    // [self startLocationService]
    //  - (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
    //{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}



- (void)updateSuccess {
    
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.bmkUserLocation) {

        self.currentCoordinate= delegate.bmkUserLocation.location.coordinate;
    
        [_mapView updateLocationData:delegate.bmkUserLocation];
        
        [BDGeocoder reverseGeocode: [[delegate.bmkUserLocation location ] coordinate] completion:^(BDPlacemark *placemark, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            self.fromAddr = placemark.formattedAddress;
            self.fromCity = placemark.city;
            
            NSLog(@"from:%@ %@",placemark.formattedAddress,placemark.city);
            
           // [self onClickDriveSearch];
             //[self onClickWalkSearch];

        }];
    }
    self.mapView.centerCoordinate = self.coordinate;
}

-(void)addAnnotationsWithLocation:(CLLocationCoordinate2D)location
{
    poingAnnotation = [[BMKPointAnnotation alloc] init];
    
    if (self.toAddr) {
        poingAnnotation.title = self.toAddr;
    }

    poingAnnotation.coordinate = location;
    
    [self.mapView addAnnotation:poingAnnotation];
}

-(void)addUserLocationWithCoor:(CLLocationCoordinate2D)coor name:(NSString *)name
{
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    
    annotation.title = name;
    
    annotation.coordinate = coor;
    
  //  self.mapView.centerCoordinate = coor;
    
    [self.mapView addAnnotation:annotation];
}

#pragma mark - 开始/关闭定位

/*
-(void)startLocation
{
    [self.locService startUserLocationService];
    
    self.mapView.showsUserLocation = YES;
    
}

-(void)stopLocation{
    
    [self.locService stopUserLocationService];
}*/
/*
#pragma mark - BaiduMap Method

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locateing");
}*/

/*
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    
    CLLocationCoordinate2D coordinate = [[userLocation location] coordinate];
    
    NSLog(@"%f %f")
    
    [userLocation.location coordinate];

    [self.mapView updateLocationData:userLocation];
    
    [self stopLocation];
    
    // [self.mapView zoomToFitMapAnnotations];
}*/


/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
/*
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    
   // [self stopLocation];
    
        self.mapView.centerCoordinate = self.coordinate;
    
    
}*/
/*
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    
    NSLog(@"stop locatation");
    
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
    NSLog(@"location error");
    
}
*/
#pragma mark - location

- (void)dealloc {
    
    _mapView.delegate = nil;
    _mapView = nil;
    
    _routesearch.delegate = nil;
    _routesearch = nil;

   // _locService.delegate = nil;
   // _locService = nil;
    
 // [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"] autorelease];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"] autorelease];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] autorelease];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"] autorelease];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"] autorelease];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"] autorelease];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        
        BMKAnnotationView * annotationView = [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
        
        BmkPaopaoView * paopaoView = [[BmkPaopaoView alloc] initWithFrame:CGRectMake(0, 40, 278, 0)];
          paopaoView.backgroundColor = [UIColor clearColor];
        [paopaoView layoutWithTitle:annotation.title];
        
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView ];
        annotationView.paopaoView.backgroundColor = [UIColor clearColor];
        
        return annotationView;
        
    }else {
        
        static NSString *pointReuseIndetifier = @"customPointView";
        BMKPinAnnotationView* annotationView = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier] autorelease];
        annotationView.canShowCallout            = YES;
        annotationView.animatesDrop              = YES;
        annotationView.draggable                 = NO;
        
        annotationView.image = TTImage(@"pin_red");
        
         BmkPaopaoView * paopaoView = [[BmkPaopaoView alloc] initWithFrame:CGRectMake(0, 0, 278, 0)];
      //  paopaoView.htCopyLabel.copyableLabelDelegate = self;
        paopaoView.backgroundColor = [UIColor clearColor];
        [paopaoView layoutWithTitle:annotation.title];
        
         annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView ];
           annotationView.paopaoView.backgroundColor = [UIColor clearColor];
    
        return annotationView;
        
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
   
    for (int index = 0; index < [array count]; index ++) {
        if (array[index] == poingAnnotation){
            continue;
        }else {
            [_mapView removeAnnotation:array[index]];
        }
    }

    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];////路线 第一条(其实可以让它切换路线,因为我想，如果切换路径的话，就必须在多一个界面，所以我就不做了，自己定义就好了)
        // 计算路线方案中的路段数目,公交还会有一个列表的显示 驾车也是
        
        NSMutableString *  timeString = [[NSMutableString alloc] initWithString:@"约"];
        
        if (plan.duration.dates > 0) {
            
            [timeString appendFormat:@"%d天",plan.duration.dates];
        }
        
        if (plan.duration.hours > 0) {
            
            [timeString appendFormat:@"%d小时",plan.duration.hours];
        }
        
        if (plan.duration.minutes > 0) {
            
            [timeString appendFormat:@"%d分钟",plan.duration.minutes];
        }
        
        _mapBar.timeLabel.text = timeString;
        
        _mapBar.distance.text = [NSString stringWithFormat:@"%dm",plan.distance];
        
    
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];//一个路线
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                [item release];
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                [item release];
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            
            NSString * tempTitle = [transitStep.instruction stringByReplacingOccurrencesOfString:@"<font color=\"#313233\">" withString:@""];

            item.title = tempTitle;
            item.type = 3;
            [_mapView addAnnotation:item];
            [item release];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }else {
        
        [self showResult:error];
    }
    
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    for (int index = 0; index < [array count]; index ++) {
        if (array[index] == poingAnnotation){
            continue;
        }else {
            [_mapView removeAnnotation:array[index]];
        }
    }
    
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
       
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        
      //  NSLog(@"%d  %d  %d  %d ",plan.distance,[plan.duration dates],[plan.duration hours], [plan.duration minutes]);
        
        NSMutableString *  timeString = [[NSMutableString alloc] initWithString:@"约"];
        
        if (plan.duration.dates > 0) {
            
            [timeString appendFormat:@"%d天",plan.duration.dates];
        }
        
        if (plan.duration.hours > 0) {
            
            [timeString appendFormat:@"%d小时",plan.duration.hours];
        }
        
        if (plan.duration.minutes > 0) {
            
            [timeString appendFormat:@"%d分钟",plan.duration.minutes];
        }
        
        _mapBar.timeLabel.text = timeString;
        
        _mapBar.distance.text = [NSString stringWithFormat:@"%dm",plan.distance];
        
        
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                [item release];
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                [item release];
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            [item release];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
                [item release];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        
    }else {
        
        [self showResult:error];
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    for (int index = 0; index < [array count]; index ++) {
        if (array[index] == poingAnnotation){
            continue;
        }else {
            [_mapView removeAnnotation:array[index]];
        }
    }
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
    
      //  NSLog(@"%d  %d  %d  %d ",plan.distance,[plan.duration dates],[plan.duration hours], [plan.duration minutes]);
        
        NSMutableString *  timeString = [[NSMutableString alloc] initWithString:@"约"];
        
        if (plan.duration.dates > 0) {
            
            [timeString appendFormat:@"%d天",plan.duration.dates];
        }
        
        if (plan.duration.hours > 0) {
            
            [timeString appendFormat:@"%d小时",plan.duration.hours];
        }
        
        if (plan.duration.minutes > 0) {
            
            [timeString appendFormat:@"%d分钟",plan.duration.minutes];
        }
        
        _mapBar.timeLabel.text = timeString;
        
        _mapBar.distance.text = [NSString stringWithFormat:@"%dm",plan.distance];
        
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                [item release];
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                [item release];
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            [item release];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
    }else {
        
        [self showResult:error];
    }
}


- (void)showResult:(BMKSearchErrorCode)errorCode {
    
    if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        
        [AppUtil HUDWithStr:@"检索词有歧义" View:self.view];
    
    }else if(errorCode == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR) {
        
        [AppUtil HUDWithStr:@"检索地址有歧义" View:self.view];
        
    }else if (errorCode == BMK_SEARCH_NOT_SUPPORT_BUS) {
        
        [AppUtil HUDWithStr:@"该城市不支持公交搜索" View:self.view];
    
    }else if (errorCode == BMK_SEARCH_NOT_SUPPORT_BUS_2CITY) {
        
        [AppUtil HUDWithStr:@"不支持跨城市公交" View:self.view];
    }else if (errorCode == BMK_SEARCH_RESULT_NOT_FOUND) {
        
        [AppUtil HUDWithStr:@"没有找到检索结果" View:self.view];
    }else if (errorCode == BMK_SEARCH_ST_EN_TOO_NEAR) {
        
          [AppUtil HUDWithStr:@"起终点太近" View:self.view];
    }
}

#pragma mark - marBarDelegate

- (BOOL)validateWithType:(int)index {
    
    if (!self.fromCity || !self.fromAddr || !self.toAddr || !self.toCity) {
        
        return NO;
    }

    
    if (![self.fromCity isEqualToString:self.toCity]) {
        
        [AppUtil HUDWithStr:@"公交目前只支持同城查询" View:self.view];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - MapBarDelegate

- (void)mapBarDidSelectedAtIndex:(int)index {
    
    _mapBar.timeLabel.text = @"";
    _mapBar.distance.text = @"";
    
    if (index == 1) {
        
        [self onClickWalkSearch];
    
    }else if(index == 2) {
        
        [self onClickBusSearch];
        
    }else if (index == 3){
        
        [self onClickDriveSearch];
    }
    
}

#pragma mark -

-(void)onClickBusSearch
{
    BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
    //start.name = self.fromAddr;
    start.pt = self.currentCoordinate;
    BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
    end.pt = self.coordinate;
   // end.name = self.toAddr;
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= self.fromCity;
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    
    [transitRouteSearchOption release];
    if(flag)
    {
        
        NSLog(@"bus检索发送成功");
    }
    else
    {
          [AppUtil HUDWithStr:@"公交路线检索失败" View:self.view];
        NSLog(@"bus检索发送失败");
    }
}

-(void)onClickDriveSearch
{
    
    BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
    start.pt = self.currentCoordinate;
  //  start.name = @"思明区环岛东路";//self.fromAddr;
    start.cityName =self.fromCity;
    
    BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
    end.pt = self.coordinate;
    //end.name = @"金山区象州路81号";//self.toAddr;
    end.cityName = self.toCity;//self.toCity;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    [drivingRouteSearchOption release];
   
    if(flag)
    {
        
        NSLog(@"car检索发送成功");
    }
    else
    {
          [AppUtil HUDWithStr:@"驾车路线检索失败" View:self.view];
        NSLog(@"car检索发送失败");
    }
    
}

-(void)onClickWalkSearch
{
    
    BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
    start.pt = self.coordinate;
    start.cityName = self.fromCity;
    
    BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
    end.pt = self.currentCoordinate;
    end.cityName = self.toCity;

    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    [walkingRouteSearchOption release];
  
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
          [AppUtil HUDWithStr:@"步行路线检索失败" View:self.view];
        NSLog(@"walk检索发送失败");
    }
}

@end
