//
//  DrawView.m
//  DrawDemo
//
//  Created by zhongxiuhao on 2020/3/30.
//  Copyright © 2020 zhongxiuhao. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //[super drawRect:rect];
    // Drawing code
    //[self drawLine];
    
    //[self drawLashLine];
    
    //[self drawRectangle];
    
    //[self drawEllipse];
    
    [self drawCircle];
    
    //[self drawCurve];
}


- (void)drawLine {
    // 1.获取自动生成的上下文对象;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2.设置图形状态;
    // 笔触的颜色;
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    // 填充颜色;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.26 green:0.27 blue:0.31 alpha:1.0].CGColor);
    // 设置线条的宽度;
    CGContextSetLineWidth(context, 5);
    // 设置定点样式;
    CGContextSetLineCap(context, kCGLineCapRound);
    // 设置连接点样式;
    CGContextSetLineJoin(context, kCGLineJoinBevel);
    // 保存图形状态;
    CGContextSaveGState(context);
    
    // 3.创建并设置路径;
    CGMutablePathRef path = CGPathCreateMutable();
    /*
     path: 路径对象
     m:    变化矩阵
     x, y: 坐标点;
     */
    // 移动画笔到某个点;
    CGPathMoveToPoint(path, nil, 100, 50);
    // 以上一个点为起点，目标点为终点绘制直线，并默认把次终点作为起点;
    CGPathAddLineToPoint(path, nil, 50, 100);
    CGPathAddLineToPoint(path, nil, 150, 100);
    CGPathAddLineToPoint(path, nil, 100, 50);
    // 4.添加路径到上下文;
    CGContextAddPath(context, path);
    
    // 5.绘制路径 在绘制的时候会自动关闭当前路径
    /*
     CGContextRef:      上下文对象;
     CGPathDrawingMode: 绘制模式;
     **/
    CGContextDrawPath(context, kCGPathFillStroke);
    // 5.释放路径;
    CGPathRelease(path);
}

- (void)drawLashLine {
    // 1.获取自动生成的上下文对象;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2.设置线段样式;
    /*
     phase:   虚线开始的位置;
     lengths: 虚线长度间隔;
     count:   虚线数组元素个数;
     **/
    CGFloat lengths[2] = {20, 10};
    CGContextSetLineDash(context, 3, lengths, 2);
    [[UIColor blueColor] setFill];
    [[UIColor yellowColor] setStroke];
    
    /*
     设置阴影;
     context: 图形上下文;
     offset:  偏移量;
     blur:    模糊度;
     color:   阴影颜色;
     **/
    // 颜色转化， Quartz 2d必须使用转换后的颜色;
    CGColorRef color = [UIColor grayColor].CGColor;
    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 0.8, color);
    
    // 3.创建以下路径;
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 250, 50);
    CGContextAddLineToPoint(context, 200, 100);
    CGContextAddLineToPoint(context, 300, 100);
    CGContextClosePath(context);
    
    // 4.绘制路径，绘制完成自动释放;
    CGContextStrokePath(context);
}

- (void)drawRectangle {
    // 1.获取自动生成的上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2.设置图形形状
    // 前面drawLine中调用CContextSaveGState保存了图形状态，这里恢复保存的图像状态;
    CGContextRestoreGState(context);
    // 3.创建路径;
    CGContextAddRect(context, CGRectMake(50, 150, 100, 50));
    // 4.绘制图形;
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawEllipse {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(200, 150, 100, 50));
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawCircle {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor yellowColor] setFill];
    [[UIColor blackColor] setStroke];
    
    for (NSInteger i = 0; i < 2; i++) {
        CGContextAddArc(context, 100, 300, 50 - i * 20, 0, M_PI * 2, NO);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    for (NSInteger i = 0; i < 2; i++) {
        CGContextAddArc(context, 250, 300, 50 - i * 20, i ? M_PI * 2 : 0, i ? 0 : M_PI * 2 , i ? YES : NO);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawCurve {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor redColor] setFill];
    [[UIColor blueColor] setStroke];
    
    CGContextSaveGState(context);
    
    CGContextAddArc(context, 20, 200, 5, 0, M_PI * 2, NO);
    CGContextFillPath(context);
    
    CGContextAddArc(context, 100, 50, 5, 0, M_PI * 2, NO);
    CGContextFillPath(context);
    
    CGContextAddArc(context, self.bounds.size.width - 20, 300, 5, 0, M_PI * 2, NO);
    CGContextFillPath(context);
    
    CGContextMoveToPoint(context, 20, 200);
    CGContextAddLineToPoint(context, 100, 50);
    CGContextAddLineToPoint(context, self.bounds.size.width - 20, 300);
    CGContextStrokePath(context);
    
    [[UIColor blackColor] setStroke];
    [[UIColor yellowColor] setFill];
    
    CGContextSetLineWidth(context, 2);
    
    CGContextMoveToPoint(context, 20, 200);
    
    
    CGContextAddQuadCurveToPoint(context, 100, 50, self.bounds.size.width - 30, 300);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

- (void)animation {
    CABasicAnimation *baseAnim = [CABasicAnimation valueForKey:@"position"];
    baseAnim.duration = 2;
    
    
}

@end
