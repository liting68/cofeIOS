//
//  CafeDetailVC.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-1.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopHeaderCell.h"
#import "MenuView.h"

//////////////咖啡详情

@interface CafeDetailVC : BaseViewController<WTURLImageViewDelegate,ShopHeaderCellDelegate,MenuViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSString * cafeName;

@property (nonatomic, strong) NSString * cafeID;

////咖啡店信息
@property (nonatomic, strong) NSDictionary * cafeDetailInfo;

@property (nonatomic,assign) BOOL isFirst;///是不是第一次获取

///////////当前选中的列别  0.店铺详情 1.评价 2.推荐菜品
@property (nonatomic,assign) int selectIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, strong)UIView * bottomView;

@end
