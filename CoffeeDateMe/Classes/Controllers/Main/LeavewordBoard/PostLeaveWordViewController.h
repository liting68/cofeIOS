//
//  PostLeaveWordViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "BLMCutImageViewController.h"

@interface PostLeaveWordViewController : BaseViewController<UITextFieldDelegate,UITextViewDelegate,BLMCutImageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *topicField;

@property (weak, nonatomic) IBOutlet UITextField *dateObject;

@property (weak, nonatomic) IBOutlet UITextField *dateTime;

@property (weak, nonatomic) IBOutlet UITextField *addrField;

@property (weak, nonatomic) IBOutlet UITextField *payTypeField;

@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (strong, nonatomic)NSString * imgURL;

@property (weak, nonatomic) IBOutlet UIButton *selectTimeButotn;

/////////////////////////进入的咖啡厅
@property (strong,nonatomic)NSDictionary * venuesSelected;
/////////////////////////////////////////////////////
@property (assign, nonatomic) BOOL isRoot;

@property (assign, nonatomic)BOOL isPresent;

@end
