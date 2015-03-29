//
//  BmkPaopaoView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-11-19.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BmkPaopaoView.h"
#import "HTCopyableLabel.h"

@implementation BmkPaopaoView

- (void)layoutWithTitle:(NSString *)title {
    
    _htCopyLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, 7, 258, 35)];
    _htCopyLabel.editable = NO;
    _htCopyLabel.scrollsToTop = YES;
    _htCopyLabel.backgroundColor = [UIColor clearColor];
    _htCopyLabel.textAlignment = NSTextAlignmentCenter;
  //  _htCopyLabel.numberOfLines = 0;
    _htCopyLabel.textColor = [UIColor colorWithWhite:0.318 alpha:1.000];
    _htCopyLabel.font = [UIFont systemFontOfSize:15];
    _htCopyLabel.text = title;
     _htCopyLabel.textAlignment =  NSTextAlignmentCenter;
  //  [_htCopyLabel sizeToFit];
    _htCopyLabel.width = 258;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 278, _htCopyLabel.height + 20)];
    _imageView.userInteractionEnabled = YES;
    _imageView.image = [TTImage(@"paopao") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 40, 0) resizingMode:UIImageResizingModeStretch];
    [_imageView addSubview:_htCopyLabel];
    
    [self addSubview:_imageView];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.height = _imageView.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
