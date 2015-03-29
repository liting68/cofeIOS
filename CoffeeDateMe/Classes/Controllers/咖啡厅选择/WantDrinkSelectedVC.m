//
//  WantDrinkSelectedVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/27.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "WantDrinkSelectedVC.h"

@interface WantDrinkSelectedVC ()

@end

@implementation WantDrinkSelectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initBackButton];
    [self initTitleViewWithTitleString:@"筛选附近爱喝咖啡的人"];
    
   // [self initWithType:self.type];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self hideTabBar];
}

- (void)initWithType:(int)type {
    
    self.type = type;
    
    if (self.type == 0) {
        
        [self.nanSelectedIcon setHidden:YES];
        [self.nvSeleectIcon setHidden:YES];
        [self.tjSelectedIcon setHidden:YES];
        
    }else if (self.type == 1) {//女
        
        [self.nanSelectedIcon setHidden:YES];
        [self.nvSeleectIcon setHidden:NO];
        [self.tjSelectedIcon setHidden:YES];
    
    }else if (self.type == 2) {
        
        [self.nanSelectedIcon setHidden:NO];
        [self.nvSeleectIcon setHidden:YES];
        [self.tjSelectedIcon setHidden:YES];
    
    }else {
        
        
        [self.nanSelectedIcon setHidden:YES];
        [self.nvSeleectIcon setHidden:YES];
        [self.tjSelectedIcon setHidden:NO];
        
    }
    
}

#pragma mark - Actions

- (IBAction)showAllAction:(id)sender {
    
   // if (self.type == 0) {
    
      //  return;
   // }
    
    [self initWithType:0];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wantDrinkSelectedVC:didSelectedType:)]) {
        
        [self.delegate wantDrinkSelectedVC:self didSelectedType:0];
    }
    
    [self popController];
    
}

- (IBAction)lookBoyAction:(id)sender {
    
    //if (self.type == 2) {
        
      //  return;
   // }
    [self initWithType:2];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wantDrinkSelectedVC:didSelectedType:)]) {
        
        [self.delegate wantDrinkSelectedVC:self didSelectedType:2];
    }
    
    [self popController];
    
}

- (IBAction)lookGirlActino:(id)sender {
    
    
   // if (self.type == 1) {
        
       // return;
  //  }
    [self initWithType:1];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wantDrinkSelectedVC:didSelectedType:)]) {
        
        [self.delegate wantDrinkSelectedVC:self didSelectedType:1];
    }
    
    [self popController];


}
- (IBAction)lookTjAction:(id)sender {
    
    
  //  if (self.type == 3) {
        
      //  return;
    //}
    
     [self initWithType:3];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wantDrinkSelectedVC:didSelectedType:)]) {
        
        [self.delegate wantDrinkSelectedVC:self didSelectedType:3];
    }
    
    [self popController];
    

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
