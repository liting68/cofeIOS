//
//  EmojiTextView.h
//  GrowingTextViewExample
//
//  Created by jimcky lin on 13-6-6.
//
//

#import <UIKit/UIKit.h>
//#import "HPGrowingTextView.h"
//#import "FacialView.h"

@protocol EmojiToolbarDelegate;
@interface CustomEmojiToolbar : UIView<UIGestureRecognizerDelegate,UITextViewDelegate,UIScrollViewDelegate>{
    UITextView * textView;
    UIView * emojiScrollView;
    UIView * theSuperView;
    UIButton * emojiBtn;
    BOOL keyboardIsShow;//键盘是否显示
    BOOL isFirstClickFaceBtn;
}

@property (nonatomic,assign)BOOL isFriend;
@property (nonatomic,retain)UIView *theSuperView;
@property (assign) id<EmojiToolbarDelegate> delegate;
@property (nonatomic,retain)UIView * backView;
@property (retain, nonatomic)UIPageControl * pageControl;

- (void)setContentText:(NSString *)content;
- (void)resignClick;
//- (void)resignTextView;
- (void)hiddenTextView;
- (void)clearText;
- (void)registKeyboard;
- (void)resignTextView:(id)sender;
- (id)initWithFrame:(CGRect)frame superView:(UIView *)superView;
- (id)initWithFrame:(CGRect)frame superView:(UIView *)superView isClose:(NSString *)isClose;
- (id)initWithFrame:(CGRect)frame superView:(UIView *)superView isAllComments:(NSString *)isClose;
- (void)addNotificatons;
- (void)removeNotifications;

@end

@protocol EmojiToolbarDelegate <NSObject>
@optional
- (void)emojiToolbarSendBtnDidClick:(CustomEmojiToolbar *)emojiToolbar sendString:(NSString *)sendString;
- (void)emojiToolbarAvatarBtnClick;
- (void)emojiHidden;
@end
