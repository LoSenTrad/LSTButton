//
//  UIView+GLDragBlast.h
//  AiyoyouCocoapods
//
//  Created by gulu on 2018/5/29.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GLDragBlast)
//是否使用粒子动画 particle
@property(nonatomic,assign)BOOL  isFragment;
//点击爆炸  默认为NO
@property(nonatomic,assign)BOOL  tapBlast;
//拖拽爆炸  默认为NO
@property(nonatomic,assign)BOOL  dragBlast;

//拖动爆炸或点击爆炸后的回调
- (void)blastCompletion:(void (^)(BOOL finished))completion;

@end
