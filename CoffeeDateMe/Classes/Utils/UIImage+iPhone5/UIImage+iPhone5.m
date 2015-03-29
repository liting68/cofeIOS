//
//  UIImage+iPhone5.m
//  Snooke
//
//  Created by jimcky lin on 13-4-16.
//  Copyright (c) 2013年 AsOne. All rights reserved.
//

#import "UIImage+iPhone5.h"

@implementation UIImage(iPhone5)

+(UIImage*)imageNamed:(NSString *)name withType:(NSString*)type{

    if ([type length] == 0 || type == nil) {
        type = @"png";
    }
    
    if (DEVICE_IS_IPHONE5) {
        name = [NSString stringWithFormat:@"%@-ip5.%@",name,type];
    }else{
        name = [NSString stringWithFormat:@"%@.%@",name,type];;
    }
    //LogDetail(@"name:%@ type:%@",name,type);
    
    return [self imageNamed:name];
}

@end
