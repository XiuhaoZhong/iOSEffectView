//
//  ViewEffectsDemoTools.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/5/14.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "ViewEffectsDemoTools.h"

@implementation ViewEffectsDemoTools

+ (UIColor *)randomColor {
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
