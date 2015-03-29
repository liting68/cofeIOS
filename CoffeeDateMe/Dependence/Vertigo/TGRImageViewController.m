// TGRImageZoomTransition.m
//
// Copyright (c) 2013 Guillermo Gonzalez
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TGRImageViewController.h"
#import "PhotoLibraryVC.h"

@interface TGRImageViewController ()<WTURLImageViewDelegate>
{
    UIView * moreView;
}
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation TGRImageViewController

- (id)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _image = image;
    }
    
    return self;
}

- (id)initWithImageURLs:(NSArray *)imageURLs {
    if (self = [super init]) {
        
        _imageArray = [[NSMutableArray alloc] initWithArray:imageURLs];;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //[self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    
    self.bigImageArray = [[NSMutableArray alloc] initWithArray:[AppUtil getBigImage:self.imageArray]];
    
    self.selectedIndex = 0;
    
    NSString * bigImageURL = self.bigImageArray[self.selectedIndex];
    
    [self.imageView setURL:bigImageURL defaultImage:nil type:1];
    
    /////////初始化
    [self initNavView];
    [self initBackButton];
    [self forNavBeTransparent];
    
    if (self.isMySelf) {
        
          [self initWithRightButtonWithImageName:@"pd_more" title:nil action:@selector(moreAction)];
       
    }
    
    if (self.userName) {
        
        [self initTitleViewWithTitleString:[NSString stringWithFormat:@"%@的相册",self.userName]];
    
    }else {
        
        [self initTitleViewWithTitleString:@"我的相册"];
    }

    if(self.isMySelf) {
        
        ///相册信息数组
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatePhotoLibraryN:) name:k_PHOTO_LIBLARY_UPDATE object:nil];
        
    }
    
    ////右边相册
    [self layoutWithPhotos];
    
    [self swipeGestue];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self panGestureEnable:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
     [self panGestureEnable:YES];
}

- (void) initWithRightButtonWithImageName:(NSString *)imageName title:(NSString *)title action:(SEL)action {
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (imageName) {
        
        rightButton.frame = CGRectMake(265, 6 + 20, 50, 28);
        [rightButton setImage:TTImage(imageName) forState:UIControlStateNormal];
        
    }else {
        
        rightButton.frame = CGRectMake(276, 13 + 20, 44, 18);
        
        [rightButton setTitle:title forState:UIControlStateNormal];
        
        [rightButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        
    }
    
    myRightButton = rightButton;
    
    
    [myNavigationView addSubview:rightButton];
    // UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    //self.navigationItem.rightBarButtonItem = rightButtonItem;
}


- (void)moreAction {
    
    if (!moreView) {
        
        moreView = [[UIView alloc] initWithFrame:CGRectMake(K_UIMAINSCREEN_WIDTH - 88, 64, 88, 84)];
        moreView.backgroundColor = [UIColor clearColor];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, moreView.width, 42);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(setAvatarAction) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"设为头像" forState:UIControlStateNormal];
        [moreView addSubview:button];
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(0, 42, moreView.width, 42);
        button1.titleLabel.font = [UIFont systemFontOfSize:16];
        [button1 addTarget:self action:@selector(manageAction) forControlEvents:UIControlEventTouchUpInside];
        [button1 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button1 setTitle:@"管理更多" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button1];
        
        moreView.hidden = YES;
        
        [self.view addSubview:moreView];
    }
    
    if (moreView.hidden == YES) {
        
        moreView.hidden = NO;
        //[UIView animateWithDuration:0.3 animations:^{
          //  moreView.top = -64;
        //}];
        
        
    }else {
        
        moreView.hidden = YES;
      //  [UIView animateWithDuration:0.3 animations:^{
        //    moreView.top = 64;
      //  }];
        
    }
}

- (void)updatePhotoLibraryN:(NSNotification *)note {
    
    NSArray * photoArray = [NSArray arrayWithArray:note.object];
    
    [self updatePhotoLibrary:photoArray];
}

- (void)updatePhotoLibrary:(NSArray *)photoArray {
    
    [self.photoDetailInfo removeAllObjects]; ////////////移除信息
    [self.photoDetailInfo addObjectsFromArray:photoArray];//加入
    
    ////小图
    NSMutableArray * user_photosArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary * dic in photoArray) {
        
        NSString * path = [dic valueForKey:@"path"];
        
        [user_photosArray addObject:path];
        
    }
    self.imageArray = user_photosArray;
    
    //大图
    [self.bigImageArray removeAllObjects];
    [self.bigImageArray addObjectsFromArray:[AppUtil getBigImage:user_photosArray]];
    
    [self updatePhotosLocations];
}

- (void)updatePhotosLocations {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (self.selectedIndex > [self.imageArray count] - 1) {
            
            self.selectedIndex = (int)[self.imageArray count] - 1;
        }
        
        if ([self.imageArray count] == 0) {
            
            self.imageView.image = nil;
            
        }else {
           
            NSString * bigURL = self.bigImageArray[self.selectedIndex];
            
            [self.imageView setURL:bigURL defaultImage:nil type:1];
        }
        
        int startX = 6;
        
        for (int index = 0; index < [self.imageArray count
                                     ]; index ++) {
         
            AvatarView * view = (AvatarView *)[self.smallPhotos viewWithTag:1000 + index];
            
            if (!view) {
            
                view = [[AvatarView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
                view.tag = 1000 + index;
                [self.smallPhotos addSubview:view];
            }
            
            
            if (self.selectedIndex == index) {
                
                 view.frame = CGRectMake(startX, 0, 80, 80);
                
                startX = startX + 80 + 6;
                
            }else {
                
                 view.frame = CGRectMake(startX, 20, 40, 40);
                
                startX = startX + 40 + 6;
            }

            [view setURL:self.imageArray[index] defaultImage:nil type:1];
            
            [view setConers];
        }
        
        if (self.isMySelf) {
            
            UIView * view = [self.smallPhotos viewWithTag:10000];
            view.frame = CGRectMake(startX, 20, 40, 40);
            
            self.smallPhotos.contentSize = CGSizeMake((self.imageArray.count + 1) * 40 + (self.imageArray.count + 2) * 6 + 40, 80);
            
        }else {
            
            self.smallPhotos.contentSize = CGSizeMake(self.imageArray.count * 40 + (self.imageArray.count + 1) * 6 + 20, 80);
            
        }
        /////////
        
        for (int index = [self.imageArray count]; index < 1000; index ++) {
            
               UIView * view = [self.smallPhotos viewWithTag:1000 + index];
            
            if (view) {
                
                [view removeFromSuperview];
            
            }else {
                
                break;
            }
        }
        
        if (self.selectedIndex > 2) {
            
            CGPoint point = self.scrollView.contentOffset;
            
            point.x = (self.selectedIndex - 2) * 46;
            
            self.smallPhotos.contentOffset = point;
        
        }else {
            
            CGPoint point = self.scrollView.contentOffset;
            
            point.x = 0;
            
             self.smallPhotos.contentOffset = point;
        }
        
    }];
}

- (void)layoutWithPhotos {
    
    int startX = 6;
    
    for(int index = 0; index < [self.imageArray count];index ++) {
        
        if (index == self.selectedIndex) {
            
            AvatarView * avatarView = [[AvatarView alloc]initWithFrame:CGRectMake(startX, 0, 80, 80)];
            
            [avatarView setConers];
            
            avatarView.delegate = self;
            
            [avatarView setURL:self.imageArray[index] defaultImage:nil type:1];
            
            avatarView.tag = 1000 + index;
            
            startX = startX + 80 + 6;
            
            [self.smallPhotos addSubview:avatarView];
            
        }else {
            
            AvatarView * avatarView = [[AvatarView alloc]initWithFrame:CGRectMake(startX, 20, 40, 40)];
            
            [avatarView setConers];
            
            [avatarView setURL:self.imageArray[index] defaultImage:nil type:1];
            
            avatarView.delegate = self;
            
            avatarView.tag = 1000 + index;
            
            startX = startX + 40 + 6;
            
            [self.smallPhotos addSubview:avatarView];
            
        }
    }
    
    if (self.isMySelf) {
        
        AvatarView * avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(startX, 20, 40, 40)];
        avatarView.image = TTImage(@"uploadImage");
         avatarView.userInteractionEnabled = YES;
        avatarView.delegate = self;
        [avatarView addGestureRecognizers];
        avatarView.tag = 10000;
        
        [self.smallPhotos addSubview:avatarView];
        
        self.smallPhotos.contentSize = CGSizeMake((self.imageArray.count + 1) * 40 + (self.imageArray.count + 2) * 6 + 40, 80);
        
    }else {
        
         self.smallPhotos.contentSize = CGSizeMake(self.imageArray.count * 40 + (self.imageArray.count + 1) * 6 + 20, 80);
        
    }
    
    self.smallPhotos.showsHorizontalScrollIndicator = NO;
}

- (void)addAnNewPhoto {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        NSString * url = self.imageArray[self.imageArray.count -1] ;
        
        AvatarView * avatarView = (AvatarView *)[self.smallPhotos viewWithTag:10000];

       ///////////////////////////////////////////////
        AvatarView * avatarView1 = [[AvatarView alloc] initWithFrame:avatarView.frame];
        [avatarView1 setConers];
        avatarView1.delegate = self;
        [avatarView1 setURL:url defaultImage:nil type:1];
        avatarView1.tag = 1000 + [self.imageArray count] - 1 ;
        [self.smallPhotos addSubview:avatarView1];
        ///////////////////////////////////////////
        
         avatarView.left = avatarView.left + 46;
        
        self.smallPhotos.contentSize = CGSizeMake(self.smallPhotos.contentSize.width + 64, self.smallPhotos.contentSize.height);
        
    }];
}

-(void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setAvatarAction {
    
    [moreView setHidden:YES];
    
   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (!memberID) {
        
        [self gotoLogin];
    }
    
    NSString * pid = [self.photoDetailInfo[self.selectedIndex] valueForKey:@"id"];
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"changeHeadImg",@"act",memberID,@"userid",pid,@"pid", nil];
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        if (response.err == 1) {
            
            [AppUtil HUDWithStr:@"已设为头像" View:self.view];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATE_USER_INFO_NOTIFICATION object:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)manageAction {
    
    moreView.hidden = YES;
    
    PhotoLibraryVC * photoLibrary =  [self getStoryBoardControllerWithControllerID:@"PhotoLibraryVC" storyBoardName:@"Other"];
    
    photoLibrary.photoDetailInfo = self.photoDetailInfo;
    
    photoLibrary.photos = self.imageArray;
    
    [self.navigationController pushViewController:photoLibrary animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - WTURLImageViewDelegate

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    if (imageView.tag == 10000) {
        
        [self openSelectSingleImageAction];
        
    }else if(imageView.tag == 20000) {
        
        
    }else {
        
        self.selectedIndex = imageView.tag - 1000;
        
        NSString * bigURL = self.bigImageArray[self.selectedIndex];
        
        [self.imageView setURL:bigURL defaultImage:nil type:1];
        
        [self updatePhotosLocations];
    }
}

- (void) URLImageViewDidDoubleClicked : (WTURLImageView*)imageView {
    
    
}
- (void) URLImageViewDidLongPressed : (WTURLImageView*)imageView {
    
    
    
}

#pragma mark - Private Method

- (void)selectImageSuccess:(UIImage *)image {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"uploadOnceImg",@"act",memberID,@"userid", nil];
    [self requestUpload:image params:parameters];///上传
    
}

- (void)uploadImageSuccess:(NSDictionary *)dictionary {
    
    Response * response = [self parseJSONValueWithJSONString:dictionary];
    
    if (response.err == 1) {
        
        [AppUtil HUDWithStr:@"上传图片成功" View:self.view];
        
        [self.imageArray addObject:[response.result valueForKey:@"path"]];
        
        [self.bigImageArray addObject:[AppUtil getBigImageWithURL:[response.result valueForKey:@"path"]]];
        
        [self.photoDetailInfo addObject:response.result];
        
        [self.userCenterVC updatePhotoLibrary:self.photoDetailInfo];
        
        [self addAnNewPhoto];
    }
}


#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - Private methods

- (void)swipeGestue {

    self.imageView.userInteractionEnabled = YES;
    
    /*!
     *@brief 向左滑动手势设置
     **/
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(initWithUserLeftGestureRecognizer)];
    [leftSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.imageView addGestureRecognizer:leftSwipeGestureRecognizer ];
 
    /*!
     *@brief 向左滑动手势设置
     **/
    UISwipeGestureRecognizer *rithSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(initWithUserRightGestureRecognizer)];
    [rithSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.imageView addGestureRecognizer:rithSwipeGestureRecognizer ];
    
}

- (void)initWithUserLeftGestureRecognizer {
    
    if (self.selectedIndex == [self.imageArray count] - 1) {
        
        return;
        
    }
    
    self.selectedIndex ++;
    
    //////////
    NSString * bigImageURL = self.bigImageArray[self.selectedIndex];
    [self.imageView setURL:bigImageURL defaultImage:nil type:1];
    ////////////////
    
    [self updatePhotosLocations];
   
}

- (void)initWithUserRightGestureRecognizer {
    
    if (self.selectedIndex == 0) {
        
        [AppUtil HUDWithStr:@"已是第一张" View:self.view];
        
        return;
    }
    
    self.selectedIndex --;
    
    //////////
    NSString * bigImageURL = self.bigImageArray[self.selectedIndex];
    [self.imageView setURL:bigImageURL defaultImage:nil type:1];
    ////////////////
    
    [self updatePhotosLocations];
    

}

- (IBAction)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
   // [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        // Zoom in
        CGPoint center = [tapGestureRecognizer locationInView:self.scrollView];
        CGSize size = CGSizeMake(self.scrollView.bounds.size.width / self.scrollView.maximumZoomScale,
                                 self.scrollView.bounds.size.height / self.scrollView.maximumZoomScale);
        CGRect rect = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        [self.scrollView zoomToRect:rect animated:YES];
    }
    else {
        // Zoom out
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
}

#pragma mark - Memory Manage

- (void) dealloc {
    
    if (self.isMySelf) {
        
           [[NSNotificationCenter defaultCenter] removeObserver:self name:k_PHOTO_LIBLARY_UPDATE object:nil];
    }
    
    self.userCenterVC = nil;
}

@end
