//
//  ExplicitAnimationDemoVC.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/5/14.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "ExplicitAnimationDemoVC.h"

#import <Masonry/Masonry.h>

#import "ViewEffectsDemoTools.h"

@interface ExplicitAnimationDemoVC () <CAAnimationDelegate>

@property (nonatomic, strong) UIView  *colorView;
@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIButton *changColorBtn;
@property (nonatomic, strong) UIButton *keyFrameColorBtn;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *switchImgBtn;
@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, strong) CALayer *shipLayer;

@end

@implementation ExplicitAnimationDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self colorChangeAni];
    //[self keyFrameAnimation];
    //[self animationWithLayer];
    [self animationWithLayerAttr];
    //[self animationWithGroup];
    //[self imgSwitchAnimation];
    
    //[self animationWithRenderInContext];
}

- (void)colorChangeAni {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.colorView = [UIView new];
    [self.view addSubview:self.colorView];
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50, 50, 100, 100);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.colorView.layer addSublayer:self.colorLayer];
    
    [self.colorView addSubview:self.changColorBtn];
    [self.changColorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    [self.colorView addSubview:self.keyFrameColorBtn];
    [self.keyFrameColorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.changColorBtn);
        make.top.equalTo(self.changColorBtn.mas_bottom).offset(10);
        make.size.equalTo(self.changColorBtn);
    }];
}

- (void)changeColor {
    // craete a new random color;
    UIColor *randomColor = [ViewEffectsDemoTools randomColor];
    
    // create a basic animatioin;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)randomColor.CGColor;
    animation.delegate = self;
    
    // apply animation to layer;
    [self.colorLayer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CABasicAnimation *)animation finished:(BOOL)flag {
    // set the backgroundColor property to match animation toValue;
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.colorLayer.backgroundColor = (__bridge CGColorRef)animation.toValue;
//    [CATransaction commit];
    
    NSLog(@"Animation Debug: the animation ended");
}

- (void)keyFrameColorAnimation {
    // create a keyframe animation;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
        (__bridge id)[UIColor blueColor].CGColor,
        (__bridge id)[UIColor redColor].CGColor,
        (__bridge id)[UIColor greenColor].CGColor,
        (__bridge id)[UIColor blueColor].CGColor,
    ];
    
    // apply animation to layer;
    [self.colorLayer addAnimation:animation forKey:nil];
}

- (void)keyFrameAnimation {
    self.view.backgroundColor = [UIColor grayColor];
    
    // create ba path;
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150)
                  controlPoint1:CGPointMake(75, 0)
                  controlPoint2:CGPointMake(225, 300)];
    
    // draw the path using a CAShapeLayer;
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3;
    [self.view.layer addSublayer:pathLayer];
    
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 64, 64);
    shipLayer.position = CGPointMake(0, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed:@"ship"].CGImage;
    [self.view.layer addSublayer:shipLayer];
    
    // create the keyFrame animation;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    [shipLayer addAnimation:animation forKey:nil];
}

- (void)animationWithLayer {
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 128, 128);
    shipLayer.position = CGPointMake(150, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed:@"ship"].CGImage;
    [self.view.layer addSublayer:shipLayer];
    self.shipLayer = shipLayer;
    
    // animate the ship rotation;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform";
    animation.duration = 2.0;
    animation.byValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
    [shipLayer addAnimation:animation forKey:@""];
}

- (void)startShipAnimation {
    // animate the ship rotation;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 2.0;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [_shipLayer addAnimation:animation forKey:@"rotateAnimation"];
}

- (void)stopShipAnimation {
    [self.shipLayer removeAnimationForKey:@"rotateAnimation"];
    
    NSLog(@"Animation Debug: the animation stop by click");
}

- (void)animationWithLayerAttr {
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 128, 128);
    shipLayer.position = CGPointMake(150, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed:@"ship"].CGImage;
    [self.view.layer addSublayer:shipLayer];
    self.shipLayer = shipLayer;
    
    UIButton *startBtn = [UIButton new];
    [self.view addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.left.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [startBtn setTitle:@"start" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startBtn setBackgroundColor:[UIColor whiteColor]];
    [startBtn addTarget:self action:@selector(startShipAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopBtn = [UIButton new];
    [self.view addSubview:stopBtn];
    [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startBtn);
        make.left.mas_equalTo(startBtn.mas_right).offset(10);
        make.size.equalTo(startBtn);
    }];
    
    [stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    [stopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stopBtn setBackgroundColor:[UIColor whiteColor]];
    [stopBtn addTarget:self action:@selector(stopShipAnimation) forControlEvents:UIControlEventTouchUpInside];
    // animate the ship rotation;
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"transform.rotation";
//    animation.duration = 2.0;
//    animation.byValue = @(M_PI * 2);
//    [shipLayer addAnimation:animation forKey:@""];
}

- (void)animationWithGroup {
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150)
                  controlPoint1:CGPointMake(75, 0)
                  controlPoint2:CGPointMake(225, 300)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    
    [self.view.layer addSublayer:pathLayer];
    
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(0, 0, 64, 64);
    colorLayer.position = CGPointMake(0, 150);
    colorLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:colorLayer];
    
    // create the position animation;
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.keyPath = @"position";
    animation1.path = bezierPath.CGPath;
    animation1.rotationMode = kCAAnimationRotateAuto;
    
    // create the color animation;
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"backgroundColor";
    animation2.toValue = (__bridge id)[UIColor redColor].CGColor;
    
    // create group animation;
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation1, animation2];
    groupAnimation.duration = 4.0f;
    
    [colorLayer addAnimation:groupAnimation forKey:nil];
}

- (void)imgSwitchAnimation {
    self.imgView = [UIImageView new];
    [self.view addSubview:self.imgView];
    
    [self.view addSubview:self.switchImgBtn];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.switchImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(10);
        make.left.equalTo(self.imgView);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    self.imageArr = @[[UIImage imageNamed:@"panda"],
                      [UIImage imageNamed:@"ship"],
                      [UIImage imageNamed:@"snowman"]];
    
    self.imgView.image = [self.imageArr objectAtIndex:0];
}

- (void)switchImage {
    // set up crossfade transition;
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;//kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    // apply transition to imageView backing layer;
    [self.imgView.layer addAnimation:transition forKey:nil];
    
    // cycle to next image;
    UIImage *curImg = self.imgView.image;
    NSUInteger index = [self.imageArr indexOfObject:curImg];
    index = (index + 1) % [self.imageArr count];
    self.imgView.image = self.imageArr[index];
}

- (void)crossAniWithCA {
    [UIView transitionWithView:self.imgView duration:5.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        UIImage *curImge = self.imgView.image;
        NSUInteger index = [self.imageArr indexOfObject:curImge];
        index = (index + 1) % self.imageArr.count;
        self.imgView.image = self.imageArr[index];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 使用CALayer的RenderInContext() 方法来模拟一个动画;
- (void)animationWithRenderInContext {
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    
    label.text = @"this is a cross by self";
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    UIButton *btn = [UIButton new];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.centerX.equalTo(label);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    [btn setTitle:@"click to cross" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(renderToCross) forControlEvents:UIControlEventTouchUpInside];
}

- (void)renderToCross {
    // preserve the current view snapshot;
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *coverImg = UIGraphicsGetImageFromCurrentImageContext();
    
    // insert snapshot view in front of this one
    UIImageView *coverView = [[UIImageView alloc] initWithImage:coverImg];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    // update the view (we'll simply randomize the layer background color);
    UIColor *color = [ViewEffectsDemoTools randomColor];
    self.view.backgroundColor = color;
    
    // perform animation (anything you like)
    [UIView animateWithDuration:1.0 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [coverView removeFromSuperview];
    }];
}

#pragma mark - getters;

- (UIButton *)changColorBtn {
    if (!_changColorBtn) {
        _changColorBtn = [UIButton new];
        [_changColorBtn setTitle:@"changeColor" forState:UIControlStateNormal];
        [_changColorBtn setBackgroundColor:[UIColor whiteColor]];
        [_changColorBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_changColorBtn addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
        _changColorBtn.layer.cornerRadius = 15;
        _changColorBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _changColorBtn.layer.borderWidth = 1;
    }
    
    return _changColorBtn;
}

- (UIButton *)keyFrameColorBtn {
    if (!_keyFrameColorBtn) {
        _keyFrameColorBtn = [UIButton new];
        [_keyFrameColorBtn setTitle:@"colorAniKeyFrame" forState:UIControlStateNormal];
        [_keyFrameColorBtn setBackgroundColor:[UIColor whiteColor]];
        [_keyFrameColorBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_keyFrameColorBtn addTarget:self action:@selector(keyFrameColorAnimation) forControlEvents:UIControlEventTouchUpInside];
        _keyFrameColorBtn.layer.cornerRadius = 15;
        _keyFrameColorBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _keyFrameColorBtn.layer.borderWidth = 1;
    }
    
    return _keyFrameColorBtn;
}

- (UIButton *)switchImgBtn {
    if (!_switchImgBtn) {
        _switchImgBtn = [UIButton new];
        [_switchImgBtn setTitle:@"SwitchImage" forState:UIControlStateNormal];
        [_switchImgBtn setBackgroundColor:[UIColor whiteColor]];
        [_switchImgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //[_switchImgBtn addTarget:self action:@selector(switchImage) forControlEvents:UIControlEventTouchUpInside];
        [_switchImgBtn addTarget:self action:@selector(crossAniWithCA) forControlEvents:UIControlEventTouchUpInside];
        _switchImgBtn.layer.cornerRadius = 15;
        _switchImgBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _switchImgBtn.layer.borderWidth = 1;
    }
    
    return _switchImgBtn;
}

@end
