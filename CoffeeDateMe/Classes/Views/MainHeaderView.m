//
//  MainHeaderView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-28.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "MainHeaderView.h"

@implementation MainHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Actions

- (IBAction)rmActi:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainHeaderViewDidClickAction:)]) {
        
        [self.delegate mainHeaderViewDidClickAction:3];
    }

}


- (IBAction)drinkAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainHeaderViewDidClickAction:)]) {
        
        [self.delegate mainHeaderViewDidClickAction:0];
    }
    
}


- (IBAction)leaveWordAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainHeaderViewDidClickAction:)]) {
        
        [self.delegate mainHeaderViewDidClickAction:1];
    }

}

- (IBAction)coffeeVenuesActioin:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainHeaderViewDidClickAction:)]) {
        
        [self.delegate mainHeaderViewDidClickAction:2];
    }
}

- (void)layoutWithBanners:(NSArray *)banners {
    
    _bannerView.contentSize = CGSizeMake(K_UIMAINSCREEN_WIDTH * [banners count], _bannerView.frame.size.height);
    _bannerView.showsHorizontalScrollIndicator = NO;
    _bannerView.delegate = self;
    _bannerView.pagingEnabled = YES;
    
    for (int index = 0; index < [banners count]; index ++) {
        
        NSString * imgURL = banners[index];
        
        WTURLImageView * imageView = [[WTURLImageView alloc] initWithFrame:CGRectMake(index * K_UIMAINSCREEN_WIDTH, 0, K_UIMAINSCREEN_WIDTH, _bannerView.frame.size.height)];
       
        [imageView setURL:imgURL defaultImage:@"banner_default" type:1];
      
        imageView.delegate = self;
        
        [_bannerView addSubview:imageView];
    }
    _pageControl.numberOfPages = [banners count];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / K_UIMAINSCREEN_WIDTH;
    
    _pageControl.currentPage = index;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
