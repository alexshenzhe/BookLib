//
//  CameraReadController.h
//  BookLib
//
//  Created by 沈喆 on 17/4/14.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class CameraReadController;
@protocol CameraReadControllerDelegate <NSObject>

@optional
- (void)cameraCaptureSuccess:(CameraReadController *)cameraReadController values:(NSString *)value;

@end

@interface CameraReadController : UIViewController

@property (nonatomic, weak) id<CameraReadControllerDelegate> delegate;
- (void)cameraCapture;

@end
