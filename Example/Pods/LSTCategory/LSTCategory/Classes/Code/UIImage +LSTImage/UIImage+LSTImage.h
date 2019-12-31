//
//  UIImage+LSTImage.h
//  DYwttai
//
//  Created by LoSenTrad on 2017/3/21.
//  Copyright © 2017年 dongyu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIImage (LSTImage)

/**
 根据颜色生成一张尺寸为1*1的相同颜色图片
 @param color 生成图片颜色
 @return 返回图片对象
 */
+ (UIImage *)lst_imageWithColor:(UIColor *)color :(CGSize)size;
/** 将该图片改成灰色 */
+ (UIImage *)changeGrayImage:(UIImage *)oldImage;

/** 保存图片到沙盒 imageName:图片名称 */
+ (NSString *)saveImageToDocuments:(UIImage *)image imageName:(NSString *)imageName;
/** 压缩图片  image:将要压缩的图片   size：压缩后的尺寸 */
- (UIImage *)imageScaleToSize:(CGSize)size;

- (NSData *)imageScaleToSize:(CGSize)ShowSize
                    FileSize:(NSInteger)FileSize;

//若Scale为YES，则原图会根据Size进行拉伸-会变形
//若Scale为NO，则原图会根据Size进行填充-不会变形
- (UIImage *)thumbnailWithSize:(CGSize)asize;

/**
 *  生成相应圆角image
 *
 *  @param radius 圆角度
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

/**
 *  view截屏(快照)
 *
 *  @param view 截屏的view
 */
+ (UIImage *)snapshotWithView:(UIView *)view;

/**
 *  view截屏(快照)
 *
 *  @param view     截屏的view
 *  @param snapSize 截屏大小
 */
+ (UIImage *)snapshotWithView:(UIView *)view size:(CGSize)snapSize;



+ (NSString *)lst_GetLaunchImageName;

+ (UIImage *)lst_GetLaunchImage;

//设置图片快捷方式
UIImage *LSTImageWithName(NSString *imgName);

@end
