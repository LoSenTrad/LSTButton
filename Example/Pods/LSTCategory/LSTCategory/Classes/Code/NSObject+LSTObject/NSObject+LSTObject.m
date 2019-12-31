//
//  NSObject+QTObject.m
//  qtsdkdemo
//
//  Created by Lambo on 2019/7/11.
//  Copyright © 2019 Lambo. All rights reserved.
//

#import "NSObject+LSTObject.h"

@implementation NSObject (LSTObject)
/** 获取当前屏幕顶层控制器 */
- (UIViewController *)getCurrentUIVC {
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1){
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
            if ([vc isKindOfClass:[UITabBarController class]]) {
                vc = ((UITabBarController*)vc).selectedViewController;
            }
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

/** 获取当前屏幕控制器所在的顶层导航栏 */
- (UINavigationController *)getTopNavigationController {
    UINavigationController *nav;
    UIViewController *temp = self.getCurrentUIVC;
    while (1) {
        temp = temp.parentViewController;
        if ([temp isKindOfClass:[UINavigationController class]]) {
            nav = (UINavigationController *)temp;
        }
        if (temp == nil) {
            break;
        }
    }
    return nav;
}

@end
