//
//  BaseTableViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-1.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
{
    
    UIButton * myRightButton;
}
@end

@implementation BaseTableViewController

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
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    progressHUD =[[MBProgressHUD alloc]initWithView:self.view];
    
    progressHUD.mode=MBProgressHUDModeIndeterminate;
    
    progressHUD.labelText=@"正在加载中...";
    
    [self.view addSubview:progressHUD];
    
    _nSpaceNavY = 20;
    
    
    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)
    {
        _nSpaceNavY = 0;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    //  NSString * cName = [NSString stringWithFormat:@"%@",self.tabBarItem.title,nil];
    
    //  [[BaiduMobStat defaultStat]pageviewStartWithName:cName];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    //  NSString * cName = [NSString stringWithFormat:@"%@",self.tabBarItem.title,nil];
    
    // [[BaiduMobStat defaultStat]pageviewEndWithName:cName];
}

- (void)showAnimating {
    
    [progressHUD setHidden:NO];
}

- (void)hideAnimating {
    
    [progressHUD setHidden:YES];
}

- (id)getStoryBoardControllerWithControllerID:(NSString *)controllerID storyBoardName:(NSString *)storyboardName {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    id  controller = [board instantiateViewControllerWithIdentifier:controllerID];
    
    return controller;
}

- (void)initBackButton {
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(5,0, 44, 44);
    [backButton setImage:TTImage(@"new_back") forState:UIControlStateNormal];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)initTitleViewWithTitleString:(NSString *)titleString {
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 24)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = CLEAR_COLOR;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = WHITE_COLOR;
    titleLabel.text = titleString;
    self.navigationItem.titleView = titleLabel;
}

- (void)initLeftBarButtonItem:(NSString *)imageName title:(NSString *)title action:(SEL)action{
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (imageName) {
        
        [rightButton setImage:TTImage(imageName) forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(6, 6, 28, 28);
        
    }else {
        
        [rightButton setTitle:title forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 6,60 , 28);
        
    }
    
    myRightButton = rightButton;
    
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)updateTitleWithTitle:(NSString *)title {
    
    [myRightButton setTitle:title forState:UIControlStateNormal];
}

- (void) initWithRightButtonWithImageName:(NSString *)imageName title:(NSString *)title action:(SEL)action {
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (imageName) {
        
        rightButton.frame = CGRectMake(276, 6, 28, 28);
        [rightButton setImage:TTImage(imageName) forState:UIControlStateNormal];
        
    }else {
        
        rightButton.frame = CGRectMake(256, 6, 64, 28);
        
        [rightButton setTitle:title forState:UIControlStateNormal];
        
        [rightButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        
    }
    
    myRightButton = rightButton;
    
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark - Actions

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gobackAciton {
    
    [self performSelectorOnMainThread:@selector(backAction) withObject:nil waitUntilDone:YES];
    
}

#pragma mark - 设置2个按钮

- (UIButton *)setBarButtonItemWithImageName:(NSString *)imageName imageNameExtenel:(NSString*)imageNameExtenel  action:(SEL)action action1:(SEL)action1 {
    
    return nil;
}
#pragma mark - 右边放置2个NavItem

- (UIButton *)setBarButtonItemWithImageName:(NSString *)imageName title:(NSString *)title imageNameExtenel:(NSString*)imageNameExtenel titleExtenel:(NSString *)titleExtenel action:(SEL)action actionExtenel:(SEL)extenelAction {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    if (imageName) {
        
        [button setBackgroundImage:TTImage(imageName) forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0, 10, 24, 24);
    }else {
        
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0, 10, 40, 24);
    }
    
    
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button1 addTarget:self action:extenelAction forControlEvents:UIControlEventTouchUpInside];
    
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    
    if (imageNameExtenel) {
        
        [button1 setBackgroundImage:TTImage(imageNameExtenel) forState:UIControlStateNormal];
        button1.frame = CGRectMake(0, 10, 24, 24);
        
    }else{
        
        
        [button1 setTitle:titleExtenel forState:UIControlStateNormal];
        
        button1.frame = CGRectMake(0, 10, 40, 24);
    }
    
    
    UIBarButtonItem * rightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightButtonItem,rightButtonItem1, nil];
    
    return button;
}

- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem
{
    
    [self.navigationController.navigationBar setHeight:YES];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, _nSpaceNavY, self.view.width, 64 - _nSpaceNavY)];
    view.backgroundColor = [UIColor colorWithRed:0.742 green:0.741 blue:0.760 alpha:1.000];//[UIColor colorWithWhite:0.517 alpha:1.000];
    
    [self.view addSubview:view];
    
    _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nSpaceNavY, self.view.width, 64 - _nSpaceNavY)];
    
    if (SYSTEM_BIGTHAN_7) {
        
        _navView.image = TTImage(@"nav_ios7");
    }
    else{
        
        _navView.image = TTImage(@"nav_ios6");
    }
    
    _navView.userInteractionEnabled = YES;
    
    [self.view addSubview:_navView];
    
    if (szTitle != nil)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.width - 200)/2,(20 - _nSpaceNavY) + (44 - 20)/2, 200, 20)];
        [titleLabel setText:szTitle];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [_navView addSubview:titleLabel];
    }
    
    UIView *item1 = menuItem(0);
    if (item1 != nil)
    {
        [_navView addSubview:item1];
    }
    UIView *item2 = menuItem(1);
    if (item2 != nil)
    {
        [_navView addSubview:item2];
    }
}


#pragma mark - 统一入口解析  如果有根据code 做出特殊处理比较好控制

#pragma mark - 统一入口解析  如果有根据code 做出特殊处理比较好控制

- (Response *)parseJSONValueWithJSONString:(NSDictionary *)dic {
    
    NSLog(@"Response dicData: %@", dic);
    
    Response * response = [[Response alloc] init];
    
    int err = [[dic valueForKey:@"err"] intValue];
    
    response.err = err;
    
    if (err == 1) {
        
        response.result = [dic valueForKey:@"result"];
        
    }else {
        
        NSString * errMsg = [dic valueForKey:@"errMsg"];
        
        response.errMsg = errMsg;
        
        [AppUtil HUDWithStr:errMsg View:self.view];
        
    }
    
    return response;
}

- (void)hideTabBar {
    
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    LeveyTabBarController * tabCtrl = delegate.leveyTabBarVC;
    
    [tabCtrl hidesTabBar:YES animated:NO];
}

- (void)showTabBar {
    
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    LeveyTabBarController * tabCtrl = delegate.leveyTabBarVC;
    
    [tabCtrl hidesTabBar:NO animated:NO];
}

#pragma mark - UPLOAD IMAGE

- (void)requestUploadWithManyImages:(NSArray *)images { ///上传多张图片
    
    [self showAnimating];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",hostUrl,@"aaa"];
    
    NSDictionary * paramsData = nil;//[CAQIRequest getUploadImageParams];
    
    asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    asiRequest.delegate = self;
    
    [asiRequest setPostFormat:ASIMultipartFormDataPostFormat];
    
    int index = 0;
    
    for (UIImage *eImage in images) {
        
        NSData *imageData = UIImageJPEGRepresentation(eImage,0.7);
        
        NSString *photoName=[NSString stringWithFormat:@"%d.jpeg",index];
        
        NSLog(@"photo:%@",photoName);
        
        [asiRequest addData:imageData withFileName:photoName andContentType:@"image/jpeg" forKey:@"file[]"];
        
        index ++;
    }
    
    NSArray * allKeys = [paramsData allKeys];
    
    for (NSString * key in allKeys) {
        
        [asiRequest setPostValue:[paramsData valueForKeyPath:key] forKey:key];
    }
    
    [asiRequest startAsynchronous];
    
}

-(void)requestUpload:(UIImage *)image { ///上传一张图片
    
    [self showAnimating];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",hostUrl,@"ddd"];
    
    NSDictionary * paramsData = nil;//[CAQIRequest getUploadImageParams];
    
    asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    asiRequest.delegate = self;
    
    NSData *dataObj = UIImageJPEGRepresentation(image, 0.7);
    
    [asiRequest setPostFormat:ASIMultipartFormDataPostFormat];
    
    [asiRequest addData:dataObj withFileName:@"1.jpeg" andContentType:@"image/jpeg" forKey:@"file"];
    
    NSArray * allKeys = [paramsData allKeys];
    
    for (NSString * key in allKeys) {
        
        [asiRequest setPostValue:[paramsData valueForKeyPath:key] forKey:key];
    }
    
    [asiRequest startAsynchronous];
}



#pragma mark - ASIHttpRequest

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    [self uploadImageSuccess:result];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    
    [self hideAnimating];
    
}

#pragma mark - PhotoBrowerDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
    return self.photosArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.photosArray.count) {
        return [self.photosArray objectAtIndex:index];
    }
    return nil;
}

#pragma mark - 查看图片(图片数组作为参数)

- (void)openImageSetWithImages:(NSArray *)images initImageIndex:(int)index {
    
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    [_photosArray removeAllObjects];
    
    for (int i = 0; i < images.count; i++) {
        
        MWPhoto *photo = [MWPhoto photoWithImage:images[i]];///图片封装
        
        [_photosArray addObject:photo];
        
    }
    
    MWPhotoBrowser * browser = [[MWPhotoBrowser alloc] initWithDelegate:self];\
    browser.displayActionButton = YES;
    browser.wantsFullScreenLayout = YES;
    [browser setInitialPageIndex:index];
    [self presentViewController:browser animated:YES completion:^{
        
    }];
}

#pragma mark - 查看图片(url数组作为参数)

- (void)openImageSetWithUrls:(NSArray *)urls initImageIndex:(int)index {
    
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    [_photosArray removeAllObjects];
    
    for (int i = 0; i < urls.count; i++) {
        
        MWPhoto * photo = [MWPhoto photoWithURL:[NSURL URLWithString:urls[i]]];//url封装
        
        [_photosArray addObject:photo];
        
    }
    
    MWPhotoBrowser * browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.wantsFullScreenLayout = YES;
    [browser setInitialPageIndex:index];
    
    [self presentViewController:browser animated:YES completion:^{
        
    }];
}

#pragma mark - 选择图片

- (void)openSelectSingleImageAction {
    UIActionSheet *uploadSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"选择图片",@"拍摄照片",@"取消",nil];
    uploadSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    uploadSheet.tag = 2001;
    [uploadSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2001) {
        
        if (buttonIndex == 2) {
            
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            
        }else if(buttonIndex == 0){
            
            [self selectSinglePhoto];
        }
        else if(buttonIndex==1){
            
            [self takePhotoWithCamera];
        }
    }
}

#pragma - Private Mehtod

- (void)selectSinglePhoto { //选择单张图片
    
    UIImagePickerController *m_imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        m_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        m_imagePicker.delegate = self;
        [m_imagePicker setAllowsEditing:NO];
        
        [self presentViewController:m_imagePicker animated:NO completion:^{
            
        }];
    }
}

- (void)takePhotoWithCamera { ///拍照
    
    UIImagePickerController *m_imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        m_imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        m_imagePicker.delegate = self;
        [m_imagePicker setAllowsEditing:NO];
        [self presentViewController:m_imagePicker animated:NO completion:^{
            
        }];
    }
}

#pragma mark - UIImagePickerViewControllerDelegate method

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * curSelectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //  curSelectImage = [CAQIRequest scaleImage:curSelectImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(curSelectImage, nil, nil, nil);
    }
    
    [picker dismissViewControllerAnimated:NO completion:^{
        
        if ([self respondsToSelector:@selector(selectImageSuccess:)]) {
            
            [self selectImageSuccess:curSelectImage];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
}


#pragma mark - 一秒回退

- (void)popController {
    
    [self performSelector:@selector(backMyAction) withObject:nil afterDelay:1.0];
    
}

-(void)backMyAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goMyLogin {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginViewController * loginViewController = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}

- (void)gotoLogin {
    
    [AppUtil HUDWithStr:@"请先登录吧" View:self.view];
    
    [self performSelector:@selector(goMyLogin) withObject:nil afterDelay:1.0];
}

- (id)getStoryBoardControllerWithControllerID:(NSString *)controllerID {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    id  controller = [board instantiateViewControllerWithIdentifier:controllerID];
    
    return controller;
}

- (NSDictionary *)commonParamsWithDictionary:(NSMutableDictionary *)dictionary {
    
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [dictionary setValue:[NSString stringWithFormat:@"%lf",delegate.coordinate.latitude] forKeyPath:@"lat"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%lf",delegate.coordinate.longitude] forKeyPath:@"lng"];
    
    return dictionary;
}

#pragma mark - Memory Manage

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [header free];
    [footer free];
}

//////////////

- (void)initNavView {
    
    myNavigationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 64)];
    myNavigationView.userInteractionEnabled = YES;
    [self.view addSubview:myNavigationView];
    
}

//for ios7
-(void)forNavBeTransparent {
    myNavigationView.image = TTImage(@"common_cover");
    
}

-(void)forNavBeNoTransparent {
    
    myNavigationView.image = TTImage(@"common_nav");
}

//*for iOS7
-(void)forIOS7:(UIViewController *)ctl
{
    if (SYSTEM_BIGTHAN_7) {
        ctl.navigationController.interactivePopGestureRecognizer.enabled = NO;
        ctl.edgesForExtendedLayout =  UIRectEdgeNone;//IOS7新增属性,但是在导航栏隐藏的情况下还是要向下移动20px
        ctl.navigationController.navigationBar.translucent = NO;//解决导航栏跟状态栏背景色都变的有点暗的问题
        ctl.extendedLayoutIncludesOpaqueBars = NO;
        ctl.modalPresentationCapturesStatusBarAppearance = NO;
        
        [ctl.navigationController.navigationBar setBackgroundImage:TTImage(@"common_nav") forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else{
        
        [ctl.navigationController.navigationBar setBackgroundImage:TTImage(@"common_nav") forBarMetrics:UIBarMetricsDefault];
    }
}

@end
