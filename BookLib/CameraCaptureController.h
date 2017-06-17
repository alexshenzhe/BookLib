//
//  CameraCaptureController.h
//  BookLib
//
//  Created by 沈喆 on 17/4/14.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class CameraCaptureController;
@protocol CameraCaptureControllerDelegate <NSObject>

@optional
/**
 * 代理方法：传递扫描结果
 */
- (void)cameraCaptureSuccess:(CameraCaptureController *)cameraCaptureController values:(NSString *)value;

@end

@interface CameraCaptureController : UIViewController

@property (nonatomic, weak) id<CameraCaptureControllerDelegate> delegate;

/**
 * 开始获取条形码
 */
- (void)cameraStartCapture;

@end
