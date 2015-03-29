//
//  PicPlaceHolderView.h
//  ModelAPP
//
//  Created by 波罗密 on 14-8-7.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicPlaceHolderViewDelegate <NSObject>

- (void)picPlaceHlderViewDidClickAddAction;

@end


@interface PicPlaceHolderView : UIView

@property (assign, nonatomic)id<PicPlaceHolderViewDelegate> delegate;

@end
