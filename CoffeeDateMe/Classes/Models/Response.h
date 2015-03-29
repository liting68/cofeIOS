//
//  Response.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-28.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (assign, nonatomic) int err;
@property (strong, nonatomic) NSString  * errMsg;
@property (strong, nonatomic) id result;

@end
