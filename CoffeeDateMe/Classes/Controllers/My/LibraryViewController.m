//
//  LibraryViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-11.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "LibraryViewController.h"

@interface LibraryViewController ()

@end

@implementation LibraryViewController

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

    
    [self initBackButton];
    
    [self initTitleViewWithTitleString:@"用户相册"];
    
    if ([self.images count] > 0) {
        
        _photoHeaderView = [[PhotoHeaderView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 0)];
        _photoHeaderView.backgroundColor = [UIColor whiteColor];
        [_photoHeaderView layoutWithType:1 Photos:self.images];
        _photoHeaderView.delegate = self;
        _photoHeaderView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_photoHeaderView];
        
    }else{
        
        [AppUtil HUDWithStr:@"暂无图片" View:self.view];
    }
}

#pragma mark - photoHeaderViewDelegate

- (void)photoHeaderViewDidClickPhotoActionWithIndex:(int)index type:(int)type {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(libaryViewDidSelectedAtIndex:)]) {
        
        [self.delegate libaryViewDidSelectedAtIndex:index];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
