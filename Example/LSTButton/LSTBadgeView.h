//
//  UIView+BadgeView.h
//  LayerDemo1
//
//  Created by LoSenTrad on 2019/9/26.
//  Copyright © 2019 AceWei. All rights reserved.
//

#import <UIKit/UIKit.h>



///** badge样式 */
//typedef NS_ENUM(NSUInteger, LSTBadgeType) {
//    LSTBadgeTypePoint,  //默认小红点
//    LSTBadgeTypeString, //小红点数量
//    LSTBadgeTypeImage  //自定义图片
//};
//
///** badge 动画样式 */
//typedef NS_ENUM(NSUInteger, LSTBadgeAnimationType) {
//    LSTBadgeAnimationTypeNone,     //无动画
//    LSTBadgeAnimationTypeShake,    //抖动
//    LSTBadgeAnimationTypeOpacity,  //透明过渡动画
//    LSTBadgeAnimationTypeScale,    //缩放动画
//};

typedef void(^LSTBadgeViewBlock)(id sender);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LSTBadgeView)

/**显示文字 */
@property (nonatomic,strong) id badgeValue;
/** 背景颜色 */
@property UIColor *bgColor;
/**
 *  黏性距离，不设置默认50，允许设置范围30~90
 */
@property CGFloat viscosity;


- (void)showBadgeWithHandleBlock:(LSTBadgeViewBlock)HandleBlock;

@end

NS_ASSUME_NONNULL_END
