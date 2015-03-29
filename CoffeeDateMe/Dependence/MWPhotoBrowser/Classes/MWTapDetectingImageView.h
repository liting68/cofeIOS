//
//  UIImageViewTap.h
//  Momento
//
//  Created by Michael Waterfall on 04/11/2009.
//  Copyright 2009 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    TapDetectingImageViewHeadViewStyle,
    TapDetectingImageViewSmallHeaderStyle,
    TapDetectingImageViewVideoViewStyle,
    TapDetectingImageViewPictureViewStyle,
    
    TapDetectingImageViewStyleActivity,
    TapDetectingImageViewStyleMember,
    TapDetectingImageViewStyleTopic
    
} TapDetectingImageViewStyle;

@protocol MWTapDetectingImageViewDelegate;

@interface MWTapDetectingImageView : UIImageView {
	id <MWTapDetectingImageViewDelegate> tapDelegate;
}
@property (nonatomic, assign) id <MWTapDetectingImageViewDelegate> tapDelegate;
@property (nonatomic) TapDetectingImageViewStyle viewStyle;
@property (nonatomic,strong) NSString * photoURL;
- (void)handleSingleTap:(UITouch *)touch;
- (void)handleDoubleTap:(UITouch *)touch;
- (void)handleTripleTap:(UITouch *)touch;
@end

@protocol MWTapDetectingImageViewDelegate <NSObject>
@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch;
@end