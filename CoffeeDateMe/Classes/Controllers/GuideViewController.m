//
//  GuideViewController.m
//  ModelAPP
//
//  Created by 波罗密 on 15/1/18.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.contentSize = CGSizeMake( K_UIMAINSCREEN_WIDTH * 3, K_UIMAINSCREEN_HEIGHT);
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    for (int index = 0; index < 3; index ++) {
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(K_UIMAINSCREEN_WIDTH * index, 0, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT)];
        
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d.jpg",index + 1]];
        
        /*if (DEVICE_BIGTHAN_IPHONE5) {
            
            NSString * imageName = [NSString stringWithFormat:@"1136-%d",index + 1];
            
            imageView.image = TTImage(imageName);
            
        }else{
            
            NSString * imageName = [NSString stringWithFormat:@"960-%d",index + 1];
            
            imageView.image = TTImage(imageName);
        }*/
        
        if (index == 2) {
        
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAction)];
            tapGesture.numberOfTapsRequired = 1;
            
            [imageView addGestureRecognizer:tapGesture];
            
        }
        
        [self.scrollView addSubview:imageView];
        
    }
}

#pragma mark - Actions

- (void)removeAction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATE_ROOT_VC object:nil];
    
   //AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[self dismissViewControllerAnimated:YES completion:^{
        
    //}];
    
}

#pragma mark - Mmoery Manage

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
