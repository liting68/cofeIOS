//
//  GenerateParams.m
//  SecondHandBookAPP
//
//  Created by 波罗密 on 14-9-27.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "GenerateParams.h"
#import "Response.h"

@implementation GenerateParams

+ (NSMutableDictionary *)commonParamsWithData:(NSMutableDictionary *)paramsDic {
    
    return paramsDic;
}


#pragma mark - Requst

+ (NSString *)getRequestURLWithSubURL:(NSString *)subURL {
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",hostUrl,subURL];
    
    return urlStr;
}


@end
