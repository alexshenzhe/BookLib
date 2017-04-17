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
- (void)cameraCaptureSuccess:(CameraCaptureController *)cameraCaptureController values:(NSString *)value;

@end

@interface CameraCaptureController : UIViewController

@property (nonatomic, weak) id<CameraCaptureControllerDelegate> delegate;
- (void)cameraStartCapture;

@end
