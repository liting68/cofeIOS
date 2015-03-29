//
//  AppUtil.m
//  SecondHandBookAPP
//
//  Created by 波罗密 on 14-9-7.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "AppUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"

@implementation AppUtil

+ (LeveyTabBarController *)getLeveyTabBarController {
    
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    LeveyTabBarController * tabVC = (LeveyTabBarController *)delegate.window.rootViewController;
    
    return tabVC;
    
}

#pragma mark - 判断电话

+ (NSString*) uuid { ////获取UUID
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

#pragma mark - 校验性的方法

+ (BOOL)isValidateUserName:(NSString *)str {
    
    NSString *regex = @"^[A-Za-z0-9]{6,15}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:str] == YES) {
       
        return YES;
    }
    
    return NO;
}

+ (BOOL)isValidateEmail:(NSString *)str { //有效返回 YES 否则返回NO
    

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

+ (BOOL)checkTelephone:(NSString *)str //有效返回YES  否则返回NO

{
    if ([str length] == 0) {
        
        return NO;
        
    }
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        return NO;
        
    }
    
    return YES;
}

+ (BOOL)isValidateAccount:(NSString *)str { //有效 返回YES 否则返回NO
    
    if ([AppUtil isNull:str] || ([str length] != 11)) {
        
        return NO;
    
    }else {
        
        return YES;
    }
}


+ (BOOL)isValidatePassword:(NSString *)str { //有效 返回YES 否则返回NO
    
    if ([AppUtil isNull:str] || [str length] < 6) {
        
        return NO;
        
    }else {
        
        return YES;
    }
}

//for ios7
+(void)forNavBeTransparent:(UIViewController *)ctl
{
    if (SYSTEM_BIGTHAN_7) {
       
        ctl.navigationController.interactivePopGestureRecognizer.enabled = NO;
        ctl.navigationController.navigationBar.translucent = YES;//
        [ctl.navigationController.navigationBar setBackgroundImage:TTImage(@"common_cover") forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else{
        
        [ctl.navigationController.navigationBar setBackgroundImage:TTImage(@"common_cover") forBarMetrics:UIBarMetricsDefault];
    }
}

+(void)forNavBeNoTransparent:(UIViewController *)ctl
{
    if (SYSTEM_BIGTHAN_7) {
        
        ctl.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
         ctl.edgesForExtendedLayout =  UIRectEdgeNone;//IOS7新增属性,但是在导航栏隐藏的情况下还是要向下移动20px
         ctl.navigationController.navigationBar.translucent = NO;//解决导航栏跟状态栏背景色都变的有点暗的问题
        ctl.extendedLayoutIncludesOpaqueBars = NO;
        ctl.modalPresentationCapturesStatusBarAppearance = NO;
        
        [ctl.navigationController.navigationBar setBackgroundImage:TTImage(@"common_nav") forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else{
        
        [ctl.navigationController.navigationBar setBackgroundImage:TTImage(@"common_nav") forBarMetrics:UIBarMetricsDefault];
    }
}



//////  0.无网络  1.wifi网络 2.  2g/3g/4g网络
/*
 + (int)networkType {
 
 AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
 
 if (appDelegate.isReachable) {
 
 if ([appDelegate.networkType isEqualToString:@"wifi"]) {
 
 return 1;
 
 }else{
 
 return 2;
 }
 
 }else{
 
 return 0;
 }
 }*/

///判断数组对象是否有值
+ (BOOL)hasObject:(id)object {
    
    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
        
        if ([object isKindOfClass:[NSNull class]] || (object == nil) ) {
            
            return NO;
            
        }else {
            
            if ([object count] > 0) {
                
                return YES;
                
            }else{
                
                return NO;
            }
        }
        
    }else {
        
        return NO;
    }
}

#pragma mark - ios根据gps坐标来计算两点间的距离

+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = M_PI*lat1/180.0f;
    double radlat2 = M_PI*lat2/180.0f;
    //now long.
    double radlong1 = M_PI*lon1/180.0f;
    double radlong2 = M_PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = M_PI_2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = M_PI_2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = M_PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = M_PI_2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = M_PI_2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = M_PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist/1000;
}

+ (BOOL)hasManyObject:(id)object {
    
    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
        
        if ([object isKindOfClass:[NSNull class]] || (object == nil) ) {
            
            return NO;
            
        }else {
            
            if ([object count] > 1) {
                
                return YES;
                
            }else{
                
                return NO;
            }
        }
        
    }else {
        
        return NO;
    }
}

//****************
//判断字符串是否为空
+(BOOL)isNotNull:(id)object
{
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
        
    }else if (object == [NSNull null]){
     
        return NO;
        
    }else if (object==nil){
        return NO;
    }
    else {
        if ([object isKindOfClass:[NSString class]]) {
            if ([object isEqualToString:@""]) {
                return NO;
            }
            return YES;
        }
        return YES;
    }
    return YES;
}

//判断字符串是否为空
+(BOOL)isNull:(id)object
{
    if ([object isEqual:[NSNull null]]) {
        
        return YES;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (object == nil){
        return YES;
    }
    else {
        if ([object isKindOfClass:[NSString class]]) {
            if ([object isEqualToString:@""] || [object isEqualToString:@"(null)"]) {
                return YES;
            }
            return NO;
        }
        return NO;
    }
    return NO;
}

+(void)deleteClock:(NSInteger )theID
{
    NSArray *myArray=[[UIApplication sharedApplication] scheduledLocalNotifications];
    for (int i=0; i<[myArray count]; i++) {
        UILocalNotification    *myUILocalNotification=[myArray objectAtIndex:i];
        if ([[[myUILocalNotification userInfo] objectForKey:@"member_event_id"] intValue]==theID) {
            [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
        }
    }
}

+(UILabel *)lbWithTitle:(NSString *)title rect:(CGRect)frame
{
    UILabel *lb=[[UILabel alloc]initWithFrame:frame];
    lb.backgroundColor=CLEAR_COLOR;
    lb.textColor=RGBCOLOR(0x83,0x83,0x83);
    lb.textAlignment=NSTextAlignmentCenter;
    UIFont *font=[UIFont fontWithName:@"Baskerville-BoldItalic" size:17];
    lb.font=font;
    [lb setNumberOfLines:0];
    CGSize size=[title sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, 300) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect rect=lb.frame;
    rect.size=size;
    lb.frame=rect;
    lb.text=title;
    CGPoint point=lb.center;
    point.x=K_UIMAINSCREEN_WIDTH/2;
    lb.center=point;
    return lb;
}

+(void)callWith:(NSString *)phoneNum inView:(UIView *)view
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不能打电话" delegate:nil cancelButtonTitle:@"好的,知道了" otherButtonTitles:nil,nil];
        
        [alert show];
    }
    else{
        
        NSString *number = [NSString stringWithFormat:@"tel:%@",phoneNum];
        
        
        NSURL *url = [NSURL URLWithString:number];
        
        UIWebView *phoneCallWeb = [[UIWebView alloc] initWithFrame:CGRectZero];
        phoneCallWeb.tag=1001;
        [phoneCallWeb loadRequest:[NSURLRequest requestWithURL:url]];
        [view addSubview:phoneCallWeb];
    }
    
}


+(void)showHudInView:(UIView *)theView withFrame:(CGRect)frame tag:(NSInteger)mtag
{
    MBProgressHUD *mHUD=[[MBProgressHUD alloc]initWithFrame:frame];
    // mHUD.frame = frame;
    mHUD.mode=MBProgressHUDModeIndeterminate;
    mHUD.tag=mtag;
    mHUD.labelText=@"正在加载中...";
    [theView addSubview:mHUD];
    [mHUD show:YES];
}

+(void)showHudInView:(UIView *)theView title:(NSString *)title tag:(NSInteger)mtag
{
    MBProgressHUD *mHUD=[[MBProgressHUD alloc]initWithView:theView];
    // mHUD.frame = frame;
    mHUD.mode=MBProgressHUDModeIndeterminate;
    mHUD.tag=mtag;
    mHUD.labelText=title;
    [theView addSubview:mHUD];
    [mHUD show:YES];
}

+(void)showHudInView:(UIView *)theView tag:(NSInteger)mtag
{
    MBProgressHUD *mHUD=[[MBProgressHUD alloc]initWithView:theView];
    mHUD.mode=MBProgressHUDModeIndeterminate;
    mHUD.tag=mtag;
    mHUD.labelText=@"正在加载中...";
    [theView addSubview:mHUD];
    [mHUD show:YES];
}

+(void)hideHudInView:(UIView *)theView mtag:(NSInteger)mtag
{
    MBProgressHUD *mHud=(MBProgressHUD *)[theView viewWithTag:mtag];
    [mHud hide:YES];
    [mHud removeFromSuperview];
}

+(MBProgressHUD *)loadingHUD:(UIView *)theview
{
    MBProgressHUD *mHUD=[[MBProgressHUD alloc]initWithView:theview];
    mHUD.mode=MBProgressHUDModeIndeterminate;
    mHUD.labelText=@"正在加载中...";
    return mHUD;
}

+(void)HUDWithStr:(NSString *)theStr View:(UIView *)theView
{
    MBProgressHUD *mHUD=[[MBProgressHUD alloc]initWithView:theView];
    mHUD.mode=MBProgressHUDModeText;
    mHUD.labelText=theStr;
    [theView addSubview:mHUD];
    [theView bringSubviewToFront:mHUD];
    [mHUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [mHUD removeFromSuperview];
    }];
}

+(NSString *)ImagePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"share.png"];
    return uniquePath;
}

+(NSString *)fileNameWithtag:(NSInteger)mTag
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
    }
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d.png",mTag]];
    return filePath;
}

+(BOOL)saveToDocument:(UIImage *)image WithTag:(NSInteger)mTag
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
    }
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d.png",mTag]];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    BOOL success=[imageData  writeToFile:filePath atomically:NO];
    return success;
}

+(NSInteger)GetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE
{
    NSArray *timeBegin=[timeS componentsSeparatedByString:@":"];
    NSArray *timeEnd=[timeE componentsSeparatedByString:@":"];
    NSInteger beginMin=[[timeBegin objectAtIndex:0]integerValue]*60+[[timeBegin objectAtIndex:1]integerValue];
    NSInteger endMin=[[timeEnd objectAtIndex:0]integerValue]*60+[[timeEnd objectAtIndex:1]integerValue];
    return endMin-beginMin;
    
}

+(NSInteger)thisHour:(NSString *)hour
{
    NSArray *strArr=[hour componentsSeparatedByString:@":"];
    return [[strArr objectAtIndex:0]integerValue];
}

+(NSInteger)thisYear:(NSString *)str{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSArray *arr=[str componentsSeparatedByString:@"-"];
    NSMutableArray *mArr=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSString * str in arr) {
        NSMutableString *str1=[NSMutableString stringWithString:str];
        if ([str1 hasPrefix:@"0"]) {
            [str1 deleteCharactersInRange:NSMakeRange(0,1)];
        }
        [mArr addObject:str1];
    }
    [components setDay:[[mArr objectAtIndex:2]integerValue]];
    [components setMonth:[[mArr objectAtIndex:1]integerValue]];
    [components setYear:[[mArr objectAtIndex:0]integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    [components release];
    
    NSCalendar*calendar=[NSCalendar currentCalendar];
    NSDateComponents*dateCom=[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    NSInteger year=[dateCom year];//年
    
    return year;
    
}

+(NSInteger)thisYearDate:(NSDate *)date{
    NSCalendar*calendar=[NSCalendar currentCalendar];
    NSDateComponents*dateCom=[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    NSInteger year=[dateCom year];//年
    
    return year;
    
}


+(NSInteger)thisMonth:(NSString *)str
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSArray *arr=[str componentsSeparatedByString:@"-"];
    NSMutableArray *mArr=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSString * str in arr) {
        NSMutableString *str1=[NSMutableString stringWithString:str];
        if ([str1 hasPrefix:@"0"]) {
            [str1 deleteCharactersInRange:NSMakeRange(0,1)];
        }
        [mArr addObject:str1];
    }
    [components setDay:[[mArr objectAtIndex:2]integerValue]];
    [components setMonth:[[mArr objectAtIndex:1]integerValue]];
    [components setYear:[[mArr objectAtIndex:0]integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    [components release];
    
    NSDateComponents *weekdayComponents =
    
    [gregorian components:NSMonthCalendarUnit fromDate:date];
    
    int month = [weekdayComponents month];
    
    return month;
}

+(NSInteger)thisDay:(NSString *)str
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSArray *arr=[str componentsSeparatedByString:@"-"];
    NSMutableArray *mArr=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSString * str in arr) {
        NSMutableString *str1=[NSMutableString stringWithString:str];
        if ([str1 hasPrefix:@"0"]) {
            [str1 deleteCharactersInRange:NSMakeRange(0,1)];
        }
        [mArr addObject:str1];
    }
    [components setDay:[[mArr objectAtIndex:2]integerValue]];
    [components setMonth:[[mArr objectAtIndex:1]integerValue]];
    [components setYear:[[mArr objectAtIndex:0]integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    [components release];
    
    NSCalendar*calendar=[NSCalendar currentCalendar];
    NSDateComponents*dateCom=[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    //从dateCom中取出日期
    NSInteger dayint=[dateCom day];//日
    
    return dayint;
}

#pragma mark - 获取date是星期几
+(NSInteger)forWeeks:(NSString*)str{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSArray *arr=[str componentsSeparatedByString:@"-"];
    NSMutableArray *mArr=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSString * str in arr) {
        NSMutableString *str1=[NSMutableString stringWithString:str];
        if ([str1 hasPrefix:@"0"]) {
            [str1 deleteCharactersInRange:NSMakeRange(0,1)];
        }
        [mArr addObject:str1];
    }
    [components setDay:[[mArr objectAtIndex:2]integerValue]];
    [components setMonth:[[mArr objectAtIndex:1]integerValue]];
    [components setYear:[[mArr objectAtIndex:0]integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    [components release];
    NSCalendar*calendar=[NSCalendar currentCalendar];
    
    return [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
    
}

+(BOOL)isToday:(NSString*)dateStr{
    NSDate *todayDate = [NSDate date];
    NSCalendar*calendar=[NSCalendar currentCalendar];
    NSDateComponents*dateCom=[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:todayDate];
    
    NSInteger yearStr= [AppUtil thisYear:dateStr];
    NSInteger monthStr=[AppUtil thisMonth:dateStr];
    NSInteger dayStr = [AppUtil thisDay:dateStr];
    
    NSInteger todayYear=[dateCom year];
    NSInteger todayMonth=[dateCom month];
    NSInteger todayDay=[dateCom day];
    if (yearStr==todayYear&&monthStr==todayMonth&&dayStr==todayDay) {
        return YES;
    }
    else{
        return NO;
    }
    
}

+(NSInteger)thisWeek:(NSString *)str
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSArray *arr=[str componentsSeparatedByString:@"-"];
    NSMutableArray *mArr=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSString * str in arr) {
        NSMutableString *str1=[NSMutableString stringWithString:str];
        if ([str1 hasPrefix:@"0"]) {
            [str1 deleteCharactersInRange:NSMakeRange(0,1)];
        }
        [mArr addObject:str1];
    }
    [components setDay:[[mArr objectAtIndex:2]integerValue]];
    [components setMonth:[[mArr objectAtIndex:1]integerValue]];
    [components setYear:[[mArr objectAtIndex:0]integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    [components release];
    
    NSDateComponents *weekdayComponents =
    
    [gregorian components:NSWeekOfMonthCalendarUnit fromDate:date];
    
    int week = [weekdayComponents weekOfMonth];
    
    return week;
}

+(NSInteger)thisWeekDay:(NSString *)str
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSArray *arr=[str componentsSeparatedByString:@"-"];
    NSMutableArray *mArr=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSString * str in arr) {
        NSMutableString *str1=[NSMutableString stringWithString:str];
        if ([str1 hasPrefix:@"0"]) {
            [str1 deleteCharactersInRange:NSMakeRange(0,1)];
        }
        [mArr addObject:str1];
    }
    [components setDay:[[mArr objectAtIndex:2]integerValue]];
    [components setMonth:[[mArr objectAtIndex:1]integerValue]];
    [components setYear:[[mArr objectAtIndex:0]integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    [components release];
    
    NSDateComponents *weekdayComponents =
    
    [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    int weekday = [weekdayComponents weekday];
    
    return weekday;
}

+(NSInteger)weekDay
{
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps;
    
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
            
                       fromDate:date];
    //    NSInteger week = [self week]; // 今年的第几周
    
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    
    //    NSInteger weekdayOrdinal = [comps weekdayOrdinal];// 这个月的第几周
    return weekday;
}

+(NSInteger)month
{
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps;
    
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit|NSMonthCalendarUnit)
            
                       fromDate:date];
    return [comps month];
}

+(NSInteger)week
{
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps;
    
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
            
                       fromDate:date];
    NSInteger week = [comps weekdayOrdinal]; // 这个月的第几周
    
    //    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    
    //    NSInteger weekdayOrdinal = [comps weekdayOrdinal];// 这个月的第几周
    
    return week;
}

+(NSDate *)convertDateFromDateTime:(NSString *)uiDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:uiDate];
    return date;
}

+(NSString *)convertToTimeFromDateTime:(NSString *)uiDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:uiDate];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString * time =[dateFormatter stringFromDate:date];
    
    return time;
}

+(NSString *)convertToFdateFromDateTime:(NSString *)uiDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:uiDate];
    
    [dateFormatter setDateFormat:@"MM-dd"];
    
    NSString * time =[dateFormatter stringFromDate:date];
    
    return time;
}

//本周的第一天
+ (NSString *)getFirstDayOfWeek
{
    //    NSDate *now = [NSDate dateWithTimeIntervalSince1970:timestamp];
    //    NSCalendar *cal = [NSCalendar currentCalendar];
    //    NSDateComponents *comps = [cal
    //                               components:NSYearCalendarUnit| NSMonthCalendarUnit| NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit
    //                               fromDate:now];
    //    if (comps.weekday <2)
    //    {
    //        comps.week = comps.week-1;
    //    }
    //    comps.weekday = 2;
    //    NSDate *firstDay = [cal dateFromComponents:comps];
    //    return [firstDay timeIntervalSince1970];
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps;
    
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
            
                       fromDate:date];
    //    NSInteger week = [comps weekdayOrdinal]; // 这个月的第几周
    
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    
    //    NSInteger weekdayOrdinal = [comps weekdayOrdinal];// 这个月的第几周
    
    NSDate *sunday=[date dateByAddingTimeInterval:-weekday*3600*24];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:sunday];
    return strDate;
    
}

+ (NSString *)getWeekFromDate:(NSString *)date {
    
    //initializtion parameter
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [dateFormatter dateFromString:date];
    
    
    comps = [calendar components:unitFlags fromDate:now];
   int  week = [comps weekday];
    
    if (week == 1) {
        
        return @"周天";
    
    }else if(week == 2) {
        
        return @"周一";
    }else if (week == 3) {
        
        return @"周二";
    
    }else if(week == 4){
        
        return @"周三";
    }else if (week == 5){
        
        return @"周四";
    }else if (week == 6){
        
        return @"周五";
    
    }else {
        
        return @"周六";
    }
    
}

+(NSDate *)today
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMdd"];
    return senddate;
}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:uiDate];
    return date;
}

+(NSDate*)convertDateFromtime:(NSString *)timeDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeDate];
    return date;
}



+(NSString *)stringFromDatetime:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+(NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
    
}

+(NSString *)stringFromTimeDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+(NSString *)strSubtoIndex:(NSInteger)index str:(NSString *)theStr
{
    if ([theStr length] >4) {
        NSMutableString *str = [NSMutableString stringWithString:theStr];
        return [str substringToIndex:index];
    }
    else{
        return theStr;
    }
    
}

+(UIImage *)scaleImage:(UIImage *)theImage
{
    CGSize size=theImage.size;
    CGFloat width;
    CGFloat height;
    if (theImage.size.width>500) {
        width=500;
        height=theImage.size.height*500/theImage.size.width;
    }
    else{
        height=500;
        width=theImage.size.width*500/theImage.size.height;
    }
    size=CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [theImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+(UIImage *)scaleImage:(UIImage *)theImage size:(CGSize )size1
{
    
    UIGraphicsBeginImageContext(size1);
    // 绘制改变大小的图片
    [theImage drawInRect:CGRectMake(0, 0, size1.width, size1.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+(UIImageView *)scaletoRound:(UIImageView *)theImage
{
    theImage.layer.masksToBounds=YES;
    theImage.layer.cornerRadius=theImage.frame.size.width/2;
    return theImage;
}
/**
 * 对输入的字符串进行MD5计算并输出验证码的工具方法。
 */
+ (NSString *)md5HexDigest:(NSString *)input{
    const char* str = [input UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
    NSMutableString *returnHashSum = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [returnHashSum appendFormat:@"%02x", result[i]];
    }
	
	return returnHashSum;
}

/*sha1加密*/
+(NSString *)sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        
        [output appendFormat:@"%02x", digest[i]];
    
    }
    return output;
}

#pragma mark - 数据持久化

+(void)saveDataWithObject:(id)object plistName:(NSString *)plistN{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *listPath = [documentDirectory stringByAppendingPathComponent:plistN];
    if ([object writeToFile:listPath atomically:YES]) {
        
        NSLog(@"写入成功");
    }
}

+(id)readDataWithPlistName:(NSString *)plisetN cat:(id)cat {
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *listPath = [documentDirectory stringByAppendingPathComponent:plisetN];
    
    if ([cat isKindOfClass:[NSString class]]) {
        
        NSString * tempStr = [NSString stringWithContentsOfFile:listPath encoding:4 error:nil];
        
        return tempStr;
   
    }else if([cat isKindOfClass:[NSArray class]]){
        
         NSArray *array = [[NSArray alloc] initWithContentsOfFile:listPath];
        
        return array;
    
    }else if([cat isKindOfClass:[NSDictionary class]]){
    
        NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:listPath];
        return dic;
    }
    return nil;
}

#pragma mark - ios根据gps坐标来计算两点间的距离

+(double)lantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = M_PI*lat1/180.0f;
    double radlat2 = M_PI*lat2/180.0f;
    //now long.
    double radlong1 = M_PI*lon1/180.0f;
    double radlong2 = M_PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = M_PI_2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = M_PI_2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = M_PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = M_PI_2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = M_PI_2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = M_PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist/1000;
}

+ (NSString *)getBigImageWithURL:(NSString *)imageURL {
    
    NSString * myImage = [imageURL stringByReplacingOccurrencesOfString:@"_s" withString:@"_b"];
    
    return myImage;

}

+(NSArray *)getBigImage:(NSArray *)images {
    
    NSMutableArray  * tempImage = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int index = 0; index < [images count]; index ++) {
        
        NSString * imageURL = images[index];
        
        NSString * myImage = [imageURL stringByReplacingOccurrencesOfString:@"_s" withString:@"_b"];
        
        [tempImage addObject:myImage];
        
    }
    return tempImage;
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur), nil, nil];
    
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}
@end
