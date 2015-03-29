//
//  PostDateView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/24.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarView.h"
@class PostDateView;

@protocol PostDateViewDelegate <NSObject>

- (void)postDateViewDidSelectTime:(PostDateView *)postDateView;

- (void)postDateViewDidSelectAddress:(PostDateView *)postDateView;

- (void)postDateViewDidSelectDidPost:(NSDictionary *)dic;

- (void)postDateViewDidAcceptWithDic:(NSDictionary *)dic;

- (void)postDateViewDidRejectWithDic:(NSDictionary *)dic;

- (void)postDateViewDidSelectTitle;

- (void)postDateViewDidCall;


@end


@interface PostDateView : UIView

@property (nonatomic, assign)id<PostDateViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *inviteNickNameLabel;//邀请人的昵称

@property (weak, nonatomic) IBOutlet UILabel *inviteTitle;

@property (weak, nonatomic) IBOutlet UIButton *inviteTimeButton;

@property (weak, nonatomic) IBOutlet UIButton *inviteAddressButton;
@property (weak, nonatomic) IBOutlet UITextField *telField;

@property (weak, nonatomic) IBOutlet AvatarView *beInviteAvatar;//被邀请人头像
@property (weak, nonatomic) IBOutlet UILabel *beInviteNickName;
@property (weak, nonatomic) IBOutlet AvatarView *inviteAvatar;//邀请人头像
@property (weak, nonatomic) IBOutlet UILabel *inviteNickName;
/////////////////
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *acctptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
////////////////

///邀请状态
@property (weak, nonatomic) IBOutlet UILabel *inviteState;


@property (strong, nonatomic) NSDictionary * postDateDic;
@property (assign, nonatomic)BOOL isShow;

@end
