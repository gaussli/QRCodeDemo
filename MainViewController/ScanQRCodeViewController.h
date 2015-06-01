//
//  ScanQRCodeViewController.h
//  QRCodeDemo
//
//  Created by lijinhai on 4/3/15.
//  Copyright (c) 2015 sharepdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ScanQRCodeDelegate <NSObject>

- (void) qrCodeFinishWithMessage: (NSString*)message;

@end

@interface ScanQRCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
// 页面控件
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;             // 摄像图层
// 页面数据
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) id<ScanQRCodeDelegate> delegate;
@end
