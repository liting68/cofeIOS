//
//  BaseViewController.h
//  ModelAPP
//
//  Created by 波罗密 on 14-7-16.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ASIFormDataRequest.h"
#import "MWPhotoBrowser.h"
#import "HTCopyableLabel.h"
#import "NVSlideMenuController.h"

@interface BaseViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,MWPhotoBrowserDelegate,UIActionSheetDelegate,MJRefreshBaseViewDelegate,HTCopyableLabelDelegate,UITextFieldDelegate>
{
    UIImageView * myNavigationView;////我的导航条
    
    MBProgressHUD * progressHUD;////提示属性
    ASIFormDataRequest * asiRequest;///上传图片相关属性
    ////////////////////上拉/下拉属性
    MJRefreshFooterView * footer;//上拉属性
    MJRefreshHeaderView * header;//下拉属性
    int page;
    BOOL refreshing;
    
    UIButton * myRightButton;
}

@property (nonatomic, assign)int startOffset;

@property (nonatomic, assign) BOOL isRoot;
////////////////自定义导航条属性////////////////
@property (nonatomic, strong) UIImageView *navView;
@property (nonatomic, assign) float nSpaceNavY;;

@property (nonatomic, strong) UILabel * myTitleLabel;

////
- (void)initHeaderViewWithTableView:(UIScrollView *)tableView;
- (void)initFooterViewWithTableView:(UIScrollView *)tableView;
- (void)refreshingAction;
- (void)loadingingAction;

- (NVSlideMenuController *)getSlideMenuVC;
/////////////tabbar隐藏相关方法////////
- (void)showTabBar;
- (void)hideTabBar;

////////////提示相关方法/////////
- (void)showAnimating;//开始加载
- (void)hideAnimating;//结束加载

- (void)initHeaderWithSearchBar;
///////////////导航条为隐藏相关方法
- (void)initBackButton;//有导航条（返回）
- (void)initLeftBarButtonItem:(NSString *)imageName title:(NSString *)title action:(SEL)action;//有导航条(左边按钮)
- (void)initTitleViewWithTitleString:(NSString *)titleString;//有导航条（标题）
- (void)initWithRightButtonWithImageName:(NSString *)imageName title:(NSString *)title action:(SEL)action;//有导航条（右边按钮）
- (void)updateRightButtonWithTitle:(NSString *)title;//更新右边按钮的字体

- (UIButton *)setBarButtonItemWithImageName:(NSString *)imageName title:(NSString *)title imageNameExtenel:(NSString*)imageNameExtenel titleExtenel:(NSString *)titleExtenel action:(SEL)action actionExtenel:(SEL)extenelAction;//有导航条(右边2个按钮)
//////////////////////////////////////

/////////////////自定义导航条相关方法///////////////
- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;

//////////////////网络请求对json的统一过滤
- (id)parseJSONValueWithJSONString:(NSDictionary *)jsonString;

//////////////网络请求廷议添加参数//////////

- (NSDictionary *)commonParamsWithDictionary:(NSMutableDictionary *)dictionary;

////////////上传图片相关方法///////////////////////////
- (void)uploadImageSuccess:(NSDictionary *)dictionary;//上传图片成功
- (void)requestUploadWithManyImages:(NSArray *)images; //////////上传多张图片张图片
- (void)requestUpload:(UIImage *)image params:(NSDictionary *) paramsData;//上传单张图片
- (void)requestUploadAvatar:(UIImage *)image params:(NSDictionary *)paramsData;
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

- (BOOL)checkLogin;//yes.已登陆 NO 未登陆s

- (id)getStoryBoardControllerWithControllerID:(NSString *)controllerID;

- (id)getStoryBoardControllerWithControllerID:(NSString *)controllerID storyBoardName:(NSString *)storyboardName ;

- (void)subClassBack;

//////选择///////////0.选择做包  1.选择右边
- (void)selctAtIndex:(int)index;
- (void)initSwitchVC;
- (void)initSwitchVCForDate;
//////////////
-(void)forNavBeTransparent;
-(void)forNavBeNoTransparent;

- (void)initNavView ;

- (void)updateTitle:(NSString *)title;

- (void)panGestureEnable:(BOOL)enable;

@end
