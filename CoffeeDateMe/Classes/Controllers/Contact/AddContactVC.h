//
//  AddContactVC.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/14.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"
 #import <AddressBook/AddressBook.h>

@interface AddContactVC : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
