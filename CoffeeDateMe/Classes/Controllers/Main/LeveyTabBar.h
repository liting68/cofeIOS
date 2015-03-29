//
//  LeveyTabBar.h
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeveyTabBarDelegate;

@interface LeveyTabBar : UIView<UIAlertViewDelegate>
{
	UIImageView *_backgroundView;
	id<LeveyTabBarDelegate> _delegate;
	NSMutableArray *_buttons;
    BOOL willGo;    //去登陆
}

@property (nonatomic, assign) int currentIndex;

@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, retain) id<LeveyTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, assign) BOOL isAtButtom;

/////更新badge
@property (nonatomic, strong)  UILabel * unreadLabel;//未读数量
@property (nonatomic, assign) int unreadCount;


- (void)updateUnreadLabelWithNumber:(int)unreadCount;
////////////

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
- (void)setBackgroundImage:(UIImage *)img;

@end
@protocol LeveyTabBarDelegate<NSObject>
@optional
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index;
- (void)tabBarDidGotoHotActi:(LeveyTabBar *)tabBar;
@end
