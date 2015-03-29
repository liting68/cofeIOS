//
//  EvaluateCofeViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseViewController.h"

@interface EvaluateCofeViewController : BaseViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic)NSString * cateTitle;

@property (strong, nonatomic)NSString * cafeID;

@property (strong, nonatomic) NSString * eventID;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@end
