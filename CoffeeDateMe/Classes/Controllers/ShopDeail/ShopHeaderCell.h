//
//  ShopHeaderCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/3.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopHeaderCell;

@protocol ShopHeaderCellDelegate <NSObject>

- (void)shopHeaderCell:(ShopHeaderCell *)shopHeaderCell clickButtonsWithCategory:(int)category;

- (void)shopHeaderCell:(ShopHeaderCell *)shopHeaderCell clickShopPicsAtIndex:(int)index;

@end

@interface ShopHeaderCell : UITableViewCell<UIScrollViewDelegate,WTURLImageViewDelegate>

@property (assign, nonatomic) id<ShopHeaderCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *shopPicScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *shopDetailInfo;

@property (weak, nonatomic) IBOutlet UIButton *commonButton;

@property (weak, nonatomic) IBOutlet UIButton *recommendButton;

@property (weak, nonatomic) IBOutlet UIImageView *selectView;

@property (assign,nonatomic) int currentSelected;

- (void)layoutWithDic:(NSDictionary *)dic;

@end
