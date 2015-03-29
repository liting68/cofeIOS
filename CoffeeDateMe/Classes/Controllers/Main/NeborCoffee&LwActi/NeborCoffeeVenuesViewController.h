//
//  NeborCoffeeVenuesViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "CoffeeVenuesCell.h"

@protocol  NeborCoffeeSelectedDelegate <NSObject>

- (void)venuesDidSelectedSuccess:(NSDictionary *)venues;

@end

@interface NeborCoffeeVenuesViewController : BaseViewController

@property (assign, nonatomic) id<NeborCoffeeSelectedDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign,nonatomic) int type;//0 附近的咖啡店, 1.关键字  2.商圈   3.地区  4.热门活动
@property (strong, nonatomic) NSString * titleName;//他人活动使用
///////
@property (weak, nonatomic) IBOutlet UIImageView *postFlagView;

@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (nonatomic, assign) int officeActivityCount;
@property (nonatomic, assign) int personActivityCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerContraint;

@property (nonatomic, strong) NSString * userID;

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, strong) NSString * keyName;

@property (nonatomic, strong) NSString * provinceID;
@property (nonatomic, strong) NSString * cityID;
@property (nonatomic, strong) NSString * townID;
@property (nonatomic, strong) NSString * circleID;


@property (nonatomic, assign) int isPresent;


@end
