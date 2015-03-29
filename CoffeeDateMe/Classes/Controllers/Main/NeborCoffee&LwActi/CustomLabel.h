//
//  CustomLabel.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/3/1.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomLabel;

@protocol CustomLabelDelegate <NSObject>

- (void)customLabelDidTapAction:(CustomLabel *)customLabel;

- (void)customLabelDidLongPressAction:(CustomLabel *)customLabel;

@end

@interface CustomLabel : UILabel<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer * tapGestureGeg;
    UILongPressGestureRecognizer * longPressReg;
}
@property (assign, nonatomic)id<CustomLabelDelegate> delegate;




- (void) layoutMyAllViews;

@end
