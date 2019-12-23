//
//  CALayer+LSTLayer.m
//  DYwttai
//
//  Created by LoSenTrad on 2017/5/23.
//  Copyright © 2017年 dongyu. All rights reserved.
//

#import "CALayer+LSTLayer.h"

@implementation CALayer (LSTLayer)

+ (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity
                      target:(UIView *)view {
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, view.bounds);
    view.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOffset = offset;
    view.layer.shadowRadius = radius;
    view.layer.shadowOpacity = opacity;
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    view.clipsToBounds = NO;

}

@end
