//
//  WantDrinkSubView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-29.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "WantDrinkSubView.h"

@implementation WantDrinkSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutWithData:(NSDictionary *)data {
    
    NSString * name = nil;
    
    if ([AppUtil isNotNull:[data valueForKey:@"nick_name"]]) {
        name = [data valueForKey:@"nick_name"];
    }else{
        name = [data valueForKey:@"user_name"];
    }
    self.nackName.text = name;
    
    if ([AppUtil isNotNull:[data valueForKey:@"distance"]]) {
        
        if ([[data valueForKey:@"distance"] isEqualToString:@"无法定位距离"]) {
            
            self.distance.text = @"无法定位距离";
            
        }else {
            
            self.distance.text = [NSString stringWithFormat:@"%@km",[data valueForKey:@"distance"]];
        }
        
    }else {
        
        self.distance.text = @"无法定位距离";
    }
    
    [self.distance sizeToFit];
     self.distance.right = 140;
     self.locaView.right = self.distance.left - 2;
}

@end
