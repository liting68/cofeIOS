//
//  PhotoLibraryVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/10.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "PhotoLibraryVC.h"
#import "PhotoCollectViewCell.h"

@interface PhotoLibraryVC ()<PhotoCollectViewDelegate>

@end

@implementation PhotoLibraryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectedIndexArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initBackButton];
    [self initTitleViewWithTitleString:@"相册管理"];
    [self initWithRightButtonWithImageName:nil title:@"删除" action:@selector(deleteAction)];
    
    [self layoutContentView];
}

- (void)layoutContentView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向

    _photoCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 10);
    
    _photoCollectionView.collectionViewLayout = flowLayout;
    _photoCollectionView.alwaysBounceVertical = YES;
    [_photoCollectionView setUserInteractionEnabled:YES];
    [_photoCollectionView setDelegate:self]; //代理－视图
    [_photoCollectionView setDataSource:self]; //代理－数据
}


#pragma mark -- UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_photos count] + 1;
    
}
// 3 320   4   312 / 3 = 104   2
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.userInteractionEnabled = YES;
 //  cell.photoHeaderView.userInteractionEnabled = NO;
    
    cell.layer.cornerRadius = 6;
    cell.layer.masksToBounds = YES;
    
    cell.index = indexPath.row;
    cell.delegate = self;
    
    NSString * row = [NSString stringWithFormat:@"%d",indexPath.row];
    
    if ([self.selectedIndexArray containsObject:row]) {
        
        cell.isSelected = YES;
    
    }else {
        
        cell.isSelected = NO;
    }
    
    if (indexPath.row == 0) {
        
        cell.photoHeaderView.image = TTImage(@"photoLibrary_upload");
        cell.photoHeaderView.userInteractionEnabled = NO;
        
    }else {
       
        [cell initPhotoCollectView];
        cell.photoHeaderView.userInteractionEnabled = YES;
        [cell.photoHeaderView setURL:_photos[indexPath.row - 1] defaultImage:nil type:1];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(93,93);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 0, 0);
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
          [collectionView deselectItemAtIndexPath:indexPath animated:YES];
     
        [self openSelectSingleImageAction];
        
    }else {
        
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return YES;
        
    }else {
        
         return NO;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

#pragma mark - PhotoCollectionCellDelegate

- (void)photoCollectView:(PhotoCollectViewCell *)photoCollectView AtIndex:(int)index didSelected:(BOOL)selected {
    
    if (selected) {
        
        NSString * str = [NSString stringWithFormat:@"%d",index];
        
        [self.selectedIndexArray addObject:str];
        
    }else {
        
        NSString * str = [NSString stringWithFormat:@"%d",index];
        
        [self.selectedIndexArray removeObject:str];
        
    }
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
        
        NSString * path = [response.result valueForKey:@"path"];
        
        [self.photos addObject:path];
        
        [self.photoDetailInfo addObject:response.result];
        
        [_selectedIndexArray removeAllObjects];
        
        [self.photoCollectionView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:k_PHOTO_LIBLARY_UPDATE object:self.photoDetailInfo];
        
    }
}

#pragma mark - Actions

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteAction {
    
    if ([self.selectedIndexArray count] == 0) {
        
        [AppUtil HUDWithStr:@"您还未选中照片" View:self.view];
    
    }else {
        
        NSMutableString * str = [[NSMutableString alloc] initWithCapacity:0];
        
        for (int index = 0; index < [self.selectedIndexArray count]; index ++) {
        
            NSString * indexStr = self.selectedIndexArray[index];
            
            NSString * mid = [NSString stringWithFormat:@"%@",[self.photoDetailInfo[indexStr.intValue - 1] valueForKey:@"id"]];
            
            if ([str length] == 0) {
                
                [str appendString:mid];
                
            }else {
                
                [str appendFormat:@",%@",mid];
                
            }
        }
        [self deletePhotoWithIds:str];
    }
}

#pragma mark - 删除图片

- (void)deletePhotoWithIds:(NSString *)ids {
    
        NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"deleteImg",@"act",userID,@"userid", ids,@"pid",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            [AppUtil HUDWithStr:@"删除图片成功" View:self.view];
            
            NSArray * array = [self.selectedIndexArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
              
                int a = [obj1 intValue];
                
                int b = [obj2 intValue];
                
                if (a > b ) {
                    
                    return NSOrderedDescending;
                
                }else {
                    
                    return  NSOrderedAscending;
                }
                
            }];
            
            for (int index = [array count] - 1; index >= 0; index --) {
                
                NSString * indexStr = array[index];
                
                [self.photos removeObjectAtIndex:[indexStr intValue] - 1];
                
                [self.photoDetailInfo removeObjectAtIndex:[indexStr intValue] - 1];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:k_PHOTO_LIBLARY_UPDATE object:self.photoDetailInfo];
            
            [self.selectedIndexArray removeAllObjects];
            
            [self.photoCollectionView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
          
            NSLog(@"Error: %@", error);
        }];
    
}

#pragma mark - Memory Manage

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
