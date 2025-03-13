//
//  LSTButton.h
//  CHMerchant
//
//  Created by LoSenTrad on 2021/8/18.
//  Copyright © 2021 Fenzhidao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




/// 控制图片在UIButton里的位置，默认为LSTButtonImagePositionLeft
typedef NS_ENUM(NSUInteger, LSTButtonImagePosition) {
    LSTButtonImagePositionTop,             // imageView在titleLabel上面
    LSTButtonImagePositionLeft,            // imageView在titleLabel左边
    LSTButtonImagePositionBottom,          // imageView在titleLabel下面
    LSTButtonImagePositionRight,           // imageView在titleLabel右边
};

/**
 *  用于 `LSTButton.cornerRadius` 属性，当 `cornerRadius` 为 `LSTButtonCornerRadiusAdjustsBounds` 时，`LSTButton` 会在高度变化时自动调整 `cornerRadius`，使其始终保持为高度的 1/2。
 */
extern const CGFloat LSTButtonCornerRadiusAdjustsBounds;

/**
 *  提供以下功能：
 *  1. 支持让文字和图片自动跟随 tintColor 变化（系统的 UIButton 默认是不响应 tintColor 的）。
 *  2. 支持自动将圆角值保持为按钮高度的一半。
 *  3. highlighted、disabled 状态均通过改变整个按钮的alpha来表现，无需分别设置不同 state 下的 titleColor、image。alpha 的值可在配置表里修改 ButtonHighlightedAlpha、ButtonDisabledAlpha。
 *  4. 支持点击时改变背景色颜色（highlightedBackgroundColor）。
 *  5. 支持点击时改变边框颜色（highlightedBorderColor）。
 *  6. 支持设置图片相对于 titleLabel 的位置（imagePosition）。
 *  7. 支持设置图片和 titleLabel 之间的间距，无需自行调整 titleEdgeInests、imageEdgeInsets（spacingBetweenImageAndTitle）。
 *  @warning LSTButton 重新定义了 UIButton.titleEdgeInests、imageEdgeInsets、contentEdgeInsets 这三者的布局逻辑，sizeThatFits: 里会把 titleEdgeInests 和 imageEdgeInsets 也考虑在内（UIButton 不会），以使这三个接口的使用更符合直觉。
 */
@interface LSTButton : UIButton



/** 标题 对UIControlStateNormal生效 */
@property (nonatomic, copy) NSString *title;
/** 标题颜色  对UIControlStateNormal生效  */
@property (nonatomic,strong, nullable) UIColor *titleColor;
/** 标题字体  对UIControlStateNormal生效   */
@property (nonatomic,strong, nullable) UIFont *titleFont;
/** 背景颜色  对UIControlStateNormal生效  */
@property (nonatomic,strong, nullable) UIColor *bgColor;
/** 图标  对UIControlStateNormal生效 */
@property (nonatomic,strong, nullable) UIImage *image;
/** 背景图  对UIControlStateNormal生效 */
@property (nonatomic,strong, nullable) UIImage *bgImage;
/** 图片大小 */
@property (nonatomic,assign) CGSize imageSize;

/**
 *  子类继承时重写的方法，一般不建议重写 initWithXxx
 */
- (void)didInitialize NS_REQUIRES_SUPER;

/**
 * 让按钮的文字颜色自动跟随tintColor调整（系统默认titleColor是不跟随的）<br/>
 * 默认为NO
 */
@property(nonatomic, assign) IBInspectable BOOL adjustsTitleTintColorAutomatically;

/**
 * 让按钮的图片颜色自动跟随tintColor调整（系统默认image是需要更改renderingMode才可以达到这种效果）<br/>
 * 默认为NO
 */
@property(nonatomic, assign) IBInspectable BOOL adjustsImageTintColorAutomatically;

/**
 *  等价于 adjustsTitleTintColorAutomatically = YES & adjustsImageTintColorAutomatically = YES & tintColor = xxx
 *  @warning 不支持传 nil
 */
@property(nonatomic, strong) IBInspectable UIColor *tintColorAdjustsTitleAndImage;

/**
 * 是否自动调整highlighted时的按钮样式，默认为YES。<br/>
 * 当值为YES时，按钮highlighted时会改变自身的alpha属性为<b>ButtonHighlightedAlpha</b>
 */
@property(nonatomic, assign) IBInspectable BOOL adjustsButtonWhenHighlighted;

/**
 * 是否自动调整disabled时的按钮样式，默认为YES。<br/>
 * 当值为YES时，按钮disabled时会改变自身的alpha属性为<b>ButtonDisabledAlpha</b>
 */
@property(nonatomic, assign) IBInspectable BOOL adjustsButtonWhenDisabled;

/**
 * 设置按钮点击时的背景色，默认为nil。
 * @warning 不支持带透明度的背景颜色。当设置highlightedBackgroundColor时，会强制把adjustsButtonWhenHighlighted设为NO，避免两者效果冲突。
 * @see adjustsButtonWhenHighlighted
 */
@property(nonatomic, strong, nullable) IBInspectable UIColor *highlightedBackgroundColor;

/**
 * 设置按钮点击时的边框颜色，默认为nil。
 * @warning 当设置highlightedBorderColor时，会强制把adjustsButtonWhenHighlighted设为NO，避免两者效果冲突。
 * @see adjustsButtonWhenHighlighted
 */
@property(nonatomic, strong, nullable) IBInspectable UIColor *highlightedBorderColor;

/**
 * 设置按钮里图标和文字的相对位置，默认为LSTButtonImagePositionLeft<br/>
 * 可配合imageEdgeInsets、titleEdgeInsets、contentHorizontalAlignment、contentVerticalAlignment使用
 */
@property(nonatomic, assign) LSTButtonImagePosition imagePosition;

/**
 * 设置按钮里图标和文字之间的间隔，会自动响应 imagePosition 的变化而变化，默认为0。<br/>
 * 系统默认实现需要同时设置 titleEdgeInsets 和 imageEdgeInsets，同时还需考虑 contentEdgeInsets 的增加（否则不会影响布局，可能会让图标或文字溢出或挤压），使用该属性可以避免以上情况。<br/>
 * @warning 会与 imageEdgeInsets、 titleEdgeInsets、 contentEdgeInsets 共同作用。
 */
@property(nonatomic, assign) IBInspectable CGFloat spacingBetweenImageAndTitle;

@property(nonatomic, assign) IBInspectable CGFloat cornerRadius UI_APPEARANCE_SELECTOR;// 默认为 0。将其设置为 LSTButtonCornerRadiusAdjustsBounds 可自动保持圆角为按钮高度的一半。

@end

NS_ASSUME_NONNULL_END
