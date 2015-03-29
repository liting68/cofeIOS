//
//  BLMCutImageViewController.m
//  Yujia001
//
//  Created by 潘淑娟 on 14-3-12.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "BLMCutImageViewController.h"
#import "BLMCommon.h"

@interface BLMCutImageViewController ()

@end

@implementation BLMCutImageViewController
@synthesize imageCropper;
@synthesize uploadImage;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.navigationController.navigationBar setHidden:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}


-(void)initView
{
    [self initBackButton];
    
    [self initWithRightButtonWithImageName:nil title:@"保存" action:@selector(rightBtn:)];
    
    //[self initTitleViewWithTitleString:@"图片裁剪"];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.imageCropper = [[BJImageCropper alloc] initWithImage:uploadImage andMaxSize:CGSizeMake(K_UIMAINSCREEN_WIDTH ,(K_UIMAINSCREEN_HEIGHT - 44 - 20) ) scaleX:self.scaleX scaleY:self.scaleX];
    self.imageCropper.scaleX = self.scaleX;
    self.imageCropper.scaleY = self.scaleY;
    [self.view addSubview:self.imageCropper];
    self.imageCropper.center = self.view.center;
    
    CGRect rect = self.imageCropper.frame;
    rect.origin.y = 10;
    self.imageCropper.frame = rect;
    
    self.imageCropper.imageView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.imageCropper.imageView.layer.shadowRadius = 3.0f;
    self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
    self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.imageCropper];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RKCropImageController

- (void)updateDisplay {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
        
    }
}
#pragma mark - UIButton

-(void)back:(UIButton *)sender
{
    PopAnimation;
}

-(void)rightBtn:(UIButton *)sender
{
    uploadImage = [self.imageCropper getCroppedImage];
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestUploadWithImage:)]) {
        
        [self.delegate requestUploadWithImage:uploadImage];
        
        PopAnimation;
    }
}

#pragma mark - 自动转屏幕

///IOS 6及其以上的旋转方式

- (BOOL) shouldAutorotate
{
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

/////// IOS 6以下的旋转方式
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

#pragma mark - Memory Manage

- (void)dealloc {
    
    [self.imageCropper removeObserver:self forKeyPath:@"crop"];
    
}

@end
