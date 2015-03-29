//
//  PostLeaveWordViewController.m
//  CoffeeDateMe It's waste a month salary.
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "PostLeaveWordViewController.h"
#import "NeborCoffeeVenuesViewController.h"
#import "UIColor+expanded.h"

@interface PostLeaveWordViewController ()<NeborCoffeeSelectedDelegate>
{
     UIDatePicker *birthDatePicker;
      BOOL datePickerSwitch;
}
@property (retain, nonatomic) UIView * selectDayView;

@end

@implementation PostLeaveWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavView];
    [self initBackButton];
    [self forNavBeNoTransparent];
    [self initTitleViewWithTitleString:@"发起约会"];


    _topicField.delegate = self;
    _topicField.textColor = [UIColor colorWithHexString:@"0x949494"];
    _dateObject.delegate = self;
      _dateObject.textColor = [UIColor colorWithHexString:@"0x949494"];
    _dateTime.delegate = self;
      _dateTime.textColor = [UIColor colorWithHexString:@"0x949494"];
    _addrField.delegate = self;
      _addrField.textColor = [UIColor colorWithHexString:@"0x949494"];
    
     _payTypeField.textColor = [UIColor colorWithHexString:@"0x949494"];
    
    if ([AppUtil isNotNull:self.venuesSelected]) {
        
        self.addrField.text = [self.venuesSelected valueForKey:@"address"];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self hideTabBar];
}

#pragma mark - NeborCoffeeSelectedDelegate

- (void)venuesDidSelectedSuccess:(NSDictionary *)venues {
    
    NSLog(@"%@",venues);
    
    self.venuesSelected = [NSDictionary dictionaryWithDictionary:venues];
    
    self.addrField.text = [venues valueForKey:@"address"];
    
}

#pragma mark - Action

- (void)backAction {
    
    if (self.isRoot) {
        
        [self.slideMenuController closeMenuBehindContentViewController:self.slideMenuController.rootViewController animated:YES completion:^(BOOL finished) {
            
        }];
     
    }else if(self.isPresent) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        
        }];
        
     
    }else {
        
          [self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)submitAction:(id)sender {
    
    NSString * topic = _topicField.text;
    
    if ([AppUtil isNull:topic]) {
        
        [AppUtil HUDWithStr:@"请输入主题" View:self.view];
        return;
    }
 
    NSString * dateObject = _dateObject.text;
    
    if ([AppUtil isNull:dateObject]) {
        
        [AppUtil HUDWithStr:@"请选择约会对象" View:self.view];
        
        return;
    }
    
    NSString * datetitme = _dateTime.text;
    
    if ([AppUtil isNull:datetitme]) {
        
        [AppUtil HUDWithStr:@"请选择时间" View:self.view];
        
        return;
    }
    
    NSString * addr = self.addrField.text;//[self.venuesSelected valueForKey:@"address"];
    
    NSString * shopID = [self.venuesSelected valueForKey:@"id"];
    
    if ([AppUtil isNull:self.venuesSelected]) {
        
        [AppUtil HUDWithStr:@"请选择地点" View:self.view];
        
        return;
    }
    
    NSString * payType = _payTypeField.text;
    
    if ([AppUtil isNull:payType]) {
        
        [AppUtil HUDWithStr:@"请选择付款类型" View:self.view];
    }
   

    NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (!userID) {
        
        [self gotoLogin];
        
        return;
    }
    
    //差一个付款类型
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"eventPublic",@"act",userID,@"userid",topic,@"title",dateObject,@"dating",datetitme,@"datetime",addr,@"address",payType,@"paytype",shopID,@"shopid", nil];
    
        
       [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         Response * response = [self parseJSONValueWithJSONString:responseObject];
         
         if (response.err == 1) {
         
            [AppUtil HUDWithStr:@"活动添加成功" View:self.view ];
         
             [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
             
        
         }
         
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         }];
}

- (void)uploadImageSuccess:(NSDictionary *)dictionary {
    
   Response * response = [self parseJSONValueWithJSONString:dictionary];
    
    if (response.err == 1) {
        
        [AppUtil HUDWithStr:@"活动添加成功" View:self.view ];
        
        [self popController];
        
    }

}

#pragma mark - actions

- (IBAction)selectTimeAction:(id)sender {
    
    [_topicField resignFirstResponder];
    [_dateObject resignFirstResponder];
    [_dateTime resignFirstResponder];
    [_addrField resignFirstResponder];
    
   // [UIView animateWithDuration:0.3 animations:^{
     //   self.view.top = (20 - self.nSpaceNavY) + 44;
  //  }];
    
    UIButton * button = (UIButton *)sender;
    
    if (button.tag == 100) {/////选择时间
        
        if (!_selectDayView) {
            
            _selectDayView = [[UIView alloc] initWithFrame:CGRectMake(0, K_UIMAINSCREEN_HEIGHT + 30, K_UIMAINSCREEN_WIDTH, 186 + 30)];
            _selectDayView.backgroundColor= [UIColor colorWithWhite:0.922 alpha:1.000];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]];//[UIColor yellowColor];
            birthDatePicker = [[UIDatePicker alloc] init];
            birthDatePicker.frame = CGRectMake(0, 30, K_UIMAINSCREEN_WIDTH, 186);
            birthDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
            
            // 完成按钮
            //    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            // toolbar.barStyle = UIBarStyleBlackTranslucent;
            
            UIView * toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 30)];
            
            toolbar.backgroundColor = [UIColor whiteColor];
            
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 60, 30);
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cancelPress) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor colorWithRed:0.043 green:0.368 blue:0.792 alpha:1.000] forState:UIControlStateNormal];
            [toolbar addSubview:button];
            
            
            UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = CGRectMake(K_UIMAINSCREEN_WIDTH - 60, 0, 60, 30);
            [button1 setTitle:@"完成" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(donePress) forControlEvents:UIControlEventTouchUpInside];
            [button1 setTitleColor:[UIColor colorWithRed:0.043 green:0.368 blue:0.792 alpha:1.000] forState:UIControlStateNormal];
            [toolbar addSubview:button1];
            
            [_selectDayView addSubview:toolbar];
            
            [_selectDayView addSubview:birthDatePicker];
            
          //  [self.view addSubview:_selectDayView];
            [self.view insertSubview:_selectDayView aboveSubview:_postButton];
        }
        
        NSDate *maxDate = [NSDate date];
        
        birthDatePicker.minimumDate = maxDate;
        
        birthDatePicker.date = maxDate;
        
        if (!datePickerSwitch) {
            // 弹出动画
            datePickerSwitch = !datePickerSwitch;
            
            CGRect rect = _selectDayView.frame;
            rect.origin.y = K_UIMAINSCREEN_HEIGHT - 216;
            
            [UIView animateWithDuration:0.3 animations:^{
                
                _selectDayView.frame = rect;
            }];
            
        }else {
            
            [self dismissDatePicker];
        }

    }else if (button.tag == 101){ //选择地点--跳转
        
        NeborCoffeeVenuesViewController * neboroffeeVC = [self getStoryBoardControllerWithControllerID:@"NeborCoffeeVenuesViewController"];
        
        neboroffeeVC.type = 0;
        
        neboroffeeVC.delegate = self;
        
        [self.navigationController pushViewController:neboroffeeVC animated:YES];
        
    }else if (button.tag == 102) {
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不限",@"男",@"女", nil];
        actionSheet.tag = 1002;
        [actionSheet showInView:self.view];
    
        
    }else if(button.tag == 103) {
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"AA",@"请我吧",@"我买单", nil];
        actionSheet.tag = 1003;
        [actionSheet showInView:self.view];

    }

}

- (void)donePress {
    /////设置值
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *date = [formatter stringFromDate:[birthDatePicker date]];
    _dateTime.text = date;
    [self dismissDatePicker];
}

- (void)cancelPress {
    
    [self dismissDatePicker];
}

-(void) dismissDatePicker {
    
    datePickerSwitch = !datePickerSwitch;
    
    CGRect rect = _selectDayView.frame;
    
    rect.origin.y = K_UIMAINSCREEN_HEIGHT;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _selectDayView.frame = rect;
    }];
}

#pragma mark - impletement super Method

- (void)selectImageSuccess:(UIImage *)image {
    
    BLMCutImageViewController *cutImageCtl = [[BLMCutImageViewController alloc] init];
    
    cutImageCtl.uploadImage = image;
    
    cutImageCtl.scaleX = 2;
    
    cutImageCtl.scaleY = 1;
    
    cutImageCtl.delegate = self;
    
    [self.navigationController pushViewController:cutImageCtl animated:NO];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex < 3) {
        
        if (actionSheet.tag == 1002) {
            
            if (buttonIndex == 0) {
                
                self.dateObject.text = @"不限";
            
            }else if (buttonIndex == 1){
                
                self.dateObject.text = @"男";
            
            }else {
                
                self.dateObject.text = @"女";
            }
            
        }else {
            
            if (buttonIndex == 0) {
                
                self.payTypeField.text = @"AA";
                
            }else if (buttonIndex == 1){
                
                self.payTypeField.text = @"请我吧";
                
            }else {
                
                self.payTypeField.text = @"我买单";
            }

            
        }
        
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
    
        [textView resignFirstResponder];

       /* [UIView animateWithDuration:0.3 animations:^{
            self.view.top = (20 - self.nSpaceNavY) + 44;
        }];*/

    }

    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
  //  [UIView animateWithDuration:0.3 animations:^{
    //    self.view.top = -16;
        
   // }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (textField == _dateTime || textField == _addrField) {
        
     /*   [UIView animateWithDuration:0.3 animations:^{
            self.view.top = -16;
            
        }];*/
        
    }else {
        
       /* [UIView animateWithDuration:0.3 animations:^{
            self.view.top = (20 - self.nSpaceNavY) + 44;
            
        }];*/
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
 
     [textField resignFirstResponder];
        
  /*  [UIView animateWithDuration:0.3 animations:^{
           self.view.top = (20 - self.nSpaceNavY) + 44;
    }];*/
    return YES;
}

#pragma mark - Meomry Manage

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
