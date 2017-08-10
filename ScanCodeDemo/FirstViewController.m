//
//  FirstViewController.m
//  ScanCodeDemo
//
//  Created by chenlishuang on 2017/8/9.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstView.h"
@interface FirstViewController ()
/** view*/
@property (nonatomic,strong)FirstView *firstView;
@end

@implementation FirstViewController
- (void)loadView{
    self.firstView = [[FirstView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.firstView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}



@end
