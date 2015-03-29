//
//  MainHeaderView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-28.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTURLImageView.h"

@protocol MainHeaderViewDelegate <NSObject>

// 0.想喝咖啡 1.发起的留言活动 2.附近的咖啡店 4.热门活动
- (void)mainHeaderViewDidClickAction:(int)type;

@end

@interface MainHeaderView : UIView<WTURLImageViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *bannerView;

@property (assign, nonatomic) id<MainHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic)NSArray * bannersArr;

- (void)layoutWithBanners:(NSArray *)banners;

@end
