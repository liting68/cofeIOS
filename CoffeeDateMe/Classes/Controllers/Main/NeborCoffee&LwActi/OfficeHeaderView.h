//
//  OfficeHeaderView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineView.h"
#import "WTURLImageView.h"
#import "HTCopyableLabel.h"
#import "CustomLabel.h"

@protocol OfficeHeaderViewDelegate <NSObject>

- (void)officeHeaderViewDidGotoMapView;
 
- (void)officeHeaderViewClickHeaderViewWithIndex:(int)index;

- (void)officeHeaderViewClickBannerViewWithIndex:(int) index;

- (void)officeHeaderViewDidUpdateSubViewSuccess;

@end

@interface OfficeHeaderView : UIView<WTURLImageViewDelegate,UIScrollViewDelegate,CustomLabelDelegate>

@property (weak, nonatomic) IBOutlet HTCopyableLabel *activityName;//活动名称
@property (weak, nonatomic) IBOutlet UIScrollView *activityImgs;//图片展示scrollView

@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet CustomLabel *activityAddr;

@property (weak, nonatomic) IBOutlet UILabel *activityIntro;
@property (weak, nonatomic) IBOutlet UIButton *gotoMapButton;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIImageView *locationView;

@property (weak, nonatomic) IBOutlet UIImageView *timeView;


@property (assign, nonatomic) id<OfficeHeaderViewDelegate> delegate;

- (void)layoutWithActivityDic:(NSDictionary *)activityDic;

@end
