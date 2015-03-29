//
//  AppUtil.h
//  SecondHandBookAPP
//
//  Created by 波罗密 on 14-9-7.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "LeveyTabBarController.h"


@interface AppUtil : NSObject

+(LeveyTabBarController *)getLeveyTabBarController;

//for ios7
-(void)forNavBeTransparent;
-(void)forNavBeNoTransparent;

#pragma mark - util

+ (NSString *)md5HexDigest:(NSString *)input;
+(NSString *)sha1:(NSString *)input;
+ (NSString *)deleteWithStr:(NSMutableString *)str;
+(UIImageView *)scaletoRound:(UIImageView *)theImage;

//////  0.无网络  1.wifi网络 2.  2g/3g/4g网络

+ (int)networkType;

#pragma mark - ios根据gps坐标来计算两点间的距离

+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;

#pragma mark - 判断array dictonry string

+ (BOOL)hasManyObject:(id)object;
+ (BOOL)hasObject:(id)object;
+ (BOOL)isNotNull:(id)object;
+ (BOOL)isNull:(id)object;

#pragma mark - 获取UUID

+ (NSString*) uuid;

#pragma mark - 信息验证方法

+ (BOOL)checkTelephone:(NSString *)str;
+ (BOOL)isValidateEmail:(NSString *)str;
+ (BOOL)isValidateAccount:(NSString *)str; //有效 返回YES 否则返回NO
+ (BOOL)isValidatePassword:(NSString *)str; //有效 返回YES 否则返回NO
+ (BOOL)isValidateUserName:(NSString *)str;
#pragma mark - 时间

+(NSDate *)today;
+(NSInteger)weekDay;
+(NSInteger)week;
+(NSInteger)month;
+(NSInteger)thisWeek:(NSString *)str;
+(NSInteger)thisWeekDay:(NSString *)arr;
+(NSInteger)thisYear:(NSString *)str;
+(NSInteger)thisYearDate:(NSDate *)date;
+(NSInteger)thisMonth:(NSString *)str;
+(NSInteger)thisDay:(NSString *)str;
+(NSInteger)thisHour:(NSString *)hour;
+(NSInteger)forWeeks:(NSString*)str;//获取是星期几
+(BOOL)isToday:(NSString*)dateStr;//是否是今天

+(NSInteger)GetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE;
+(BOOL)saveToDocument:(UIImage *)image WithTag:(NSInteger)mTag;
+(NSString *)fileNameWithtag:(NSInteger)mTag;
+(MBProgressHUD *)loadingHUD:(UIView *)theview;
+(NSString *)ImagePath;
+(NSDate*) convertDateFromString:(NSString*)uiDate;
+(NSString *)stringFromDate:(NSDate *)date;
+(NSString *)stringFromTimeDate:(NSDate *)date;
+(void)clockWithArr:(NSArray *)classArr;
+(NSDate*)convertDateFromtime:(NSString *)timeDate;
+(NSDate *)convertDateFromDateTime:(NSString *)uiDate;
+(NSString *)stringFromDatetime:(NSDate *)date;
+(void)deleteClock:(NSInteger )theID;
+(UIImage *)scaleImage:(UIImage *)theImage;
+(UIImage *)scaleImage:(UIImage *)theImage size:(CGSize )size1;
+(UILabel *)lbWithTitle:(NSString *)title rect:(CGRect)frame;
+(void)callWith:(NSString *)phoneNum inView:(UIView *)view;

+(void)showHudInView:(UIView *)theView title:(NSString *)title tag:(NSInteger)mtag;
+(void)showHudInView:(UIView *)theView tag:(NSInteger)mtag;
+(void)showHudInView:(UIView *)theView withFrame:(CGRect)frame tag:(NSInteger)mtag;
+(void)hideHudInView:(UIView *)theView mtag:(NSInteger)mtag;
+(void)HUDWithStr:(NSString *)theStr View:(UIView *)theView;
+(NSString *)strSubtoIndex:(NSInteger)index str:(NSString *)theStr;
/////////转化为时间/
+(NSString *)convertToTimeFromDateTime:(NSString *)uiDate;

+(NSString *)convertToFdateFromDateTime:(NSString *)uiDate;

+ (NSString *)getWeekFromDate:(NSString *)date;

+ (NSString *)getFirstDayOfWeek;

///////////////缓存方面的方法///////////////
+(void)saveDataWithObject:(id)object plistName:(NSString *)plistN;
+(id)readDataWithPlistName:(NSString *)plisetN cat:(id)cat;
//////////////////////////////////////////



+(void)loginAgain:(UIViewController *)ctl;

+(void)noneShow:(UIView *)theview;
/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ios 7

//for ios7
+(void)forNavBeTransparent:(UIViewController *)ctl;
+(void)forNavBeNoTransparent:(UIViewController *)ctl;

+(NSArray *)getBigImage:(NSArray *)images;
+ (NSString *)getBigImageWithURL:(NSString *)imageURL;

+(double) lantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
@end
