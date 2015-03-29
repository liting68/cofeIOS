//
//  OfficeHeaderView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "OfficeHeaderView.h"


@implementation OfficeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/*
@property (weak, nonatomic) IBOutlet UILabel *activityName;//活动名称
@property (weak, nonatomic) IBOutlet UIScrollView *activityImgs;//图片展示scrollView

@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *activityAddr;
@property (weak, nonatomic) IBOutlet UILabel *activityPrice;

@property (weak, nonatomic) IBOutlet UILabel *activityPartinNums;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *activityIntro;
@property (weak, nonatomic) IBOutlet UIButton *gotoMapButton;
@property (weak, nonatomic) IBOutlet UIScrollView *partInScrollView;
*/
- (void)layoutWithActivityDic:(NSDictionary *)activityDic {
    
    self.activityImgs.pagingEnabled = YES;
    
    NSArray * topArr = [activityDic valueForKey:@"photos"];
    
    self.pageControl.numberOfPages =[topArr count];
    
    if ([topArr count] > 0) {
        
        for (int index = 0; index < [topArr count]; index ++) {
            
            NSDictionary * photo = topArr[index];            ///1000代表海报
            WTURLImageView * imageView = [[WTURLImageView alloc] initWithFrame:CGRectMake(index * K_UIMAINSCREEN_WIDTH, 0, K_UIMAINSCREEN_WIDTH, 260)];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 1000 +index;
            [imageView  setURL:[photo valueForKey:@"img"] defaultImage:@"venues_detail_defafault" type:1];
            imageView.delegate = self;
            [self.activityImgs addSubview:imageView];
        }
        
      self.activityImgs.contentSize = CGSizeMake([topArr count] * K_UIMAINSCREEN_WIDTH, self.activityImgs.height);
    }
    
    self.activityName.text = [activityDic valueForKey:@"title"];
  
    
    self.activityName.top = self.activityImgs.bottom + 8;
    
    self.activityIntro.top = self.activityName.bottom + 8;
    self.activityIntro.text = [activityDic valueForKey:@"content"];
    [self.activityIntro sizeToFit];

    self.locationView.top = self.activityIntro.bottom + 25;
    self.activityAddr.top = self.activityIntro.bottom + 25;
    self.activityAddr.text =[NSString stringWithFormat:@"%@", [activityDic valueForKey:@"address"]];
    [self.activityAddr sizeToFit];
    //self.activityAddr.delegate = self;

    self.userInteractionEnabled = YES;
    self.gotoMapButton.top = self.activityAddr.top;
    self.gotoMapButton.height = self.activityAddr.height;
    
    self.locationView.top = self.activityIntro.bottom + 25;

    self.timeView.top = self.activityAddr.bottom + 8;
    self.activityTime.top = self.activityAddr.bottom + 8;
    self.activityTime.text = [NSString stringWithFormat:@"%@",[activityDic valueForKey:@"datetime"]];
    
    self.height = self.activityTime.bottom + 15;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(officeHeaderViewDidUpdateSubViewSuccess)]) {
        
        [self.delegate officeHeaderViewDidUpdateSubViewSuccess];
    }
    
 }

- (IBAction)gotoMapAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(officeHeaderViewDidGotoMapView)]) {
        
        [self.delegate officeHeaderViewDidGotoMapView];
    }
}


#pragma mark - WTURLImageViewDelegate

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    if (imageView.tag < 2000) {//海报
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(officeHeaderViewClickBannerViewWithIndex:)]) {
            
            [self.delegate officeHeaderViewClickBannerViewWithIndex:imageView.tag- 1000];
        }
        
    }else{//头像
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(officeHeaderViewClickHeaderViewWithIndex:)]) {
            
            [self.delegate officeHeaderViewClickHeaderViewWithIndex:imageView.tag - 2000];
        }
        
    }
}

#pragma mark - UIScrollDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int page = scrollView.contentOffset.x/K_UIMAINSCREEN_WIDTH;
    
    self.pageControl.currentPage = page;
    
}

- (void)customLabelDidTapAction:(CustomLabel *)customLabel {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(officeHeaderViewDidGotoMapView)]) {
        
        [self.delegate officeHeaderViewDidGotoMapView];
    }
}

- (void)customLabelDidLongPressAction:(CustomLabel *)customLabel {
    
    
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
