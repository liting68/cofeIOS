//
//  LeveyTabBarControllerViewController.m
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import "LeveyTabBarController.h"
#import "LeveyTabBar.h"
#import "BLMCommon.h"
#import "AppDelegate.h"
#import "GuideViewController.h"
#import "NeborCoffeeVenuesViewController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

static LeveyTabBarController *leveyTabBarController;

@interface LeveyTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation LeveyTabBarController
@synthesize delegate = _delegate;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize lastSelectedIndex=_lastSelectedIndex;
@synthesize containerView = _containerView;
@synthesize transitionView = _transitionView;

-(id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr{
   
    return nil ;

}

- (void)layoutLeveyTabBarViewControllersAtButtom:(NSArray *)vcs imageArray:(NSArray *)arr
{
       _isAtButtom = YES;
        
		_viewControllers = [NSMutableArray arrayWithArray:vcs] ;
        
		_containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,K_UIMAINSCREEN_WIDTH, _containerView.frame.size.height - BUTTOM_BAR_HEIGHT)];
		_transitionView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
		_transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, K_UIMAINSCREEN_HEIGHT - BUTTOM_BAR_HEIGHT, K_UIMAINSCREEN_WIDTH, BUTTOM_BAR_HEIGHT) buttonImages:arr];
        _tabBar.isAtButtom = YES;
        _tabBar.userInteractionEnabled=YES;
		_tabBar.delegate = self;
		_tabBarHidden = NO;
        leveyTabBarController = self;
    
    ////////聊天相关/////////
    [self didUnreadMessagesCountChanged];

#warning 把self注册为SDK的delegate
    [self registerNotifications];
 

    self.selectedIndex = 0;
    
  //  UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
   // [addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
   // [addButton addTarget:_contactsVC action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
   // _addFriendItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    [self setupUnreadMessageCount];

    ///////////////
}

////初始化方法

- (id)initWithViewControllersAtButtom:(NSArray *)vcs imageArray:(NSArray *)arr
{
	self = [super init];
	if (self != nil)
	{
        _isAtButtom = YES;
        
		_viewControllers = [NSMutableArray arrayWithArray:vcs] ;
     
		_containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
        _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,K_UIMAINSCREEN_WIDTH, _containerView.frame.size.height - BUTTOM_BAR_HEIGHT)];
		_transitionView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
		_transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, K_UIMAINSCREEN_HEIGHT - BUTTOM_BAR_HEIGHT, K_UIMAINSCREEN_WIDTH, BUTTOM_BAR_HEIGHT) buttonImages:arr];
        _tabBar.isAtButtom = YES;
        _tabBar.userInteractionEnabled=YES;
		_tabBar.delegate = self;
		_tabBarHidden = NO;
        leveyTabBarController = self;
        
       //[self forIOS7];
    }
	return self;
}

//初始化方法
+ (LeveyTabBarController *)leveyTabBarControllerWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr {
    
    if (!leveyTabBarController) {
        leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllersAtButtom:vcs imageArray:arr];
    }
    
	return leveyTabBarController;
}

- (void)pushController:(UIViewController *)controller {
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)upateNoReadLabelMethod {
    
    [self.tabBar updateUnreadLabelWithNumber:0];
    
}

- (void)popController {
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)controllersWithArr:(NSArray *)vcs imageArr:(NSArray *)arr
{
    _viewControllers = [NSMutableArray arrayWithArray:vcs] ;
    self.wantsFullScreenLayout = YES;
    _containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //        DLog(@"%@",NSStringFromCGRect(_containerView.frame));
    //[_containerView setBackgroundColor:[UIColor redColor]];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //_transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight)];
    _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,K_UIMAINSCREEN_WIDTH, _containerView.frame.size.height - kTabBarHeight)];
    //        DLog(@"%@",NSStringFromCGRect(_transitionView.frame));
    _transitionView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
    _transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //		_tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - kTabBarHeight, 320.0f, kTabBarHeight) buttonImages:arr];
    _tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, kTabBarHeight) buttonImages:arr];
    _tabBar.userInteractionEnabled=YES;
    _tabBar.delegate = self;
    _tabBarHidden = NO;
    leveyTabBarController = self;
}
-(void)popBack:(NSNotification *)noti
{
    [self gotoLogin];
}

-(void)pushNotiWith:(NSString *)courseID
{
   // BLMDetailClassViewController *detailCtl=[[BLMDetailClassViewController alloc]init];
   // detailCtl.courseID = courseID;
  //  [self.navigationController pushViewController:detailCtl animated:NO];
}

-(void)pushMemberID:(NSString *)memberid
{
//    BLMChanguanDetailViewController *memberCtl=[[BLMChanguanDetailViewController alloc]init];
//    memberCtl.memberID=memberid;
//    PushAnimation;
//    [self.navigationController pushViewController:memberCtl animated:NO];
}

- (void)loadView
{
	[super loadView];
	
	[_containerView addSubview:_transitionView];
	[_containerView addSubview:_tabBar];
	self.view = _containerView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //登陆选择
  
   //  [self.navigationBar setHidden:YES];
    
//      self.selectedIndex = MYUSERINFO.tabSelectIndex;
    self.selectedIndex = 0;
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	_tabBar = nil;
	_viewControllers = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   /* UIViewController *targetViewController = [self.viewControllers objectAtIndex:_selectedIndex];
    // If target index is equal to current index.
    
    if ([targetViewController isKindOfClass:[UINavigationController class]]) {
     
        UINavigationController * nav = (UINavigationController *)targetViewController;
     
        if ([[nav viewControllers] count] > 1) {
            
            UIViewController * viewController = [nav topViewController];
            
            BaseViewController * baseVC = (BaseViewController *)viewController;
            
            [baseVC hideTabBar];
            
        }
    }*/
}
//- (void)gotoGuide {
//    
//    ////判断是否是首次登陆
//    if (![[NSUserDefaults standardUserDefaults]
//          valueForKey:@"isFirst"]) {
//        
//        // [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirst"];
//        //[[NSUserDefaults standardUserDefaults] synchronize];
//        
//        GuideViewController * guideVC = [[GuideViewController alloc] init];
//        
//        
//        
//        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:guideVC] animated:YES completion:^{
//            
//        }];
//    }
//
//}

#pragma mark - instant methods

- (LeveyTabBar *)tabBar
{
	return _tabBar;
}
- (BOOL)tabBarTransparent
{
	return _tabBarTransparent;
}
- (void)setTabBarTransparent:(BOOL)yesOrNo
{
	if (yesOrNo == YES)
	{
		_transitionView.frame = _containerView.bounds;
//        DLog(@"%@",NSStringFromCGRect(_containerView.bounds));
	}
	else
	{
//		_transitionView.frame = CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight);
        _transitionView.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, _containerView.frame.size.height - kTabBarHeight);
	}

}
-(void)hideTabBar
{
    self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
}
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
{
//	if (yesOrNO == YES)
//	{
//		if (self.tabBar.frame.origin.x == -320)
//		{
//			return;
//		}
//	}
//	else 
//	{
//		if (self.tabBar.frame.origin.x == 0)
//		{
//			return;
//		}
//	}
	
	if (animated == YES)
	{
        
        [UIView animateWithDuration:0.33f animations:^{
            
            if (yesOrNO == YES)
            {
             //   self.tabBar.frame = CGRectMake(-320, self.tabBar.frame.origin.y , self.tabBar.frame.size.width, self.tabBar.frame.size.height);
                _tabBarHidden = YES;
            }
            else
            {
              //  self.tabBar.frame = CGRectMake(0, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
                _tabBarHidden = NO;
            }

            
        } completion:^(BOOL finished) {
            
            [self.tabBar setHidden:yesOrNO];

        }];
	}
	else 
	{
		if (yesOrNO == YES)
		{
        //    self.tabBar.frame = CGRectMake(-320, self.tabBar.frame.origin.y , self.tabBar.frame.size.width, self.tabBar.frame.size.height);
            _tabBarHidden = YES;
            
             [self.tabBar setHidden:yesOrNO];
		}
		else 
		{
			//self.tabBar.frame = CGRectMake(0, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
            _tabBarHidden = NO;
            
             [self.tabBar setHidden:yesOrNO];

		}
	}
}

- (NSUInteger)selectedIndex
{
	return _selectedIndex;
}
- (UIViewController *)selectedViewController
{
    UIViewController* c = [_viewControllers objectAtIndex:_selectedIndex];
    return c;
}

-(void)setSelectedIndex:(NSUInteger)index
{
//    [self displayViewAtIndex:index];//错误
    [_tabBar selectTabAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [_viewControllers count])
    {
        return;
    }
    // Remove view from superview.
    [[(UIViewController *)[_viewControllers objectAtIndex:index] view] removeFromSuperview];
    // Remove viewcontroller in array.
    [_viewControllers removeObjectAtIndex:index];
    // Remove tab from tabbar.
    [_tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [_viewControllers insertObject:vc atIndex:index];
    [_tabBar insertTabWithImageDic:dict atIndex:index];
}

- (void)goAtIndex:(int)index {
    
    [self.tabBar selectTabAtIndex:index];
    
}

- (void)curSelectedGoFirst {
    
    _lastSelectedIndex =_selectedIndex;
    
    UIViewController *targetViewController = [self.viewControllers objectAtIndex:_selectedIndex];
    // If target index is equal to current index.
  
    if ([targetViewController isKindOfClass:[UINavigationController class]]) {
        
        [(UINavigationController*)targetViewController popToRootViewControllerAnimated:YES];
    
    }
}

#pragma mark - Private methods

- (void)displayViewAtIndex:(NSUInteger)index
{
    
    // Before changing index, ask the delegate should change the index.
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) 
    {
        if (![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]])
        {
            return;
        }
    }
    
     UIViewController *targetViewController1 = [self.viewControllers objectAtIndex:_lastSelectedIndex];
    
    if ([targetViewController1 isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController * nav = (UINavigationController *)targetViewController1;
        
        [nav popToRootViewControllerAnimated:NO];
        
    }

    _lastSelectedIndex =  _selectedIndex;
 
    UIViewController *targetViewController = [self.viewControllers objectAtIndex:index];
    // If target index is equal to current index.

    if (_selectedIndex == index && [[_transitionView subviews] count] != 0) 
    {
        if ([targetViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)targetViewController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    
    _selectedIndex = index;
   
	[_transitionView.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES]];
  
    targetViewController.view.hidden = NO;
	
    targetViewController.view.frame = _transitionView.frame;
	
    if ([targetViewController.view isDescendantOfView:_transitionView])
	{
		[_transitionView bringSubviewToFront:targetViewController.view];
	}
	else
	{
		[_transitionView addSubview:targetViewController.view];
	}
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:isReload:)])
    {
        [_delegate tabBarController:self didSelectViewController:targetViewController isReload:isReload[index]];
    }
    
    if ([targetViewController isKindOfClass:[UINavigationController class]]) {
    
        UINavigationController * targetNav = (UINavigationController *)targetViewController;
        
        UIViewController * viewController = [targetNav topViewController];
        
        [viewController viewWillAppear:YES];
        
    }else {
        
          [targetViewController viewWillAppear:YES];
        
    }
    
  
}
#pragma mark -
#pragma mark tabBar delegates
-(void)gotoLogin
{
   // BLMAppDelegate *appDelegate = (BLMAppDelegate *)[UIApplication sharedApplication].delegate;
   // [appDelegate showStart];
    
}

- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    mySelectIndex = index;
   
   [self displayViewAtIndex:index];
}

- (void)tabBarDidGotoHotActi:(LeveyTabBar *)tabBar {

    UIStoryboard * board1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NeborCoffeeVenuesViewController * beborCV = [board1 instantiateViewControllerWithIdentifier:@"NeborCoffeeVenuesViewController"];
    beborCV.isPresent = YES;
    beborCV.type = 4;
    UINavigationController * neborCoffee = [[UINavigationController alloc] initWithRootViewController:beborCV];


    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    [appDelegate.window.rootViewController presentViewController:neborCoffee animated:YES completion:^{
        
    }];

}

-(void)didSelect:(NSNotification *)noti
{
    [self.tabBar setHidden:NO];
    
    [self displayViewAtIndex:mySelectIndex];
}

-(BOOL)shouldAutorotate
{
    UINavigationController* nav = (UINavigationController*)self.selectedViewController;    
    return nav.topViewController.shouldAutorotate;
}
-(NSUInteger)supportedInterfaceOrientations
{
    UINavigationController* nav = (UINavigationController*)self.selectedViewController;
    return nav.topViewController.supportedInterfaceOrientations;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if(SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"5.1.1")){
        UINavigationController* nav = (UINavigationController*)self.selectedViewController;
        return [nav.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
//ios7  处理statusbar隐藏
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
-(void)forIOS7
{
    if (SYSTEM_BIGTHAN_7) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.edgesForExtendedLayout =  UIRectEdgeNone;//IOS7新增属性,但是在导航栏隐藏的情况下还是要向下移动20px
        self.navigationController.navigationBar.translucent = NO;//解决导航栏跟状态栏背景色都变的有点暗的问题
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}
#endif

//////////////////////////////////////////////////////
////////////////////////聊天模块///////////////////////////////
///////////////////////////////////////////////////////

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        
        [_tabBar updateUnreadLabelWithNumber:unreadCount];

      /*  if (unreadCount > 0) {
            
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }*/
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [_chatListVC refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    [self setupUnreadMessageCount];
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupList];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    if (ret) {
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        
        do {
            if (options.noDisturbing) {
                NSDate *now = [NSDate date];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute
                                                                               fromDate:now];
                
                NSInteger hour = [components hour];
                //        NSInteger minute= [components minute];
                
                NSUInteger startH = options.noDisturbingStartH;
                NSUInteger endH = options.noDisturbingEndH;
                if (startH>endH) {
                    endH += 24;
                }
                
                if (hour>=startH && hour<=endH) {
                    ret = NO;
                    break;
                }
            }
        } while (0);
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = message.isGroup ? [self needShowNotification:message.conversation.chatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }
#endif
    }
}

- (void)playSoundAndVibration{
    
    //如果距离上次响铃和震动时间太短, 则跳过响铃
    NSLog(@"%@, %@", [NSDate date], self.lastPlaySoundDate);
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        return;
    }
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
      notification.soundName = @"default";
    
    /*UILocalNotification *notification=[[UILocalNotification alloc] init];
     
     if (notification != nil) {
     
     NSDate *now=[NSDate new];
     
     notification.fireDate=[now dateByAddingTimeInterval:15];
     
     notification.timeZone=[NSTimeZone defaultTimeZone];
     
     notification.alertBody=@"定时推送通知！";
     
     notification.soundName = @"default";
     
     [notification setApplicationIconBadgeNumber:22];
     
     [[UIApplication sharedApplication] scheduleLocalNotification:notification];
     
     }*/

    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = @"[图片]";
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = @"[位置]";
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = @"[音频]";
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = @"[视频]";
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.isGroup) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversation.chatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"您有一条新消息";
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
 //   notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        /*NSString *hintText = @"";
         if (error.errorCode != EMErrorServerMaxRetryCountExceeded) {
         if (![[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled]) {
         hintText = @"你的账号登录失败，请重新登陆";
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
         message:hintText
         delegate:self
         cancelButtonTitle:@"确定"
         otherButtonTitles:nil,
         nil];
         alertView.tag = 99;
         [alertView show];
         }
         } else {
         hintText = @"已达到最大登陆重试次数，请重新登陆";
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
         message:hintText
         delegate:self
         cancelButtonTitle:@"确定"
         otherButtonTitles:nil,
         nil];
         alertView.tag = 99;
         [alertView show];
         }*/
        NSString *hintText = @"你的账号登录失败，正在重试中... \n点击 '登出' 按钮跳转到登录页面 \n点击 '继续等待' 按钮等待重连成功";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:@"继续等待"
                                                  otherButtonTitles:@"登出",
                                  nil];
        alertView.tag = 99;
       
        [alertView show];
    }
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        
        ////////////////////
        //在此处注销用户，弹出登录界面
        [[NSUserDefaults standardUserDefaults] clearCurrentMemberID];
        [[NSUserDefaults standardUserDefaults]clearUserInfo];
        ////////////////////////////////////
        ////////////////////
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"你的账号已在其他地方登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,
                                  nil];
        alertView.tag = 100;
        
        [alertView show];
   
    } onQueue:nil];
}

- (void)didRemovedFromServer {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        
        ////////////////////
        //在此处注销用户，弹出登录界面
        [[NSUserDefaults standardUserDefaults] clearCurrentMemberID];
        [[NSUserDefaults standardUserDefaults]clearUserInfo];
        ////////////////////////////////////

        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"你的账号已被从服务器端移除"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,
                                  nil];
        alertView.tag = 101;
       
        [alertView show];
    } onQueue:nil];
}

- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    [_chatListVC networkChanged:connectionState];
}

#pragma mark -

- (void)willAutoReconnect{
   
    //[AppUtil HUDWithStr:@"正在重连中..." View:self.view];
    
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
 
    if (error) {
      //  [AppUtil HUDWithStr:@"重连失败，稍候将继续重连" View:self.view];
     
    }else{
      //[AppUtil HUDWithStr:@"重连成功！" View:self.view];
        
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
     [[NSNotificationCenter defaultCenter] postNotificationName:K_GOTOLOGIN_FROM_SET object:nil];
    
}

#pragma mark - dealloc

- (void)dealloc
{
    [self unregisterNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
