;
//
//  AppDelegate.m
//  CoffeDateMe
//
//  Created by 波罗密 on 14-9-28.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MessageViewController.h"
#import "ContactsViewController.h"
#import "LeveyTabBarController.h"
#import "CafeMapViewController.h"
#import "BDGeocoder.h"
#import "APService.h"
#import "MessageViewController.h"
#import "ContactsViewController.h"
#import "BaiduMobStat.h"
#import "ChatListViewController.h"
#import "EaseMob.h"
#import "LeftViewController.h"
#import "PostLeaveWordViewController.h"
#import "GuideViewController.h"
#import "ContactsViewController.h"
#import "UMessage.h"
#import "UserCenterVC.h"
#import "LeftViewController.h"
#import "InviteDateVC.h"
#import "NeborCoffeeVenuesViewController.h"

@implementation AppDelegate

LeftViewController * mLeftVC = nil;

CLLocationManager * locationManager =  nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self createAllControllers];
    
    [self regsiterBaiduMobStat]; //
    
    ///////////
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    ///////////////////////同样是后台运行，为什么。
    ///////////////////////
    
    [self openBaiDuMap];
    
    //////////////////////
    [self initLocation];

    ////////////////////////////////////////////
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoLogin) name:K_GOTOLOGIN_NOTIFICATION object:nil];///去登陆
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:K_GOTOLOGIN_FROM_SET object:nil];//从设置去登陆
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postActiAction) name:K_POST_ACTI object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootVC) name:K_UPDATE_ROOT_VC object:nil];
    
    ///////////////////chat + info
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];

    [self registerUMpush:launchOptions];
    
    [self registerRemoteNotification];
    
    #warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
        NSString *apnsCertName = nil;
    #if DEBUG
        apnsCertName = @"mycoffee-apns-dev";
    #else
        apnsCertName = @"mycoffee-apns-pro";
    #endif
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"zcsy#coffee" apnsCertName:apnsCertName];
    
    #if DEBUG
        [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
    #endif
        [[[EaseMob sharedInstance] chatManager] setAutoFetchBuddyList:YES];
    
    //以下一行代码的方法里实现了自动登录，异步登录，需要监听[didLoginWithInfo: error:]
    //demo中此监听方法在MainViewController中
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    #warning 注册为SDK的ChatManager的delegate (及时监听到申请和通知)
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self loginStateChange:nil];
   
    
    ///////////////////
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults]currentMemberID];
    
    if ([AppUtil isNotNull:memberID]) {
        
        NSString * myMemberID = [NSString stringWithFormat:@"%@",memberID];
        
        [UMessage addAlias:myMemberID type:@"invitation" response:^(id responseObject, NSError *error) {
      
        }];
    }
    ////////////
    
    [self getAllCitysForNativePlaceSelected];/////获取公共数据
    [self getAllCitysForShopSearch];/////获取公共数据
    [self getAllCitysForBusinessSearch];/////获取公共数据
    
    
    ///////////判断是否是推送进入的/////////
   
    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            
            
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
      
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请您到设置->隐私->定位服务->咖啡约我中允许访问地理位置" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
        
        //[AppUtil HUDWithStr:@"请您到设置->隐私->定位服务->咖啡约我中允许访问地理位置" View:self.window.rootViewController.view];
        
    }
    
    ///////////
   // NSDictionary * notificationDic = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
   //_msgType = [[notificationDic valueForKey:@"msgType"]intValue];
    
    
    self.slideMenuVC = (NVSlideMenuController *)self.window.rootViewController;
    
    ////判断是否是首次登陆
    if (![[NSUserDefaults standardUserDefaults]
          valueForKey:@"isFirst"]) {
        
//        [self.leveyTabBarVC gotoGuide];
         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GuideViewController * guideVC = [[GuideViewController alloc] init];
        
        self.window.rootViewController = guideVC;
    }
    
  
    return YES;
}
- (LeftViewController *)getLeftVC {
    
    return mLeftVC;
}

-(void)createAllControllers
{
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController * mainNav = [board instantiateViewControllerWithIdentifier:@"MainNav"];
    
    ChatListViewController * chatListVC = [[ChatListViewController alloc] init];
    
    UINavigationController * messageNav = [[UINavigationController alloc] initWithRootViewController:chatListVC];
    
    self.chatListVC = messageNav;

    UINavigationController * contactNav = [board instantiateViewControllerWithIdentifier:@"ContactNav"];

    UIImage * image01 = TTImage(@"message");
    UIImage * image02 = TTImage(@"message_hover");
    
    UIImage *image11=TTImage(@"message");
    UIImage *image12=TTImage(@"message_hover");
    
    UIImage *image21=TTImage(@"hot_acti");
    UIImage *image22=TTImage(@"hot_acti");
    
    UIImage *image31=TTImage(@"coffee_friend");
    UIImage *image32=TTImage(@"coffee_friend_hover");
    
    NSMutableDictionary * dict0=[NSMutableDictionary dictionaryWithCapacity:3];
    [dict0 setObject:image01 forKey:@"Default"];
    [dict0 setObject:image02 forKey:@"Highlighted"];
    [dict0 setObject:image02 forKey:@"Seleted"];
    
    NSMutableDictionary * dict1=[NSMutableDictionary dictionaryWithCapacity:3];
    [dict1 setObject:image11 forKey:@"Default"];
    [dict1 setObject:image12 forKey:@"Highlighted"];
    [dict1 setObject:image12 forKey:@"Seleted"];
    
    NSMutableDictionary *dict2=[NSMutableDictionary dictionaryWithCapacity:3];
    [dict2 setObject:image21 forKey:@"Default"];
    [dict2 setObject:image22 forKey:@"Highlighted"];
    [dict2 setObject:image22 forKey:@"Seleted"];
    
    NSMutableDictionary *dict3=[NSMutableDictionary dictionaryWithCapacity:3];
    [dict3 setObject:image31 forKey:@"Default"];
    [dict3 setObject:image32 forKey:@"Highlighted"];
    [dict3 setObject:image32 forKey:@"Seleted"];
    
    NSArray *imageArr=[NSArray arrayWithObjects:dict0,dict1,dict2,dict3,nil];
    
    NSArray *ctlArr=[NSArray arrayWithObjects:mainNav,messageNav,@"",contactNav,nil];
    
    LeveyTabBarController * tabCtrl = [board instantiateViewControllerWithIdentifier:@"LeveyTabBarController"];
    
    tabCtrl.chatListVC = chatListVC;
    
    [tabCtrl layoutLeveyTabBarViewControllersAtButtom:ctlArr imageArray:imageArr];
    
    [tabCtrl setTabBarTransparent:YES];

    self.leveyTabBarVC = tabCtrl;
    
    LeftViewController * leftVC = [board instantiateViewControllerWithIdentifier:@"LeftViewController"];
    
    mLeftVC = leftVC;
    
    NVSlideMenuController * sliderMenuVC = (NVSlideMenuController *)self.window.rootViewController;
    
    sliderMenuVC.rootViewController = tabCtrl;
    
    [sliderMenuVC layoutMenuViewController:leftVC andContentViewController:tabCtrl];
}


#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif



#pragma mark - 获取故事版

- (id)getStoryBoardControllerWithControllerID:(NSString *)controllerID storyBoardName:(NSString *)storyboardName {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    id  controller = [board instantiateViewControllerWithIdentifier:controllerID];
    
    return controller;
}

#pragma mark - Actions

- (void)updateRootVC  {
    
    self.window.rootViewController = self.slideMenuVC;
}

- (void)gotoLogin {
    
    [AppUtil HUDWithStr:@"请先登录" View:self.leveyTabBarVC.view];
    
    [self performSelector:@selector(login) withObject:nil afterDelay:1.0];
}

//- (void)login1 {
//    
//    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    LoginViewController * loginVC = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
//    loginVC.isPresent = YES;
//    
//    loginVC.type = 1;
//    
//    [self.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:^{
//        
//    }];
//
//}

- (void)login {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginViewController * loginVC = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    loginVC.isPresent = YES;
    
    [self.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:^{
        
    }];
}

- (void)postActiAction {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PostLeaveWordViewController * postLeaveWordViewController = [board instantiateViewControllerWithIdentifier:@"PostLeaveWordViewController"];
    
    postLeaveWordViewController.isPresent = YES;
    
    [self.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:postLeaveWordViewController] animated:YES completion:^{
        
    }];
}


#pragma mark - 注册推送

- (void)registerUMpush:(NSDictionary *)launchOptions {

    //set AppKey and AppSecret
    [UMessage startWithAppkey:UMENG_PUSH_API_KEY launchOptions:launchOptions];

     [UMessage setLogEnabled:NO];
}

//注册远程通知
- (void)registerRemoteNotification {
#if !TARGET_IPHONE_SIMULATOR
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }else {
        
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        
    }
    
#endif
    
}


#pragma mark - 百度移动统计

- (void)regsiterBaiduMobStat {
    
    BaiduMobStat * statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
    statTracker.channelId = @"App Store";
    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;
    statTracker.logSendInterval = 1;
    statTracker.logSendWifiOnly = YES;
    statTracker.sessionResumeInterval = 60;
    [statTracker startWithAppId:@"4a64c4ed22"];//咖啡约我
}

#pragma mark - 注册通知回调

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

//  NSString *str = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",str);
    
    [UMessage registerDeviceToken:deviceToken];
    
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
   
#warning SDK方法调用
        [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
     [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{

    //NSLog(@"remoteNotifications:%@", userInfo);
   
    NSString * type = [userInfo valueForKey:@"notify"];
    
    if ([type isEqualToString:@"invitation"]) { ////邀请
        
        ///////
        UIApplicationState state = application.applicationState;
        
        if (state == UIApplicationStateActive) { //收到通知
            
            //////////////////////////////////////友盟
           // [UMessage didReceiveRemoteNotification:userInfo];
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"通知" message:[[userInfo valueForKey:@"aps"]valueForKey:@"alert"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
           [alertView show];
            
            [mLeftVC getInviteNoRead];
            
        }else {//点击通知
        
            InviteDateVC * inviteVC =  [self getStoryBoardControllerWithControllerID:@"InviteDateVC" storyBoardName:@"Other"];
            
            inviteVC.isRoot = YES;
            
            UINavigationController * InviteNAV = [[UINavigationController alloc] initWithRootViewController:inviteVC];
            
            NVSlideMenuController * slideMenuVC =  (NVSlideMenuController *)self.window.rootViewController;
            
            [slideMenuVC closeMenuBehindContentViewController:InviteNAV animated:YES completion:nil];
        }
        
    }else {
        
        ///////
        UIApplicationState state = application.applicationState;
        
        if (state == UIApplicationStateActive) { //收到通知
            
            #warning SDK方法调用
            [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
            
        }else {//点击通知
            
            _leveyTabBarVC.selectedIndex = 1;
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    NSLog(@"localNotifications:%@",[notification userInfo]);
    UIApplicationState state = application.applicationState;
    
    if (state == UIApplicationStateActive) {
        
    }else {
        
        _leveyTabBarVC.selectedIndex = 1;
    }

    #warning SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
}

#pragma mark - BaiduMap

- (void)openBaiDuMap {
    
    _mapManager = [[BMKMapManager alloc]init];
  
    BOOL ret = [_mapManager start:BAIDU_MAP_API_KEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark - 开启定位

- (void)initLocation {
    
    if (!_locService) {
        
        _locService = [[BMKLocationService alloc]init];
        
    }
    _locService.delegate = self;

    [self startLocation];
   
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied ://拒绝
        {
            // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您还未开启定位！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [tempA show];
        }
            break;
        case kCLAuthorizationStatusNotDetermined ://未决定
           // if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                //[_locationManager requestWhenInUseAuthorization];
           // }
            break;
        case kCLAuthorizationStatusRestricted: ///定位失败
        {
            // 提示用户出错原因，可按住Option键点击 kCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提醒"
                                                           message:@"定位服务无法使用！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            [tempA show];
        }
            break;
            
        default:
          
            break;
    }
}

#pragma mark - 使用百度定位(开始定位,结束定位)

-(void)startLocation
{
    self.locService.delegate = self;
    [self.locService startUserLocationService];

}

-(void)stopLocation{
    
    [self.locService stopUserLocationService];
}

- (void)updateCurrentLocaton {
    
    NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (!userID) {
        
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"updateCurrent", @"act",userID,@"userid",nil];
    [parameters setValue:[NSString stringWithFormat:@"%lf",self.coordinate.latitude] forKeyPath:@"lat"];
    [parameters setValue:[NSString stringWithFormat:@"%lf",self.coordinate.longitude] forKeyPath:@"lng"];
    
    ///更新位置
    [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSString * address = [[responseObject valueForKey:@"result"] valueForKey:@"address"];
        
        [[NSUserDefaults standardUserDefaults] setCurrentCityName:address];
        
      //  NSLog(@"location:lat lng %@ %@",[NSString stringWithFormat:@"%lf",self.coordinate.latitude],[NSString stringWithFormat:@"%lf",self.coordinate.longitude]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 获取全国区域数据(用户选择籍贯时使用)

- (void)getAllCitysForNativePlaceSelected {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"base",@"c",@"getCityArea", @"act",nil];
    [parameters setValue:[NSString stringWithFormat:@"%lf",self.coordinate.latitude] forKeyPath:@"lat"];
    [parameters setValue:[NSString stringWithFormat:@"%lf",self.coordinate.longitude] forKeyPath:@"lng"];
    
    ///更新位置
    [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * areas = [[responseObject valueForKey:@"result"] valueForKey:@"province"];
        
        [AppUtil saveDataWithObject:areas plistName:@"all_area.plist"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 店铺区域数据(附近店铺筛选用)

- (void)getAllCitysForShopSearch {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"base",@"c",@"getShopCityArea", @"act",nil];
    [parameters setValue:[NSString stringWithFormat:@"%lf",self.coordinate.latitude] forKeyPath:@"lat"];
    [parameters setValue:[NSString stringWithFormat:@"%lf",self.coordinate.longitude] forKeyPath:@"lng"];
    
    ///更新位置
    [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSArray * areas = [[responseObject valueForKey:@"result"] valueForKey:@"province"];
        
        [AppUtil saveDataWithObject:areas plistName:@"shop_area.plist"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 商圈数据(附近店铺筛选用)

- (void)getAllCitysForBusinessSearch {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"base",@"c",@"getBusinessCircle", @"act",nil];
    [parameters setValue:[NSString stringWithFormat:@"%lf",self.coordinate.latitude] forKeyPath:@"lat"];
    [parameters setValue:[NSString stringWithFormat:@"%lf",self.coordinate.longitude] forKeyPath:@"lng"];
    
    ///更新位置
    [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
      
        NSArray * areas = [[responseObject valueForKey:@"result"] valueForKey:@"province"];
        
        [AppUtil saveDataWithObject:areas plistName:@"business_area.plist"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - 定位结果

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    self.bmkUserLocation = userLocation;
    
    self.coordinate = [[userLocation location] coordinate];
    
    [self updateCurrentLocaton];
    
    [self stopLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_LOCATIOIN_UPDATE_SUCCESS object:nil];
    
    if (!timer) {
        
        seconds = 0;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self  selector:@selector(locateAction) userInfo:nil repeats:YES];
    }
}

- (void)locateAction {
    
    seconds ++;
    
    if (seconds > LOCATION_INTERVAL) {
        
        [timer invalidate];
        timer = nil;
        
         [self startLocation];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    
    NSLog(@"location fail");
    
    [self startLocation];
}

#pragma mark - application

- (void)applicationWillResignActive:(UIApplication *)application
{
    
#warning SDK方法调用
    [[EaseMob sharedInstance] applicationWillResignActive:application];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
#warning SDK方法调用
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
     [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
#warning SDK方法调用
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
#warning SDK方法调用
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - push

- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        NSLog(@"消息推送与设备绑定失败");
    }
}

#pragma mark - private

-(void)loginStateChange:(NSNotification *)notification
{
    //UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"d" message:@"1" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"1", nil];
    //[alert show];
    
    NSNumber * memebrID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if(memebrID){
        
       // mobile
        
        NSString * mobile = [[NSUserDefaults standardUserDefaults] valueForKey:@"mobile"];
        
       // NSString  * userName = [[NSUserDefaults standardUserDefaults] currentUserEmail];
        
        NSString * password = [[NSUserDefaults standardUserDefaults] currentUserPsw];
        
        ////////////////////登陆IM
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:mobile
                                                            password:[AppUtil md5HexDigest:password]
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *error) {
             if (!error) {
                
                 NSLog(@"IM登录成功");
             
             }
         } onQueue:nil];

    }
}



#pragma mark - Memory Manage

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_GOTOLOGIN_NOTIFICATION object:nil];
    
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:K_SET_AXISNAME_NOTIFICATION object:nil];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE  object:nil];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:K_GOTOLOGIN_FROM_SET  object:nil];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:K_UPDATE_ROOT_VC  object:nil];
}

@end
