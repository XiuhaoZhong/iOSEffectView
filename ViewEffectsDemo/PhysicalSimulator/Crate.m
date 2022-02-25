//
//  Crate.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/6/8.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import "Crate.h"



#define MASS 100

@interface Crate ()



@end

@implementation Crate

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // set image;
        self.image = [UIImage imageNamed:@"ball"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        // create the body;
        self.cpBody = [[ChipmunkBody alloc] initWithMass:MASS andMoment:cpMomentForBox(MASS, frame.size.width, frame.size.height)];
        
        // create the shape;
        cpVect corners[] = {cpv(0, 0), cpv(0, frame.size.height), cpv(frame.size.width, frame.size.height), cpv(frame.size.width, 0)};
        
        self.cpShape = [ChipmunkShape shapeFromCPShape:cpPolyShapeNew(self.cpBody.body, 4, corners, cpTransformIdentity, 6)];
        // 设置摩擦力;
        [self.cpShape setFriction:0.5];
        // 设置弹性;
        [self.cpShape setElasticity:0.8];
        
        // link the crate to the shape so we can refer to crate from callback later on;
        self.cpShape.userData = self;
        
        // set the body position to match view;
        [self.cpBody setPosition:cpv(frame.origin.x + frame.size.width / 2, 300 - frame.origin.y - frame.size.height / 2)];
        
        return self;
    }
    
    return nil;
}

@end
