//
//  PopupVCManager.h
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/4/21.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopupVCManager : NSObject

// 缓存的VC;
@property (nonatomic, strong) UIViewController *cacheVC;
// 当前展示的VC;
@property (nonatomic, strong) UIViewController *curVC;

// 展示一个半屏弹窗;
- (void)showPopupView;
// 关闭一个半屏弹窗
// isCached: 是否缓存改弹窗，从关闭从其中弹出的弹窗时，重新弹出;
- (void)dismissPopupView:(BOOL)isCached;

@end

NS_ASSUME_NONNULL_END
