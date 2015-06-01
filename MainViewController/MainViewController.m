//
//  MainViewController.m
//  QRCodeDemo
//
//  Created by lijinhai on 4/27/15.
//  Copyright (c) 2015 gaussli. All rights reserved.
//

#import "MainViewController.h"
#import "MacroDefinition.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - 页面生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initWidget];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
#pragma mark 页面初始化
- (void) initWidget {
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置二维码ImageView
    _qrcodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((JH_DEVICE_WIDTH-100)/2.0, JH_STATUSBAR_HEIGHT*2.0, 100, 100)];
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:@"QRCode Test"] withSize:100];
    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
    _qrcodeImageView.image = customQrcode;
    [self.view addSubview:_qrcodeImageView];
    
    // 设置扫描按钮
    _scanQRCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(_qrcodeImageView.frame.origin.x, _qrcodeImageView.frame.origin.y+100+10, 100, 30)];
    _scanQRCodeButton.backgroundColor = [UIColor blackColor];
    [_scanQRCodeButton setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [_scanQRCodeButton addTarget:self action:@selector(scanQRCodeButtonClickListener:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanQRCodeButton];
    
    // 设置扫描结果Label
    _scanResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _scanQRCodeButton.frame.origin.y+30+10, JH_DEVICE_WIDTH, 30)];
    _scanResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_scanResultLabel];
}

#pragma mark 数据初始化
- (void) initData {
    
}

#pragma mark - 按钮监听器
#pragma mark 扫描二维码按钮监听器
- (void) scanQRCodeButtonClickListener: (id)sender {
    ScanQRCodeViewController *scanQRCodeViewController = [[ScanQRCodeViewController alloc] init];
    scanQRCodeViewController.delegate = self;
    [self presentViewController:scanQRCodeViewController animated:YES completion:^{
        ;
    }];
}

#pragma mark - 生成二维码逻辑
#pragma mark InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

#pragma mark - 自定义代理实现
#pragma mark ScanQRCodeDelegate扫描完成代理
- (void) qrCodeFinishWithMessage:(NSString *)message {
    _scanResultLabel.text = message;
}

@end
