//
//  PhotoHeaderView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-3.
//  Copyright (c) 2014年 jensen. All rights reserved.

#import "PhotoHeaderView.h"


@implementation PhotoHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutWithType:(int)type Photos:(NSArray *)photos {
    
    self.type = type;// 0 编辑  1.查看状态
    
    if (!_picPlaceHolderView) {
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PicPlaceHolderView" owner:nil options:nil];
        _picPlaceHolderView = [nibView objectAtIndex:0];
        _picPlaceHolderView.backgroundColor = [UIColor clearColor];
        _picPlaceHolderView.delegate = self;
    }
    
    for (UIView * view in self.subviews) {
        
        [view removeFromSuperview];
    }
    
    float startx = 8;
    float starty = 10;
    float width = 70;
    float height = 70;
    float sepx = 8;
    float sepy = 10;
    
    for (int index = 0; index < [photos count]; index ++) {
        
        WTURLImageView * imageView = [[WTURLImageView alloc]initWithFrame:CGRectMake(startx + (width + sepx) * (index % 4),starty + (height + sepy) * (index / 4), width, height)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 1000 + index;
        [imageView setURL:photos[index] defaultImage:@"library" type:0];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 6.0;
        imageView.delegate = self;
        [self addSubview:imageView];
    }
    
    if (self.type == 0) {
        
        if ([photos count] < 8) {
            
            int index = [photos count];
            
             _picPlaceHolderView.frame = CGRectMake(startx + (width + sepx) * (index % 4),starty + (height + sepy) * (index / 4), width, height);
            
            [self addSubview:_picPlaceHolderView];
            
        }
    }
    
    if (self.type == 0) {
        
        if ([photos count] < 4) {
            
            self.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 80);
            
        }else {
            
            self.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 160);
        }

    }else {
        
        
        if ([photos count] <= 4) {
            
            self.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 80);
            
        }else {
            
            self.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 160);
        }
    }

}

- (void)layoutWithType:(int)type Photos:(NSArray *)photos headIndex:(int)hIndex {
    
    self.type = type;// 0 编辑  1.查看状态
    
    self.photos = photos;
    
    self.headIndex = hIndex;
    
    if (!_picPlaceHolderView) {
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PicPlaceHolderView" owner:nil options:nil];
        _picPlaceHolderView = [nibView objectAtIndex:0];
        _picPlaceHolderView.backgroundColor = [UIColor clearColor];
        _picPlaceHolderView.delegate = self;
    }
    
    if (!_selectedView) {
        
        _selectedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT)];
        [_selectedView setHidden:YES];
        _selectedView.frame = CGRectMake(0, 0, 72, 72);
        _selectedView.image = TTImage(@"photo_seleted");
    }
    
    for (UIView * view in self.subviews) {
        
        [view removeFromSuperview];
    }
    
    [self addSubview:_selectedView];
    
    float startx = 8;
    float starty = 15;
    float width = 70;
    float height = 70;
    float sepx = 8;
    float sepy = 10;
    
    if ([photos count] == 0) {
        
        [_selectedView setHidden:YES];
    }
    
    for (int index = 0; index < [photos count]; index ++) {
        
        WTURLImageView * imageView = [[WTURLImageView alloc]initWithFrame:CGRectMake(startx + (width + sepx) * (index % 4),starty + (height + sepy) * (index / 4), width, height)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 1000 + index;
        [imageView setURL:photos[index] defaultImage:@"library" type:0];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 6.0;
        imageView.delegate = self;
        [self addSubview:imageView];
           
        if (self.type == 0) {
            
            UIButton * deleteButotn = [UIButton buttonWithType:UIButtonTypeSystem];
            [deleteButotn setBackgroundImage:TTImage(@"delete3") forState:UIControlStateNormal];
            
            if (self.isShowClose && self.headIndex != index) {
                
                [deleteButotn setHidden:NO];
                
            }else {
                
                [deleteButotn setHidden:YES];
            }
            
            [deleteButotn addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
            deleteButotn.frame = CGRectMake(imageView.right - 15, imageView.top - 15, 30, 30);
            deleteButotn.tag = 2000 + index;
            [self addSubview:deleteButotn];
        }
        
        /*if (type == 0) {
            
            UILongPressGestureRecognizer * longPressReg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
            [longPressReg setNumberOfTapsRequired:1];
            [imageView addGestureRecognizer:longPressReg];
            
            UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
            [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
            [imageView addGestureRecognizer:doubleTapGestureRecognizer];
         
        }*/
        
        
        if(self.type == 0){
           
            if (index == self.headIndex) {
                
                //UIButton * button = (UIButton *)[self viewWithTag:2000 + index];
                //[button setHidden:YES];
                [self selectAtIndex:imageView];
                
            }
            
        }
    }
    
    if (self.type == 0) {
        
        if ([photos count] < 8) {
            
            int index = [photos count];
            
            _picPlaceHolderView.frame = CGRectMake(startx + (width + sepx) * (index % 4),starty + (height + sepy) * (index / 4), width, height);
            
            [self addSubview:_picPlaceHolderView];
            
        }
    }
    
    if (self.type == 0) {
        
        if ([photos count] < 4) {
            
            self.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 80);
            
        }else {
            
            self.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 160);
        }
        
    }else {
        
        
        if ([photos count] <= 4) {
            
            self.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 90);
            
        }else {
            
            self.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 170);
        }
        
    }
}

#pragma mark - WTURLImageViewDelegate

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    if (self.type == 0) {
        
        if (self.headIndex == imageView.tag - 1000) {
            
            if (self.isShowClose) {
                
                self.isShowClose = NO;
                
                for (int index = 0; index < [self.photos count]; index ++) {
                    
                    
                    UIButton * button = (UIButton *)[self viewWithTag:2000 + index];
                    [button setHidden:YES];
                    
                }
            }
            
            return;
            
        }else {
            
            if (self.isShowClose) {
                
                self.isShowClose = NO;
                
                for (int index = 0; index < [self.photos count]; index ++) {
                    
                    
                    UIButton * button = (UIButton *)[self viewWithTag:2000 + index];
                    [button setHidden:YES];
                    
                }
                
               return;
                
            }else {
             
             /*   UIButton * button = (UIButton *)[self viewWithTag:2000 + self.headIndex];
                [button setHidden:NO];///把原来的不隐藏
                
                UIButton * button1 = (UIButton *)[self viewWithTag:imageView.tag - 1000 + 2000];
                [button1 setHidden:YES];////把选中的隐藏*/
                
                /////将选中框移到这个位置
                [self selectAtIndex:imageView];
                
                self.headIndex = imageView.tag - 1000;
                
            }

        }
    }
    
    ///发起请求去上传图片
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoHeaderViewDidClickPhotoActionWithIndex:type:)]) {
        
        [self.delegate photoHeaderViewDidClickPhotoActionWithIndex:imageView.tag - 1000 type:self.type];
    }
 }


- (void) URLImageViewDidDoubleClicked : (WTURLImageView*)imageView {
    
    if (self.type == 0) {
        if (!self.isShowClose) {
            
            int tag = imageView.tag;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoHeaderDidDoubleClickAtIndex:)]) {
                
                [self.delegate photoHeaderDidDoubleClickAtIndex:tag - 1000];
                
            }
        }else {
            
            self.isShowClose = NO;
            
            for (int index = 0; index < [self.photos count]; index ++) {
                
                
                UIButton * button = (UIButton *)[self viewWithTag:2000 + index];
                [button setHidden:YES];
                
            }
        }
    }
}
- (void) URLImageViewDidLongPressed : (WTURLImageView*)imageView {
    
    if (self.type == 0) {
        
        if (!self.isShowClose) {
            
            self.isShowClose = YES;
            
            for (int index = 0; index < [self.photos count]; index ++) {
                
                if (index != self.headIndex) {
                    
                    UIButton * button = (UIButton *)[self viewWithTag:2000 + index];
                    [button setHidden:NO];
                    
                }
            }
        }else {
            
            self.isShowClose = NO;
            
            for (int index = 0; index < [self.photos count]; index ++) {
                UIButton * button = (UIButton *)[self viewWithTag:2000 + index];
                [button setHidden:YES];
                
            }
        }
    }
}

#pragma mark - PicPlaceHeaderViewDelegate

- (void)picPlaceHlderViewDidClickAddAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoHeaderViewDidClickAddAction)]) {
        
        [self.delegate photoHeaderViewDidClickAddAction];
    }
}

#pragma mark - 手势
/*
- (void)longClick:(UIGestureRecognizer *)gesReg {
    
    if (gesReg.state == UIGestureRecognizerStateEnded) {
        
        if (!self.isShowClose) {
            
            self.isShowClose = YES;
            
            for (int index = 0; index < [self.photos count]; index ++) {
                
                if (index != self.headIndex) {
                    
                    UIButton * button = (UIButton *)[self viewWithTag:2000 + index];
                    [button setHidden:NO];

                }
            }
        }else {
            
            self.isShowClose = NO;
            
            for (int index = 0; index < [self.photos count]; index ++) {
                
            
                UIButton * button = (UIButton *)[self viewWithTag:2000 + index];
                [button setHidden:YES];
                    
            }
        }
        
    }
}*/
/*
- (void)doubleClick:(UIGestureRecognizer *)gesReg {
    
    
    if (gesReg.state == UIGestureRecognizerStateEnded) {
        
        
        if (!self.isShowClose) {
            
            int tag = gesReg.view.tag;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoHeaderDidDoubleClickAtIndex:)]) {
                
                [self.delegate photoHeaderDidDoubleClickAtIndex:tag - 1000];
                
            }
        }else {
            
            self.isShowClose = NO;
            
            for (int index = 0; index < [self.photos count]; index ++) {
                
                
                UIButton * button = (UIButton *)[self viewWithTag:2000 + index];
                [button setHidden:YES];
                
            }

        }
        
        
    }
}
*/
#pragma mark - Actions

- (void)delAction:(UIButton *)button {
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = button.tag + 1000;
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(photoHeaderViewDidClickDeleteActionIndex:)]) {
            
            [self.delegate photoHeaderViewDidClickDeleteActionIndex:alertView.tag - 3000];
        }
    }
}

#pragma mark - 

- (void)selectAtIndex:(WTURLImageView *)imageView {
    
    [self.selectedView setHidden:NO];
    
    self.selectedView.frame = CGRectMake(imageView.left -1,imageView.top -1 , imageView.width + 2 ,imageView.height  + 2 );
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
