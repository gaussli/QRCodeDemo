//
//  MainViewController.h
//  QRCodeDemo
//
//  Created by lijinhai on 4/27/15.
//  Copyright (c) 2015 gaussli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanQRCodeViewController.h"

@interface MainViewController : UIViewController<ScanQRCodeDelegate>
@property (nonatomic, strong) UIImageView *qrcodeImageView;
@property (nonatomic, strong) UIButton *scanQRCodeButton;
@property (nonatomic, strong) UILabel *scanResultLabel;
@end
