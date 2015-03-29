//
//  BaseTableViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-1.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ASIFormDataRequest.h"
#import "MWPhotoBrowser.h"

@interface BaseTableViewController : UITableViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,MWPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    MBProgressHUD * progressHUD;////提示属性
    MJRefreshFooterView * footer;//上拉属性
    MJRefreshHeaderView * header;//下拉属性
    
    UIImageView * myNavigationView;////我的导航条
    
    ASIFormDataRequest * asiRequest;///上传图片相关属性
}

////////////////自定义导航条属性////////////////
@property (nonatomic, strong) UIImageView *navView;
@property (nonatomic, assign) float nSpaceNavY;;

/////////////tabbar隐藏相关方法////////
- (void)showTabBar;
- (void)hideTabBar;

////////////提示相关方法/////////
- (void)showAnimating;//开始加载
- (void)hideAnimating;//结束加载

///////////////导航条为隐藏相关方法
- (void)initBackButton;//有导航条（返回）
- (void)initLeftBarButtonItem:(NSString *)imageName title:(NSString *)title action:(SEL)action;//有导航条(左边按钮)
- (void)initTitleViewWithTitleString:(NSString *)titleString;//有导航条（标题）
- (void)initWithRightButtonWithImageName:(NSString *)imageName title:(NSString *)title action:(SEL)action;//有导航条（右边按钮）
- (UIButton *)setBarButtonItemWithImageName:(NSString *)imageName title:(NSString *)title imageNameExtenel:(NSString*)imageNameExtenel titleExtenel:(NSString *)titleExtenel action:(SEL)action actionExtenel:(SEL)extenelAction;//有导航条(右边2个按钮)
//////////////////////////////////////

/////////////////自定义导航条相关方法///////////////
- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;

//////////////////网络请求对json的统一过滤
- (id)parseJSONValueWithJSONString:(NSDictionary *)jsonString;

////////////上传图片相关方法///////////////////////////
- (void)uploadImageSuccess:(NSDictionary *)dictionary;
- (void)requestUploadWithManyImages:(NSArray *)images;
- (void)requestUpload:(UIImage *)image;

/////////////拍照相关方法/////////////////////////////
@property (nonatomic, assign)int selectType;////
@property (nonatomic, strong) UIImage * curSelectImage;
- (void)selectSinglePhoto; ///选择单张图片
- (void)selectMutiPhotoWithMax:(int)max;//目前没有实现该方法
- (void)takePhotoWithCamera; ///拍照
- (void)openSelectSingleImageAction;///弹出actionSheet进行选择
- (void)selectImageSuccess:(UIImage *)image;//选择图片成功


/////////////看大图相关方法///////////////////////////
@property (strong, nonatomic) NSMutableArray * photosArray;
- (void)openImageSetWithImages:(NSArray *)images initImageIndex:(int)index;////查看图片(图片数组作为参数)
- (void)openImageSetWithUrls:(NSArray *)urls initImageIndex:(int)index;///////查看图片(url数组作为参数)

- (void)popController;

- (void)gotoLogin;

- (id)getStoryBoardControllerWithControllerID:(NSString *)controllerID;

- (NSDictionary *)commonParamsWithDictionary:(NSMutableDictionary *)dictionary;
- (void)updateTitleWithTitle:(NSString *)title;

//////////////
-(void)forNavBeTransparent;
-(void)forNavBeNoTransparent;
- (void)initNavView ;

//*for iOS7
-(void)forIOS7:(UIViewController *)ctl;

- (id)getStoryBoardControllerWithControllerID:(NSString *)controllerID storyBoardName:(NSString *)storyboardName;
@end
