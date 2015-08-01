//
//  MyExpandingInputView.h
//  MyExpandingInputView
//
//  Created by Petey Mi on 7/30/15.
//  Copyright © 2015 Petey Mi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyExpandingInputViewDelegate;

@interface MyExpandingInputView : UITextView

@property(nonatomic, assign) int maximumNumberOfLines;
@property(nonatomic, assign) int minimumNumberOfLines;
@property(nonatomic, assign) BOOL animateHeightChange;

-(void)setDelegate:(id<MyExpandingInputViewDelegate> __nullable)delegate;
-(__nullable id<MyExpandingInputViewDelegate>)delegate;

@end


@protocol MyExpandingInputViewDelegate <UITextViewDelegate>

@optional
-(void)myExpandingInputView:(__nonnull MyExpandingInputView*)inputView willChangeHeight:(CGFloat)height;
-(void)myExpandingInputView:(__nonnull MyExpandingInputView*)inputView didChangeHeight:(CGFloat)height;

@end