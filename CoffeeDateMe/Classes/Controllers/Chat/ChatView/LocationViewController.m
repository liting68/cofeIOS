/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <CoreLocation/CoreLocation.h>
#import "LocationViewController.h"
#import "BMKMapView.h"
#import "BMKPointAnnotation.h"
#import "UIViewController+HUD.h"
#import "AppDelegate.h"
#import "BDGeocoder.h"

static LocationViewController *defaultLocation = nil;

@interface LocationViewController () <BMKMapViewDelegate>
{
    BMKMapView * _mapView;
   // MKMapView *_mapView;
    //MKPointAnnotation *_annotation;
    BMKPointAnnotation  * _annotation;
    
    CLLocationCoordinate2D _currentLocationCoordinate;
    BOOL _isSendLocation;
}

@property (strong, nonatomic) NSString *addressString;

@end

@implementation LocationViewController

@synthesize addressString = _addressString;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSendLocation = YES;
    }
    
    return self;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isSendLocation = NO;
        _currentLocationCoordinate = locationCoordinate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // self.title = @"位置信息";
    
 //   UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
   // [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
   // [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
  // UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  //  [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self initMapView];
    
    [self initNavView];
    [self forNavBeTransparent];
    [self initTitleViewWithTitleString:@"位置信息"];
    [self initBackButton];
    [self initWithRightButtonWithImageName:nil title:@"发送" action:@selector(sendLocation)];

    if (_isSendLocation) {
        
       // _mapView.showsUserLocation = YES;//显示当前位置
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(K_UIMAINSCREEN_WIDTH - 60, 20, 60, 44)];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [sendButton addTarget:self action:@selector(sendLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.navView addSubview:sendButton];
       // [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sendButton]];
       // self.navigationItem.rightBarButtonItem.enabled = NO;
        
       //[self startLocation];
        [self updateLocation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation) name:K_LOCATIOIN_UPDATE_SUCCESS object:nil];
    }
    else{
        
        [self removeToLocation:_currentLocationCoordinate];
        
        __weak typeof(self) weakSelf = self;
        
        AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [BDGeocoder reverseGeocode:appDelegate.coordinate completion:^(BDPlacemark *placemark, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            weakSelf.addressString = placemark.formattedAddress;
            
            _annotation.title = weakSelf.addressString;
            
        }];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self panGestureEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self panGestureEnable:YES];
}

#pragma mark - class methods

+ (instancetype)defaultLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultLocation = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
    });
    
    return defaultLocation;
}

#pragma mark -

- (void)initMapView {
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0,K_UIMAINSCREEN_WIDTH ,self.view.bounds.size.height)];
    
    _mapView.zoomLevel = 15;
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;

    [self.view addSubview:_mapView];
    
}

/*
#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            weakSelf.addressString = placemark.name;
            
            [self removeToLocation:userLocation.coordinate];
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [self showHint:@"定位失败"];
}*/

- (void)updateLocation {
    
    __weak typeof(self) weakSelf = self;
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [BDGeocoder reverseGeocode:appDelegate.coordinate completion:^(BDPlacemark *placemark, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        weakSelf.addressString = placemark.formattedAddress;
        
        [self removeToLocation:appDelegate.coordinate];
    }];
}

#pragma mark - public
/*
- (void)startLocation
{
    if (_isSendLocation) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [self showHudInView:self.view hint:@"正在定位..."];
}
*/
-(void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords
{
    if (_annotation == nil) {
        _annotation = [[BMKPointAnnotation alloc] init];
        _annotation.title = self.addressString;
    }
    else{
        [_mapView removeAnnotation:_annotation];
    }
    _annotation.coordinate = coords;
    [_mapView addAnnotation:_annotation];
}

- (void)removeToLocation:(CLLocationCoordinate2D)locationCoordinate
{
    [self hideHud];
    
    _currentLocationCoordinate = locationCoordinate;
    int zoomLevel = 0.01;
    
   BMKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = zoomLevel;
    coordinateSpan.longitudeDelta = zoomLevel;
    
    BMKCoordinateRegion region ;//= BMKCoordinateRegionMake(_currentLocationCoordinate, coordinateSpan);
    region.center = _currentLocationCoordinate;
    region.span = coordinateSpan;
    
    [_mapView setRegion:region animated:YES];
    
  //  [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    
    if (_isSendLocation) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    [self createAnnotationWithCoords:_currentLocationCoordinate];
}

- (void)sendLocation
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendLocationLatitude:longitude:andAddress:)]) {
        [_delegate sendLocationLatitude:_currentLocationCoordinate.latitude longitude:_currentLocationCoordinate.longitude andAddress:_addressString];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Memory Manage

- (void)dealloc {
    
    if (_isSendLocation) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:K_LOCATIOIN_UPDATE_SUCCESS object:nil];
    }
}

@end
