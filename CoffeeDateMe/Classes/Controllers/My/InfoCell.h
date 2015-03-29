//
//  InfoCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/16.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoCell;

@protocol InfoCellDelegate <NSObject>

- (void)infoCell:(InfoCell *)infoCell didChangeValue:(NSString *)value;

@end


@interface InfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (weak, nonatomic) IBOutlet UITextField *hintField;

@property (assign, nonatomic) id<InfoCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@end
