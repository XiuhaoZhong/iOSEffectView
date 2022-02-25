//
//  ReplicatorLayerDemoVC.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/5/10.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "ReplicatorLayerDemoVC.h"

#import <Masonry/Masonry.h>

#import "ReflectorView.h"
#import "ScrollLayerView.h"

@interface ReplicatorLayerDemoVC ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation ReplicatorLayerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self initUI];
//    [self showReplicatorView];
    
//    [self showReflectionView];
    [self showScrollingView];
}

- (void)initUI {
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _containerView = containerView;
}

- (void)showReplicatorView {
    // create a replicator layer and add it to containerView;
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, 390, 800);
    [self.containerView.layer addSublayer:replicatorLayer];
    replicatorLayer.backgroundColor = [UIColor grayColor].CGColor;
    
    // configure the replicator;
    replicatorLayer.instanceCount = 10;
    
    // apply a transform for each instance;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 200, 0, 0);
    transform = CATransform3DRotate(transform, M_PI / 5, 0, 0, 1);
    transform = CATransform3DTranslate(transform, -200, 0, 0);
    replicatorLayer.instanceTransform = transform;
    
    // apply a color shift for each instance;
    replicatorLayer.instanceBlueOffset = -0.1;
    replicatorLayer.instanceGreenOffset = -0.1;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // create a sublayer and place it inside the replicatorLayer;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake((screenWidth - 100) / 2, (screenHeight - 100) / 2, 100, 100);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicatorLayer addSublayer:layer];
}

- (void)showReflectionView {
    ReflectorView *reflectorView = [[ReflectorView alloc] initWithFrame:CGRectMake(0, 0, 390, 800)];
    [self.view addSubview:reflectorView];
}

- (void)showScrollingView {
    ScrollLayerView *scrollView = [[ScrollLayerView alloc] initWithFrame:CGRectMake(50, 100, 300, 300)];
    [self.view addSubview:scrollView];
}

@end
