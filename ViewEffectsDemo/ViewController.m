//
//  ViewController.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2020/8/7.
//  Copyright © 2020 zhongxiuhao. All rights reserved.
//

#import "ViewController.h"
#import "BasicAnimationVC.h"
#import "Masonry.h"

#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>
#import <CoreText/CoreText.h>

#import "TransformLayerDemoVC.h"
#import "ReplicatorLayerDemoVC.h"
#import "CoreAnimationDemoVC.h"
#import "ExplicitAnimationDemoVC.h"
#import "CAMediaTimingDemoVC.h"
#import "AnimationBufferVC.h"
#import "PhysicalSimVC.h"

#import "CSJLabel.h"

#define faceWidth 60

#define LIGHT_DIRECTION 0, 1, 0.5
#define AMBIENT_LIGHT 0.9

@interface ViewController ()

@property (nonatomic, strong) UIButton  *basicAniBtn;

@property (nonatomic, strong) NSMutableArray<UIView *> *faces;
@property (nonatomic, strong) UIView                   *cubicContainer;

// textDemo;
@property (nonatomic, strong) UIView                   *shapeLayerDemoView;
@property (nonatomic, strong) UIView                   *textDemoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    
    //[self initUI];
    //[self showCubic];
    
//    TransformLayerDemoVC *transformDemoVC = [TransformLayerDemoVC new];
//    [self.view addSubview:transformDemoVC.view];
//    [transformDemoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
//    ReplicatorLayerDemoVC *replicatorLayerDemoVC = [ReplicatorLayerDemoVC new];
//    [self.view addSubview:replicatorLayerDemoVC.view];
//    [replicatorLayerDemoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
//    CoreAnimationDemoVC *coreAniVC = [CoreAnimationDemoVC new];
//    [self.view addSubview:coreAniVC.view];
//    [coreAniVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
//    ExplicitAnimationDemoVC *explicitAniVC = [ExplicitAnimationDemoVC new];
//    [self.view addSubview:explicitAniVC.view];
//    [explicitAniVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//    [self addChildViewController:explicitAniVC];
    
//    CAMediaTimingDemoVC *timingDemoVC = [CAMediaTimingDemoVC new];
//    [self.view addSubview:timingDemoVC.view];
//    [timingDemoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//    [self addChildViewController:timingDemoVC];
    
//    AnimationBufferVC *aniBufferDemoVC = [AnimationBufferVC new];
//    [self.view addSubview:aniBufferDemoVC.view];
//    [aniBufferDemoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//    [self addChildViewController:aniBufferDemoVC];
    
//    PhysicalSimVC *physicVC = [PhysicalSimVC new];
//    [self.view addSubview:physicVC.view];
//    [physicVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//    [self addChildViewController:physicVC];
    
    //[self showScroll];
    
}

- (void)initUI {
    [self.view addSubview:self.basicAniBtn];
    [_basicAniBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
}

- (UIButton *)basicAniBtn {
    if (!_basicAniBtn) {
        UIButton *basicAniBtn = [UIButton new];
        [basicAniBtn setTitle:@"BasicAnimation" forState:UIControlStateNormal];
        [basicAniBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [basicAniBtn addTarget:self action:@selector(navigateVC:) forControlEvents:UIControlEventTouchUpInside];
        _basicAniBtn = basicAniBtn;
    }
    
    return _basicAniBtn;
}

- (void)navigateVC:(UIButton *)clickBtn {
    if (clickBtn == _basicAniBtn) {
        BasicAnimationVC *basicAnimationVC = [[BasicAnimationVC alloc] init];
        [self addChildViewController:basicAnimationVC];
        
        [self.view addSubview:basicAnimationVC.view];
        
        if (self.navigationController) {
            NSLog(@"navigationController is ok");
        } else {
            NSLog(@"navigationController is not ok");
        }
        
        [self.navigationController pushViewController:basicAnimationVC animated:YES];
    }
}

- (void)applyLightingToFace:(CALayer *)face {
    // add lighting layer
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    // convert the face transform to matrix
    // (GLKitMatrix4 has the same structure as CATransform3D)
    
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    // get face normal;
    GLKVector3 normal = GLKVector3Make(1, 1, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    // get dot product with light direction;
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    
    // set lighting layer opacity;
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
}


- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform {
    UIView *face = self.faces[index];
    [self.cubicContainer addSubview:face];
    CGSize containerSize = self.cubicContainer.frame.size;
    face.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    face.layer.transform = transform;
    [self applyLightingToFace:face.layer];
}

- (void)showCubic {
    
    self.faces = [NSMutableArray new];
    
    UIView *container = [UIView new];
    container.frame = CGRectMake(50, 100, 300, 300);
    self.view.backgroundColor = [UIColor grayColor];
    container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:container];
    self.cubicContainer = container;
    
    for (NSInteger i = 0; i < 6; i++) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor blackColor].CGColor;
        view.frame = CGRectMake(0, 0, faceWidth, faceWidth);
        view.layer.borderWidth = 1;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(faceWidth / 4, faceWidth / 4, faceWidth / 2, faceWidth / 2)];
        [view addSubview:label];
        label.text = [NSString stringWithFormat:@"%ld", i];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.faces addObject:view];
    }

    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.cubicContainer.layer.sublayerTransform = perspective;
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, faceWidth / 2);
    [self addFace:0 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(faceWidth / 2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];

    transform = CATransform3DMakeTranslation(0, -faceWidth / 2, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];

    transform = CATransform3DMakeTranslation(0, faceWidth / 2, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];

    transform = CATransform3DMakeTranslation(-faceWidth / 2, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];

    transform = CATransform3DMakeTranslation(0, 0, -faceWidth / 2);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}

#pragma mark - CAShapeLayer 上绘制图案;
- (void)shapeLayerDemo {
    _shapeLayerDemoView = [UIView new];
    [self.view addSubview:_shapeLayerDemoView];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(175, 100)];
    
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    // create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    
    CGRect rect = CGRectMake(100, 300, 100, 100);
    CGSize radii = CGSizeMake(20, 20);
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    
    [path appendPath:rectPath];
    shapeLayer.path = path.CGPath;
    [self.textDemoView.layer addSublayer:shapeLayer];
}

#pragma mark - TextLayer 上绘制文字;
- (void)textLayerDemo {
    _textDemoView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 300, 200)];
    [self.view addSubview:_textDemoView];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = _textDemoView.bounds;
    [_textDemoView.layer addSublayer:textLayer];
    
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    // 该参数不设置的话，字体渲染出来会像素化;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    /* font without rich text */
//    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
//    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
//    textLayer.font = fontRef;
//    textLayer.fontSize = font.pointSize;
//    CGFontRelease(fontRef);
    /* font without rich text */
    
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet lobortis";
    
    
    // rich text
    
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:text];
    
    // convert UIFont to a CTFont;
    CFStringRef richFontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef richFontRef = CTFontCreateWithName(richFontName, fontSize, NULL);
    
    // set text attributes;
    NSDictionary *attribs = @{
        (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
        (__bridge id)kCTFontAttributeName:(__bridge id)richFontRef
    };
    
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
    attribs = @{
        (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor redColor].CGColor,
        (__bridge id)kCTUnderlineStyleAttributeName:@(kCTUnderlineStyleSingle),
        (__bridge id)kCTFontAttributeName:(__bridge id)richFontRef
    };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    
    // release the CTFont we created earliser;
    CFRelease(richFontRef);
    textLayer.string = string;
    // rich text
    
    // rich without text and rich text can't set together;
    
    //textLayer.string = text;
}

- (void)showScroll {
    UIScrollView *scrollView = [UIScrollView new];
    UILabel *lbl = [UILabel new];
    lbl.text = @"biubiubiubiubiubiubiubiubiubiubiubiubiubiu~";
    lbl.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    [scrollView addSubview:lbl];
    lbl.frame = CGRectMake(0, 0, 100, 300);
    
    scrollView.contentSize = CGSizeMake(100, 300);
    scrollView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

@end
