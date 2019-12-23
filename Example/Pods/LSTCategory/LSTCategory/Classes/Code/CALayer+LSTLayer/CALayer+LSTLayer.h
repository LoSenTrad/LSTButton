//
//  CALayer+LSTLayer.h
//  DYwttai
//
//  Created by LoSenTrad on 2017/5/23.
//  Copyright © 2017年 dongyu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (LSTLayer)

+ (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity
                      target:(UIView *)view;


@end
