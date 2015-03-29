//
//  GuideViewController.h
//  ModelAPP
//
//  Created by 波罗密 on 15/1/18.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"

@interface GuideViewController : BaseViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
