//
//  OtherUserHeaderView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-11-29.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "OtherUserHeaderView.h"

@implementation OtherUserHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutWithDic:(NSDictionary *)responseObject {
    
    if ([AppUtil isNull:[responseObject valueForKey:@"sex"]]) {
        
        self.sexFlag.image = TTImage(@"nv");
        
       // [self updateTitleWithTitle:@"她的活动"];
        
    }else {
        
        int  sex = [[responseObject valueForKey:@"sex"] intValue];
        
        if (sex == 1) {//男的图标
            
            self.sexFlag.image = TTImage(@"nan");
            
           // [self updateTitleWithTitle:@"他的活动"];
            
        }else {
            
            self.sexFlag.image = TTImage(@"nv");
            
            //[self updateTitleWithTitle:@"她的活动"];
        }
    }
    
    if ([AppUtil isNull:[responseObject valueForKey:@"address"]]) {
        
        self.addressLabel.text = @"";
    }else {
        
        NSString * cafeNum =  [responseObject valueForKey:@"address"];
        self.addressLabel.text = cafeNum;
    }
    
    
    if ([AppUtil isNull:[responseObject valueForKey:@"user_name"]]) {
        
        self.coffeeNumber.text = @"";
    }else {
        
        NSString * cafeNum =  [responseObject valueForKey:@"user_name"];
        self.coffeeNumber.text = cafeNum;
    }
    
    if ([AppUtil isNotNull:[responseObject valueForKey:@"distance"]]) {
        
        if ([[responseObject valueForKey:@"distance"] isEqualToString:@"无法定位距离 "]) {
            
            self.postTime.text = @"[无法定位距离]";
            
        }else {
            
            self.postTime.text = [NSString stringWithFormat:@"[%@千米]",[responseObject valueForKey:@"distance"]];
            
        }
        
    }else {
        self.postTime.text = @"[无法定位距离]";
    }
    
    /*   if ([AppUtil isNull: [responseObject valueForKey:@"talk"]]) {
     
     self.bestSpecInfo.text = @"";
     }else {
     NSString * talk = [responseObject valueForKey:@"talk"];
     self.bestSpecInfo.text = talk;
     }*/
    
    
    if ([AppUtil isNotNull:[responseObject valueForKey:@"constellation"]]) {
        
        NSString * constellation = [responseObject valueForKey:@"constellation"];//星座
        self.xingzuoLabel.text = constellation;
    }
    
    
    if ([AppUtil isNotNull: [responseObject valueForKey:@"created"]]) {
        NSString * createed = [responseObject valueForKey:@"created"];
        self.registerDate.text = createed;
        
    }
    
    if ([AppUtil isNotNull:[responseObject valueForKey:@"career"]]) {
        
        NSString * career = [responseObject valueForKey:@"career"];
        self.job.text = career;
        
    }
    

    
    if ([AppUtil isNotNull:[responseObject valueForKey:@"home"]]) {
        
        NSString * home = [responseObject valueForKey:@"home"];//家乡
        self.homeTown.text = home;
    }
    
    
    if ([AppUtil isNotNull: [responseObject valueForKey:@"interest"]]) {
        
        NSString * interest = [responseObject valueForKey:@"interest"];
        self.xqahLabel.text = interest;
        
        [self.xqahLabel sizeToFit];
    }
    
    if([AppUtil isNotNull:[responseObject valueForKey:@"relation"]]){
        
        NSString * relation = [responseObject valueForKey:@"relation"];
        
        self.releation.text = relation;
        
     /*   if ([relation isEqualToString:@"黑名单"]) {////黑名单
            
         //   self.isBlack = YES;
            
           // [_buttomBarView updatePullBlackWithFlag:NO];
            
        }else {
            
          //  self.isBlack = NO;
            
           // [_buttomBarView updatePullBlackWithFlag:YES];
        }*/
    }
    
    /*****
     只差一个时间
     ***/
    
    if ([AppUtil isNotNull:[responseObject valueForKey:@"lasttime"]]) {
        
        self.distanceLabel.text = [responseObject valueForKey:@"lasttime"];
    }
    
    
    if ([AppUtil isNotNull: [responseObject valueForKey:@"signature"]]) {
        
        NSString * signature1 = [responseObject valueForKey:@"signature"];
        
        self.gxqmLabel.text = signature1;
        
        
        // CGFloat maxHeight = 9999;
        
        //     CGSize textSize = [self.gxqmLabel.text sizeWithFont:self.gxqmLabel.font
        //                             constrainedToSize:CGSizeMake(self.gxqmLabel.width, maxHeight)
        //  lineBreakMode:self.gxqmLabel.lineBreakMode];
        
        self.gxqmLabel.height = 9999;
        
        [self.gxqmLabel sizeToFit];
        
        //   self.gxqmLabel.height = textSize.height;
        
        
      
        
    }
    
    self.otherView.top = self.gxqmLabel.bottom + 17;
    
    self.height = self.otherView.bottom + 44;
    
    
    
    //[self.postTime sizeToFit];
    
    // [self.distanceLabel sizeToFit];
    
    //   self.distanceLabel.left = self.postTime.right + 20;
    
    
  /* NSArray * photoArr = [responseObject valueForKey:@"user_photos"];
    
    int headIndex = 0;
    int index = 0;
    
    if ([photoArr count] > 0) {
        
        NSMutableArray * images = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSDictionary * dic in photoArr) {
            
            [images addObject:[dic valueForKey:@"path"]];
            
            if ([[dic valueForKey:@"ishead"] intValue] == 1) {
                
                headIndex = index;
                self.headID = [[dic valueForKey:@"id"] intValue];
            }
            
            index ++;
        }
        _imageArr = images;
        
        _photoHeaderView = [[PhotoHeaderView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 0)];
        [_photoHeaderView layoutWithType:1 Photos:images headIndex:headIndex];
        _photoHeaderView.delegate = self;
        _photoHeaderView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = _photoHeaderView;
    }*/

}

@end
