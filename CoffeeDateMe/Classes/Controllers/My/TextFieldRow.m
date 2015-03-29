//
//  TextFieldRow.m
//  ModelAPP
//
//  Created by 波罗密 on 14-7-23.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "TextFieldRow.h"
#import "UIColor+expanded.h"

@implementation TextFieldRow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置颜色，仅填充4条边
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"0xC99065"].CGColor);
    //设置线宽为1
    CGContextSetLineWidth(ctx, 1.0);
    //设置长方形4个顶点
    CGPoint poins[] = {CGPointMake(0, 0),CGPointMake(self.bounds.size.width, 0),CGPointMake(self.bounds.size.width, self.bounds.size.height),CGPointMake(0, self.bounds.size.height)};
    CGContextAddLines(ctx,poins,4);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    
}


@end
