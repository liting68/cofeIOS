//
//  VenuesSelectVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/14.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "VenuesSelectVC.h"

@interface VenuesSelectVC ()<AddrSelectDelegate,UISearchBarDelegate>
{
    AddrSelectView * addrSelectView;
}
@end

@implementation VenuesSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
     [self forNavBeNoTransparent];
    [self initLeftBarButtonItem:nil title:@"取消" action:@selector(cancelAction)];
    [self initTitleViewWithTitleString:@"筛选附近的咖啡厅"];
    
    self.searchBar.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [self hideTabBar];
}

#pragma mark - Actions

- (void)cancelAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showAllAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(veneusSelectVC:isAll:didSelectWith:bussiness:bus:title:)]) {
        
        [self.delegate veneusSelectVC:self isAll:YES didSelectWith:nil bussiness:nil bus:nil title:nil];
        
        [self popController];
    }
}

- (IBAction)cityAction:(id)sender {//区域
    
    NSArray * bussinessArray = [AppUtil readDataWithPlistName:@"shop_area.plist" cat:[NSArray array]];
    
    NSLog(@"%@",bussinessArray);
    
    if (!addrSelectView) {
        
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddrSelectView" owner:nil options:nil];
        addrSelectView  = [nibView objectAtIndex:0];
        addrSelectView.delegate = self;
        
        addrSelectView.frame = CGRectMake(0,K_UIMAINSCREEN_HEIGHT , K_UIMAINSCREEN_WIDTH, addrSelectView.height);
        [self.view addSubview:addrSelectView];
        
    }
    addrSelectView.level = 3;//
    addrSelectView.level1_key = @"city";
    addrSelectView.level2_key = @"town";
    addrSelectView.type = 1;
    
    [addrSelectView initAddrSelectViewWithData:bussinessArray level:3];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (addrSelectView.top == K_UIMAINSCREEN_HEIGHT) {
            
            addrSelectView.top = K_UIMAINSCREEN_HEIGHT - addrSelectView.height;
            
        }else {
            
            addrSelectView.top = K_UIMAINSCREEN_HEIGHT;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)businessAction:(id)sender {//商圈
    
    NSArray * bussinessArray = [AppUtil readDataWithPlistName:@"business_area.plist" cat:[NSArray array]];
   
    if (!addrSelectView) {
        
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddrSelectView" owner:nil options:nil];
        addrSelectView  = [nibView objectAtIndex:0];
        addrSelectView.delegate = self;
        
        addrSelectView.frame = CGRectMake(0,K_UIMAINSCREEN_HEIGHT , K_UIMAINSCREEN_WIDTH, addrSelectView.height);
        [self.view addSubview:addrSelectView];

    }
    addrSelectView.type = 0;
    addrSelectView.level = 3;
    addrSelectView.level1_key = @"city";
    addrSelectView.level2_key = @"circle";
    
    [addrSelectView initAddrSelectViewWithData:bussinessArray level:3];
    
    [UIView animateWithDuration:0.3 animations:^{
       
        if (addrSelectView.top == K_UIMAINSCREEN_HEIGHT) {
            
            addrSelectView.top = K_UIMAINSCREEN_HEIGHT - addrSelectView.height;
        
        }else {
            
            addrSelectView.top = K_UIMAINSCREEN_HEIGHT;
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
}
- (IBAction)busAction:(id)sender {//地铁(先不需要)
    
}

#pragma mark -

- (void)addrSelectDidSelectProvinceID:(NSString *)provinceID cityID:(NSString *)cityID townID:(NSString *)townID circleID:(NSString *)circleID addrString:(NSString *)addrString {
    
    if (circleID) {
        
         [self.businessButton setTitle:addrString forState:UIControlStateNormal];
        
    }else{
        
        [self.cityButton setTitle:addrString forState:UIControlStateNormal];
    }
    
    [self.delegate veneusSelectVC:self didSelectWithProvinceID:provinceID cityID:cityID townID:townID circleID:circleID title:addrString];
    
    [self popController];

}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString * keyName = searchBar.text;
    
    if ([AppUtil isNull:keyName]) {
        
        [AppUtil HUDWithStr:@"请输入搜索关键字" View:self.view];
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(veneusSelectVC:didSearchWithKeyName:)]) {
        
        [self.delegate veneusSelectVC:self didSearchWithKeyName:keyName];
    }
    
    [self popController];
     
}

#pragma mark - 回收键盘

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - Memory Manage

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
