//
//  Crate.h
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/6/8.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ObjectiveChipmunk.h"

NS_ASSUME_NONNULL_BEGIN

@interface Crate : UIImageView

@property (nonatomic, strong) ChipmunkBody  *cpBody;
@property (nonatomic, strong) ChipmunkShape *cpShape;

@end

NS_ASSUME_NONNULL_END
