//
//  PhotoCollectViewCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/12.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTURLImageView.h"

@class PhotoCollectViewCell;

@protocol PhotoCollectViewDelegate <NSObject>

- (void)photoCollectView:(PhotoCollectViewCell *)photoCollectView AtIndex:(int)index didSelected:(BOOL)selected;

@end

@interface PhotoCollectViewCell : UICollectionViewCell<WTURLImageViewDelegate>

@property (assign, nonatomic) id<PhotoCollectViewDelegate> delegate;

@property (assign, nonatomic) int index;

@property (assign, nonatomic)BOOL isSelected;

@property (weak, nonatomic) IBOutlet WTURLImageView *photoHeaderView;

@property (weak, nonatomic) IBOutlet UIImageView *selectButton;


///遮罩层
@property (weak, nonatomic) IBOutlet WTURLImageView *coverView;

- (void)initPhotoCollectView;

@end
