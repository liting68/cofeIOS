//
//  BLMCutImageViewController.h
//  Yujia001
//
//  Created by 潘淑娟 on 14-3-12.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJImageCropper.h"

@protocol BLMCutImageViewControllerDelegate <NSObject>
@optional
-(void)requestUploadWithImage:(UIImage *)image;
@end
@interface BLMCutImageViewController : BaseViewController<BLMCutImageViewControllerDelegate>

@property (nonatomic,retain) id<BLMCutImageViewControllerDelegate>delegate;

@property (nonatomic,strong) BJImageCropper *imageCropper;

@property (nonatomic,strong) UIImage *uploadImage;

@property (nonatomic, assign)float scaleX;
@property (nonatomic, assign) float scaleY;

@end
