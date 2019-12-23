//
//  UIView+GLDragBlast.m
//  AiyoyouCocoapods
//
//  Created by gulu on 2018/5/29.
//  Copyright © 2018年 gulu. All rights reserved.
//
/*
 设置拖动时改变大小的圆为circle1
 被拖动的圆则为当前的视图
 */
//设置最大偏移距离为当前控件的倍数
#define MAXMultiple 3

#import "UIView+GLDragBlast.h"
#import <objc/runtime.h>

NSString const *kTapBlastKey = @"kTapBlastKey";
NSString const *kDragBlastKey = @"kDragBlastKey";
static const void *kCompletionKey = @"kCompletionKey";

@interface UIView (_GLDragBlast)
@property (readwrite, nonatomic, strong, setter = setCircle1:) UIView   *circle1;
@property(readwrite,nonatomic,strong) CAShapeLayer                      *shapeLayer;
@property(readwrite,nonatomic,strong) UIView                            *restSuperView;//保存self的父视图，用于复位
@property (readwrite, nonatomic, copy, setter = setCompletion:) void (^completion)(BOOL finished);
@property (readwrite, nonatomic, assign, setter = setOriginalPoint:) CGPoint originalPoint;//保留初始值
@end

@implementation UIView (_GLDragBlast)

- (void)setRestSuperView:(UIView *)restSuperView {
    objc_setAssociatedObject(self, @selector(restSuperView), restSuperView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)restSuperView {
     return objc_getAssociatedObject(self, @selector(restSuperView));
}

- (void)setCircle1:(UIView *)circle1 {
    objc_setAssociatedObject(self, @selector(circle1), circle1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)circle1 {
    return objc_getAssociatedObject(self, @selector(circle1));
}

- (void)setShapeLayer:(CAShapeLayer *)shapeLayer {
    objc_setAssociatedObject(self, @selector(shapeLayer), shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)shapeLayer {
    return objc_getAssociatedObject(self, @selector(shapeLayer));
}

- (void)setOriginalPoint:(CGPoint)originalPoint {
    objc_setAssociatedObject(self, @selector(originalPoint), NSStringFromCGPoint(originalPoint), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGPoint)originalPoint {
    return CGPointFromString(objc_getAssociatedObject(self, @selector(originalPoint)));
}

- (void)setCompletion:(void (^)(BOOL))completion {
    objc_setAssociatedObject(self, kCompletionKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(BOOL))completion {
    return objc_getAssociatedObject(self, kCompletionKey);
}

@end

@implementation UIView (GLDragBlast)

#pragma mark - setters

- (void)setTapBlast:(BOOL)tapBlast {
    objc_setAssociatedObject(self, (__bridge const void *)(kTapBlastKey), [NSNumber numberWithBool:tapBlast], OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.userInteractionEnabled = YES;
    //self.translatesAutoresizingMaskIntoConstraints = NO;
    if (tapBlast) {
         UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlastAction:)];
        [self addGestureRecognizer:tapGR];
    }else{
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
            if ([gesture isMemberOfClass:[UITapGestureRecognizer class]]) {
                [gesture removeTarget:self action:@selector(tapBlastAction:)];
            }
        }
    }

}

- (void)setDragBlast:(BOOL)dragBlast {
    objc_setAssociatedObject(self, (__bridge const void *)(kDragBlastKey), [NSNumber numberWithBool:dragBlast], OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.userInteractionEnabled = YES;
    
    if (!self.circle1) {
        self.circle1 = [[UIView alloc] init];
        self.circle1.hidden = YES;
    }
  
    self.originalPoint = CGPointZero;
    
    if (dragBlast) {
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPanAction:)];
        [self addGestureRecognizer:panGR];
    }else{
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
            if ([gesture isMemberOfClass:[UIPanGestureRecognizer class]]) {
                [gesture removeTarget:self action:@selector(dragPanAction:)];
            }
        }
    }
    
}

- (void)setIsFragment:(BOOL)isFragment {
    objc_setAssociatedObject(self, @selector(isFragment), [NSNumber numberWithBool:isFragment], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - getters
- (BOOL)tapBlast {
    return [objc_getAssociatedObject(self, (__bridge const void *)(kTapBlastKey)) boolValue];
}

- (BOOL)dragBlast {
    return [objc_getAssociatedObject(self, (__bridge const void *)(kDragBlastKey)) boolValue];
}

- (BOOL)isFragment {
    return [objc_getAssociatedObject(self, @selector(isFragment)) boolValue];
}

- (CAShapeLayer *)getShapeLayer {
    if (!self.shapeLayer) {
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.fillColor = self.backgroundColor.CGColor;
    }
    return self.shapeLayer;
}

#pragma mark - Method
- (void)blastCompletion:(void (^)(BOOL finished))completion {
    self.completion = completion;
    self.dragBlast = YES;
}

- (void)tapBlastAction:(UITapGestureRecognizer *)tap {
    if (self.tapBlast) {
        tap.view.hidden = YES;
        self.circle1.hidden = YES;
        self.originalPoint = tap.view.center;
        if (self.isFragment) {
            [self boomCellsInGesture:tap];
        }else{
            [self aViewBlastEffect:tap];
        }
        
    }else{
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            self.circle1.hidden = NO;
        }];
        
    }
    
}

- (void)dragPanAction:(UIPanGestureRecognizer *)pan {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGPoint translation = [pan translationInView:window];
    CGPoint topFloorPoint = [pan.view.superview convertPoint:pan.view.center  toView:window];
    if (CGPointEqualToPoint(self.originalPoint, CGPointZero)){
        self.originalPoint = topFloorPoint;//pan.view.center;
    }
    CGPoint panPoint = CGPointMake(topFloorPoint.x+ translation.x,
                                    topFloorPoint.y + translation.y);
    pan.view.center= panPoint;
    [pan setTranslation:CGPointZero inView:window];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.circle1.bounds = pan.view.bounds;
            self.circle1.layer.cornerRadius = pan.view.layer.cornerRadius;
            self.circle1.layer.masksToBounds = pan.view.layer.masksToBounds;
            self.circle1.backgroundColor = pan.view.backgroundColor;
            self.circle1.center = self.originalPoint;
            self.circle1.hidden = NO;
            self.restSuperView = pan.view.superview;
            
            [window addSubview:self];
            [window insertSubview:self.circle1 belowSubview:self];
            [window.layer insertSublayer:[self getShapeLayer] below:self.circle1.layer];
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //  设置circle1变化的值
            CGFloat centerDistance = [self distanceWithPoint1:self.circle1.center andPoint2:pan.view.center];
            CGFloat scale = 1- centerDistance/(MAXMultiple*pan.view.bounds.size.height);
            if (centerDistance >MAXMultiple*pan.view.bounds.size.height) {
                self.shapeLayer.path = nil;
                //[self.shapeLayer removeFromSuperlayer];
                //self.shapeLayer = nil;
                self.circle1.hidden = YES;
                
            }else{
                self.circle1.hidden = NO;
                [self reloadBeziePath:1-scale];
            }

            if (scale < 0.4) {
                scale = 0.4;
            }
            self.circle1.transform = CGAffineTransformMakeScale(scale, scale);
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //求圆心距离
            CGFloat distance = sqrtf(pow(self.originalPoint.x- panPoint.x, 2)+pow(self.originalPoint.y- panPoint.y, 2));
            
            if (distance>MAXMultiple*pan.view.bounds.size.height) {
                pan.view.hidden = YES;
                
                if (self.isFragment) {
                    [self boomCellsInGesture:pan];
                }else{
                   [self aViewBlastEffect:pan];
                }
                
            }else{
                self.circle1.hidden = YES;
                self.shapeLayer.path = nil;
                //设置动画时间，阻尼系数，初始速度，动画方式
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                     pan.view.center = self.circle1.center;
                    
                } completion:^(BOOL finished) {
                    
                    [self.circle1 removeFromSuperview];
                    [self.shapeLayer removeFromSuperlayer];
                    //复位
                    [self.restSuperView addSubview:self];
                    CGPoint belowFloorPoint = [window convertPoint:pan.view.center  toView:self.restSuperView];
                    //判定该视图有没有添加约束
                    if (self.translatesAutoresizingMaskIntoConstraints) {
                        self.center = belowFloorPoint;
                    }else{
                        CGFloat R = self.bounds.size.height/2.0;
                        //创建左边约束
                        NSLayoutConstraint *leftLc = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.restSuperView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:belowFloorPoint.x-R];
                        [self.restSuperView addConstraint:leftLc];
                        //创建顶部约束
                        NSLayoutConstraint *topLc = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.restSuperView attribute:NSLayoutAttributeTop multiplier:1.0 constant:belowFloorPoint.y-R];
                        [self.restSuperView addConstraint:topLc];
                    }
                    
                }];
                
            }

        }
            break;
            
        default:
            break;
    }

}

- (void)aViewBlastEffect:(UIGestureRecognizer *)gesture {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //获取在顶层视图的位置
    CGRect topFloorRect = [gesture.view.superview convertRect:gesture.view.frame  toView:window];
    //爆炸效果
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:topFloorRect];
    imageView.contentMode = UIViewContentModeCenter;
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 1 ; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"unreadBomb_%d",i]];
        [imageArr addObject:image];
    }
    imageView.animationImages = imageArr;
    imageView.animationDuration = 0.5;
    imageView.animationRepeatCount = 1;
    [imageView startAnimating];
    [window addSubview:imageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageView removeFromSuperview];
        [self.circle1 removeFromSuperview];
        [self.shapeLayer removeFromSuperlayer];
        //复位
        [self.restSuperView addSubview:gesture.view];
        CGPoint belowFloorPoint = [window convertPoint:self.originalPoint  toView:self.restSuperView];
        //判断有没有约束和是那种手势
        if (self.translatesAutoresizingMaskIntoConstraints) {
            gesture.view.center = belowFloorPoint;
        }else if([gesture isMemberOfClass:[UIPanGestureRecognizer class]] && !self.translatesAutoresizingMaskIntoConstraints){
            CGFloat R = self.bounds.size.height/2.0;
            //创建左边约束
            NSLayoutConstraint *leftLc = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.restSuperView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:belowFloorPoint.x-R];
            [self.restSuperView addConstraint:leftLc];
            //创建顶部约束
            NSLayoutConstraint *topLc = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.restSuperView attribute:NSLayoutAttributeTop multiplier:1.0 constant:belowFloorPoint.y-R];
            [self.restSuperView addConstraint:topLc];
        }
        //self.hidden = NO;
        if (self.completion) {
            self.completion(self.hidden);
        }
    });

}

#pragma mark - 获取圆心距离
- (CGFloat)distanceWithPoint1:(CGPoint)point1  andPoint2:(CGPoint)point2 {
    CGFloat offSetX = point1.x - point2.x;
    CGFloat offSetY = point1.y - point2.y;
    //平方根sqrt(9) = 3  N次方pow(x,N)表示x的N次方
    return sqrt(pow(offSetX, 2) + pow(offSetY, 2));
}
#pragma mark - 绘制贝塞尔图形
- (void) reloadBeziePath:(CGFloat)scale {
    CGFloat r1 = self.circle1.frame.size.width / 2.0f;
    CGFloat r2 = self.frame.size.width / 2.0f;
    
    CGFloat x1 = self.circle1.center.x;
    CGFloat y1 = self.circle1.center.y;
    CGFloat x2 = self.center.x;
    CGFloat y2 = self.center.y;
    
    CGFloat distance = sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2));
    
    CGFloat sinDegree = (x2 - x1) / distance;
    CGFloat cosDegree = (y2 - y1) / distance;
    
    CGPoint pointA = CGPointMake(x1 - r1 * cosDegree, y1 + r1 * sinDegree);
    CGPoint pointB = CGPointMake(x1 + r1 * cosDegree, y1 - r1 * sinDegree);
    CGPoint pointC = CGPointMake(x2 + r2 * cosDegree, y2 - r2 * sinDegree);
    CGPoint pointD = CGPointMake(x2 - r2 * cosDegree, y2 + r2 * sinDegree);
    CGPoint pointP = CGPointMake(pointB.x + (distance / 2) * sinDegree, pointB.y + (distance / 2) * cosDegree);
    CGPoint pointO = CGPointMake(pointA.x + (distance / 2) * sinDegree, pointA.y + (distance / 2) * cosDegree);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: pointA];
    [path addLineToPoint: pointB];
    
    [path addQuadCurveToPoint: pointC controlPoint: CGPointMake(pointP.x-r1*cosDegree*scale, pointP.y+r1*sinDegree*scale)];
    /*
    if (distance>r1+r2) {
        [path addQuadCurveToPoint: pointC controlPoint: CGPointMake(pointP.x-r1*cosDegree*scale, pointP.y+r1*sinDegree*scale)];
    }else{
        [path addQuadCurveToPoint: pointC controlPoint: pointP];
    }
     */
    [path addLineToPoint: pointD];
    
    [path addQuadCurveToPoint: pointA controlPoint: CGPointMake(pointO.x+r1*cosDegree*scale, pointO.y-r1*sinDegree*scale)];
    /*
    if (distance >r1+r2) {
        [path addQuadCurveToPoint: pointA controlPoint: CGPointMake(pointO.x+r1*cosDegree*scale, pointO.y-r1*sinDegree*scale)];
    }else{
        [path addQuadCurveToPoint: pointA controlPoint: pointO];
    }
    */
    [self getShapeLayer].path = path.CGPath;
}

#pragma mark ============= CALayer实现粒子爆炸动画

- (void)boomCellsInGesture:(UIGestureRecognizer *)gesture {
    NSInteger rowClocn = 3;
    NSMutableArray *boomCells = [NSMutableArray array];
    for (int i = 0; i < rowClocn*rowClocn; ++ i) {
        CGFloat pw = MIN(self.frame.size.width, self.frame.size.height);
        CALayer *shape = [CALayer layer];
        shape.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
        shape.cornerRadius = pw / 2;
        //shape.frame = CGRectMake((i/rowClocn) * pw, (i%rowClocn) * pw, pw, pw);
        shape.frame = CGRectMake(0, 0, pw, pw);
        [self.layer.superlayer addSublayer: shape];
        [boomCells addObject: shape];
    }
    [self cellAnimations:boomCells withGesture:gesture];
}
- (void)cellAnimations:(NSArray*)cells withGesture:(UIGestureRecognizer *)gesture {
    
    for (NSInteger j=0; j<cells.count;j++) {
        CALayer *shape = cells[j];
        shape.position = self.center;
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.toValue = @0.6;
        
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
        pathAnimation.path = [self makeRandomPath: shape AngleTransformation:j].CGPath;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        
        animationGroup.animations = @[scaleAnimation,pathAnimation,];
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.duration = 0.5;
        animationGroup.removedOnCompletion = NO;
        animationGroup.repeatCount = 1;
        
        [shape addAnimation: animationGroup forKey: @"animationGroup"];
        [self performSelector:@selector(removeLayer:) withObject:shape afterDelay:animationGroup.duration];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        //复位
        [self.restSuperView addSubview:gesture.view];
        CGPoint belowFloorPoint = [window convertPoint:self.originalPoint  toView:self.restSuperView];
        //判断有没有约束和是那种手势
        if (self.translatesAutoresizingMaskIntoConstraints) {
            gesture.view.center = belowFloorPoint;
        }else if([gesture isMemberOfClass:[UIPanGestureRecognizer class]] && !self.translatesAutoresizingMaskIntoConstraints){
            CGFloat R = self.bounds.size.height/2.0;
            //创建左边约束
            NSLayoutConstraint *leftLc = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.restSuperView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:belowFloorPoint.x-R];
            [self.restSuperView addConstraint:leftLc];
            //创建顶部约束
            NSLayoutConstraint *topLc = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.restSuperView attribute:NSLayoutAttributeTop multiplier:1.0 constant:belowFloorPoint.y-R];
            [self.restSuperView addConstraint:topLc];
        }

        
        if (self.completion) {
            self.completion(self.hidden);
        }
    });
    
}
- (void)removeLayer:(CALayer *)layer {
    [layer removeAnimationForKey:@"animationGroup"];
    layer.hidden = YES;
    [layer removeFromSuperlayer];
    
}

#pragma mark - 设置碎片路径
- (UIBezierPath *)makeRandomPath: (CALayer *) alayer AngleTransformation:(CGFloat)index {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.center];
    CGFloat dia = self.frame.size.width;
    if (index>0) {
        CGFloat angle = index*45*M_PI*2/360;
        CGFloat x = dia*cosf(angle);
        CGFloat y = dia*sinf(angle);
        [path addLineToPoint:CGPointMake(self.center.x + x, self.center.y+y)];
    }else{
        [path addLineToPoint:CGPointMake(self.center.x, self.center.y)];
    }
    return path;
}

@end
