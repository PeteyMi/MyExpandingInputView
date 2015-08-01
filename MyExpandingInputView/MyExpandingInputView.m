//
//  MyExpandingInputView.m
//  MyExpandingInputView
//
//  Created by Petey Mi on 7/30/15.
//  Copyright © 2015 Petey Mi. All rights reserved.
//

#import "MyExpandingInputView.h"


@implementation MyExpandingInputView
{
    CGFloat _minimumHeight;
    CGFloat _maximunHegith;
    CGFloat _defalutHeight;
}

@synthesize maximumNumberOfLines = _maximumNumberOfLines;
@synthesize minimumNumberOfLines = _minimumNumberOfLines;
@synthesize animateHeightChange = _animateHeightChange;

-(id)initWithCoder:(nonnull NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInitialiser];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInitialiser];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInitialiser];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)commonInitialiser
{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6.0f;
    self.backgroundColor = [UIColor redColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    self.text = @"";

    self.minimumNumberOfLines = 1;
    self.maximumNumberOfLines = 4;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)setDelegate:(id<MyExpandingInputViewDelegate> __nullable)delegate
{
    [super setDelegate:delegate];
}
-(id<MyExpandingInputViewDelegate>)delegate
{
    return (id<MyExpandingInputViewDelegate>) [super delegate];
}

-(void)setMaximumNumberOfLines:(int)maximumNumberOfLines
{
    NSString* testStr = @"|W|";
    _maximunHegith = [testStr sizeWithAttributes:@{NSFontAttributeName:self.font}].height * maximumNumberOfLines;
    _maximumNumberOfLines = maximumNumberOfLines;
    [self sizeToFit];
}

-(void)setMinimumNumberOfLines:(int)minimumNumberOfLines
{
    NSString* testStr = @"|W|";
    _minimumHeight = [testStr sizeWithAttributes:@{NSFontAttributeName:self.font}].height * minimumNumberOfLines;
    _minimumNumberOfLines = minimumNumberOfLines;
    [self sizeToFit];
}

-(void)sizeToFit
{
    CGRect rect = self.frame;
    
    if ([self.text length] > 0) {
        return;
    } else {
        CGFloat topBottomPadding = self.textContainerInset.top + self.textContainerInset.bottom + self.contentInset.top + self.contentInset.bottom;
        rect.size.height = _minimumHeight + topBottomPadding;
        self.frame = rect;
    }
    NSLog(@"%@",NSStringFromCGRect(self.frame));
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    if (self.tracking || self.decelerating) {

    } else {

        CGRect textFrame=[[self layoutManager] usedRectForTextContainer:[self textContainer]];
        NSInteger newHeight = textFrame.size.height;
       
        if (newHeight > _minimumHeight && newHeight < _maximunHegith) {
            contentOffset.y = -self.contentInset.top;
        } else if (newHeight > _maximunHegith && self.font){
             CGFloat singleHeight = [@"|W|" sizeWithAttributes:@{NSFontAttributeName: self.font}].height;
            CGFloat row = (newHeight - _maximunHegith) / singleHeight;
            contentOffset.y = row * singleHeight + (-self.contentInset.top) + 1;
        }
    }

    [UIView beginAnimations:@"MoveOffSet" context:NULL];
    [UIView setAnimationDuration:0.25];
    [super setContentOffset: contentOffset];
    [UIView commitAnimations];
}

-(void)resizeTextView:(CGFloat)newHeight
{
    CGRect rect = self.frame;
    rect.size.height = newHeight;
    self.frame = rect;
    
}

-(void)growDidStop
{
    if ([[self delegate] respondsToSelector:@selector(myExpandingInputView:didChangeHeight:)])
    {
        [[self delegate] myExpandingInputView:self didChangeHeight:self.frame.size.height];
    }
}
- (void)textDidChangeNotification:(NSNotification*)notification
{
    CGRect textFrame=[[self layoutManager] usedRectForTextContainer:[self textContainer]];
    NSInteger newHeight = textFrame.size.height;
    
    if (newHeight > _minimumHeight) {
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = -self.textContainerInset.top / 2;
        insets.top = - self.textContainerInset.bottom / 2;
        self.contentInset = insets;
    } else {
        UIEdgeInsets insets = self.contentInset;
        insets.top = 0;
        insets.bottom = 0;
        self.contentInset = insets;
    }
    
    if (newHeight <= _minimumHeight || !self.hasText) {
        newHeight = _minimumHeight;
    }
    
    if (newHeight > _maximunHegith) {
        newHeight = _maximunHegith;
    }
    
    if (newHeight != self.frame.size.height) {
        if (_animateHeightChange) {
            [UIView beginAnimations:@"ExpandingInputView" context:NULL];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(growDidStop)];
            [UIView setAnimationBeginsFromCurrentState:YES];
        }
        if ([[self delegate] respondsToSelector:@selector(myExpandingInputView:willChangeHeight:)]) {
            [[self delegate] myExpandingInputView:self willChangeHeight:newHeight];
        }
        
        [self resizeTextView:newHeight];
        
        if (_animateHeightChange) {
            [UIView commitAnimations];
        } else if ([[self delegate] respondsToSelector:@selector(myExpandingInputView:didChangeHeight:)]){
            [[self delegate] myExpandingInputView:self didChangeHeight:newHeight];
        }
    }
    
     CGFloat topBottomPadding = self.textContainerInset.top + self.textContainerInset.bottom + self.contentInset.top + self.contentInset.bottom;
    if (newHeight + topBottomPadding != self.frame.size.height) {
        [self resizeTextView:newHeight + topBottomPadding];
    }
    
}


@end


