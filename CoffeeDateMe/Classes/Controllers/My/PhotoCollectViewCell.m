//
//  PhotoCollectViewCell.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/12.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "PhotoCollectViewCell.h"

@implementation PhotoCollectViewCell

- (void)initPhotoCollectView {
    
    self.photoHeaderView.delegate = self;
}

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
      [self setIsSelected:!_isSelected];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(photoCollectView:AtIndex:didSelected:)]) {
        
        [self.delegate photoCollectView:self AtIndex:_index didSelected:_isSelected];
    }
}

- (IBAction)selectAction:(id)sender {
    
    [self setIsSelected:!_isSelected];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(photoCollectView:AtIndex:didSelected:)]) {
        
        [self.delegate photoCollectView:self AtIndex:_index didSelected:_isSelected];
    }
 }

- (void)setIsSelected:(BOOL)isSelected {
    
    _isSelected = isSelected;
    
    if (_isSelected) {
      
        [self.coverView setHidden:NO];
       //[self.selectButton setHidden:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.selectButton setHidden:NO];
        });
        
    }else {
        
        [self.coverView setHidden:YES];
       // [self.selectButton setHidden:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.selectButton setHidden:YES];
        });
       // [self.selectButton setBackgroundImage:TTImage(@"photo_normal") forState:UIControlStateNormal];
    }
}

@end
