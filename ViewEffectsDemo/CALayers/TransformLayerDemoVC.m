//
//  TransformLayerDemoViewController.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/5/8.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "TransformLayerDemoVC.h"

#import <Masonry/Masonry.h>

#define cubeWidth 100

@interface TransformLayerDemoVC ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation TransformLayerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self showCube];
}

- (void)initUI {
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.containerView = containerView;
}

- (CALayer *)faceWithTransform:(CATransform3D)transform {
    // create cube face layer;
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(75, 75, cubeWidth, cubeWidth);
    
    // apply a random color;
    CGFloat red = rand() / (double)INT_MAX;
    CGFloat green = rand() / (double)INT_MAX;
    CGFloat blue = rand() / (double)INT_MAX;
    
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    face.transform = transform;
    
    return face;
}

- (CALayer *)cubeWithTransform:(CATransform3D)transform {
    CATransformLayer *cube= [CATransformLayer layer];
    
    // add cube face1;
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, cubeWidth/ 2);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face2;
    ct = CATransform3DMakeTranslation(cubeWidth / 2, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face3;
    ct = CATransform3DMakeTranslation(0, -cubeWidth / 2, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face4;
    ct = CATransform3DMakeTranslation(0, cubeWidth / 2, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face5;
    ct = CATransform3DMakeTranslation(-cubeWidth / 2, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face6;
    ct = CATransform3DMakeTranslation(0, 0, -cubeWidth / 2);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    CGSize containerSize = self.containerView.bounds.size;
    cube.position = CGPointMake(containerSize.width / 2, containerSize.height / 2);
    cube.transform = transform;
    
    return cube;
}

- (void)showCube {
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500;
    self.containerView.layer.sublayerTransform = pt;
    
    // set up the transform for cube 1 and add it;
    CATransform3D ct1 = CATransform3DIdentity;
    ct1 = CATransform3DTranslate(ct1, 0, 150, 0);
    CALayer *cube1 = [self cubeWithTransform:ct1];
    [self.containerView.layer addSublayer:cube1];
    
    // set up the transform for cube2 and add it;
    CATransform3D ct2 = CATransform3DIdentity;
    ct2 = CATransform3DTranslate(ct2, 0, 300, 0);
    ct2 = CATransform3DRotate(ct2, -M_PI_4, 1, 0, 0);
    ct2 = CATransform3DRotate(ct2, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:ct2];
    [self.containerView.layer addSublayer:cube2];
}

@end
