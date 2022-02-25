//
//  AppDelegate.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2020/8/7.
//  Copyright © 2020 zhongxiuhao. All rights reserved.
//

#import "AppDelegate.h"

#import "CoreAnimationDemoVC.h"
#import "ExplicitAnimationDemoVC.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 以下代码使用了tabBarController来切换不同的VC，带有过渡的切换效果，默认情况下注释掉;
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    CoreAnimationDemoVC *CADemoVC = [CoreAnimationDemoVC new];
//    ExplicitAnimationDemoVC *EADemoVC = [ExplicitAnimationDemoVC new];
//
//    self.tabBarController = [UITabBarController new];
//    self.tabBarController.viewControllers = @[CADemoVC, EADemoVC];
//    self.tabBarController.delegate = self;
//    self.window.rootViewController = self.tabBarController;
//    
//    [self.window makeKeyWindow];
    
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // set up crossfade transition;
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;//kCATransitionFade;
    
    // apply transition to tab bar controller's view;
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}


@end
