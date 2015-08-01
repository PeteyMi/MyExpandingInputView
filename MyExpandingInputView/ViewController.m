//
//  ViewController.m
//  MyExpandingInputView
//
//  Created by Petey Mi on 7/30/15.
//  Copyright © 2015 Petey Mi. All rights reserved.
//

#import "ViewController.h"
#import "MyExpandingInputView.h"

@interface ViewController ()<MyExpandingInputViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MyExpandingInputView* inputView = [[MyExpandingInputView alloc] initWithFrame:CGRectMake(50, 200, 200, 33)];
//    inputView.backgroundColor = [UIColor redColor];
    inputView.delegate = self;
    [self.view addSubview:inputView];
    
//    UIColor* a = [UIColor colorWithCGColor:textField.layer.borderColor];
//    NSLog(@"%@",a);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)myExpandingInputView:(__nonnull MyExpandingInputView*)inputView willChangeHeight:(CGFloat)height
{
    CGRect rect = inputView.frame;
    rect.origin.y = inputView.frame.origin.y - ( inputView.frame.size.height - height);

    inputView.frame = rect;
}
@end
