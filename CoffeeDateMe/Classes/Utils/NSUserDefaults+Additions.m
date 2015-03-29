//
//  NSUserDefaults+Additions.m
//  HKSportMap
//
//  Created by AsOne on 13-2-1.
//  Copyright (c) 2013年 AsOne. All rights reserved.
//

#import "NSUserDefaults+Additions.h"

NSString *const DefaultsKeyCurrentLocation = @"currentLocation";
NSString *const DefaultsKeyCurrentCity = @"currentCity";
NSString *const DefaultsKeyCurrentCityName = @"currentCityName";
NSString *const DefaultsKeyCurrentUserEmail = @"currentUserEmail";
NSString *const DefaultsKeyCurrentUserPsw = @"currentUserPsw";
NSString *const DefaultsKeyCurrentMemberID = @"currentMemberID";
NSString *const DefaultsKeyCurrentVisitorID = @"currentVisitorID";
NSString *const DefaultsKeyCurrentMemberNick = @"currentMemberNick";
NSString *const DefaultsKeyCurrentMessageCount = @"currentMessageCount";
NSString *const DefaultsKeyCurrentChatRecordCount = @"currentChatRecordCount";
NSString * const DefaultsKeyCurrentAvatar = @"currentAvatar";

NSString * const DefaultsKeyISFirstLogin = @"isFirstLogin";
NSString * const DefatltsKeyLoginType = @"LoginType"; // qq  sina universal

NSString * const DefaultsKeyUserInfo = @"DefaultsKeyUserInfo";

@implementation NSUserDefaults (Additions)

- (void)setUserInfo:(NSDictionary *)userInfo {
    
    [self setObject:userInfo forKey:DefaultsKeyUserInfo];
    [self synchronize];
}

- (NSDictionary *)userInfo {
    return [self valueForKey:DefaultsKeyUserInfo];
}

- (void)clearUserInfo {
    
    [self removeObjectForKey:DefaultsKeyUserInfo];
    [self synchronize];
}
/****************************应用信息相关************************************/
- (void)setIsFirstIn:(NSString *)firstIn {
    
    [self setObject:firstIn forKey:DefaultsKeyISFirstLogin];
    [self synchronize];
}

- (BOOL)isFirstIn {
    
    NSString * isFirstIn = [self valueForKey:DefaultsKeyISFirstLogin];
    
    if (isFirstIn) {
        return YES;
    }
    return NO;
}

- (void)setLoginType:(NSString *)loginType {
    
    [self setObject:loginType forKey:DefatltsKeyLoginType];
    [self synchronize];
}

- (NSString *)loginType {
    
   return  [self valueForKey:DefatltsKeyLoginType];

}

- (void)clearLoginType {
    
    [self removeObjectForKey:DefatltsKeyLoginType];
    [self synchronize];
    
}


/*****************************当前位置相关**********************************/

-(void)setCurrentlocation:(NSDictionary *)currentLocation{
    [self setObject:currentLocation forKey:DefaultsKeyCurrentLocation];
    [self synchronize];
}

-(NSString*)currentlocation{
    return [self valueForKey:DefaultsKeyCurrentLocation];
}

- (void)clearCurrentLocation{
    
    [self removeObjectForKey:DefaultsKeyCurrentLocation];
    [self synchronize];
}


-(void)setCurrentCity:(NSString *)currentCity{
    [self setObject:currentCity forKey:DefaultsKeyCurrentCity];
    [self synchronize];
}

-(NSString*)currentCity{
    return [self stringForKey:DefaultsKeyCurrentCity];
}

- (void)setCurrentCityName:(NSString *)currentCityName{
    
    [self setObject:currentCityName forKey:DefaultsKeyCurrentCityName];
    [self synchronize];
}

- (NSString*)currentCityName{
    
    return [self valueForKey:DefaultsKeyCurrentCityName];
}


/*****************************当前用户相关**********************************/

-(void)setCurrentMemberAvatar:(NSString *)currentMemberAvatar{
    [self setObject:currentMemberAvatar forKey:DefaultsKeyCurrentAvatar];
    [self synchronize];
}
-(NSString*)currentMemberAvatar{
    return [self stringForKey:DefaultsKeyCurrentAvatar];
}

- (void)clearCurrentAvatar {
    [self removeObjectForKey:DefaultsKeyCurrentAvatar];
    [self synchronize];
    
}

- (void)clearUserEmail {
    
    [self removeObjectForKey:DefaultsKeyCurrentUserEmail];
    [self synchronize];
}

-(void)setCurrentUserEmail:(NSString *)currentUserEmail{
    [self setObject:currentUserEmail forKey:DefaultsKeyCurrentUserEmail];
    [self synchronize];
}
-(NSString*)currentUserEmail{
    return [self stringForKey:DefaultsKeyCurrentUserEmail];
}

- (void)clearPwd {
    [self removeObjectForKey:DefaultsKeyCurrentUserPsw];
    [self synchronize];
    
}

-(void)setCurrentUserPsw:(NSString *)currentUserPsw{
    [self setObject:currentUserPsw forKey:DefaultsKeyCurrentUserPsw];
    [self synchronize];
}
-(NSString*)currentUserPsw{
    return [self stringForKey:DefaultsKeyCurrentUserPsw];
}

- (NSNumber*)currentMemberID{

    return [self valueForKey:DefaultsKeyCurrentMemberID];
}

- (void)setCurrentMemberID:(NSNumber *)currentMemberID{
    
    [self setObject:currentMemberID forKey:DefaultsKeyCurrentMemberID];
    [self synchronize];
}

- (void)clearCurrentMemberID{
    
    [self removeObjectForKey:DefaultsKeyCurrentMemberID];
    [self synchronize];
}
//visitorID
- (NSString*)visitorID{
    return [self valueForKey:DefaultsKeyCurrentVisitorID];
}
- (void)setVisitorID:(NSString *)visitorID{
    [self setObject:visitorID forKey:DefaultsKeyCurrentVisitorID];
    [self synchronize];
}
- (void)clearVisitorID{
    [self removeObjectForKey:DefaultsKeyCurrentVisitorID];
    [self synchronize];
}
///
- (NSNumber*)currentMemberNick{
    
    return [self valueForKey:DefaultsKeyCurrentMemberNick];
}

- (void)setCurrentMemberNick:(NSString *)currentMemberNick{
    
    [self setObject:currentMemberNick forKey:DefaultsKeyCurrentMemberNick];
    [self synchronize];
}

- (void)clearCurrentMemberNick{
    
    [self removeObjectForKey:DefaultsKeyCurrentMemberNick];
    [self synchronize];
}


- (void)setCurrentMessageCount:(NSInteger)currentMessageCount{
    
    [self setInteger:currentMessageCount forKey:DefaultsKeyCurrentMessageCount];
    [self synchronize];
}

- (NSInteger)currentMessageCount{
    
    return [self integerForKey:DefaultsKeyCurrentMessageCount];
}

- (void)clearCurrentMessageCount{
    
    [self removeObjectForKey:DefaultsKeyCurrentMessageCount];
    [self synchronize];
}

- (void)clearCurentChatCount{
    
    [self removeObjectForKey:DefaultsKeyCurrentChatRecordCount];
    [self synchronize];
}

- (NSInteger)currentChatRecordCount{
   
    return [self integerForKey:DefaultsKeyCurrentChatRecordCount];
    
}

-(void) setCurrentChatRecordCount:(NSInteger)currentChatRecordCount {
    
    [self setInteger:currentChatRecordCount forKey:DefaultsKeyCurrentChatRecordCount];
    [self synchronize];
    
}
@end

