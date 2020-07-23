//
//  LSTButton.m
//  LSTButton_Example
//
//  Created by LoSenTrad on 2019/12/24.
//  Copyright © 2019 LoSenTrad@163.com. All rights reserved.
//

#import "LSTButton.h"
#import "Masonry.h"

static char LSTActionEventKey;
static char LSTActionTouchUpInsideEventKey;

@interface LSTButton ()


/** 图文间距 默认5 */
@property (nonatomic, assign) CGFloat padding;

@end

@implementation LSTButton

/** 添加点击事件 */
//- (void)lst_addEventTouchUpInsideBlock:(LSTButtonActionBlock)actionBlock {
//    objc_setAssociatedObject(self, &LSTActionTouchUpInsideEventKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    [self addTarget:self action:@selector(clickActionBlock:) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)clickActionBlock:(UIButton *)sender {
//    LSTButtonActionBlock actionBlock = (LSTButtonActionBlock)objc_getAssociatedObject(self, &LSTActionTouchUpInsideEventKey);
//    if (actionBlock) {
//        actionBlock(sender);
//    }
//}
//
//- (void)lst_addTargetWithEvent:(UIControlEvents)event
//                andActionBlock:(LSTButtonActionBlock)actionBlock {
//    objc_setAssociatedObject(self, &LSTActionEventKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
//}
//
//
//
//- (void)callActionBlock:(id)sender{
//    LSTButtonActionBlock actionBlock = (LSTButtonActionBlock)objc_getAssociatedObject(self, &LSTActionEventKey);
//    if (actionBlock){
//        actionBlock(self);
//    }
//}

- (void)lst_addClickEventBlock:(LSTButtonActionBlock)actionBlock {
    
    objc_setAssociatedObject(self, &LSTActionEventKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickActionBlock:)];
    
    [self addGestureRecognizer:tap];
    
}

- (void)clickActionBlock:(UIButton *)sender {
    LSTButtonActionBlock actionBlock = (LSTButtonActionBlock)objc_getAssociatedObject(self, &LSTActionEventKey);
    if (actionBlock){
        actionBlock(self);
    }
    
}


#pragma mark - ***** 初始化 *****

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.imageType = LSTButtonImageTypeLeft;
        self.imageTextSpace = 5;
        self.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        [self initSubViews];
    }
    return self;
}

#pragma mark - ***** setter 设置器/数据处理 *****


- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imgView.image = image;
    
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLab.text = title;
    
}

- (void)setImageType:(LSTButtonImageType)imageType {
    _imageType = imageType;
    
    [self setNeedsLayout];

}


- (void)setImageTextSpace:(CGFloat)imageTextSpace {
    _imageTextSpace = imageTextSpace;
    
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
}

#pragma mark - ***** setupUI 界面布局 *****

- (void)initSubViews {

    [self addSubview:self.bgImgView];
    [self addSubview:self.imgView];
    [self addSubview:self.titleLab];


    
    
//    [self addTarget:self action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
//    [self addTarget:self action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
//    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    
    CGFloat allW = self.bounds.size.width;
    CGFloat allH = self.bounds.size.height;
    
    
    CGFloat imgX;
    CGFloat imgY;

    CGFloat imgW = self.imgView.image.size.width;
    CGFloat imgH = self.imgView.image.size.height;
    if (self.imageSize.width>0&&self.imageSize.height>0&&self.imgView.image) {
      imgW = self.imageSize.width;
      imgH = self.imageSize.height;
    }
   
    
    CGFloat titleW = [self getWidthWithFont:self.titleLab.font andString:self.titleLab.text];
    CGFloat titleH = [self getHeightWithFont:self.titleLab.font andWidth:allW andString:self.titleLab.text];

    CGFloat padding = self.imageTextSpace;
    
    if (!self.imgView.image || self.titleLab.text.length<=0) {
        padding = 0;
    }
    
    UIEdgeInsets contentInset = self.contentInset;
    
    
    CGFloat contentW = contentInset.left+imgW+padding+titleW+contentInset.right;
    CGFloat contentH;
    
    
    
    

     
    
    
    switch (self.imageType) {
          case LSTButtonImageTypeTop://图上
          {
              contentH = contentInset.top+imgH+padding+titleH+contentInset.bottom;
              imgY = contentInset.top + (allH-contentH)*0.5;
              [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.centerX.equalTo(self);
                  make.top.equalTo(self).offset(imgY);
                  make.height.mas_equalTo(imgH);
                  make.width.mas_equalTo(imgW);
              }];
              [_titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.top.equalTo(_imgView.mas_bottom).offset(padding);
                  make.centerX.equalTo(_imgView);
              }];
          }
              break;
          case LSTButtonImageTypeBottom://图下
          {
              contentH = contentInset.top+imgH+padding+titleH+contentInset.bottom;
              imgY = contentInset.bottom + (allH-contentH)*0.5;//参考btn底部
              [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.centerX.equalTo(self);
                  make.bottom.equalTo(self).offset(-imgY);
                  make.height.mas_equalTo(imgH);
                  make.width.mas_equalTo(imgW);
              }];
              [_titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.bottom.equalTo(_imgView.mas_top).offset(-padding);
                  make.centerX.equalTo(_imgView);
              }];
          }
              break;
          case LSTButtonImageTypeRight://图右
          {
              contentW = contentInset.left+imgW+padding+titleW+contentInset.right;
              imgX = (allW - contentW)*0.5+contentInset.right;
              
              if (imgX<=contentInset.right) {
                  imgX = contentInset.right;
              }
              
              [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.centerY.equalTo(self);
                  make.right.equalTo(self).offset(-imgX);
                  make.height.mas_equalTo(imgH);
                  make.width.mas_equalTo(imgW);
              }];
              [_titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.right.equalTo(_imgView.mas_left).offset(-padding);
                  make.centerY.equalTo(_imgView);
                  if (imgX<=contentInset.left) {
                      make.left.equalTo(self).offset(contentInset.left);
                  }
              }];
          }
              break;
          default://图左
          {
              contentW = contentInset.left+imgW+padding+titleW+contentInset.right;
              imgX = (allW-contentW)/2.0 + contentInset.left;
              
              if (imgX<=contentInset.left) {
                  imgX = contentInset.left;
              }
              
              [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.centerY.equalTo(self);
                  make.left.equalTo(self).offset(imgX);
                  make.height.mas_equalTo(imgH);
                  make.width.mas_equalTo(imgW);
              }];
              [_titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.left.equalTo(_imgView.mas_right).offset(padding);
                  make.centerY.equalTo(_imgView);
                  if (imgX<=contentInset.right) {
                      make.right.equalTo(self).offset(-contentInset.right);
                  }
              }];
          }
              break;
      }

    
    
    
}

#pragma mark - ***** other 其他 *****

//按钮的压下事件 按钮缩小
- (void)pressedEvent:(UIView *)btn
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
- (void)cancelEvent:(UIView *)btn
{
    [UIView animateWithDuration:0.5 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
    [self layoutIfNeeded];
    [self layoutSubviews];
}
//按钮的松开事件 按钮复原 执行响应
- (void)unpressedEvent:(UIView *)btn
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


/** 根据字符串获取宽度 (不适合富文本)(修改标记) */
- (CGFloat)getWidthWithFont:(UIFont *)font andString:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = text;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
/** 根据字符串获取高度(不适合富文本) */
- (CGFloat)getHeightWithFont:(UIFont *)font andWidth:(CGFloat)width andString:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

#pragma mark - ***** Lazy Loading 懒加载 *****


- (UILabel *)titleLab {
    if(_titleLab) return _titleLab;
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = UIColor.blackColor;
    _titleLab.font = [UIFont systemFontOfSize:14];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    return _titleLab;
}

- (UIImageView *)imgView {
    if(_imgView) return _imgView;
    _imgView = [[UIImageView alloc] init];
    return _imgView;
}

- (UIImageView *)bgImgView {
    if(_bgImgView) return _bgImgView;
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.contentMode = UIViewContentModeScaleAspectFit;
    return _bgImgView;
}

@end
