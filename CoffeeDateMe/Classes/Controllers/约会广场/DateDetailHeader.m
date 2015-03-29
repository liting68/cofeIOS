//
//  DateDetailHeader.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/14.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "DateDetailHeader.h"

@implementation DateDetailHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)gotoMapAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dateDetailHeaderDidGotoMap)]) {
        
        [self.delegate dateDetailHeaderDidGotoMap];
    }
}

- (void)layoutWithDic:(NSDictionary *)dic {
    
    
    NSDictionary * user = [dic valueForKey:@"user"];
    
    [self.showView setURL:[dic valueForKey:@"shopimg"] defaultImage:@"dateDetail_default" type:1];
    self.showView.delegate = self;
    self.showView.userInteractionEnabled = YES;
    
    [self.avatarView setURL:[user valueForKey:@"head_path"] defaultImage:@"default_avatar" type:1];
    [self.avatarView setConers];
    
    self.cafeName.text = [user valueForKey:@"nick_name"];
    
    int sex = [[user valueForKey:@"sex"] intValue];
    
    if (sex == 1) {///男女
        
        self.postSexView.image = TTImage(@"wantD_nan");
        self.xzBg.image = TTImage(@"xingzuo_boy_Bg");
        self.ageLabel.textColor = [UIColor colorWithRed:0.682 green:0.851 blue:0.961 alpha:1.000];
        
    }else if(sex == 2) {
     
        self.postSexView.image = TTImage(@"wantD_nv");
        self.xzBg.image = TTImage(@"xingzuo_nv_Bg");
        self.ageLabel.textColor = [UIColor colorWithRed:0.961 green:0.407 blue:0.618 alpha:1.000];
  
    }else  {
        
        self.postSexView.image = TTImage(@"buxian");
        self.xzBg.image = TTImage(@"xingzuo_none");
        self.ageLabel.textColor = [UIColor colorWithWhite:0.537 alpha:1.000];
    }
    
    ///先不写
    if ([AppUtil isNotNull:[user valueForKey:@"age"]]) {
        
        self.ageLabel.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"age"]];
        
    }else {
    
        self.ageLabel.text = @"0";
                                
    }

    self.xzLabel.text = [user valueForKey:@"constellation"];
    
    self.actiLabel.text = [dic valueForKey:@"title"];
    
    self.postTime.text = [dic valueForKey:@"created"];
    
    self.payTypeLabel.text = [dic valueForKey:@"pay_type"];
    
    NSString * date = [dic valueForKey:@"dating"];
    
    if ([date isEqualToString:@"男"]) {
        
          self.dateObject.text = @"限男生";
        self.dateObjectIcon.image = TTImage(@"boy");
        
    }else if([date isEqualToString:@"女"]) {
        
       self.dateObject.text = @"限女生";
        self.dateObjectIcon.image = TTImage(@"girl");
    
    }else {
        
        self.dateObject.text = @"不限";
        self.dateObjectIcon.image = TTImage(@"buxian");
    }

    
    self.dateAddr.text = [dic valueForKey:@"address"];
    
    self.dateTime.text = [dic valueForKey:@"datetime"];

}

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(dateDetailHeaderDidGotoShop)]){
        
        [self.delegate dateDetailHeaderDidGotoShop];
    }
    
    
}

@end
