//
//  ViewController.m
//  ScanCodeDemo
//
//  Created by chenlishuang on 2017/8/9.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (IBAction)view1Action:(id)sender {
    FirstViewController *firstVC = [FirstViewController new];
    [self.navigationController pushViewController:firstVC animated:YES];
}
- (IBAction)view2Action:(id)sender {
    SecondViewController *secondVC = [SecondViewController new];
    [self.navigationController pushViewController:secondVC animated:YES];
}
- (IBAction)view3Action:(id)sender {
    ThirdViewController *thirdVC = [ThirdViewController new];
    [self.navigationController pushViewController:thirdVC animated:YES];
}

- (IBAction)createQRCodeImage:(id)sender {
    //回收键盘
    [self.view endEditing:YES];
    //1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.回复滤镜的默认属性(因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    //3.经字符串转化为NSData
    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    //4.通过KVC设置滤镜,传入data,将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    //5.生成二维码
    //补充：CIImage是CoreImage框架中最基本代表图像的对象，他不仅包含原图像数据，还包含作用在原图像上的滤镜链
    CIImage *image = [filter outputImage];
    //此方法生成的是模糊图片
//    self.imageView.image = [UIImage imageWithCIImage:image];
    //高清方法
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:100.0];
}
//由于生成的二维码是CIImage类型，如果直接转换成UIImage，大小不好控制，图片模糊
//高清方法：CIImage->CGImageRef->UIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    //设置比例
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap（位图）;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
- (IBAction)saveQRCodeImage:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(saveImage:didFinishSavingWithError:contextInfo:), nil);
}
- (void)saveImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        NSLog(@"保存成功");
    }
}

- (IBAction)chooseImage:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //1.弹出系统相册
        UIImagePickerController *pickVC = [[UIImagePickerController alloc]init];
        //2.设置照片来源
        /** UIImagePickerControllerSourceTypePhotoLibrary,相册 UIImagePickerControllerSourceTypeCamera,相机 UIImagePickerControllerSourceTypeSavedPhotosAlbum,照片库 
         */
        pickVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //3.设置代理
        pickVC.delegate = self;
        //4.跳到相册
        self.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:pickVC animated:YES completion:nil];
        
    }else{
        NSLog(@"打开相册失败");
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //初始化一个监听器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    [picker dismissViewControllerAnimated:YES completion:^{
        //检测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >= 1) {
            //结果对象
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            NSLog(@"%@",scannedResult);
        }else{
            NSLog(@"读取失败");
        }
    }];
}
@end
