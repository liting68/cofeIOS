//
//  UserCenterVC.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/9.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "InfoCell.h"
#import "PostDateView.h"
#import "ModifyInfoVC.h"
#import "LoginViewController.h"

@interface UserCenterVC : BaseViewController<UITextFieldDelegate,UITextViewDelegate,InfoCellDelegate>
{
    BOOL datePickerSwitch;
}
@property (strong, nonatomic)PostDateView * postDateView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic)BOOL isMySelf;//是不是自己

@property (strong, nonatomic) NSString * otherID;//别人的ID
@property (strong, nonatomic) NSString * nickName;

@property (assign,nonatomic) BOOL isRoot;///从根部过来的

@property (strong,nonatomic)NSArray * keyArray;//属性名称
@property (strong,nonatomic)NSArray * valArray;//属性字段


@property (assign, nonatomic)BOOL isEdit;

@property (weak, nonatomic) IBOutlet UIButton *mailButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

//////////////选择的约会时间
@property (strong, nonatomic) NSString * dateTime;


@property (strong, nonatomic) UIView * selectDayView;
@property (strong, nonatomic) UIDatePicker * birthDatePicker;

@property (strong, nonatomic) NSDictionary * selectedVenues;

///////////所有标题，提供选择
@property (strong, nonatomic) NSArray * allTitles;

///////////星座
@property (strong, nonatomic) NSArray * allXZArray;

//////////////loginVC 判断是是刚登陆 还是第二次进去/////////////
@property (strong, nonatomic)LoginViewController *loginVC;
@property (assign, nonatomic) BOOL isFromLogin;
////////////

@property (assign, nonatomic) int relation_status;

- (void)updatePhotoLibrary:(NSArray * )photo;
//////////


@end
