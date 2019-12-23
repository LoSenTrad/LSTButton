//
//  LSTBadgeView.m
//  LayerDemo1
//
//  Created by LoSenTrad on 2019/9/26.
//  Copyright © 2019 AceWei. All rights reserved.
//

#import "LSTBadgeView.h"
#import <UIView+LSTView.h>
#import <objc/runtime.h>

@interface UIView (BadgeView)

/** <#.....#> */
@property (nonatomic,strong) UIView *backView;
/** <#.....#> */
@property (nonatomic,strong) UIView *frontView;
/** <#.....#> */
@property (nonatomic,strong) UILabel *label;
/** <#.....#> */
@property (nonatomic,strong) CAShapeLayer *BezierLayer;

 // backView
/**  */
@property (nonatomic, assign) CGFloat r1;

// frontView
/**  */
@property (nonatomic, assign) CGFloat r2;

/**  */
@property (nonatomic, assign) CGFloat x1;

/**  */
@property (nonatomic, assign) CGFloat y1;

/**  */
@property (nonatomic, assign) CGFloat x2;

/**  */
@property (nonatomic, assign) CGFloat y2;

/**  */
@property (nonatomic, assign) CGFloat centerDistance;

/**  */
@property (nonatomic, assign) CGFloat cosDigree;

/**  */
@property (nonatomic, assign) CGFloat sinDigree;

 //A
/**  */
@property (nonatomic, assign) CGPoint pointA;
 //B
/**  */
@property (nonatomic, assign) CGPoint pointB;
 //D
/**  */
@property (nonatomic, assign) CGPoint pointD;
 //C
/**  */
@property (nonatomic, assign) CGPoint pointC;
 //O
/**  */
@property (nonatomic, assign) CGPoint pointO;
 //P
/**  */
@property (nonatomic, assign) CGPoint pointP;

@end

@implementation UIView (LSTBadgeView)

/**
 OBJC_ASSOCIATION_ASSIGN    assign
 OBJC_ASSOCIATION_RETAIN_NONATOMIC    nonatomic, strong
 OBJC_ASSOCIATION_COPY_NONATOMIC    nonatomic, copy
 OBJC_ASSOCIATION_RETAIN    atomic, strong
 OBJC_ASSOCIATION_COPY    atomic, copy
 */


- (void)showBadgeWithHandleBlock:(LSTBadgeViewBlock)HandleBlock {
    
    [self initSubViews];
    [self addGesture];
    
    self.BezierLayer = [CAShapeLayer layer];
    self.BezierLayer.lineWidth = 1;
    self.BezierLayer.fillColor = self.bgColor.CGColor;
    [self.layer insertSublayer:self.BezierLayer atIndex:0];


}


#pragma mark - ***** 界面布局 *****

-(void)initSubViews {
    self.bgColor = [UIColor redColor];
    CGFloat DefaultSize = CGRectGetHeight(self.frame);
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DefaultSize, DefaultSize)];
    self.backView.backgroundColor = self.bgColor;
    self.backView.layer.cornerRadius = CGRectGetHeight(self.backView.frame)/2;
    self.backView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:self.backView];
    
    
    self.frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), DefaultSize)];
    self.frontView.backgroundColor = self.bgColor;
    self.frontView.layer.cornerRadius = DefaultSize/2;
    [self addSubview:self.frontView];
    
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), DefaultSize)];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.layer.cornerRadius = DefaultSize/2;
    
    self.label.text = @"9999";
    if (self.bubbleText.length>0) {
        self.label.text = self.bubbleText;
    }
    [self.frontView addSubview:self.label];
}



-(void)addGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction:)];
    [self.frontView addGestureRecognizer:pan];
}


- (void)doHandlePanAction:(UIPanGestureRecognizer *)paramSender
{
    CGPoint point = [paramSender translationInView:self];
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    [paramSender setTranslation:CGPointMake(0, 0) inView:self];
    
    //粘度设置
    if (self.viscosity == 0) {
        self.viscosity = 50;
    }
    if (self.viscosity < 30) {
        self.viscosity = 30;
    }
    if (self.viscosity > 90) {
        self.viscosity = 500;
    }
    
    
    [self addBezierPathLayer:self.BezierLayer];
    
    
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        self.backView.hidden = NO;
    }
    
    
    if (paramSender.state == UIGestureRecognizerStateChanged) {
        if (self.centerDistance>self.viscosity) {
            self.BezierLayer.path = nil;
            self.backView.hidden = YES;
        } else {
            self.backView.hidden = NO;
        }
    }
    
    
    if (paramSender.state == UIGestureRecognizerStateEnded || paramSender.state ==UIGestureRecognizerStateCancelled || paramSender.state == UIGestureRecognizerStateFailed) {
        
        //距离50以内没问题
        if (self.centerDistance < self.viscosity) {
            self.BezierLayer.path = nil;
            self.backView.hidden = YES;
            [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.2f initialSpringVelocity:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                paramSender.view.center = self.backView.center;
            } completion:nil];
        } else {
            //距离50外
//            [self removeFromSuperview];
        }
        
    }
    
}


-(void)addBezierPathLayer:(CAShapeLayer *)layer
{
    self.x1 = self.backView.center.x;
    self.y1 = self.backView.center.y;
    self.x2 = self.frontView.center.x;
    self.y2 = self.frontView.center.y;
    
    self.centerDistance = sqrtf((self.x2-self.x1)*(self.x2-self.x1)+(self.y2-self.y1)*(self.y2-self.y1));
    
    
    
    CGFloat size = self.frame.size.height-self.centerDistance*0.2;
    self.backView.frame = CGRectMake(0, 0, size, size);
    self.backView.center = CGPointMake(self.x1, self.y1);
    self.backView.layer.cornerRadius = CGRectGetWidth(self.backView.frame)/2;
    
    
#if 1
    
    self.r1 = self.backView.frame.size.height/2;
    self.r2 = self.frontView.frame.size.height/2;
    
    if (self.centerDistance == 0) {
        self.cosDigree = 1;
        self.sinDigree = 0;
    }else{
        self.cosDigree = (self.y2-self.y1)/self.centerDistance;
        self.sinDigree = (self.x2-self.x1)/self.centerDistance;
    }
    
    float m = 2;
    self.pointA = CGPointMake(self.x1-self.r1*self.cosDigree, self.y1+self.r1*self.sinDigree);  // A
    self.pointB = CGPointMake(self.x1+self.r1*self.cosDigree, self.y1-self.r1*self.sinDigree); // B
    self.pointD = CGPointMake(self.x2-self.r2*self.cosDigree, self.y2+self.r2*self.sinDigree); // D
    self.pointC = CGPointMake(self.x2+self.r2*self.cosDigree, self.y2-self.r2*self.sinDigree);// C
    self.pointO = CGPointMake(self.pointA.x + (self.centerDistance / m)*self.sinDigree, self.pointA.y + (self.centerDistance / m)*self.cosDigree);
    self.pointP = CGPointMake(self.pointB.x + (self.centerDistance / m)*self.sinDigree, self.pointB.y + (self.centerDistance / m)*self.cosDigree);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    //B→C  D→A  需要贝赛尔曲线
    [path moveToPoint:self.pointA];
    [path addQuadCurveToPoint:self.pointD controlPoint:self.pointO];
    [path addLineToPoint:self.pointC];
    [path addQuadCurveToPoint:self.pointB controlPoint:self.pointP];
    [path moveToPoint:self.pointA];
    
    layer.path = path.CGPath;
    
#endif
}


- (UIView *)backView {
    return objc_getAssociatedObject(self, @selector(backView));
}

- (void)setBackView:(UIView *)backView {
     objc_setAssociatedObject(self, @selector(backView), backView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)frontView {
    return objc_getAssociatedObject(self, @selector(frontView));
}

- (void)setFrontView:(UIView *)frontView {
    objc_setAssociatedObject(self, @selector(frontView), frontView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)label {
     return objc_getAssociatedObject(self, @selector(label));
}

- (void)setLabel:(UILabel *)label {
    objc_setAssociatedObject(self, @selector(label), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)BezierLayer {
    return objc_getAssociatedObject(self, @selector(BezierLayer));
}

- (void)setBezierLayer:(CAShapeLayer *)BezierLayer {
    objc_setAssociatedObject(self, @selector(BezierLayer), BezierLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)bubbleText {
     return objc_getAssociatedObject(self, @selector(bubbleText));
}

- (void)setBubbleText:(NSString *)bubbleText {
     objc_setAssociatedObject(self, @selector(bubbleText), bubbleText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)bgColor {
    return objc_getAssociatedObject(self, @selector(bgColor));
}

- (void)setBgColor:(UIColor *)bgColor {
     objc_setAssociatedObject(self, @selector(bgColor), bgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)viscosity {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setViscosity:(CGFloat)viscosity {
     objc_setAssociatedObject(self, @selector(viscosity), @(viscosity), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)r1 {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setR1:(CGFloat)r1 {
    objc_setAssociatedObject(self, @selector(r1), @(r1), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)r2 {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setR2:(CGFloat)r2 {
    objc_setAssociatedObject(self, @selector(r2), @(r2), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)x1 {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setX1:(CGFloat)x1 {
    objc_setAssociatedObject(self, @selector(x1), @(x1), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)y1 {
     return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setY1:(CGFloat)y1 {
    objc_setAssociatedObject(self, @selector(y1), @(y1), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)centerDistance {
     return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCenterDistance:(CGFloat)centerDistance {
    objc_setAssociatedObject(self, @selector(centerDistance), @(centerDistance), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)x2 {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setX2:(CGFloat)x2 {
    objc_setAssociatedObject(self, @selector(x2), @(x2), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)y2 {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setY2:(CGFloat)y2 {
    objc_setAssociatedObject(self, @selector(y2), @(y2), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)cosDigree {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCosDigree:(CGFloat)cosDigree {
    objc_setAssociatedObject(self, @selector(cosDigree), @(cosDigree), OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)pointA {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setPointA:(CGPoint)pointA {
    NSValue *value = [NSValue valueWithCGPoint:pointA];
    objc_setAssociatedObject(self, @selector(pointA), value, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)sinDigree {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSinDigree:(CGFloat)sinDigree {
    objc_setAssociatedObject(self, @selector(sinDigree), @(sinDigree), OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)pointB {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setPointB:(CGPoint)pointB {
     NSValue *value = [NSValue valueWithCGPoint:pointB];
    objc_setAssociatedObject(self, @selector(pointB), value, OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)pointD {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setPointD:(CGPoint)pointD {
    NSValue *value = [NSValue valueWithCGPoint:pointD];
    objc_setAssociatedObject(self, @selector(pointD), value, OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)pointC {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setPointC:(CGPoint)pointC {
    NSValue *value = [NSValue valueWithCGPoint:pointC];
    objc_setAssociatedObject(self, @selector(pointC), value, OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)pointO {
    
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setPointO:(CGPoint)pointO {
    NSValue *value = [NSValue valueWithCGPoint:pointO];
    objc_setAssociatedObject(self, @selector(pointO), value, OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)pointP {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setPointP:(CGPoint)pointP {
    NSValue *value = [NSValue valueWithCGPoint:pointP];
    objc_setAssociatedObject(self, @selector(pointP), value, OBJC_ASSOCIATION_ASSIGN);
}





@end
