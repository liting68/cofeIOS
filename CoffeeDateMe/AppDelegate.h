//
//  AppDelegate.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-28.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKMapManager.h"
#import "BMKLocationService.h"
#import "LeveyTabBarController.h"
#import "EaseMob.h"

#import "NVSlideMenuController.h"
#import <CoreLocation/CoreLocation.h>

@class LeftViewController;
/*
 1.让APP马上挂起，通知为远程通知 
 2.让本地通知在后台发声
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKLocationServiceDelegate,LeveyTabBarControllerDelegate,IChatManagerDelegate,CLLocationManagerDelegate>
{
    NSTimer * timer;
    int seconds;
}

@property (strong, nonatomic)UIWindow *window;

@property (nonatomic,strong) BMKMapManager * mapManager;//百度地图

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;///当前定位的位置

@property (nonatomic, strong) BMKUserLocation * bmkUserLocation;

@property (strong, nonatomic) BMKLocationService* locService;//定位服务

@property (strong, nonatomic) LeveyTabBarController * leveyTabBarVC;

@property (strong, nonatomic) UINavigationController * chatListVC;

@property (strong,nonatomic) NVSlideMenuController * slideMenuVC;

- (LeftViewController *)getLeftVC ;

- (void)updateCurrentLocaton;

-(void)startLocation;//开始定位

-(void)stopLocation;//结束定位

@end
