//
//  HeaderCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/9.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeaderCell;

@protocol HeaderCellDelegate <NSObject>

//0 相册  1. 约会
- (void)headerCell:(HeaderCell *)headerCell didClickAction:(int)index;

@end

@interface HeaderCell : UITableViewCell<WTURLImageViewDelegate>

@property (assign,nonatomic) id<HeaderCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet WTURLImageView *avatarBigView;
@property (weak, nonatomic) IBOutlet AvatarView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *locateView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

////////////////////
@property (weak, nonatomic) IBOutlet UIImageView *personIcon;
@property (weak, nonatomic) IBOutlet UIButton *personInfoButton;
////////////
@property (weak, nonatomic) IBOutlet UIImageView *photoIcon;
@property (weak, nonatomic) IBOutlet UIButton *photoButotn;
//////////////////
@property (weak, nonatomic) IBOutlet UIImageView *coffeeIcon;
@property (weak, nonatomic) IBOutlet UIButton *coffeeButton;

/////////////新的
@property (weak, nonatomic) IBOutlet UIImageView *personInfo_my;
@property (weak, nonatomic) IBOutlet UIButton *personInfo_button_my;

@property (weak, nonatomic) IBOutlet UIImageView *photo_my;
@property (weak, nonatomic) IBOutlet UIButton *photo_butotn_my;

- (void)setCommentNumber:(int)number;


/////////////
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

- (void)initSubViewWithIsMyself:(BOOL)mySelf;

@end
