//
//  UIImage+LSTImage.m
//  DYwttai
//
//  Created by LoSenTrad on 2017/3/21.
//  Copyright © 2017年 dongyu. All rights reserved.
//

#import "UIImage+LSTImage.h"




@implementation UIImage (LSTImage)

+ (UIImage *)lst_imageWithColor:(UIColor *)color :(CGSize)size
{
    // 描述矩形
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)changeGrayImage:(UIImage *)oldImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = oldImage.size.width;
    int height = oldImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), oldImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

+ (NSString *)saveImageToDocuments:(UIImage *)image imageName:(NSString *)imageName {
    
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",imageName]];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    BOOL success = [UIImagePNGRepresentation(image) writeToFile:imagePath  atomically:YES];
    if (success){
//        (@"写入本地成功");
    }
    return imagePath;
}



- (UIImage *)thumbnailWithSize:(CGSize)asize
{
    UIImage *newimage = nil;
    UIGraphicsBeginImageContext(asize);
    [self drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}



/**
 *  压缩图片
 *  image:将要压缩的图片   size：压缩后的尺寸
 */
- (UIImage *)imageScaleToSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

- (NSData *)imageScaleToSize:(CGSize)ShowSize
                    FileSize:(NSInteger)FileSize {

    UIImage *oldIMG = self;
    
    UIImage *thumIMG = [self ResizeImageWithImage:oldIMG
                                          andSize:ShowSize
                                            Scale:NO];
    
    NSData  *outIMGData = [self OnlyCompressToDataWithImage:thumIMG
                                                   FileSize:(FileSize*1024)];
    
    CGSize scalesize = ShowSize;
    
    //如果压缩后还是无法达到文件大小，则降低分辨率，继续压缩
    while (outIMGData.length>(FileSize*1024)) {
        
        scalesize = CGSizeMake(scalesize.width*0.8, scalesize.height*0.8);
        
        thumIMG = [self ResizeImageWithImage:oldIMG
                                     andSize:scalesize
                                       Scale:NO];
        
        outIMGData = [self OnlyCompressToDataWithImage:thumIMG
                                              FileSize:(FileSize*1024)];
    }
    //(@"压缩完成");
    return outIMGData;
}

//若Scale为YES，则原图会根据Size进行拉伸-会变形
//若Scale为NO，则原图会根据Size进行填充-不会变形
 - (UIImage *)ResizeImageWithImage:(UIImage *)OldImage
                         andSize:(CGSize)Size
                           Scale:(BOOL)Scale
{
    UIGraphicsBeginImageContextWithOptions(Size, NO, 0.0);
    
    CGRect rect = CGRectMake(0,
                             0,
                             Size.width,
                             Size.height);
    if (!Scale) {
        
        CGFloat bili_imageWH = OldImage.size.width/
        OldImage.size.height;
        CGFloat bili_SizeWH  = Size.width/Size.height;
        
        if (bili_imageWH > bili_SizeWH) {
            
            CGFloat bili_SizeH_imageH = Size.height/
            OldImage.size.height;
            CGFloat height = OldImage.size.height*
            bili_SizeH_imageH;
            CGFloat width = height * bili_imageWH;
            CGFloat x = -(width - Size.width)/2;
            CGFloat y = 0;
            rect = CGRectMake(x,y,
                              width,
                              height);
            
        }else{
            
            CGFloat bili_SizeW_imageW = Size.width/
            OldImage.size.width;
            CGFloat width = OldImage.size.width *
            bili_SizeW_imageW;
            CGFloat height = width / bili_imageWH;
            CGFloat x = 0;
            CGFloat y = -(height - Size.height)/2;
            rect = CGRectMake(x,y,
                              width,
                              height);
        }
    }
    
    [[UIColor clearColor] set];
    UIRectFill(rect);
    
    [OldImage drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

//------只压不缩--按NSData大小压缩，返回NSData
- (NSData *)OnlyCompressToDataWithImage:(UIImage *)OldImage
                               FileSize:(NSInteger)FileSize
{
    CGFloat compression    = 1.0f;
    CGFloat minCompression = 0.001f;
    NSData *imageData = UIImageJPEGRepresentation(OldImage,
                                                  compression);
    //每次减少的比例
    float scale = 0.1;
    
    //循环条件：没到最小压缩比例，且没压缩到目标大小
    while ((compression > minCompression)&&
           (imageData.length>FileSize))
    {
        compression -= scale;
        imageData = UIImageJPEGRepresentation(OldImage,
                                              compression);
        
    }
    return imageData;
}


- (UIImage *)imageWithCornerRadius:(CGFloat)radius
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //clip image
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, radius);
    CGContextAddLineToPoint(context, 0.0f, self.size.height - radius);
    CGContextAddArc(context, radius, self.size.height - radius, radius, M_PI, M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, self.size.width - radius, self.size.height);
    CGContextAddArc(context, self.size.width - radius, self.size.height - radius, radius, M_PI / 2.0f, 0.0f, 1);
    CGContextAddLineToPoint(context, self.size.width, radius);
    CGContextAddArc(context, self.size.width - radius, radius, radius, 0.0f, -M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, radius, 0.0f);
    CGContextAddArc(context, radius, radius, radius, -M_PI / 2.0f, M_PI, 1);
    CGContextClip(context);
    
    //draw image
    [self drawAtPoint:CGPointZero];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

+ (UIImage *)snapshotWithView:(UIView *)view
{
    return [self snapshotWithView:view size:view.bounds.size];
}

+ (UIImage *)snapshotWithView:(UIView *)view size:(CGSize)snapSize
{
    UIGraphicsBeginImageContextWithOptions(snapSize, NO, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//// 引用自stackflow
//+ (NSString *)lst_GetLaunchImageName
//{
//    NSString *viewOrientation = @"Portrait";
//    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
//        viewOrientation = @"Landscape";
//    }
//    NSString *launchImageName = nil;
//    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
//    CGSize viewSize = tyCurrentWindow.bounds.size;
//    for (NSDictionary* dict in imagesDict)
//    {
//        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
//
//        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
//        {
//            launchImageName = dict[@"UILaunchImageName"];
//        }
//    }
//    return launchImageName;
//}
//
//+ (UIImage *)lst_GetLaunchImage
//{
//    return [UIImage imageNamed:[self ty_getLaunchImageName]];
//}



UIImage *LSTImageWithName(NSString *imgName) {
    return [UIImage imageNamed:imgName];
}




@end
