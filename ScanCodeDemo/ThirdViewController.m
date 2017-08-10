//
//  ThirdViewController.m
//  ScanCodeDemo
//
//  Created by chenlishuang on 2017/8/9.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "ThirdViewController.h"
#import "ThirdView.h"
#import <AVFoundation/AVFoundation.h>
@interface ThirdViewController ()
@property (nonatomic,strong)ThirdView *thirdView;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.thirdView];
    //闪光灯
    [self systemLightSwitch:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (ThirdView *)thirdView{
    if (!_thirdView) {
        _thirdView = [[ThirdView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _thirdView.transparentArea = CGSizeMake(200, 200);
        _thirdView.backgroundColor = [UIColor clearColor];
    }
    return _thirdView;
}

- (void)systemLightSwitch:(BOOL)open {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}






@end
