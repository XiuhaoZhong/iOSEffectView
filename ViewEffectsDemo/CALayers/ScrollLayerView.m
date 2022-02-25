//
//  ScrollLayerView.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/5/13.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "ScrollLayerView.h"

@interface ScrollLayerView ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ScrollLayerView

+ (Class)layerClass {
    return [CAScrollLayer class];
}

- (void)showScrollView {
    // enable clipping;
    self.layer.masksToBounds = YES;
    
    // attch pan gesture recognizer;
    UIPanGestureRecognizer *panRecoginzer = nil;
    panRecoginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panRecoginzer];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self showScrollView];
        return self;
    }
    
    return nil;
}

- (void)initUI {
    self.imgView = [UIImageView new];
    self.imgView.image = [UIImage imageNamed:@"panda"];
    
    [self addSubview:self.imgView];
    self.imgView.frame = CGRectMake(0, 0, 500, 500);
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    // get the offset of subtracting the pan gesture;
    // translation from the current bounds origin;
    CGPoint offset = self.bounds.origin;
    
    NSLog(@"track debug: current pos: (%@, %@)", @([recognizer translationInView:self].x), @([recognizer translationInView:self].y));
    
    offset.x -= [recognizer translationInView:self].x;
    offset.y -= [recognizer translationInView:self].y;
    
    // scroll the layer;
    [(CAScrollLayer *)self.layer scrollPoint:offset];
    
    // reset the pan gesture translation;
    [recognizer setTranslation:CGPointZero inView:self];
}

@end
