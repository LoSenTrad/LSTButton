//
//  UIProgressView+LSTWebViewProgress.m
//  KitNote
//
//  Created by LoSenTrad on 2019/7/16.
//  Copyright © 2019 LoSenTrad. All rights reserved.
//

#import "UIProgressView+LSTWebViewProgress.h"
#import <objc/runtime.h>

@implementation UIProgressView (LSTWebViewProgress)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, @selector(setProgress:));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(lst_setProgress:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
        originalMethod = class_getInstanceMethod(self, @selector(setProgress:animated:));
        swizzledMethod = class_getInstanceMethod(self, @selector(lst_setProgress:animated:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)lst_setProgress:(float)progress {
    [self lst_setProgress:progress];
    [self checkHiddenWhenProgressApproachFullSize];
}
- (void)lst_setProgress:(float)progress animated:(BOOL)animated {
    [self lst_setProgress:progress animated:animated];
    [self checkHiddenWhenProgressApproachFullSize];
}

- (void)checkHiddenWhenProgressApproachFullSize {
    if (!self.lst_hiddenWhenProgressApproachFullSize) {
        return;
    }
    float progress = self.progress;
    if (progress < 1) {
        if (self.hidden) {
            self.hidden = NO;
        }
    } else if (progress >= 1) {
        [UIView animateWithDuration:0.35 delay:0.15 options:7 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.hidden = YES;
                self.progress = 0.0;
                self.alpha = 1.0;
            }
        }];
    }
}

- (BOOL)lst_hiddenWhenProgressApproachFullSize {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLst_hiddenWhenProgressApproachFullSize:(BOOL)lst_hiddenWhenProgressApproachFullSize {
    objc_setAssociatedObject(self, @selector(lst_hiddenWhenProgressApproachFullSize), @(lst_hiddenWhenProgressApproachFullSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
