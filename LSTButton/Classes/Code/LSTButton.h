//
//  LSTButton.h
//  LSTButton_Example
//
//  Created by LoSenTrad on 2019/12/24.
//  Copyright © 2019 LoSenTrad@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>
#import "LSTControlEvents.h"
#import "LSTGestureEvents.h"

//按钮图文布局样式
typedef NS_ENUM(NSUInteger,LSTButtonImageType) {
    LSTButtonImageTypeLeft,    //系统默认样式,左图右文字
    LSTButtonImageTypeTop,     //上图下文字
    LSTButtonImageTypeBottom,  //下图上文字
    LSTButtonImageTypeRight    //右图左文字
};


typedef void(^LSTButtonActionBlock)(id sender);

NS_ASSUME_NONNULL_BEGIN

@interface LSTButton : UIControl


/** <#.....#> */
@property (nonatomic,strong) UILabel *titleLab;
/**  */
@property (nonatomic,strong) UIImageView *imgView;
/** <#.....#> */
@property (nonatomic,strong) UIImageView *bgImgView;
/** <#...#> */
@property (nonatomic, assign) LSTButtonImageType imageType;
/** <#.....#> */
@property (nonatomic,strong) UIImage *image;
/** <#...#> */
@property (nonatomic, copy) NSString *title;
/** <#...#> */
@property (nonatomic, assign) CGSize imageSize;
/** 图文间距 默认5 */
@property (nonatomic, assign) CGFloat imageTextSpace;
/** 内间距 */
@property (nonatomic, assign) UIEdgeInsets contentInset;



/** 添加点击事件 */
//- (void)lst_addEventTouchUpInsideBlock:(LSTButtonActionBlock)actionBlock;
///** 添加UIControlEvents时间 */
//- (void)lst_addTargetWithEvent:(UIControlEvents)event andActionBlock:(LSTButtonActionBlock)actionBlock;

//添加手势而不是UIControlEvents
- (void)lst_addClickEventBlock:(LSTButtonActionBlock)actionBlock;




@end

NS_ASSUME_NONNULL_END
