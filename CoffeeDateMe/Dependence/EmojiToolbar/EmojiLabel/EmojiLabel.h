//
//  EmojiLabel.h
//  MyEmojiView
//
//  Created by null on 13-12-14.
//  Copyright (c) 2013年 null. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmojiLabel;

@protocol EmojiLabelDelegate <NSObject>

@optional

-(void)emojiLabel:(EmojiLabel *)emojiLabel touchURL:(NSString *)url;

-(void)emojiLabelDidClick;

@end;

@interface EmojiLabel : UIView

@property(nonatomic,copy)   NSString *text;            // default is nil
@property(nonatomic,assign) int contentWidth;
@property(nonatomic,assign) int showViewWidth;
@property(nonatomic,retain) UIFont *font;
@property(nonatomic,retain) UIColor * fontColor;
@property(nonatomic,retain) NSMutableArray * urls;
@property(nonatomic,retain) NSMutableArray * locations;
@property (nonatomic, retain) NSMutableArray * emojiRect;
@property (nonatomic, retain)  NSString * regexString;
@property(nonatomic, assign) id<EmojiLabelDelegate> emojiLabelDelegate;
- (void) setContentWidth:(int)width showViweWidth:(int)viewWidth;
- (void)setText:(NSString *)text;
@end