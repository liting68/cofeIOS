//
//  BLMCommon.h
//  Yujia001
//
//  Created by pansj on 13-9-9.
//  Copyright (c) 2013年 apple. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "HTCopyableLabel.h"

/**
 * 应用程序主要KEY的设置
 */
#define SECRETKEY @"32df2bc3520d53a10ed6eb0807a5a6ab"
#define BAIDU_API_KEY @"86G7Lr7xHsG7S1x35X3Bc7ny" ///定位完,获取地址
#define BAIDU_MAP_API_KEY @"N8fZ5M1Y1TjS50AA179ywwwn"//咖啡约我 已经更换
#define UMENG_PUSH_API_KEY @"54f462edfd98c51d67000385"//友盟推送//////
#define UMENG_SHARE_API_KEY @"537af9a956240bc738013e2c"//友盟分享
#define UMENG_ANALYSIS_API_KEY @"537af9a956240bc738013e2c"//友盟分析

//分享方面的KEY
#define QQ_APPID @"100424468"
#define QQ_APPKEY @"c7394704798a158208a74ab60104f0ba"

#define SINA_WEIBO_APPKEY @"642818874"
#define SINA_WEIBO_SECRET @"923c0998d4adfa792f77821f6131fa43"

#define WECHAT_APPID @"wxfba15a9583c435a5"

#define QZONE_APPKEY @"101004622"
#define QZONE_SECRET @"b78dec29d48ed777eed9e294ddb9e3cb"

#define kTabBarHeight 49
#define BUTTOM_BAR_HEIGHT 57
#define NAV_BAR_HEIGHT 44
#define LEFT_X 20
#define BTN_HEIGHT 30
#define LINE_SPACING 7

#define LOCATION_INTERVAL 10

#define SYSTEM_VERSION [[[UIDevice currentDevice]systemVersion]floatValue]
/*常用类*/
#define SYSTEM_BIGTHAN_7 ([[[UIDevice currentDevice]systemVersion]floatValue] ==7.0)||([[[UIDevice currentDevice]systemVersion]floatValue]>7)
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)  
#define MYUSERINFO [BLMUserInfo shareBLMUserInfo]
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define DELTA_HEIGHT ((SYSTEM_BIGTHAN_7)?20:0)

// 获取memberId
#define PATHS   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
#define PATH     [PATHS objectAtIndex:0]
#define USER_INFO_PATH    [PATH stringByAppendingPathComponent:@"/userInfo.plist"]
#define MEMBER_INFO   [NSDictionary dictionaryWithContentsOfFile:USER_INFO_PATH]
#define USER_AVATAR_PATH  [PATH stringByAppendingPathComponent:@"/avatar.png"]

/*屏幕尺寸常量*/
#define K_UIMAINSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define K_UIMAINSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height - (20 - DELTA_HEIGHT))

#define hostUrl @"http://www.kfyw021.com/api.php"

#define ABOUT_URL @"http://www.kfyw021.com/about.html"

#define isIos7      ([[[UIDevice currentDevice] systemVersion] floatValue])
#define StatusbarSize ((isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)?20.f:0.f)

/* { thread } */
#define __async_opt__  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define __async_main__ dispatch_async(dispatch_get_main_queue()

#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

/*常用方法*/
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define HEXCOLOR(hexString)  [UIColor colorWithHexString:hexString]
#define DARK_BLUE RGBCOLOR(0x47,0x88,0xb2)
#define LIGHT_BLUE RGBCOLOR(0x76,0xb2,0xd4)
#define OTHER_BLUE RGBCOLOR(0x1c,0x63,0x8d)
#define TEXT_COLOR RGBCOLOR(0x48,0x48,0x48)
#define LIGHT_TEXT_COLOR RGBCOLOR(0x98,0x98,0x98)
#define LINE_COLOR RGBCOLOR(0xdc,0xdc,0xdc)
#define LIGHT_GREEN RGBCOLOR(0x61,0xc3,0xd5)

#define SEGEMENT_BTN_COLOR RGBCOLOR(0xf1,0xf1,0xf1)
#define SEGEMENT_TITLE_COLOR RGBCOLOR(0x61,0xc3,0xd5)

#define BLACK_TEXT_COLOR RGBCOLOR(0x11,0x11,0x11)
#define LIGHT_BLACK_COLOR RGBCOLOR(0x88,0x88,0x88)
#define BLUE_NAV_COLOR RGBCOLOR(0x13,0xa7,0xe5)
#define CELL_SELECTED_COLOR RGBCOLOR(0xdf,0xdf,0xdf)
#define LIGHT_LINE_COLOR RGBCOLOR(0xd8,0xd8,0xd8)

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define CITY_DICT @"cityDict"
//#define COLORWITHHEX(hexString) [UIColor colorWithHexString:hexString]



#ifndef TTImage
#define TTImage(_IMAGENAME_) [UIImage imageNamed: _IMAGENAME_ ]
#endif
#ifndef TTFont
#define TTFont(_FONTSIZE_) [UIFont systemFontOfSize:_FONTSIZE_]
#endif
#ifndef TTBoldFont
#define TTBoldFont(_FONTSIZE_) [UIFont boldSystemFontOfSize:_FONTSIZE_]
#endif
#ifndef BUTTON_CUSTOM 
#define BUTTON_CUSTOM [UIButton buttonWithType:UIButtonTypeCustom]
#endif
#ifndef BLACK_COLOR
#define BLACK_COLOR [UIColor blackColor]
#endif
#ifndef CLEAR_COLOR 
#define CLEAR_COLOR [UIColor clearColor]
#endif
#ifndef WHITE_COLOR 
#define WHITE_COLOR [UIColor whiteColor]
#endif
#define DARKGRAY_COLOR [UIColor darkGrayColor]
#define GRAY_COLOR [UIColor grayColor]
#define TTUrl(_URL_) [NSURL URLWithString: _URL_ ]

#define PLACEHOLDER_IMAGE TTImage(@"thedefault_04")
#define CHANGGUAN_PLACEHOLDER_IMAGE TTImage(@"thedefault_01")
#define CHANGGUAN_LOGO_PLACEHOLDER TTImage(@"thedefault_02")
#define PHOTO_PLACEHOLDER TTImage(@"thedefault_03")
 
#define MORE_IMAGE TTImage(@"btn_more_unselected")



#ifndef PopAnimation
#define PopAnimation      CATransition *transition = [CATransition animation];\
transition.duration = 0.2f;\
transition.type = kCATransitionReveal;\
transition.subtype = kCATransitionFromLeft;\
[self.navigationController.view.layer addAnimation:transition forKey:@"animation"];\
[self.navigationController popViewControllerAnimated:NO];
#endif
#ifndef PushAnimation
#define PushAnimation      CATransition *transition = [CATransition animation];\
transition.duration = 0.2f;\
transition.type = kCATransitionMoveIn;\
transition.subtype = kCATransitionFromRight;\
[self.navigationController.view.layer addAnimation:transition forKey:@"animation"];
#endif

//[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_blue_lump.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];

#ifndef NAV_COLOR_DEFINE 
#define NAV_COLOR_DEFINE    if (SYSTEM_BIGTHAN_7) \
[self.navigationController.navigationBar setBackgroundImage:TTImage(@"bg_blue_blump") forBarPosition:UIBarPositionTopAttached barMetrics:UIBarStyleDefault];\
else \
[self.navigationController.navigationBar setBackgroundImage:TTImage(@"bg_blue_blump_ios6") forBarMetrics:UIBarStyleDefault];
#endif

#ifndef NAV_RIGHT_TITLE
#define NAV_RIGHT_TITLE(x,color) UIButton *rightBtn=BUTTON_CUSTOM;\
[rightBtn setTitle:x forState:UIControlStateNormal];\
rightBtn.frame=CGRectMake(320-50,(44-20)/2,50,20);\
 [rightBtn setTitleColor:color forState:UIControlStateNormal];\
[rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];\
self.navigationItem.rightBarButtonItem=rightItem;
#endif

#ifndef NAV_BACK_BTN
#define NAV_BACK_BTN   UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];\
UIImage *leftImage=[UIImage imageNamed:@"btn_back"];\
[leftBtn setImage:leftImage forState:UIControlStateNormal];\
[leftBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateHighlighted];\
leftBtn.frame=CGRectMake(25,(44-leftImage.size.height)/2,leftImage.size.width, leftImage.size.height);\
[leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];\
self.navigationItem.leftBarButtonItem =leftItem;
#endif


#ifndef TITLE_VIEW 
#define TITLE_VIEW(x) UILabel *titleLabel = [[UILabel alloc] init];\
titleLabel.backgroundColor  = [UIColor clearColor];\
titleLabel.textColor        = [UIColor whiteColor];\
titleLabel.text             = x;\
[titleLabel sizeToFit];\
self.navigationItem.titleView = titleLabel;
#endif


#define BACKGROUND_COLOR [UIColor colorWithRed:0xE6/255.0 green:0xE6/255.0 blue:0xE6/255.0 alpha:0xE6/255.0]

#define k_PHOTO_LIBLARY_UPDATE @"k_PHOTO_LIBLARY_UPDATE"

#define K_UPDATE_USER_INFO_NOTIFICATION @"K_UPDATE_USER_INFO_NOTIFICATION"

#define K_GET_NO_READ_NOTIFICATION @"K_GET_NO_READ_NOTIFICATION"////为读数

#define K_UPDATE_VIEWS @"K_UPDATE_VIEWS"

#define K_LOCATIOIN_UPDATE_SUCCESS @"K_LOCATIOIN_UPDATE_SUCCESS"

#define K_PULL_BLACK_NOTIFICATION @"K_PULL_BLACK_NOTIFICATION"

#define K_UPDATE_CONTACTS @"K_UPDATE_CONTACTS"

#define K_CHANGE_AVATAR_NOTIFICATION @"K_CHANGE_AVATAR_NOTIFICATION"//更换头像

#define KNOTIFICATION_LOGINCHANGE @"KNOTIFICATION_LOGINCHANGE"//

#define K_SET_AXISNAME_NOTIFICATION @"K_SET_AXISNAME_NOTIFICATION"

#define K_GOTOLOGIN_FROM_SET @"K_GOTOLOGIN_FROM_SET"

#define K_UPDATE_ROOT_VC @"K_UPDATE_ROOT_VC"

#define K_POST_ACTI @"K_POST_ACTI"

#define K_GOTOLOGIN_NOTIFICATION @"K_GOTOLOGIN_NOTIFICATION"
#define K_LOGIN_NOTIFICATION @"K_LOGIN_NOTIFICATION"
#define K_PERSON_LEAVE_NOTIFICATION @"K_PERSON_LEAVE_NOTIFICATION"
#define k_CAFE_LEAVE_NOTIFICATION @"k_CAFE_LEAVE_NOTIFICATION"
/*消息*/
#define K_ADDPHOTO_NOTIFICATION @"K_ADDPHOTO_NOTIFICATION"
#define K_PHOTOCHOOSED_NOTIFICATION @"K_PHOTOCHOOSED_NOTIFICATION"
#define K_BTNCLICKED_NOTIFICATION @"K_BTNCLICKED_NOTIFICATION"
#define K_CHANGEINFO_NOTIFICATION @"K_CHANGEINFO_NOTIFICATION"
#define K_PUSHTOMEMBER_NOTIFICATION @"K_PUSHTOMEMBER_NOTIFICATION"
#define K_TOUCHBEGIN_NOTIFICATION @"K_TOUCHBEGIN_NOTIFICATION"
#define K_REACH_CHANGE_NOTIFICATION @"kNetworkReachabilityChangedNotification"
#define K_PUSH_MESSAGE_NOTIFICATION @"K_PUSH_MESSAGE_NOTIFICATION"
#define K_PUSH_DETAIL_NOTIFICATION @"K_PUSH_DETAIL_NOTIFICATION"
#define K_ADDorDELETE_NOTIFICATION @"K_ADDorDELETE_NOTIFICATION"
#define K_ALREADY_SIGN_NOTIFICATION @"K_ALREADY_SIGN_NOTIFICATION"
#define K_COLOCK_NOTIFICATION @"K_COLOCK_NOTIFICATION"
#define K_CLEANDATA_NOTIFICATION @"K_CLEANDATA_NOTIFICATION"
#define K_CHANGE_CLOCK_NOTIFICATION @"K_CHANGE_CLOCK_NOTIFICATION"
#define K_CLOCK_NOTIFICATION @"K_CLOCK_NOTIFICATION"
#define K_MEMBER_NOTIFICATION @"K_MEMBER_NOTIFICATION"
#define K_POPBACK_NOTIFICATION @"K_POPBACK_NOTIFICATION"
#define K_HAS_SIGNIN_NOTIFICATION @"K_HAS_SIGNIN_NOTIFICATION"//登陆
#define K_COLLECT_VIDEO_NOTIFICATION @"K_COLLECT_VIDEO_NOTIFICATION" //收藏视频
#define K_ADD_FRIEND_NOTIFICATION @"K_ADD_FRIEND_NOTIFICATION"
#define K_CITYCHANGE_NOTIFICATION @"K_CITYCHANGE_NOTIFICATION"
#define K_CATEGORY_NOTIFICATION @"K_CATEGORY_NOTIFICATION"
#define K_LOCATION_CLICK_NOTIFICATION @"K_LOCATION_CLICK_NOTIFICATION"
#define K_KEYWORD_NOTIFICATION @"K_KEYWORD_NOTIFICATION"
#define K_LOGOUT_NOTIFICATION @"K_LOGOUT_NOTIFICATION"



/*设备版本号比较*/
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

