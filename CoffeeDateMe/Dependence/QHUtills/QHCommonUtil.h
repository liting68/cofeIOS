//
//  QHCommonUtil.h
//  NewsFourApp
//
//  Created by chen on 14/8/9.
//  Copyright (c) 2014年 chen. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Foundation/Foundation.h>
#import "QHConfiguredObj.h"

@interface QHCommonUtil : NSObject

//将view转为image
+ (UIImage *)getImageFromView:(UIView *)view;

//获取随机颜色color
+ (UIColor *)getRandomColor;

//根据比例（0...1）在min和max中取值
+ (float)lerp:(float)percent min:(float)nMin max:(float)nMax;

+ (void)unzipFileToDocument:(NSString *)fileName;

+ (void)moveFileToDocument:(NSString *)fileName type:(NSString *)fileType;

+ (UIImage *)imageNamed:(NSString *)name;

@end
