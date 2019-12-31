//
//  UIFont+LSTFont.h
//  LSTCategory_Example
//
//  Created by LoSenTrad on 2019/8/20.
//  Copyright © 2019 LoSenTrad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (LSTFont)

/** 返回UIFont对象 */
UIFont * LSTFont(CGFloat value);
/** 返回Bold UIFont对象 */
UIFont * LSTBoldFont(CGFloat value);





@end




NS_ASSUME_NONNULL_END
