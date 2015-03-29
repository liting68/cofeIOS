//
//  ShopHeaderCell.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/3.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "ShopHeaderCell.h"
#import "WTURLImageView.h"

@implementation ShopHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)shopDetailAction:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.selectView.left = 0;
        
    }];
    
    self.currentSelected = 0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopHeaderCell:clickButtonsWithCategory:)]) {
        
        [self.delegate shopHeaderCell:self clickButtonsWithCategory:0];
    }
}

- (IBAction)commentAction:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.selectView.left = 107;
        
    }];
    self.currentSelected = 1;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopHeaderCell:clickButtonsWithCategory:)]) {
        
        [self.delegate shopHeaderCell:self clickButtonsWithCategory:1];
    }
}

- (IBAction)recommendAction:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.selectView.left = 107 * 2;
        
    }];
    
    self.currentSelected = 2;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopHeaderCell:clickButtonsWithCategory:)]) {
        
        [self.delegate shopHeaderCell:self clickButtonsWithCategory:2];
    }
}

#pragma mark - 布局

- (void)layoutWithDic:(NSDictionary *)dic {
    
    NSString * bbsCount = [NSString stringWithFormat:@"%@",[dic valueForKey:@"bbsCount"]];
    
    if ([AppUtil isNotNull:dic]) {
        
           [self.commonButton setTitle:[NSString stringWithFormat:@"评论(%@)",bbsCount] forState:UIControlStateNormal];
        
    }else {
        
          [self.commonButton setTitle:@"评论(0)" forState:UIControlStateNormal];
        
    }
    

    self.shopPicScrollView.pagingEnabled = YES;
    self.shopPicScrollView.showsHorizontalScrollIndicator = NO;
    self.shopPicScrollView.delegate = self;
    
    if (dic) {
        
        NSArray * photos = [dic valueForKey:@"imgs"];
        
        self.pageControl.numberOfPages = [photos count];
        
        for (int index = 0; index < [photos count]; index ++) {
            
            NSString * photoURL = photos[index];
            
            WTURLImageView * imageView = [[WTURLImageView alloc] initWithFrame:CGRectMake(K_UIMAINSCREEN_WIDTH * index, 0, K_UIMAINSCREEN_WIDTH, _shopPicScrollView.height)];
            imageView.tag = 2000 + index;
            [imageView setURL:photoURL defaultImage:@"venues_detail_defafault" type:0];
            imageView.delegate = self;
            imageView.userInteractionEnabled = YES;
            [_shopPicScrollView addSubview:imageView];
        }
        
        _shopPicScrollView.contentSize = CGSizeMake(K_UIMAINSCREEN_WIDTH * [photos count], _shopPicScrollView.height);
    }
    
  //  [UIView animateWithDuration:0.3 animations:^{
        
        _selectView.left = 107 * self.currentSelected;
   // }];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / K_UIMAINSCREEN_WIDTH;
    
    self.pageControl.currentPage = index;
    
}

#pragma mark - WTURLImageViewDelegate

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(shopHeaderCell:clickShopPicsAtIndex:)]) {
        
        [self.delegate shopHeaderCell:self clickShopPicsAtIndex:imageView.tag - 2000];
        
    }
}

@end
