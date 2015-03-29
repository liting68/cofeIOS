//
//  SLineView.m
//  ModelAPP
//
//  Created by 波罗密 on 14-9-9.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "SLineView.h"

@implementation SLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
  //  CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"0xbfbebe"].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.658 alpha:1.000].CGColor);
    //设置线宽为1
    CGContextSetLineWidth(ctx, 1.0);

    float height = self.bounds.size.height;
    
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, 0, height);
    CGContextStrokePath(ctx);

}

@end
