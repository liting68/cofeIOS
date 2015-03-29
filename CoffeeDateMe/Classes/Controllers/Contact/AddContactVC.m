//
//  AddContactVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/14. 
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "AddContactVC.h"
#import "MessageViewController.h"

@interface AddContactVC ()


@end

@implementation AddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    
    [self forNavBeNoTransparent];
    
    [self initBackButton];
    
    [self initTitleViewWithTitleString:@"添加好友"];
    
    self.textField.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [self hideTabBar];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self searchAction:nil];
    
    return YES;
}

#pragma mark - Actions

- (IBAction)searchAction:(id)sender {
    
    NSString * keyName = self.textField.text;
    
    if ([AppUtil isNotNull:keyName]) {///
        
        ///////////////////////////////////
        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController * messageViewController = [board instantiateViewControllerWithIdentifier:@"MessageViewController"];
        messageViewController.keyword = keyName;
        messageViewController.type = 4;
        
        [self.navigationController pushViewController:messageViewController animated:YES];

        
    }else {
        
        [AppUtil HUDWithStr:@"请输入搜索关键字" View:self.view];
   }
    
}
- (IBAction)nebAction:(id)sender {
        
        ///////////////////////////////////
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController * messageViewController = [board instantiateViewControllerWithIdentifier:@"MessageViewController"];
    messageViewController.type = 6;
        
    [self.navigationController pushViewController:messageViewController animated:YES];
}

- (IBAction)mailAction:(id)sender { /////////手机号
    
    ABAddressBookRef addressBook = nil;
   
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
      
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else {
        addressBook = ABAddressBookCreateWithOptions(NULL,NULL);
    }
    
    if (addressBook != nil) {
        
        NSMutableString * mobileString = [[NSMutableString alloc] initWithCapacity:0];
        
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
       
        for (NSUInteger i = 0; i < [allContacts count]; i++) {
          
            
          ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
         /*   NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *companyName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonOrganizationProperty);
            
            NSMutableString *displayName = [[NSMutableString alloc] init];
            if (firstName != nil)
                [displayName appendString:firstName];
            if (lastName != nil)
                [displayName appendString:lastName];
            if (companyName.length > 0)
                [displayName appendString:companyName];
            
            if (displayName.length == 0)
                continue;*/
            
            // phone
            ABMultiValueRef phones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            
            for (NSInteger j = 0; j < ABMultiValueGetCount(phones); ++j) {
                NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, j);
                NSLog(@"tel:%@\n",phone);
              
                if([AppUtil isNotNull:phone]) {
                    
                    if ([mobileString length] == 0) {
                        [mobileString appendFormat:@"%@",phone];
                        
                    }else {
                         [mobileString appendFormat:@",%@",phone];
                        
                    }
                    
                }
            }
        }
        
        NSString * tempString = [mobileString stringByReplacingOccurrencesOfString:@"-" withString:@""];

        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController * messageViewController = [board instantiateViewControllerWithIdentifier:@"MessageViewController"];
        messageViewController.type = 5;
        messageViewController.mobile = tempString;
        [self.navigationController pushViewController:messageViewController animated:YES];
    }else {
        
        UIAlertView * alertVIew = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设置->隐私->通讯录中允许app访问您的通讯录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertVIew show];
        
//        [AppUtil HUDWithStr:@"请在设置->隐私->通讯录中允许app访问您的通讯录" View:self.view];
    }
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark -

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
