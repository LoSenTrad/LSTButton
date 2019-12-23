//
//  LSTButton.h
//  LSTButton
//
//  Created by LoSenTrad on 2018/2/19.
//  Copyright © 2018年 LoSenTrad. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮图文布局样式
typedef NS_ENUM(NSUInteger,LSTButtonImageType) {
    LSTButtonImageTypeLeft,    //系统默认样式,左图右文字
    LSTButtonImageTypeRight,   //右图左文字
    LSTButtonImageTypeTop,     //上图下文字
    LSTButtonImageTypeBottom,  //下图上文字
};

/** badge样式 */
typedef NS_ENUM(NSUInteger, LSTBadgeType) {
    LSTBadgeTypePoint,  //默认小红点
    LSTBadgeTypeNew,    //小红点new标识
    LSTBadgeTypeNumber, //小红点数量
    LSTBadgeTypeCustom  //自定义图片
};

/** badge 动画样式 */
typedef NS_ENUM(NSUInteger, LSTBadgeAnimationType) {
    LSTBadgeAnimationTypeNone,     //无动画
    LSTBadgeAnimationTypeShake,    //抖动
    LSTBadgeAnimationTypeOpacity,  //透明过渡动画
    LSTBadgeAnimationTypeScale,    //缩放动画
};

/** 点击 动画效果样式 */
typedef NS_ENUM(NSUInteger, LSTClickAnimationType) {
    LSTClickAnimationTypeNone,     //无动画
    LSTClickAnimationTypeWave,    //水波纹效果
    LSTClickAnimationTypeHighlight,  //聚光高亮显示
    LSTClickAnimationTypeScale,  //缩放效果
};

typedef NS_ENUM(NSInteger, LPButtonStyle){
    LPButtonStyleTop,       // 图片在上，文字在下
    LPButtonStyleLeft,      // 图片在左，文字在右
    LPButtonStyleRight,     // 图片在右，文字在左
    LPButtonStyleBottom,    // 图片在下，文字在上
};


typedef void(^LSTButtonActionBlock)(id sender);


@interface LSTButton : UIButton <UIGestureRecognizerDelegate>

/**
 图片和文字的间距
 */
//@property (nonatomic, assign) CGFloat space;
/**
 整个LPButton(包含ImageV and titleV)的内边距
 */
@property (nonatomic, assign) CGFloat delta;



/** 是否根据文字内容自适应宽度 默认为NO */
@property (nonatomic,assign) BOOL isAdaptiveWidth;
/** 按钮图文布局样式 */
@property (nonatomic,assign) LSTButtonImageType imageType;
/** 按钮图文间距 默认为6.0f */
@property (nonatomic,assign) CGFloat imageTextSpacing;

//*********************文字属性设置
/** 按钮文字内容 UIControlStateNormal状态 */
@property (nonatomic,copy) NSString *title;
/** 按钮文字大小 默认是15 UIControlStateNormal状态 */
@property (nonatomic,strong) UIFont *titleFont;
/** 按钮文字颜色 默认是黑色 UIControlStateNormal状态 */
@property (nonatomic,strong) UIColor *titleColor;

//*********************图片相关属性设置
@property (nonatomic,strong) UIImage *image;
/** 图片大小 */
@property (nonatomic,assign) CGSize imageSize;
/** 圆角处理 默认是UIRectCornerAllCorners上下左右4圆角 */
@property (nonatomic,assign) UIRectCorner corners;
/** 圆角大小 默认是0 */
@property (nonatomic,assign) CGFloat cornerRadius;

//*********************背景相关属性设置
/** 背景颜色 默认白色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 背景图 默认为nil */
@property (nonatomic, strong) UIImage *backgroundImage;

//*********************边框相关属性设置
/** 边框线条颜色 (默认 clearColor) */
@property (nonatomic, strong) UIColor *borderColor;
/** 边框线条宽度 (默认 0 ) */
@property (nonatomic, assign) CGFloat borderWidth;

//*********************badge相关属性设置*********************
/** 角标显示的信息，可以为数字和文字*/
@property (nonatomic) NSString *badgeValue;
/** 角标背景颜色，默认为红色 */
@property (nonatomic) UIColor *badgeBGColor;
/**  角标文字的颜色 */
@property (nonatomic) UIColor *badgeTextColor;
/**  角标字号 */
@property (nonatomic) UIFont *badgeFont;
/** 角标的气泡边界 */
@property (nonatomic) CGFloat badgePadding;
/** 角标的最小尺寸 */
@property (nonatomic) CGFloat badgeMinSize;
/** 角标的x值 */
@property (nonatomic) CGFloat badgeOriginX;
/** 角标的y值 */
@property (nonatomic) CGFloat badgeOriginY;
/** 当角标为0时，自动去除角标 */
@property BOOL shouldHideBadgeAtZero;
//********************************************************

//动画时间，默认为1秒
@property (nonatomic, assign) NSTimeInterval AnimationDuration;
//动画颜色 (默认 橙色)
@property (nonatomic, strong) UIColor *highlightedColor;

/** 缩放比例 */
@property (nonatomic,assign) CGFloat btnScaleRatio;
/** 缩放持续时间 */
@property (nonatomic,assign) CGFloat scaleTimeInterval;




+ (instancetype)buttonWithFrame:(CGRect)frame;

/** 显示BadgeView(根据属性配置显示) */
- (void)showBadgeView;
/** 移除BadgeView */
- (void)removeBadgeView;

/** 添加点击事件 */
- (void)lst_addEventTouchUpInsideBlock:(LSTButtonActionBlock)actionBlock;
/** 添加UIControlEvents时间 */
- (void)lst_addTargetWithEvent:(UIControlEvents)event
                andActionBlock:(LSTButtonActionBlock)actionBlock;

@end
