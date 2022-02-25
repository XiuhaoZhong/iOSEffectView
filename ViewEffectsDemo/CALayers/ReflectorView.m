//
//  ReflectorView.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/5/13.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "ReflectorView.h"

@implementation ReflectorView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self showReflect];
        return self;
    }
    
    return nil;
}

- (void)showReflect {
    // configure replicator;
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    [self.layer addSublayer:replicatorLayer];
    replicatorLayer.frame = CGRectMake(50, 100, 200, 200);
    
    replicatorLayer.instanceCount = 2;
    
    // move reflection instance below original and flip vertically;
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = replicatorLayer.bounds.size.height + 2;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);
    replicatorLayer.instanceTransform = transform;
    
    // reduce alpha of reflection layer;
    replicatorLayer.instanceAlphaOffset = - 0.6;
    
    CALayer *imgLayer = [CALayer layer];
    imgLayer.frame = CGRectMake(0, 0, 200, 200);
    imgLayer.contents = (id)[UIImage imageNamed:@"panda"].CGImage;
    imgLayer.contentsGravity = kCAGravityResizeAspect;
    
    [replicatorLayer addSublayer:imgLayer];
    
    replicatorLayer.opacity = 1;
}

@end
