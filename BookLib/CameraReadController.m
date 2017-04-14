//
//  CameraReadController.m
//  BookLib
//
//  Created by 沈喆 on 17/4/14.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "CameraReadController.h"
#import "MBProgressHUD.h"

@interface CameraReadController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation CameraReadController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cameraCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cameraCapture {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        NSLog(@"获取摄像头失败");
        // 获取摄像头失败
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用摄像头" message:@"请确认在设置中已允许使用摄像头" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{ // 获取摄像头成功
        //获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //创建输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        self.session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [self.session addInput:input];
        [self.session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        //开始捕获
        [self.session startRunning];
        
    }
    
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0];
        
        if ([self.delegate respondsToSelector:@selector(cameraCaptureSuccess:values:)]) {
            [self.delegate cameraCaptureSuccess:self values:metadataObject.stringValue];
        }
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
    }
}

@end
