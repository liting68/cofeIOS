//
//  PhotoHeaderView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-3.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicPlaceHolderView.h"
#import "WTURLImageView.h"

@protocol PhotoheaderViewDelegate <NSObject>

- (void)photoHeaderViewDidClickPhotoActionWithIndex:(int)index type:(int)type;///类型
- (void)photoHeaderViewDidClickAddAction;//添加事件

- (void)photoHeaderViewDidClickDeleteActionIndex:(int)index;

- (void)photoHeaderDidDoubleClickAtIndex:(int)index;

@end

@interface PhotoHeaderView : UIView<WTURLImageViewDelegate,PicPlaceHolderViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic)PicPlaceHolderView * picPlaceHolderView;

@property (assign, nonatomic) int type; //0.表示编辑状态 1.表示查看状态

@property (strong, nonatomic) id<PhotoheaderViewDelegate> delegate;

@property (assign, nonatomic) int headIndex;

@property (strong, nonatomic) UIImageView * selectedView;

@property (assign,nonatomic) BOOL isShowClose;

@property (strong, nonatomic) NSArray * photos;

- (void)layoutWithType:(int)type Photos:(NSArray *)photos;
- (void)layoutWithType:(int)type Photos:(NSArray *)photos headIndex:(int)index ;

@end
