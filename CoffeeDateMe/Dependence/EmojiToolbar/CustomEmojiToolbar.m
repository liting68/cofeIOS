//
//  EmojiTextView.m
//  GrowingTextViewExample
//
//  Created by jimcky lin on 13-6-6.
//
//

#import "CustomEmojiToolbar.h"

#define Emoji @"emoji"
#define MARGIN_HEIGHT (SYSTEM_BIGTHAN_7?20:0)
#define Margin_H (SYSTEM_BIGTHAN_7?0:44)
#define Margin (Margin_H)
#define Time  0.25
#define keyboardHeight 216

@implementation CustomEmojiToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)addNotificatons {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emojiKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emojiKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)removeNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
    
}


-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 注册通知
        
        self.theSuperView = superView;
        
        CGRect rect = self.theSuperView.bounds;
        rect.size.height = rect.size.height - 40 - 216;
        
        _backView = [[UIView alloc] initWithFrame:rect];
        _backView.backgroundColor = [UIColor clearColor];
       [_backView setHidden:YES];
        [self.theSuperView addSubview:_backView];
        
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        tapRecognizer.numberOfTapsRequired = 1;
        [_backView addGestureRecognizer:tapRecognizer
         ];
        
        ///////////////////////
        self.backgroundColor = [UIColor colorWithRed:0.283 green:0.189 blue:0.098 alpha:1.000];
        //UIImageView * backView = [[UIImageView alloc]initWithFrame:self.bounds];
       // backView.image = [UIImage imageNamed:@"toolBar_back.png"];
       // [self addSubview:backView];
        /////////
    
        // 文本框
        textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 3, 265, 34)];
        textView.backgroundColor = [UIColor whiteColor];
        textView.contentSize = CGSizeMake(textView.frame.size.width, 30);
       // textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
       //textView.backgroundColor = [UIColor clearColor];
       //textView.minNumberOfLines = 1;
       //textView.maxNumberOfLines = 5;
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = YES;
        textView.returnKeyType = UIReturnKeyDone; //just as an example
        textView.font = [UIFont systemFontOfSize:15.0f];
        textView.delegate = self;
        [self addSubview:textView];
    /*    emojiScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, K_UIMAINSCREEN_HEIGHT, K_UIMAINSCREEN_WIDTH, keyboardHeight)];
        // 表情界面
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, keyboardHeight)];
        scrollView.delegate = self;
        scrollView.bounces = NO;
        [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
        [scrollView setContentSize:CGSizeMake(K_UIMAINSCREEN_WIDTH * 4, emojiScrollView.frame.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.userInteractionEnabled = YES;
        [emojiScrollView addSubview:scrollView];
        
        for (int page = 0; page < 63/12+1; page ++) {
            CGRect rect = scrollView.bounds;
            rect.origin.x = K_UIMAINSCREEN_WIDTH * page;
            rect.size.height = 180;
            FacialView *facialView = [[FacialView alloc] initWithFrame:rect];
            facialView.delegate = self;
            [scrollView addSubview:facialView];
        }
        [superView addSubview:emojiScrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, emojiScrollView.frame.size.height - 40, K_UIMAINSCREEN_WIDTH, 20)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.numberOfPages = 4;
        _pageControl.currentPage = 0;
        [emojiScrollView addSubview:_pageControl];
        
        [self addSubview:textView];
        
                // 表情按钮
        emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        emojiBtn.frame = CGRectMake(7, 7, 26, 26);
        [emojiBtn setBackgroundImage:TTImage(Emoji) forState:UIControlStateNormal];
        [emojiBtn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        emojiBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:emojiBtn];*/
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(self.frame.size.width - 38, 3, 35, 35);
        doneBtn.tag = 3000;
        doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [doneBtn setTitle:@"发送" forState:UIControlStateNormal];
        
        [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0.917 alpha:0.400] forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(resignTextView:) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"set_submit.png"] forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"set_submit.png"] forState:UIControlStateSelected];
        [self addSubview:doneBtn];
       
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        [self.theSuperView addSubview:self];
    }
    
    return self;
}

- (void)resignClick {
    
    [self resignTextView:nil];
    
    [_backView setHidden:YES];
}

- (void)tapAction {
    
    [self resignClick];
    
}

-(void)resignTextView:(id)sender
{
    [_backView setHidden:YES];
    
	[textView resignFirstResponder];

    isFirstClickFaceBtn = NO;
  
    [emojiBtn setBackgroundImage:TTImage(Emoji) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:Time animations:^{
        self.frame = CGRectMake(self.frame.origin.x, K_UIMAINSCREEN_HEIGHT - self.frame.size.height - 64 ,  self.frame.size.width,self.frame.size.height);
    }];
    
    [UIView animateWithDuration:Time animations:^{
        emojiScrollView.frame = CGRectMake(self.frame.origin.x, self.theSuperView.frame.size.height,  self.frame.size.width,self.frame.size.height);
    }];
    
    if (sender) {
        
         NSString * sendText = textView.text;
        
        if (![textView.text isEqualToString:@""]) {
            
            NSArray * tempArray = [NSArray arrayWithObjects:
                                   @"/OK",
                                   @"/飞吻",
                                   @"/恭喜",
                                   @"/欢乐",
                                   @"/就是你",
                                   @"/害羞",
                                   @"/胜利",
                                   @"/拍头",
                                   @"/盘算",
                                   @"/亲亲",
                                   @"/招财",
                                   @"/真棒",
                                   nil];
            
            for (int index = 0; index < 12; index ++) {
                
                NSString * beReplace = [tempArray objectAtIndex:index];
                
                NSString * tempString = nil;
                
                if (index < 10) {
                    
                    tempString = [NSString stringWithFormat:@"f00%d",index];
                    
                }else{
                    
                    tempString = [NSString stringWithFormat:@"f0%d",index];
                }
                
                [sendText stringByReplacingOccurrencesOfString:beReplace withString:tempString];
                
            }
        }
        if ([_delegate respondsToSelector:@selector(emojiToolbarSendBtnDidClick:sendString:)]) {
            
            [_delegate emojiToolbarSendBtnDidClick:self sendString:sendText];
        }
        
         //textView.text = @"";
    }
}

- (void)setContentText:(NSString *)content {
    
    NSLog(@"重新设置:%@",content);
    
    textView.text = content;
}

-(void)resignTextView2:(id)sender
{
    
	[textView resignFirstResponder];
    isFirstClickFaceBtn = NO;
    [emojiBtn setBackgroundImage:TTImage(Emoji) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:Time animations:^{
        
        self.frame = CGRectMake(self.frame.origin.x, K_UIMAINSCREEN_HEIGHT - self.frame.size.height - 64 ,  self.theSuperView.bounds.size.width,self.frame.size.height);
        
    }];
    
    [UIView animateWithDuration:Time animations:^{
        emojiScrollView.frame = CGRectMake(self.frame.origin.x, self.theSuperView.frame.size.height,  self.theSuperView.bounds.size.width,self.frame.size.height);
    }];
    
    textView.text = @"";
}


-(void)hiddenTextView{
    
    [textView resignFirstResponder];
    isFirstClickFaceBtn = NO;
    [emojiBtn setBackgroundImage:TTImage(Emoji) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:Time animations:^{
        
        self.frame = CGRectMake(self.frame.origin.x, K_UIMAINSCREEN_HEIGHT - self.frame.size.height - 64 - Margin,  self.theSuperView.bounds.size.width,self.frame.size.height);
        
    }];
    
    [UIView animateWithDuration:Time animations:^{
        emojiScrollView.frame = CGRectMake(self.frame.origin.x, self.theSuperView.frame.size.height,  self.theSuperView.bounds.size.width,self.frame.size.height);
    }];
    
    textView.text = @"";
}

// 键盘将要显示通知

-(void) emojiKeyboardWillShow:(NSNotification *)note{
  
    [_backView setHidden:NO];
    
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.theSuperView convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = self.frame;
    
    containerFrame.origin.y = K_UIMAINSCREEN_HEIGHT - (keyboardBounds.size.height + containerFrame.size.height) - 64;
   
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	self.frame = containerFrame;
	[UIView commitAnimations];
    
    keyboardIsShow = YES;
    [emojiBtn setBackgroundImage:TTImage(Emoji) forState:UIControlStateNormal];
    [UIView animateWithDuration:Time animations:^{
        [emojiScrollView setFrame:CGRectMake(self.frame.origin.x, self.theSuperView.frame.size.height,self.frame.size.width, keyboardHeight)];
    }];
    
}

// 键盘将要隐藏通知

-(void) emojiKeyboardWillHide:(NSNotification *)note{
    
    keyboardIsShow = NO;
}

#pragma mark - button action

// 头像点击
- (void)avatarBtnClick:(id)sender{
    
    [_backView setHidden:YES];
    
    [self resignTextView:nil];
   
    [_delegate emojiToolbarAvatarBtnClick];
    
}

// 点击表情按钮

- (void)emojiBtnClick:(id)sender{
    
    [_backView setHidden:NO];
    
    if (keyboardIsShow) {
        
        [UIView animateWithDuration:Time animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.theSuperView.frame.size.height-keyboardHeight-self.frame.size.height+MARGIN_HEIGHT-Margin,  self.bounds.size.width,self.frame.size.height);
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [emojiScrollView setFrame:CGRectMake(self.frame.origin.x, self.theSuperView.frame.size.height - keyboardHeight + MARGIN_HEIGHT,self.frame.size.width, keyboardHeight)];
        }];
        [textView resignFirstResponder];
    
    }
    else{
        
        [UIView animateWithDuration:Time animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.theSuperView.frame.size.height-keyboardHeight-self.frame.size.height+MARGIN_HEIGHT-Margin,  self.bounds.size.width,self.frame.size.height);
        }];
        
        if (!isFirstClickFaceBtn) { // 第一次点击表情按钮
            
            [UIView animateWithDuration:Time animations:^{
                [emojiScrollView setFrame:CGRectMake(self.frame.origin.x, self.theSuperView.frame.size.height - keyboardHeight+MARGIN_HEIGHT,self.frame.size.width, keyboardHeight)];
            }];
            
            isFirstClickFaceBtn = YES;
       
        }else{
            
            [UIView animateWithDuration:Time animations:^{
                [emojiScrollView setFrame:CGRectMake(self.frame.origin.x, self.theSuperView.frame.size.height+MARGIN_HEIGHT ,self.frame.size.width, keyboardHeight)];
            }];
            [textView becomeFirstResponder];
            [emojiBtn setBackgroundImage:TTImage(Emoji) forState:UIControlStateNormal];
        }

    }
}

#pragma mark - FacialViewDelegate

- (void)selectedFacialView:(NSString *)facialString{

    NSString *newText = [NSString stringWithFormat:@"%@%@",textView.text,facialString];
    
    textView.text = newText;
    
    textView.contentOffset = CGPointMake(0,textView.contentSize.height - 34);

}

- (void)clearText{
    
    textView.text = @"";
}

-(void)emojiHidden{
    
    emojiScrollView.hidden = YES;
}

- (void)dealloc
{
      _delegate = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint point = scrollView.contentOffset;
    
    int page = point.x/K_UIMAINSCREEN_WIDTH;
    
    _pageControl.currentPage = page;
}


#pragma mar - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSArray * tempArray = [NSArray arrayWithObjects:
                           @"/OK",
                           @"/飞吻",
                           @"/恭喜",
                           @"/欢乐",
                           @"/就是你",
                           @"/害羞",
                           @"/胜利",
                           @"/拍头",
                           @"/盘算",
                           @"/亲亲",
                           @"/招财",
                           @"/真棒",
                           nil];
    
    if (!text || [text isEqualToString:@""]) { ////后退删除
        
        if (!textView.text || [textView.text isEqualToString:@""]) {
            
            return NO;
        }
        
        NSString * subString = [textView.text substringToIndex:range.location + 1];
        
        for (int index = 0; index < [tempArray count]; index++) {
            
            if ([subString hasSuffix:tempArray[index]]) {
                
                textView.text = [NSString stringWithFormat:@"%@%@",[subString substringToIndex:(subString.length - [tempArray[index] length])],[textView.text substringFromIndex:range.location + 1]];
                
                return NO;
            }
        }
    }
    return YES;
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
