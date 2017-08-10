//
//  ScanCodeViewController.m
//  ScanCodeDemo
//
//  Created by chenlishuang on 2017/8/9.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
/** device*/
@property (nonatomic,strong)AVCaptureDevice *device;
/** 输入流*/
@property (nonatomic,strong)AVCaptureDeviceInput *input;
/** 输出流*/
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
/** 链接对象*/
@property (nonatomic,strong)AVCaptureSession *session;
/** preview */
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@end

@implementation ScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.添加预览图层
    self.preview.frame = self.view.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    //2.设置输出能够解析的数据类型
    //注意:设置数据类型一定要在输出对象添加到回话之后才能设置
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode]];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    //3.开始扫描
    [self.session startRunning];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate代理方法  只有这一个代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *object = metadataObjects[0];
        NSString *stringValue = object.stringValue;
        if (stringValue != nil) {
            [self.session stopRunning];
            NSLog(@"扫码结果%@",stringValue);
        }
    }
}
#pragma mark - 懒加载
- (AVCaptureDevice *)device{
    if (!_device) {
        //AVMediaTypeVideo是打开相机
        //AVMediaTypeAudio是打开麦克风
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
- (AVCaptureDeviceInput *)input{
    if (!_input) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}
- (AVCaptureMetadataOutput *)output{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //限制扫描区域,默认值是CGRect(x: 0,y: 0, width: 1,height: 1)。通过对这个值的观察，我们发现传入的是比例
        CGRect myRect =CGRectMake(((LCDH - 200) / 2 )/LCDH,((LCDW - 200) /2)/LCDW,200/LCDH, 200/LCDW);
        [_output setRectOfInterest:myRect];
    }
    return _output;
}
- (AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
    }
    return _session;
}
- (AVCaptureVideoPreviewLayer *)preview{
    if (!_preview) {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _preview;
}

@end
