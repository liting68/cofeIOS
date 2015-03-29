//
//  Message.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "Message.h"

@implementation Message

- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults]currentMemberID];
    
    int  postID = [[dict valueForKey:@"from_user_id"] intValue];
    
    if ([memberID intValue] == postID) {//自己
        
        self.type = 0;
    
    }else {
        
        self.type = 1;
    }

    self.icon = dict[@"from_head_photo"];
    self.time = dict[@"created"];
    self.content = dict[@"content"];

}



@end
