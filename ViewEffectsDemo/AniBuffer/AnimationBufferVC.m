//
//  AnimationBufferVC.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/6/2.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "AnimationBufferVC.h"
#import <Masonry/Masonry.h>

typedef enum {
    ANITYPE_LAYER = 0,
    ANITYPE_VIEW,
    ANITYPE_BALL
} ANITYPE;
 
@interface AnimationBufferVC ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CALayer *colorLayer;

@property (nonatomic, strong) UIView *colorView;

@property (nonatomic, strong) UIView *layerView;

@property (nonatomic, strong) UIImageView *ballImgView;

@property (nonatomic, assign) ANITYPE aniType;

@end

@implementation AnimationBufferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.containerView = [UIView new];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //[self AniBuffer];
    //[self ViewAniBuffer];
    //[self colorAni];
    //[self curveDemo];
    [self ballFallDown];
}

- (void)AniBuffer {
    self.colorLayer = [CALayer layer];
    // create a red layer;
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    
    self.containerView = [UIView new];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView.layer addSublayer:self.colorLayer];
    self.aniType = ANITYPE_LAYER;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    switch (self.aniType) {
        case ANITYPE_LAYER: {
                // configure the transaction;
                [CATransaction begin];
                [CATransaction setAnimationDuration:1.0];
                // kCAMediaTimingFunctionEaseOut
                // kCAMediaTimingFunctionLinear;
                // kCAMediaTimingFunctionEaseIn;
                // kCAMediaTimingFunctionEaseInEaseOut;
                // kCAMediaTimingFunctionDefault;
                [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
                // set the position;
                self.colorLayer.position = [[touches anyObject] locationInView:self.view];
                // commit transaction;
                [CATransaction commit];
            }
            
            break;
        case ANITYPE_VIEW: {
                // UIViewAnimationOptionCurveEaseOut;
                // UIViewAnimationOptionCurveEaseInOut;
                // UIViewAnimationOptionCurveEasein;
                // UIViewAnimationOptionCurveLinear;
                [UIView animateWithDuration:1.0
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.colorView.center = [[touches anyObject] locationInView:self.containerView];
                } completion:^(BOOL finished) {
                    
                }];
            }
            break;
        case ANITYPE_BALL: {
                // replay animationi on Tap;
                //[self ballFallAnimation];
            
                [self customeAni];
            }
            break;
        default:
            break;
    }
}

- (void)ViewAniBuffer {
    self.colorView = [UIView new];
    [self.containerView addSubview:self.colorView];
    self.colorView.backgroundColor = [UIColor redColor];
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    self.aniType = ANITYPE_VIEW;
}

- (void)colorAni {
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50, 50, 100, 100);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.containerView.layer addSublayer:self.colorLayer];
    
    UIButton *btn = [UIButton new];
    [self.containerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    [btn setTitle:@"ChangeColor" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    btn.layer.cornerRadius = 15;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeColor {
    // create a keyframe animation;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2;
    animation.values = @[(__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor];
    
    // add timing function;
    CAMediaTimingFunction *fn = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.timingFunctions = @[fn, fn, fn];
    
    // apply animation to layer;
    [self.colorLayer addAnimation:animation forKey:nil];
}

- (void)curveDemo {
    self.layerView = [UIView new];
    [self.containerView addSubview:self.layerView];
    [self.layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    
    // kCAMediaTimingFunctionEaseOut
    // kCAMediaTimingFunctionLinear;
    // kCAMediaTimingFunctionEaseIn;
    // kCAMediaTimingFunctionEaseInEaseOut;
    // kCAMediaTimingFunctionDefault;
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // get control points;
    float cp1[2], cp2[2];
    [function getControlPointAtIndex:1 values:cp1];
    [function getControlPointAtIndex:2 values:cp2];
    
    // ****************** 原书籍代码有误 *********************
    // 通过传入point地址的方式，并不能得到正确的值;
    // 原因在于，在64位机上，CGFloat被定义成了double类型，而在32位机上，才是float类型;
    // 原书籍(《ios核心动画》)应该是在32位机上进行的试验;写一篇博客记录一下吧 2021/06/03 15:04:00
    CGPoint cPt1, cPt2;
    [function getControlPointAtIndex:1 values:(float *)&cPt1];
    [function getControlPointAtIndex:2 values:(float *)&cPt2];
    // ****************** 原书籍代码有误 *********************
    
    CGPoint sPt = CGPointMake(cp1[0], cp1[1]);
    CGPoint ePt = CGPointMake(cp2[0], cp2[1]);
    
    // create curve;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointZero];
    //[path addCurveToPoint:CGPointMake(1, 1) controlPoint1:cPt1 controlPoint2:cPt2];
    [path addCurveToPoint:CGPointMake(1, 1) controlPoint1:sPt controlPoint2:ePt];
    
    // scale tht path up to a reasonable size for display;
    [path applyTransform:CGAffineTransformMakeScale(200, 200)];
    
    // create shape layer;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 4.0f;
    shapeLayer.path = path.CGPath;
    [self.layerView.layer addSublayer:shapeLayer];
    //self.layerView.layer.geometryFlipped = YES;
}

- (void)ballFallDown {
    self.ballImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball"]];
    [self.containerView addSubview:self.ballImgView];
    
    //[self ballFallAnimation];
    [self customeAni];
    self.aniType = ANITYPE_BALL;
}

- (void)ballFallAnimation {
    // reset ball to top of screen;
    self.ballImgView.center = CGPointMake(150, 32);
    // create keyframe animation;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    //animation.delegate = self;
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(150, 32)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 140)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 220)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 250)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)]];
    
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    animation.keyTimes = @[@(0.0), @(0.3), @(0.5), @(0.7), @(0.8), @(0.9 ),@(0.95), @(1.0)];
    
    // apply animation;
    self.ballImgView.layer.position = CGPointMake(150, 268);
    [self.ballImgView.layer addAnimation:animation forKey:nil];
}

#pragma mark - 流程自动化;
float interpolate(float from, float to, float time) {
    return (to - from) * time + from;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time {
    if ([fromValue isKindOfClass:[NSValue class]]) {
        // get type;
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            NSLog(@"current compute Point: (%@, %@)", @(result.x), @(result.y));
            return [NSValue valueWithCGPoint:result];
        }
    }
    
    // provide safe default implementation;
    return (time < 0.5) ? fromValue : toValue;
}

- (void)customeAni {
    // reset ball to top of screen;
    self.ballImgView.center = CGPointMake(150, 32);
    
    // set up animation parameters;
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 500)];
    CFTimeInterval duration = 1.0;
    
    // generate the keyFrames;
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        float time = 1 / (float)numFrames * i;
        time = bounceEaseOut(time);
        NSValue *resValue = [self interpolateFromValue:fromValue toValue:toValue time:time];
        CGPoint curPt = [resValue CGPointValue];
        NSLog(@"current returned Point: (%@, %@)", @(curPt.x), @(curPt.y));
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    
    // create keyframe animation;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 10.0;
    //animation.delegate = self;
    animation.values = frames;
    
    // apply animation;
    //self.ballImgView.layer.position = CGPointMake(150, 500);
    [self.ballImgView.layer addAnimation:animation forKey:nil];
    
}

float bounceEaseOut(float t) {
    if (t < 4 / 11.0) {
        return (121 * t * t) / 16;
    } else if (t < 8 / 11.0) {
        return (363 / 40.0 * t * t) - (99/10.0 * t) + 17 / 5.0;
    } else if (t < 9 / 10.0) {
        return (4356 / 361.0 * t * t) - (35442 / 1805.0) + 16061 / 1805.0;
    }
    
    return (54 / 5.0 * t * t) - (513 / 25.0) + 268 / 25.0;
}

@end
