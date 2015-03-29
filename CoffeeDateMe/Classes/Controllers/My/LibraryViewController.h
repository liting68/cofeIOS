//
//  LibraryViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-11.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "PhotoHeaderView.h"

@protocol LibraryViewDelegate <NSObject>

- (void)libaryViewDidSelectedAtIndex:(int)index;

@end

@interface LibraryViewController : BaseViewController<PhotoheaderViewDelegate>

@property (nonatomic, strong)NSArray * images;
@property (nonatomic, strong)NSArray * imageInfos;

@property (nonatomic, strong)PhotoHeaderView * photoHeaderView;

@property (nonatomic, strong) id<LibraryViewDelegate> delegate;

@end
