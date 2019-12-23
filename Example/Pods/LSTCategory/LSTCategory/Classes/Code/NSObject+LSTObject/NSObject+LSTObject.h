//
//  NSObject+QTObject.h
//  qtsdkdemo
//
//  Created by Lambo on 2019/7/11.
//  Copyright © 2019 Lambo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LSTObject)

/** 获取当前屏幕顶层控制器 */
- (UIViewController *)getCurrentUIVC;


@end

NS_ASSUME_NONNULL_END
