//
//  LZScanViewController.m
//  LZScaner
//
//  Created by comst on 16/4/5.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import "UIView+LZFrame.h"
#import "NSString+Tools.h"
@interface LZScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@property (weak, nonatomic) IBOutlet UIView *scanRectView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet UIView *preView;

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;

@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation LZScanViewController


+ (instancetype)scanerViewController{
    
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"LZScan" bundle:[NSBundle mainBundle]];
    
     return  [SB instantiateViewControllerWithIdentifier:@"LZScanerVC"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNotification];
    // Do any additional setup after loading the view.
    [self baseConfig];
    [self configiBlurViewMask];
    [self scanConfig];
    [self.session startRunning];
    [self beginAnimation];
    
    
}

#pragma mark - configuration

- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beomeActiveAction:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)baseConfig{
    self.showLabel.layer.borderColor = [UIColor blueColor].CGColor;
    self.showLabel.layer.borderWidth = 2;
    self.tipLabel.hidden = YES;
    self.showLabel.text = @"";
    self.showLabel.hidden = YES;
    
    NSRange totalRange = NSMakeRange(0, self.tipLabel.text.length);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.tipLabel.text];
    [attrString setAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleThick)} range:totalRange];
    self.tipLabel.attributedText = attrString;
    
    self.scanRectView.backgroundColor = [UIColor clearColor];
    self.scanRectView.layer.borderColor = [UIColor greenColor].CGColor;
    self.scanRectView.layer.borderWidth = 2;
    
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = [UIColor greenColor];
    self.indicatorView.height = 2;
    self.indicatorView.x = 10;
    self.indicatorView.y = 0;
    self.indicatorView.width = 160;
    self.indicatorView.hidden = YES;
    [self.scanRectView addSubview:self.indicatorView];
    
}

- (void)configiBlurViewMask{
    
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.blurView.layer.mask = self.maskLayer;
}

- (void)scanConfig{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat rectX;
    CGFloat rectY;
    CGFloat rectW = 180;
    CGFloat rectH = 180;
    
    rectX = ( screenW - rectW ) * 0.5;
    rectY = (screenH - rectH) * 0.5;
    
    self.output.rectOfInterest = CGRectMake(rectY / screenH, rectX / screenW, rectH / screenH, rectW / screenW);
    
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]){
        [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }else if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]){
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    }else{
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    self.preViewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preViewLayer.frame = [UIScreen mainScreen].bounds;
    [self.preView.layer insertSublayer:self.preViewLayer atIndex:0];
}

#pragma mark - scanerView animatin
- (void)beginAnimation{
    self.indicatorView.hidden = NO;
    [self.indicatorView.layer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.toValue = @(self.indicatorView.y + self.scanRectView.height - 2);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = MAXFLOAT;
    animation.duration = 2;
    [self.indicatorView.layer addAnimation:animation forKey:@"scanAnimation"];
}

- (void)endAnimation{
    [self.indicatorView.layer removeAllAnimations];
    self.indicatorView.hidden = YES;
}

#pragma mark - subview layout

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.maskLayer.bounds = self.blurView.bounds;
    self.maskLayer.position = self.blurView.center;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.blurView.bounds];
   
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:self.scanRectView.frame];
    
    
    
    [path appendPath:path1];
     path.usesEvenOddFillRule = YES;
    
    self.maskLayer.path = path.CGPath;
}

#pragma mark - QRCode delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [self.session stopRunning];
    [self endAnimation];
    self.tipLabel.hidden = NO;
    if (metadataObjects.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"No QRCode"];
        return;
    }else{
        
        AVMetadataMachineReadableCodeObject *item = [metadataObjects lastObject];
        self.showLabel.text = item.stringValue;
        self.showLabel.hidden = NO;
        [self handleURL:item.stringValue];
        }
}

#pragma mark - handleURL
- (void)handleURL:(NSString *)source{
    
    if ([source isURL]) {
        [[UIApplication sharedApplication] openURL:[NSString HTTPURLFromString:source]];
    }
}

#pragma mark - tipcontrol

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.tipLabel.isHidden) {
        return;
    }else{
        self.tipLabel.hidden = YES;
        [self.session startRunning];
        [self beginAnimation];
        self.showLabel.hidden = YES;
    }
}

#pragma mark - notifcation

- (void)beomeActiveAction:(NSNotification *)notif{
    
    self.tipLabel.hidden = YES;
    [self.session startRunning];
    [self beginAnimation];
    self.showLabel.hidden = YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
