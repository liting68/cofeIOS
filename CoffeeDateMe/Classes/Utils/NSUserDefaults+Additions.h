//
//  NSUserDefaults+Additions.h
//  HKSportMap
//
//  Created by AsOne on 13-2-1.
//  Copyright (c) 2013年 AsOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Additions)

//当前位置，保留经纬度以逗号分隔
@property (assign, getter = currentlocation, setter = setCurrentlocation:) NSDictionary *currentLocation;
//当前城市，如0591
@property (assign, getter = currentCity, setter = setCurrentCity:) NSString *currentCity;
// 当前城市名， 如“福州市”
@property (assign, getter = currentCityName, setter = setCurrentCityName:) NSString *currentCityName;
//当前登录用户邮箱
@property (assign, getter = currentUserEmail, setter = setCurrentUserEmail:) NSString *currentUserEmail;
//当前登录用户密码
@property (assign, getter = currentUserPsw, setter = setCurrentUserPsw:) NSString *currentUserPsw;

//当前登录用户MemberID
@property (assign, getter = currentMemberID, setter = setCurrentMemberID:) NSNumber *currentMemberID;

//当前游客visitorID
@property (assign, getter = visitorID, setter = setVisitorID:) NSString *visitorID;

//当前登录用户昵称
@property (assign, getter = currentMemberNick, setter = setCurrentMemberNick:) NSString *currentMemberNick;
//当前登录用户的消息总数（除朋友消息）
@property (assign, getter = currentMessageCount, setter = setCurrentMessageCount:) NSInteger currentMessageCount;

@property (assign, getter = currentMemberAvatar,setter = setCurrentMemberAvatar:) NSString * currentMemberAvatar;
@property (assign, getter = userInfo,setter = setUserInfo:)NSDictionary * userInfo;

// 清除当前经纬度
- (void)clearCurrentLocation;
// 清除当前登录 MemberID
- (void)clearCurrentMemberID;
// 清除当前登录 MemberNick
- (void)clearCurrentMemberNick;
// 清除当前登录用户的消息总数（除朋友消息）
- (void)clearCurrentMessageCount;
//清楚聊天数目
- (void)clearCurentChatCount;
- (NSInteger)currentChatRecordCount;

- (void)clearUserInfo;

-(void) setCurrentChatRecordCount:(NSInteger)currentChatRecordCount;
- (void)clearCurrentAvatar ;

#pragma mark - 应用相关

- (void)setIsFirstIn:(NSString *)firstIn;
- (BOOL)isFirstIn;
- (void)setLoginType:(NSString *)loginType;
- (NSString *)loginType;
- (void)clearLoginType;


- (void)clearUserEmail;
- (void)clearPwd ;

@end

