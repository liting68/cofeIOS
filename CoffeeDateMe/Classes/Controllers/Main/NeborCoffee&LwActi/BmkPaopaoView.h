//
//  BmkPaopaoView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-11-19.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCopyableLabel.h"

@interface BmkPaopaoView : UIView

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic,strong) UITextView* htCopyLabel;

- (void)layoutWithTitle:(NSString *)title;

@end
