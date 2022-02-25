//
//  CoreAnimationDemoVC.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/5/13.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "CoreAnimationDemoVC.h"

#import <Masonry/Masonry.h>

@interface CoreAnimationDemoVC ()

@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIButton *colorBtn;

@property (nonatomic, strong) UIView *moveAniView;
@property (nonatomic, strong) CALayer *moveColorLayer;

@end

@implementation CoreAnimationDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    //[self colorChangeDemo];
    [self moveAnimation];
}

- (void)colorChangeDemo {
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50, 50, 100, 100);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layerView.layer addSublayer:self.colorLayer];
    
    self.colorBtn.frame = CGRectMake(40, 160, 150, 30);
    [self.layerView addSubview:self.colorBtn];
    
    [self.view addSubview:self.layerView];
    [_layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(100);
        make.width.height.mas_equalTo(200);
    }];
}

- (UIView *)layerView {
    if (!_layerView) {
        _layerView = [UIView new];
        [self.view addSubview:_layerView];
        _layerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _layerView;
}

- (UIButton *)colorBtn {
    if (!_colorBtn) {
        _colorBtn = [UIButton new];
        [_colorBtn setTitle:@"Change color" forState:UIControlStateNormal];
        [_colorBtn setBackgroundColor:[UIColor whiteColor]];
        [_colorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_colorBtn addTarget:self action:@selector(changeLayerColor) forControlEvents:UIControlEventTouchUpInside];
        _colorBtn.layer.cornerRadius = 15;
        _colorBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _colorBtn.layer.borderWidth = 1;
    }
    
    return _colorBtn;
}

- (void)changeLayerColor {
    [self animationTransaction];
    
    //[self animationBlock];
}

- (void)animationBlock {
    // randomize the layer background color;
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    } completion:^(BOOL finished) {
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI / 2);
        self.colorLayer.affineTransform = transform;
    }];
}

- (void)animationTransaction {
    // begin a new transaction;
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    
    // randomize the layer background color;
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    [CATransaction setCompletionBlock:^{
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI / 2);
        self.colorLayer.affineTransform = transform;
    }];

    [CATransaction commit];
}

#pragma mark - 验证layer的presentationLayer的存在，以及其交互的方式;
- (void)moveAnimation {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.moveAniView = [UIView new];
    [self.view addSubview:self.moveAniView];
    [self.moveAniView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.moveAniView.backgroundColor = [UIColor grayColor];
    
    self.moveColorLayer = [CALayer layer];
    self.moveColorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.moveColorLayer.position = CGPointMake(self.moveAniView.bounds.size.width / 2, self.moveAniView.bounds.size.height);
    self.moveColorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.moveAniView.layer addSublayer:self.moveColorLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // get the touch point
    CGPoint point = [[touches anyObject] locationInView:self.moveAniView];
    // check if we've tapped the moving layer;
    if ([self.moveColorLayer.presentationLayer hitTest:point]) {
        // randomize the layer background color;
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        
        self.moveColorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    } else {
        // otherwise(slowly) move the layer to position;
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.moveColorLayer.position = point;
        [CATransaction commit];
    }
}

@end
