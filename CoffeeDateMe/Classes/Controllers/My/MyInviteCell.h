//
//  MyInviteCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/27.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "SWTableViewCell.h"
#import "AvatarView.h"
@class MyInviteCell;

@protocol MyInviteCellDelegate <NSObject>

-(void)myInviteCell:(MyInviteCell *)myInviteCell didGotoUserDetail:(NSDictionary *)dic;

- (void)myInviteCellDidCancel:(MyInviteCell *)myInviteCell;

- (void)myInviteCellDidOpenDetail:(MyInviteCell *)myInviteCell;
@end

@interface MyInviteCell : SWTableViewCell<WTURLImageViewDelegate>

@property (strong, nonatomic)NSDictionary * inviteInfo;

@property (assign, nonatomic)id<MyInviteCellDelegate> adelegate;

@property (weak, nonatomic) IBOutlet AvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *operButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


- (void)initInviteCell;

@end
