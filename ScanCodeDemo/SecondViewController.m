//
//  SecondViewController.m
//  ScanCodeDemo
//
//  Created by chenlishuang on 2017/8/9.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "SecondViewController.h"
#import "SecondView.h"
@interface SecondViewController ()
/** view*/
@property (nonatomic,strong)SecondView *secondView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.secondView];
    
}

- (SecondView *)secondView{
    if (!_secondView) {
        _secondView = [[SecondView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _secondView.transparentArea = CGSizeMake(200, 200);
        _secondView.backgroundColor = [UIColor clearColor];
    }
    return _secondView;
}

@end
