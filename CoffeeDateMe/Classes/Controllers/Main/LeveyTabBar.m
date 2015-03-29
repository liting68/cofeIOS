//
//  LeveyTabBar.m
//  LeveyTabBarController  
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import "LeveyTabBar.h"
#import "BLMCommon.h"
#import "AppDelegate.h"
#import "LeftViewController.h"

@implementation LeveyTabBar
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
	{

		_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.top = 5;
        _backgroundView.height = 44;
        _backgroundView.image = TTImage(@"buttom_frame");
		[self addSubview:_backgroundView];
        
		self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
		UIButton *btn;
		//CGFloat width = 320.0f / [imageArray count];
        CGFloat width=K_UIMAINSCREEN_WIDTH/ ([imageArray count] -1);
//        CGFloat y = 20;
		for (int i = 0; i < [imageArray count]; i++)
		{
           // y = (i != 2) ? 7: 0 ;
			btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.showsTouchWhenHighlighted = YES;
			btn.tag = i + 4000;

            btn.frame=CGRectMake(width* (i -1),8,width,49);
            btn.userInteractionEnabled=YES;
			[btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Default"] forState:UIControlStateNormal];
			[btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
			[btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Seleted"] forState:UIControlStateSelected];
			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[self.buttons addObject:btn];
        
            if (i == 2) {
                
                btn.frame = CGRectMake((K_UIMAINSCREEN_WIDTH - 62 )/2, 0, 62, 57);
            }
            
            if(i != 0){
                
                [self addSubview:btn];
            }
            
            if (i == 1) {
                
                _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.right - 40, 0, 20, 20)];
                _unreadLabel.backgroundColor = [UIColor redColor];
                _unreadLabel.textColor = [UIColor whiteColor];
                _unreadLabel.textAlignment = NSTextAlignmentCenter;
                _unreadLabel.font = [UIFont systemFontOfSize:11];
                _unreadLabel.layer.cornerRadius = 10;
                _unreadLabel.clipsToBounds = YES;
                [_unreadLabel setHidden: YES];
                [self addSubview:_unreadLabel];
            
            }
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectSecond:) name:K_PUSH_MESSAGE_NOTIFICATION object:nil];
    }
    return self;
}

- (void)updateUnreadLabelWithNumber:(int)unreadCount {
    
    self.unreadCount = unreadCount;
    
    if (_unreadCount > 0) {
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        _unreadLabel.text = [NSString stringWithFormat:@"%d",_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
    
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    LeftViewController * leftVC = [appdelegate getLeftVC];
    
    [leftVC setNoReadMsg:unreadCount];
    
}

-(void)selectSecond:(NSNotification *)noti
{
    [self selectTabAtIndex:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_PUSH_DETAIL_NOTIFICATION object:[noti object]];
}
- (void)setBackgroundImage:(UIImage *)img
{
	[_backgroundView setImage:img];
}

- (void)tabBarButtonClicked:(id)sender
{
    UIButton *btn = sender;
    
    if ((btn.tag - 4000 == 3) || (btn.tag - 4000 == 1)) { //////
        
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        if (!memberID) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:K_GOTOLOGIN_NOTIFICATION object:nil];
            
            return;
            
        }
        
    }else if(btn.tag - 4000 == 2) {
        
        if ((self.currentIndex == 1) || (self.currentIndex == 3)) {
            
            [self selectTabAtIndex:0];
        
        }else {
            
           // [[NSNotificationCenter defaultCenter] postNotificationName:K_POST_ACTI object:nil];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarDidGotoHotActi:)]) {
                
                [self.delegate tabBarDidGotoHotActi:self];
            }
            
        }
        return;
    }
    
    [self selectTabAtIndex:btn.tag - 4000];
    
    /*
#if ComLimited
    if(![USERINFO_DEFAULT.signIn boolValue]){
        if(btn.tag == 0&& !willGo){
            UIAlertView *alv = [[UIAlertView alloc]initWithTitle:nil message:@"访问该页面需要先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
            alv.tag = 101;
            [alv show];
            return;
        }
        else if(btn.tag == 4 &&!willGo){
            UIAlertView *alv = [[UIAlertView alloc]initWithTitle:nil message:@"访问该页面需要先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
            alv.tag = 104;
            [alv show];
            return;
        }
    }
#if 0
    if(btn.tag == 3){
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
       MBProgressHUD *mHUD = [[MBProgressHUD alloc] initWithView:keywindow];
        [keywindow addSubview:mHUD];
        mHUD.labelText = @"该功能尚未开放，敬请期待";
        mHUD.mode = MBProgressHUDModeText;
        [mHUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [mHUD removeFromSuperview];
        }];
        return;
    }
#endif
#endif */
   
}

- (void)selectTabAtIndex:(NSInteger)index
{
    willGo = NO;
	
    for (int i = 0; i < [self.buttons count]; i++)
	{
		UIButton *b = [self.buttons objectAtIndex:i];
		b.selected = NO;
	}
	UIButton *btn = [self.buttons objectAtIndex:index];
	
    btn.selected = YES;
    
    self.currentIndex = index;
    
    if (self.currentIndex == 1 || self.currentIndex == 3) { ///
        
        UIButton * button = [self.buttons objectAtIndex:2];
        
        [button setImage:TTImage(@"first_tab") forState:UIControlStateNormal];
         [button setImage:TTImage(@"first_tab") forState:UIControlStateSelected];
        [button setImage:TTImage(@"first_tab") forState:UIControlStateHighlighted];
        
    }else {
        
          UIButton * button = [self.buttons objectAtIndex:2];
        [button setImage:TTImage(@"hot_acti") forState:UIControlStateNormal];
         [button setImage:TTImage(@"hot_acti") forState:UIControlStateHighlighted];
            [button setImage:TTImage(@"hot_acti") forState:UIControlStateSelected];
    }
    
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:index];
    }
}

- (void)removeTabAtIndex:(NSInteger)index
{
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
   
    // Re-index the buttons
     CGFloat width =K_UIMAINSCREEN_WIDTH/ [self.buttons count];
    for (UIButton *btn in self.buttons) 
    {
        if (btn.tag > index)
        {
            btn.tag --;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
}
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    // Re-index the buttons
    CGFloat width = K_UIMAINSCREEN_WIDTH / ([self.buttons count] + 1);
    for (UIButton *b in self.buttons) 
    {
        if (b.tag >= index)
        {
            b.tag ++;
        }
        b.frame = CGRectMake(width * b.tag, 0, width, self.frame.size.height);
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
    btn.frame = CGRectMake(width * index, 0, width, self.frame.size.height);
    [btn setImage:[dict objectForKey:@"Default"] forState:UIControlStateNormal];
    [btn setImage:[dict objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
    [btn setImage:[dict objectForKey:@"Seleted"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:1 animated:NO];
    if(alertView.tag == 101 &&buttonIndex == 1){
        willGo = YES;
        [self selectTabAtIndex:0];
    }else if(alertView.tag == 104 &&buttonIndex == 1){
        willGo = YES;
        [self selectTabAtIndex:4];
    }
}
@end
