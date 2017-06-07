//
//  CameraCaptureController.m
//  BookLib
//
//  Created by 沈喆 on 17/4/14.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "CameraCaptureController.h"
#import "MBProgressHUD.h"

#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface CameraCaptureController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation CameraCaptureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cameraCaptureArea];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
  扫描条形码方法
 */
- (void)cameraStartCapture {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    // 判断摄像头状态
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用摄像头" message:@"请确认在设置中已允许使用摄像头" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // 获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // 创建输入、输出流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        // 设置代理，在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        // 设置识别区域
//        output.rectOfInterest = CGRectMake(1/3, 1/4, 1/3, 1/2);
        // 初始化链接对象
        self.session = [[AVCaptureSession alloc]init];
        // 高质量采集率
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [self.session addInput:input];
        [self.session addOutput:output];
        // 设置扫码的编码格式
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        // 拍摄预览
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        // 开始捕获
        [self.session startRunning];
    }
}

/**
  创建扫描区域阴影
*/
- (void)cameraCaptureArea {
    // 阴影区域
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.5;
    [self.view addSubview:coverView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    // 扫描区域
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(SCREENWIDTH / 4, (SCREENHEIGHT - 64) / 3, SCREENWIDTH * 0.5, (SCREENHEIGHT - 64) / 3) cornerRadius:1] bezierPathByReversingPath]];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    coverView.layer.mask = maskLayer;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(cameraCaptureSuccess:values:)]) {
            [self.delegate cameraCaptureSuccess:self values:metadataObject.stringValue];
        }
        // 输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
    }
}

@end
