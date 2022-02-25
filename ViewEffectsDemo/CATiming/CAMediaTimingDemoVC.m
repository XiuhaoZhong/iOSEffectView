//
//  CAMediaTimingDemoVC.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/5/26.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "CAMediaTimingDemoVC.h"

#import <Masonry/Masonry.h>

@interface CAMediaTimingDemoVC () <CAAnimationDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView        *containerView;
@property (nonatomic, strong) UITextField   *durationField;
@property (nonatomic, strong) UITextField   *repeatField;
@property (nonatomic, strong) UIButton      *startBtn;
@property (nonatomic, strong) CALayer       *shipLayer;

@property (nonatomic, strong) CALayer       *doorLayer;

@end

@implementation CAMediaTimingDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self TimingDemo1];
    
    [self TimingDemo2];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self setControlsEnabled:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.durationField resignFirstResponder];
    [self.repeatField resignFirstResponder];
    
    return YES;
}

#pragma mark - 第一个测试CAMediaTiming Demo;
- (void)TimingDemo1 {
    [self Demo1UI];
}

- (void)Demo1UI {
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.durationField];
    [self.view addSubview:self.repeatField];
    [self.view addSubview:self.startBtn];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.durationField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(400);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    [self.repeatField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.durationField.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.size.equalTo(self.durationField);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.repeatField.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = CGPointMake(150, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed:@"ship"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
}

- (void)setControlsEnabled:(BOOL)enabled {
    for (UIControl *control in @[self.durationField, self.repeatField]) {
        control.enabled = enabled;
        control.alpha = enabled ? 1.0f : 0.25f;
    }
}

#pragma mark - Demo2;
- (void)TimingDemo2 {
    [self TimingDemo2UI];
}

- (void)TimingDemo2UI {
    self.doorLayer = [CALayer layer];
    self.doorLayer.frame = CGRectMake(0, 0, 128, 256);
    self.doorLayer.position = CGPointMake(150 - 64, 150);
    self.doorLayer.anchorPoint = CGPointMake(0, 0.5);
    self.doorLayer.contents = (__bridge id)[UIImage imageNamed:@"door"].CGImage;
    
    [self.containerView.layer addSublayer:self.doorLayer];
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = - 1.0 / 500;
    self.containerView.layer.sublayerTransform = perspective;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self.containerView action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    self.doorLayer.speed = 0.0;
    
    // apply swinging animation (which won't play because layer is paused);
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.duration = 1.0;
    animation.toValue = @(-M_PI_2);
    [self.doorLayer addAnimation:animation forKey:nil];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    // get horizontal component of pan gesture;
    CGFloat x = [recognizer translationInView:self.view].x;
    // convert from points to animation duration using a resonable scale factor;
    x /= 200.f;
    
    // update timeOffset and clamp result;
    CFTimeInterval timeOffset = self.doorLayer.timeOffset;
    timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
    self.doorLayer.timeOffset = timeOffset;
    
    // reset the recoginzer;
    [recognizer setTranslation:CGPointZero inView:self.view];
}

#pragma mark - getter;
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor grayColor];
    }
    
    return _containerView;
}

- (UITextField *)durationField {
    if (!_durationField) {
        _durationField = [UITextField new];
        _durationField.backgroundColor = [UIColor whiteColor];
        _durationField.delegate = self;
    }
    
    return _durationField;
}

- (UITextField *)repeatField {
    if (!_repeatField) {
        _repeatField = [UITextField new];
        _repeatField.backgroundColor = [UIColor whiteColor];
        _repeatField.delegate = self;
    }
    
    return _repeatField;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton new];
        [_startBtn setTitle:@"start" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startBtn setBackgroundColor:[UIColor whiteColor]];
        [_startBtn addTarget:self action:@selector(startAni) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _startBtn;
}

- (void)startAni {
    CFTimeInterval duration = [self.durationField.text doubleValue];
    float repeatCount = [self.repeatField.text floatValue];
    
    // animate the ship rotation;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [self.shipLayer addAnimation:animation forKey:@""];
    [self setControlsEnabled:NO];
}

@end
