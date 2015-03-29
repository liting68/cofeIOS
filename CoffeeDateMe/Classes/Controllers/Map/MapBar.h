//
//  MapBar.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-11-16.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapBarDelegate <NSObject>

- (void)mapBarDidSelectedAtIndex:(int)index;//1 walk 2 bus 3 car

@end


@interface MapBar : UIView

///当前选中哪一个
@property (assign, nonatomic)int currentSelected;

@property (weak, nonatomic) IBOutlet UIView *busView;
@property (weak, nonatomic) IBOutlet UIView *driveView;
@property (weak, nonatomic) IBOutlet UIView *walkView;
@property (weak, nonatomic) IBOutlet UIView *infoView;


////距离 和 时间
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/////imgView
@property (weak, nonatomic) IBOutlet UIImageView *walkImgView;
@property (weak, nonatomic) IBOutlet UIImageView *busImgView;
@property (weak, nonatomic) IBOutlet UIImageView *carImgView;

@property (assign, nonatomic)id<MapBarDelegate> delegate;

- (void)layoutMapbarView;

@end
