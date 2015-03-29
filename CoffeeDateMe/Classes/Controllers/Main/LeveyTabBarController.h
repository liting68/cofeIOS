//
//  LeveyTabBarControllerViewController.h
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBar.h"
#import "ChatListViewController.h"
#import "EaseMob.h"

@class UITabBarController;
@protocol LeveyTabBarControllerDelegate;

@interface LeveyTabBarController : UIViewController <LeveyTabBarDelegate,UIAlertViewDelegate,IChatManagerDelegate>
{
	LeveyTabBar *_tabBar;
	UIView      *_containerView;
	UIView		*_transitionView;
	__weak id<LeveyTabBarControllerDelegate> _delegate;
	NSMutableArray *_viewControllers;
	NSUInteger _selectedIndex;
    NSUInteger _lastSelectedIndex;
    NSUInteger mySelectIndex;
	
	BOOL _tabBarTransparent;
	BOOL _tabBarHidden;
    int isReload[5];
}
@property (nonatomic, assign) BOOL isAtButtom;
@property(nonatomic, assign)int oldControllerNum;
@property(nonatomic, copy) NSMutableArray *viewControllers;

@property(nonatomic, readonly) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;
@property(nonatomic)NSUInteger lastSelectedIndex;

// Apple is readonly
@property (nonatomic, readonly) LeveyTabBar *tabBar;
@property(nonatomic,weak) id<LeveyTabBarControllerDelegate> delegate;
@property(nonatomic, strong) UIView* containerView;
@property(nonatomic , strong) UIView* transitionView;

@property(nonatomic, strong)ChatListViewController * chatListVC;


@property (strong, nonatomic)NSDate *lastPlaySoundDate;

// Default is NO, if set to YES, content will under tabbar
@property (nonatomic) BOOL tabBarTransparent;
@property (nonatomic) BOOL tabBarHidden;

- (void)upateNoReadLabelMethod;

- (void)goAtIndex:(int)index;

- (void)curSelectedGoFirst;

///布局
- (void)layoutLeveyTabBarViewControllersAtButtom:(NSArray *)vcs imageArray:(NSArray *)arr;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;

- (void)pushController:(UIViewController *)controller;

- (void)popController;

- (id)initWithViewControllersAtButtom:(NSArray *)vcs imageArray:(NSArray *)arr;

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
-(void)hideTabBar;
// Remove the viewcontroller at index of viewControllers.
- (void)removeViewControllerAtIndex:(NSUInteger)index;

// Insert an viewcontroller at index of viewControllers.
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

+ (LeveyTabBarController *)leveyTabBarControllerWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;

- (void)gotoGuide;

@end


@protocol LeveyTabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(LeveyTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(LeveyTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController isReload:(BOOL)theIsreload;

@end

@interface UIViewController (LeveyTabBarControllerSupport)
@property(nonatomic, retain, readonly) LeveyTabBarController *leveyTabBarController;
@end

