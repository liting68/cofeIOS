//
//  AboutViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-22.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    // Do any additional setup after loading the view from its nib.
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT - 64)];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ABOUT_URL]]];
    [self.view addSubview:_webView];
    
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initBackButton];
    [self initTitleViewWithTitleString:@"关于"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
