//
//  LSTButton.m
//  LSTButton
//
//  Created by LoSenTrad on 2018/2/19.
//  Copyright © 2018年 LoSenTrad. All rights reserved.
//

#import "LSTButton.h"
#import "UIView+LSTView.h"
#import <objc/message.h>
#import "NSString+LSTString.h"


static char ActionEventKey;
static char ActionTouchUpInsideEventKey;

NSString const *badgeKey                 = @"badgeKey";
NSString const *badgeBGColorKey          = @"badgeBGColorKey";
NSString const *badgeTextColorKey        = @"badgeTextColorKey";
NSString const *badgeFontKey             = @"badgeFontKey";
NSString const *badgePaddingKey          = @"badgePaddingKey";
NSString const *badgeMinSizeKey          = @"badgeMinSizeKey";
NSString const *badgeOriginXKey          = @"badgeOriginXKey";
NSString const *badgeOriginYKey          = @"badgeOriginYKey";
NSString const *shouldHideBadgeAtZeroKey = @"shouldHideBadgeAtZeroKey";
NSString const *shouldAnimateBadgeKey    = @"shouldAnimateBadgeKey";
NSString const *badgeValueKey            = @"badgeValueKey";


@interface LSTButtonCircleSet : NSObject

@property CGFloat circleCenterX;
@property CGFloat circleCenterY;
@property CGFloat circleWidth;
@property CGFloat circleRait;

@end

@implementation LSTButtonCircleSet

@end

@interface LSTButton ()

@property (nonatomic,strong) UILabel *badge;
@property (nonatomic, assign) int loopCount;
@property (nonatomic, strong) NSMutableDictionary *circles;
@property (nonatomic, assign) int circleFlag;
/** <#.....#> */
@property (nonatomic,strong) UIView *cutView;


/** <#.....#> */
@property (nonatomic,strong) NSString *lastTitle;


@end


@implementation LSTButton

/** 添加点击事件 */
- (void)lst_addEventTouchUpInsideBlock:(LSTButtonActionBlock)actionBlock {
    objc_setAssociatedObject(self, &ActionTouchUpInsideEventKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(clickActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickActionBlock:(UIButton *)sender {
    LSTButtonActionBlock actionBlock = (LSTButtonActionBlock)objc_getAssociatedObject(self, &ActionTouchUpInsideEventKey);
    if (actionBlock) {
        actionBlock(sender);
    }
}

- (void)lst_addTargetWithEvent:(UIControlEvents)event
                andActionBlock:(LSTButtonActionBlock)actionBlock {
    objc_setAssociatedObject(self, &ActionEventKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}



- (void)callActionBlock:(id)sender{
    LSTButtonActionBlock actionBlock = (LSTButtonActionBlock)objc_getAssociatedObject(self, &ActionEventKey);
    if (actionBlock){
        actionBlock(self);
    }
}

#pragma mark - ***** 初始化 *****

+ (instancetype)buttonWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
//        _imageTextSpacing =0;
//        _isAdaptiveWidth = NO;
//        _imageType = LSTButtonImageTypeLeft;
//        _titleFont = [UIFont systemFontOfSize:15];
//        _titleColor = [UIColor blackColor];
//        _corners = UIRectCornerAllCorners;
//        _cornerRadius = 0;
//        _borderWidth = 0.f;
//        _borderColor = [UIColor whiteColor];
//        _backgroundColor = [UIColor whiteColor];
//        self.adjustsImageWhenHighlighted = NO;
        
        // 默认 文字和图片的间距是 0
        _imageTextSpacing = 0.0f;
        // 默认的内边距为 8
        _delta = 5.0;
        self.badgePadding = 2;
        
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        self.AnimationDuration = 1;
        self.loopCount = self.AnimationDuration / 0.02;
        
        self.circles = [NSMutableDictionary dictionary];
        self.circleFlag = 0;
        
        [self addTarget:self action:@selector(touchedDown:event:) forControlEvents:UIControlEventTouchDown];
       
        [self addTarget:self action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
    }
    return self;
}




#pragma mark - ***** setupUI 界面布局 *****

- (void)initSubViews {
    
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    
    
    [self addSubview:self.cutView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

//    self.cutView.frame = CGRectMake(0, self.height*0.5, self.width, 1);
//    self.badge.frame = CGRectMake(CGRectGetMaxX(self.bounds)-10, self.badgeOriginY, 20, 20);
    
//    if (![self.currentTitle isEqualToString:self.lastTitle] && self.lastTitle.length>0) {
//        self if
//    }
    
    
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.layer.backgroundColor = backgroundColor.CGColor;
}

- (void)badgeInit{
    //  初始化，设定默认值
    if (self.badgeBGColor == nil) {
        self.badgeBGColor   = [UIColor redColor];
    }
    if (self.badgeTextColor == nil) {
        self.badgeTextColor = [UIColor whiteColor];
    }
    if (self.badgeFont == nil) {
        self.badgeFont      = [UIFont systemFontOfSize:12.0];
    }
    
    self.badgePadding   = 6;
    self.badgeMinSize   = 8;
    self.badgeOriginX   = self.frame.size.width - self.badge.frame.size.width/2;
    self.badgeOriginY   = -4;
    self.shouldHideBadgeAtZero = YES;
    self.shouldAnimateBadge = YES;
    // 避免角标被裁剪
    self.clipsToBounds = NO;
}

#pragma mark - ***** setter 设置器 *****

- (void)setImageType:(LSTButtonImageType)imageType {
    _imageType = imageType;
    
}

- (void)setImageTextSpacing:(CGFloat)imageTextSpacing {
    _imageTextSpacing = imageTextSpacing;
    
}

- (void)setDelta:(CGFloat)delta {
    
    _delta = delta;
    
}


- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    
}

//-(void)setBadge:(UILabel *)badgeLabel{
//    objc_setAssociatedObject(self, &badgeKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

-(void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
//    objc_setAssociatedObject(self, &badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当角标信息不存在，或者为空，则移除
    if (!badgeValue || [badgeValue isEqualToString:@""] || ([badgeValue isEqualToString:@"0"] && self.shouldHideBadgeAtZero)) {
        [self removeBadgeView];
    } else if (!self.badge) {
        //当又有值时，重新设置角标
        self.badge                      = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bounds), self.badgeOriginY, 20, 20)];
        self.badge.textColor            = self.badgeTextColor;
        self.badge.backgroundColor      = self.badgeBGColor;
        self.badge.font                 = self.badgeFont;
        self.badge.textAlignment        = NSTextAlignmentCenter;
        [self badgeInit];
        [self addSubview:self.badge];
        [self updateBadgeValueAnimated:NO];
    } else {
        [self updateBadgeValueAnimated:YES];
    }
}

//获取关联
-(void)setBadgeBGColor:(UIColor *)badgeBGColor{
    objc_setAssociatedObject(self, &badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

-(void)setBadgeFont:(UIFont *)badgeFont{
    objc_setAssociatedObject(self, &badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}


-(void) setBadgeMinSize:(CGFloat)badgeMinSize{
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

-(void)setBadgeOriginX:(CGFloat)badgeOriginX{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}


#pragma mark - ***** 重写 imageFrame and labelFrame *****

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat contentH = CGRectGetHeight(contentRect);
    CGFloat contentW = CGRectGetWidth(contentRect);
    
    
    CGFloat imageX;
    CGFloat imageY;

    CGFloat imageW;
    CGFloat imageH;

    switch (_imageType) {
        case LSTButtonImageTypeTop:
        {
         
            /*
             图片在上 文字在下
             首先 设置 image 的 h 为 (整个按钮高度 - 两个内边距之后) 的 0.65
             其次 设置 image 的 w 等于 image 的高度
             再者 设置 image 的 x 为 (整个按钮的宽度 - image 的宽度) / 2
             最后 设置 image 的 y 为 一个内边距
             image 是一个正方形
             
             同理 设置 titleLabelFrame 的时候:
             首先 设置 label 的 x 为 一个内边距
             其次 设置 label 的 y 为 (整个按钮高度 - 两个内边距之后) 的 0.65 + 一个内边距 + space
             再者 设置 label 的 w 为 整个按钮高度 - 两个内边距
             最后 设置 label 的 h 为 整个按钮的高度 - label 的 y - 一个内边距的值
             */
            
            if (self.imageSize.height>0 && self.imageSize.width>0) {
                imageH = _imageSize.height;
                imageW = _imageSize.width;
            }else {
                            
                imageH = (CGRectGetHeight(contentRect) - _delta * 2) * 0.65;
                imageW = imageH;
            }

            
            imageX = (CGRectGetWidth(contentRect) - imageW) / 2;

            if (self.imageSize.height>0 && self.imageSize.width>0) {
//                imageY = _imageSize.height * 0.65 - _imageTextSpacing*0.5;
                
            
                
                imageY = (contentH * 0.65 - _imageSize.height)/(0.65*2);

            }else {
                imageY = _delta;
            }
            
          
            
        }
            break;
         
        case LSTButtonImageTypeLeft:
        {
            
            /*
             图片在左，文字在右
             首先 设置 image 的 x 是 一个内边距
             其次 设置 image 的 y 是 一个内边距
             再者 设置 image 的 h 是 整个按钮高度 - 两个内边距
             最后 设置 image 的 w 等于 image 的高度
             image 是个正方形
             
             同理 设置 titleLableFrame 的时候:
             首先 设置 label 的 x 为 一个内边距 + (整个按钮的高度 - 两个内边距) + space
             其次 设置 label 的 y 是 一个内边距
             再者 设置 label 的 w 是 整个按钮宽度 - label 的起始位置 x - 一个内边距
             最后 设置 label 的 h 是 整个按钮高度 - 两个内边距
             */
            
            if (self.imageSize.height>0 && self.imageSize.width>0) {
                imageH = _imageSize.height;
                imageW = _imageSize.width;
            }else {
                
                imageH = CGRectGetHeight(contentRect) - _delta * 2;
                imageW = imageH;
            }
            
            if (self.imageSize.height>0 && self.imageSize.width>0) {
                imageX = (contentW * 0.65 - _imageSize.width)/(0.65*2);
                imageY = (contentH - imageH) / 2;
            }else {
                imageX = _delta;
                imageY = _delta;
            }
            
           
            
            
         
            
        }
            break;
            
        case LSTButtonImageTypeRight:
        {
            
            /*
             图片在右，文字在左
             首先 设置 image 的 h 是 整个按钮高度 - 两个内边距
             其次 设置 image 的 w 等于 image 的高度
             再者 设置 image 的 x 是 整个按钮的宽度 - image 的宽度 - 一个内边距
             最后 设置 image 的 y 是 一个内边距
             image 是个正方形
             
             同理 设置 titleLableFrame 的时候:
             首先 设置 label 的 x 是 一个内边距
             其次 设置 label 的 y 是 一个内边距
             再者 设置 label 的 w 是 整个按钮宽度 - image 的宽度 - 两个内边距 - space
             最后 设置 label 的 h 是 整个按钮高度 - 两个内边距
             */
            imageH = CGRectGetHeight(contentRect) - _delta * 2;
            imageW = imageH;
            
            imageX = CGRectGetWidth(contentRect) - imageW - _delta;
            imageY = _delta;
            
        }
            break;
            
        case LSTButtonImageTypeBottom:
        {
            
            /*
             图片在下 文字在上
             首先 设置 image 的 h 为 (整个按钮高度 - 两个内边距之后) 的 0.65
             其次 设置 image 的 w 等于 image 的高度
             再者 设置 image 的 x 为 (整个按钮的宽度 - image 的宽度) / 2
             最后 设置 image 的 y 为 (整个按钮高度 - 两个内边距之后) - image 的 h + 一个内边距 + space
             image 是一个正方形
             
             同理 设置 titleLabelFrame 的时候:
             首先 设置 label 的 x 为 一个内边距
             其次 设置 label 的 y 为 一个内边距
             再者 设置 label 的 w 为 整个按钮高度 - 两个内边距
             最后 设置 label 的 h 为 整个按钮的高度 - image 的 h - 两个内边距的值 - spcae
             */
            imageH = (CGRectGetHeight(contentRect) - _delta * 2) * 0.65;
            imageW = imageH;
            
            imageX = (CGRectGetWidth(contentRect) - imageW) / 2;
            imageY = (CGRectGetHeight(contentRect) - _delta * 2) - imageH + _delta  + _imageTextSpacing;
            
        }
            break;
            
        default:
        {
            imageX = _delta;
            imageY = _delta;
            
            imageH = CGRectGetHeight(contentRect) - _delta * 2;
            imageW = imageH;
        }
            break;
    }

    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat contentH = CGRectGetHeight(contentRect);
    CGFloat contentW = CGRectGetWidth(contentRect);
    
    CGFloat titleX;
    CGFloat titleY;
    
    CGFloat titleW;
    CGFloat titleH;
    switch (_imageType)
    {
        case LSTButtonImageTypeTop:{
            
            titleX = _delta;
          
            
            if (self.imageSize.height>0 && self.imageSize.width>0) {
                titleY = (contentH * 0.65 - _imageSize.height)/(0.65*2)  + self.imageSize.height + _imageTextSpacing;
            }else {
                titleY = (CGRectGetHeight(contentRect) - _delta * 2) * 0.65 + _delta + _imageTextSpacing;
            }
            
            
            titleW = CGRectGetWidth(contentRect) - _delta * 2;
            
            if (self.imageSize.height>0 && self.imageSize.width>0) {
                titleH = CGRectGetHeight(contentRect) - (contentH * 0.65 - _imageSize.height)/(0.65*2)*2 - _imageSize.height-_imageTextSpacing;
            }else {
                titleH = CGRectGetHeight(contentRect) - titleY - _delta;
            }
            
            
            
        }
            break;
            
        case LSTButtonImageTypeLeft:
        {
            
            if (self.imageSize.height>0 && self.imageSize.width>0) {
                titleX = (contentW * 0.65 - _imageSize.width)/(0.65*2)  + self.imageSize.width + _imageTextSpacing;
                titleY = _delta;
                
                titleW = CGRectGetWidth(contentRect) - (contentW * 0.65 - _imageSize.width)/(0.65*2)*2 - _imageSize.width-_imageTextSpacing;
                titleH =  CGRectGetHeight(contentRect) - _delta * 2;


            }else {

                titleX = _delta + (CGRectGetHeight(contentRect) - _delta * 2) + _imageTextSpacing;
                titleY = _delta;
                
                titleW = CGRectGetWidth(contentRect) - titleX - _delta;
                titleH = CGRectGetHeight(contentRect) - _delta * 2;
            }
            
            
        
            
        }
            break;
            
        case LSTButtonImageTypeRight:
        {
            
            titleX = _delta;
            titleY = _delta;
            
            titleW = CGRectGetWidth(contentRect) - (CGRectGetHeight(contentRect) - _delta * 2) - _delta * 2 - _imageTextSpacing;
            titleH = CGRectGetHeight(contentRect) - _delta * 2;
            
        }
            break;
            
        case LSTButtonImageTypeBottom:
        {
            
            titleX = _delta;
            titleY = _delta;
            
            titleW = CGRectGetWidth(contentRect) - _delta * 2;
            titleH = CGRectGetHeight(contentRect) - (CGRectGetHeight(contentRect) - _delta * 2) * 0.65 - _delta * 2 - _imageTextSpacing;
            
        }break;
            
        default:
        {
            titleX = _delta + (CGRectGetHeight(contentRect) - _delta * 2) + _imageTextSpacing;
            titleY = _delta;
            
            titleW = CGRectGetWidth(contentRect) - titleX - _delta;
            titleH = CGRectGetHeight(contentRect) - _delta * 2;
        }
            break;
    }

    return CGRectMake(titleX, titleY, titleW, titleH);
}



#pragma mark - ***** other *****


//按钮的压下事件 按钮缩小
- (void)pressedEvent:(LSTButton *)btn
{
    //缩放比例必须大于0，且小于等于1
//    CGFloat scale = (_btnScaleRatio && _btnScaleRatio <=1.0) ? _btnScaleRatio : defaultScale;
    CGFloat scale = 0.9;

    [UIView animateWithDuration:0.5 animations:^{
        btn.transform = CGAffineTransformMakeScale(scale, scale);
    }];
    [self layoutIfNeeded];
    [self layoutSubviews];
}
//点击手势拖出按钮frame区域松开，响应取消
- (void)cancelEvent:(LSTButton *)btn
{
    [UIView animateWithDuration:0.5 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
    [self layoutIfNeeded];
    [self layoutSubviews];
}
//按钮的松开事件 按钮复原 执行响应
- (void)unpressedEvent:(LSTButton *)btn
{
    [UIView animateWithDuration:0.5 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        //执行动作响应
//        if (self.clickBlock) {
//            self.clickBlock();
//        }
    }];
    [self layoutIfNeeded];
    [self layoutSubviews];
}


// 当角标的属性改变时，调用此方法
- (void)refreshBadge{
    // 更新属性
    self.badge.textColor        = self.badgeTextColor;
    self.badge.backgroundColor  = self.badgeBGColor;
    self.badge.font             = self.badgeFont;
}

/**
 *  更新角标的frame
 */
- (void)updateBadgeFrame{
    

    CGFloat oldHeight = [self.titleLabel.text getWidthWithFont:self.titleLabel.font];
    CGFloat oldWidth = [self.titleLabel.text getHeightWithFont:self.titleLabel.font andWidth:self.titleLabel.width];
    
    CGFloat minHeight = oldHeight;
    
    // 判断如果小于最小size，则为最小size
    minHeight = (minHeight < self.badgeMinSize) ? self.badgeMinSize : oldHeight;
    CGFloat minWidth = oldWidth;
    CGFloat padding = self.badgePadding;
    
    // 填充边界
    minWidth = (minWidth < minHeight) ? minHeight : oldWidth;
    self.badge.frame = CGRectMake(self.badgeOriginX, self.badgeOriginY, minWidth + padding, minHeight + padding);
    self.badge.layer.cornerRadius = (minHeight + padding) / 2;
    self.badge.layer.masksToBounds = YES;
}

// 角标值变化
- (void)updateBadgeValueAnimated:(BOOL)animated{
    // 动画效果
    if (animated && self.shouldAnimateBadge && ![self.badge.text isEqualToString:self.badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.badge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    self.badge.text = self.badgeValue;
    
    // 动画时间
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self updateBadgeFrame];
    }];
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    return duplicateLabel;
}

- (void)removeBadgeView{
    // 移除角标
    [UIView animateWithDuration:0.2 animations:^{
        self.badge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.badge removeFromSuperview];
        self.badge = nil;
    }];
}

-(void)touchedDown:(UIButton *)btn event:(UIEvent *)event{
    
    UITouch *touch = event.allTouches.allObjects.firstObject;
    CGPoint touchePoint = [touch locationInView:btn];
    
    NSString *key = [NSString stringWithFormat:@"%d",self.circleFlag];
    LSTButtonCircleSet *set = [LSTButtonCircleSet new];
    set.circleCenterX = touchePoint.x;
    set.circleCenterY = touchePoint.y;
    set.circleRait = 0;
    
    CGFloat maxX = touchePoint.x>(self.frame.size.width-touchePoint.x)?touchePoint.x:(self.frame.size.width-touchePoint.x);
    CGFloat maxY = touchePoint.y>(self.frame.size.width-touchePoint.y)?touchePoint.y:(self.frame.size.height-touchePoint.y);
    set.circleWidth = maxX>maxY?maxX:maxY;
    
    [self.circles setObject:set forKey:key];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.001
                                             target:self
                                           selector:@selector(TimerFunction:)
                                           userInfo:@{@"key":key}
                                            repeats:YES];
    
    [NSRunLoop.mainRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.circleFlag++;
}

-(void)TimerFunction:(NSTimer *)timer{
    
    [self setNeedsDisplay];
    
    NSDictionary *userInfo = timer.userInfo;
    
    NSString *key = userInfo[@"key"];
    
    LSTButtonCircleSet *set = self.circles[key];
    
    if(set.circleRait<=1){
        
        set.circleRait += (1.0/self.loopCount);
        
    }else{
        [self.circles removeObjectForKey:key];
        
        [timer invalidate];
    }
}

/** 显示BadgeView(根据属性配置显示) */
- (void)showBadgeView {
    
    NSLog(@"%f",self.titleLabel.font.lineHeight);
}

#pragma mark - ***** getter 懒加载 *****

//-(UILabel*)badge {
//    return objc_getAssociatedObject(self, &badgeKey);
//}


// 显示角标
//-(NSString *)badgeValue {
//    return objc_getAssociatedObject(self, &badgeValueKey);
//}

//进行关联
-(UIColor *)badgeBGColor {
    return objc_getAssociatedObject(self, &badgeBGColorKey);
}


-(UIColor *)badgeTextColor {
    return objc_getAssociatedObject(self, &badgeTextColorKey);
}

-(void)setBadgeTextColor:(UIColor *)badgeTextColor{
    objc_setAssociatedObject(self, &badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

-(UIFont *)badgeFont {
    return objc_getAssociatedObject(self, &badgeFontKey);
}


-(CGFloat) badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &badgeMinSizeKey);
    return number.floatValue;
}


-(CGFloat) badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &badgeOriginXKey);
    return number.floatValue;
}


-(CGFloat) badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &badgeOriginYKey);
    return number.floatValue;
}
-(void) setBadgeOriginY:(CGFloat)badgeOriginY{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

-(BOOL) shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &shouldHideBadgeAtZeroKey);
    return number.boolValue;
}
- (void)setShouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero{
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &shouldAnimateBadgeKey);
    return number.boolValue;
}

- (void)setShouldAnimateBadge:(BOOL)shouldAnimateBadge{
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)cutView {
    if(_cutView) return _cutView;
    _cutView = [[UIView alloc] init];
    _cutView.backgroundColor = UIColor.blackColor;
    return _cutView;
}



//-(void)drawRect:(CGRect)rect{
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGFloat endAngle = M_PI * 2;
//
//    for (LSTButtonCircleSet *circleSet in self.circles.allValues) {
//        CGContextAddArc(context,
//                        circleSet.circleCenterX,
//                        circleSet.circleCenterY,
//                        circleSet.circleWidth * circleSet.circleRait,
//                        0,
//                        endAngle,
//                        NO);
//
//        [[self.highlightedColor colorWithAlphaComponent:(1-circleSet.circleRait)] setStroke];
//        [[self.highlightedColor colorWithAlphaComponent:(1-circleSet.circleRait)] setFill];
//
//        CGContextFillPath(context);
//    }
//}

@end
