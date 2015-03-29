//
//  EmojiLabel.m
//  MyEmojiView
//
//  Created by null on 13-12-14.
//  Copyright (c) 2013年 null. All rights reserved.
//

#import "EmojiLabel.h"
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300
#define BEGIN_FLAG @"[/"
#define END_FLAG @"]"
#define KFacialSizeWidth  20
#define KFacialSizeHeight 20
#define MAX_WIDTH 274  //content
#define SHOWVIEW_WIDTH 284  //show view
#import "SCGIFImageView.h"

@implementation EmojiLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.contentWidth = MAX_WIDTH;
        
        self.showViewWidth = SHOWVIEW_WIDTH;
        
        self.regexString =@"(\\(http[s]{0,1}|ftp)://([^\\s^\\)^(\u4e00-\u9fa5)]*)+\\)";
        //@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        
    }
    return self;
}

- (void) setContentWidth:(int)width showViweWidth:(int)viewWidth {
    
    self.contentWidth = width;
    
    self.showViewWidth = viewWidth;
    
}

- (void)setText:(NSString *)text {
    
    for (UIView * view in self.subviews) {
       
        [view removeFromSuperview];
    
    }
    
    for (int index = 0; index < 14; index ++ ) {
        
        NSString * imageName = nil;
        NSString * imageChar = nil;
        NSString * replaceStr = nil;
        
        if (index < 10) {
            
            imageName = [NSString stringWithFormat:@"00%d",index];
            
            replaceStr = [NSString stringWithFormat:@"f%@",imageName];
            
            imageChar = [NSString stringWithFormat:@"|brow:%@.png:end|",imageName];
            
        }else {
            
            imageName = [NSString stringWithFormat:@"0%d",index];
            
            replaceStr = [NSString stringWithFormat:@"f%@",imageName];
            
            imageChar = [NSString stringWithFormat:@"|brow:%@.png:end|",imageName];
            
        }
        
        
       text = [text stringByReplacingOccurrencesOfString:imageChar withString:replaceStr];
    }
    
    UIView * showContentView = nil;
    
    if (!text || [text isKindOfClass:[NSNull class]] || [text isEqualToString:@""]) {
        
       showContentView = [self emojiView:@""];
        
    }else {
        
      showContentView = [self emojiView:text];
        
    }
    
    CGRect showContentRect = showContentView.frame;
    showContentRect.size.height += KFacialSizeHeight;
    showContentView.frame = showContentRect;
    showContentView.backgroundColor = [UIColor clearColor];
     CGRect rect = self.frame;
    rect.size = showContentRect.size;
     self.frame = rect;
    [self addSubview:showContentView];
}

#pragma mark 验证是否表情
// 验证表情
- (UIView*)emojiView:(NSString *)text{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"f0[0-9]{2}|f10[0-7]|g0[0-9]{2}|%@",self.regexString] options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *array =    nil;
    array = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (!self.font) {
        self.font = [UIFont systemFontOfSize:14.0f];
    }
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    
    if ([array count] != 0) {
        
        NSArray *splitArray = [self splitText:text faceArray:array];
        
        for (int index = 0; index < [splitArray count]; index ++) {
            
            NSString *string = [splitArray objectAtIndex:index];
            
            if ([[self isEmoji:string] isEqualToString:@"f"]) {
                
                if (upX >= self.contentWidth)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = self.showViewWidth;
                    Y = upY;
                }
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:string]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [cellView addSubview:img];
                upX=KFacialSizeWidth+upX;
                if (X<self.showViewWidth) X = upX;
                
                
            }else if([[self isEmoji:string] isEqualToString:@"g"]){
                
                if (upX >= self.contentWidth)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = self.showViewWidth;
                    Y = upY;
                }
                
                 NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.gif",string] ofType:nil];
                 SCGIFImageView* gifImageView = [[SCGIFImageView alloc] initWithGIFFile:filePath];
                 gifImageView.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [cellView addSubview:gifImageView];
                upX=KFacialSizeWidth+upX;
                if (X<self.showViewWidth) X = upX;

            }else if([[self isEmoji:string] isEqualToString:@"h"]){
                
                 NSMutableArray * tempLocation = [[NSMutableArray alloc] init];
                
               NSString * showString = @"网页链接";
                
                for (int j = 0; j < [showString length]; j++) {
                    
                    NSString *temp = [showString substringWithRange:NSMakeRange(j, 1)];
                    
                    if (upX >= self.contentWidth)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = self.showViewWidth;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:self.font constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY + 3,size.width,size.height)];
                    la.textColor = [UIColor blueColor];
                    la.font = self.font;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [cellView addSubview:la];

                    upX=upX+size.width;
                    
                    NSValue* value = [NSValue valueWithCGRect:la.frame];
                    [tempLocation addObject:value];

                    if (X<self.showViewWidth) {
                        X = upX;
                    }
                }
                
                if([string length] > 0) {
            
                    if (!_urls) {
                        _urls = [[NSMutableArray alloc] init];
                        _locations = [[NSMutableArray alloc] init];
                        
                    }
                    [_urls addObject:string];
                    
                    [_locations addObject:tempLocation];
                }
            }else{
                
                for (int j = 0; j < [string length]; j++) {
                    NSString *temp = [string substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= self.contentWidth)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = self.showViewWidth;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:self.font constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY + 3,size.width,size.height)];
                   // la.textColor = [UIColor colorWithWhite:0.234 alpha:1.000];
                    la.textColor = [UIColor grayColor];
                    la.font = self.font;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [cellView addSubview:la];
               
                    upX=upX+size.width;
                    if (X<self.showViewWidth) {
                        X = upX;
                    }
                }
                
            }
        }
        cellView.frame = CGRectMake(0.0f,0.0f, X, Y);
        
        cellView.backgroundColor = [UIColor clearColor];
        
        return cellView;
        
    }else{
        
        /**
         不存在表情以及URL
         */
        for (int j = 0; j < [text length]; j++) {
            NSString *temp = [text substringWithRange:NSMakeRange(j, 1)];
            if (upX >= self.contentWidth)
            {
                upY = upY + KFacialSizeHeight;
                upX = 0;
                X = self.showViewWidth;
                Y =upY;
            }
            CGSize size=[temp sizeWithFont:self.font constrainedToSize:CGSizeMake(150, 40)];
            UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY + 3,size.width,size.height)];
            la.textColor = [UIColor lightGrayColor];
            //la.textColor = [UIColor colorWithWhite:0.234 alpha:1.000];
            la.font = self.font;
            la.text = temp;
            la.backgroundColor = [UIColor clearColor];
            [cellView addSubview:la];
           
            upX=upX+size.width;
            if (X<self.showViewWidth) {
                X = upX;
            }
        }
        
        cellView.frame = CGRectMake(0.0f,0.0f, X, Y);
        cellView.backgroundColor = [UIColor clearColor];
        
        return cellView;
    }
}

// 验证是否表情
-(NSString *)isEmoji:(NSString *)text {
    
    NSString *emojiRegex = @"f0[0-9]{2}|f10[0-7]";
    NSPredicate *emojiPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emojiRegex];
    if ([emojiPredicate evaluateWithObject:text]){
        
        return @"f";
    }
    
    NSString *gifRegex = @"g0[0-9]{2}";
    NSPredicate *gifPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", gifRegex];
    if ([gifPredicate evaluateWithObject:text]){
        
        return @"g";
    }
    
    NSString *regulaStr = self.regexString;//@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSPredicate * regulaPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regulaStr];
    if ([regulaPredicate evaluateWithObject:text]){
        
        return @"h";
    }
    return nil;
}

- (NSArray*)splitText:(NSString*)text faceArray:(NSArray*)array{
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < [array count]; index ++) {
        
        NSString *subString;
        NSTextCheckingResult* a = [array objectAtIndex:index];
        if (index == 0) {
            
            subString = [text substringWithRange:NSMakeRange(index, a.range.location)];
        }else{
            
            NSTextCheckingResult* b = [array objectAtIndex:index - 1];
            subString = [text substringWithRange:NSMakeRange(b.range.location+b.range.length, a.range.location - (b.range.location+b.range.length))];
        }
        [temp addObject:subString];
        [temp addObject:[text substringWithRange:a.range]];
        
        
        if (index == [array count] - 1) {
            if (a.range.location + a.range.length < text.length) {
                
                subString = [text substringWithRange:NSMakeRange(a.range.location + a.range.length, text.length - (a.range.location + a.range.length))];
                [temp addObject:subString];
            }
        }
    }
    
    return temp ;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch * touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
 
    BOOL isFind = false;
    
    int index = 0;
    
    for (index=0; index < [_urls count]; index++) {
        
        NSArray * tempLocation = [_locations objectAtIndex:index];
        
        for (int j=0; j < [tempLocation count]; j++) {
            
            NSValue * value = [tempLocation objectAtIndex:j];
            
            CGRect rect = [value CGRectValue];
            
            if(CGRectContainsPoint(rect, point))
            {
                isFind = true;
                
                break;
               
            }
            
        }
        
        if (isFind) {
            break;
        }
        
    }
    
    if (isFind) {
    
        NSString *  url = [_urls objectAtIndex:index];
        
        NSRange range;
        range.location = 1;
        range.length = [url length]-2;
        
        url = [url substringWithRange: range];
        
        if (self.emojiLabelDelegate && [self.emojiLabelDelegate respondsToSelector:@selector(emojiLabel:touchURL:)]) {
            
            [self.emojiLabelDelegate emojiLabel:self touchURL:url];
            
        }
        
    }else {
        
        if (self.emojiLabelDelegate && [self.emojiLabelDelegate respondsToSelector:@selector(emojiLabelDidClick)]) {
            
            [self.emojiLabelDelegate emojiLabelDidClick];
        }
        
    }
    
}


- (void)dealloc {

   
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
