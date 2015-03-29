//
//  PhotoLibraryVC.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/10.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"

@interface PhotoLibraryVC : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray * photos;
@property (nonatomic, strong) NSMutableArray * selectedIndexArray;

@property (nonatomic, strong) NSMutableArray * photoDetailInfo;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;


@end
