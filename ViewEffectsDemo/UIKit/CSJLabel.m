//
//  CSJLabel.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/12/6.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "CSJLabel.h"

@implementation CSJLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGRect selfRect = self.bounds;
    if (selfRect.origin.x > 0) {
        NSLog(@"get current");
    }
    
    UIFont *font = [UIFont boldSystemFontOfSize:20.0];
    NSDictionary *attrDict = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor redColor]};
    //[@"绘制文字" drawInRect:CGRectMake(180, 270, 30, 150) withAttributes:attrDict];
    
    [self.text drawInRect:selfRect withAttributes:attrDict];
}



@end
