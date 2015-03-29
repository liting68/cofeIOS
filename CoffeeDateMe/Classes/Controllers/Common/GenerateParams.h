//
//  GenerateParams.h
//  SecondHandBookAPP
//
//  Created by 波罗密 on 14-9-27.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenerateParams : NSObject

+ (NSMutableDictionary *)commonParamsWithData:(NSMutableDictionary *)paramsDic;

#pragma mark - Requst

+ (NSString *)getRequestURLWithSubURL:(NSString *)subURL;



@end
