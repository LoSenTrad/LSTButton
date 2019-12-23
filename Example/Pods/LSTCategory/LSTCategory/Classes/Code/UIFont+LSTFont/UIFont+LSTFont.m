//
//  UIFont+LSTFont.m
//  LSTCategory_Example
//
//  Created by LoSenTrad on 2019/8/20.
//  Copyright © 2019 LoSenTrad. All rights reserved.
//

#import "UIFont+LSTFont.h"

@implementation UIFont (LSTFont)

/** 返回UIFont对象 */
UIFont * LSTFont(CGFloat value) {
    return [UIFont systemFontOfSize:value];
}
/** 返回Bold UIFont对象 */
UIFont * LSTBoldFont(CGFloat value) {
    return [UIFont boldSystemFontOfSize:value];
}

@end
