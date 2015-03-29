//
//  AddrSelectView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/24.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddrSelectDelegate <NSObject>

- (void)addrSelectDidSelectProvinceID:(NSString *)provinceID cityID:(NSString *)cityID townID:(NSString *)townID circleID:(NSString *)circleID addrString:(NSString *)addrString;

- (void)addrSelectDidSelectTitle:(NSString *)title;

@end

@interface AddrSelectView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *provinces;
}

@property (assign,nonatomic) id<AddrSelectDelegate> delegate;

@property (assign, nonatomic) int level;

@property (assign, nonatomic) int type;
//0.business 1.区域 2.籍贯 4.选择标题  5.星座选择 6.年龄选择

@property (assign, nonatomic) int level1;
@property (strong, nonatomic) NSString * level1_key;///
@property (assign, nonatomic) int level2;
@property (strong, nonatomic) NSString * level2_key;///
@property (assign, nonatomic) int level3;

//locatePicker
@property (weak, nonatomic) IBOutlet UIPickerView *locatePicker;

- (void)initAddrSelectViewWithData:(NSArray *)data level:(int)level;

@end