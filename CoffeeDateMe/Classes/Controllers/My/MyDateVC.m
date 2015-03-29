//
//  MyDateVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/11.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "MyDateVC.h"

@interface MyDateVC ()

@end

@implementation MyDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self initBackButton];
    [self forNavBeNoTransparent];
    [self initSwitchVC];
}

#pragma mark - Memory Mangae
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
