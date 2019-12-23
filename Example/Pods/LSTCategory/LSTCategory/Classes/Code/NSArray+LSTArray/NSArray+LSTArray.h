//
//  NSArray+LSTArray.h
//  DYwttai
//
//  Created by LoSenTrad on 2017/5/5.
//  Copyright © 2017年 dongyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (LSTArray)
/**
 *  数组转字符串
 *  @param separator 分隔符
 */
- (NSString *)arrayToStringWithSeparator:(NSString *)separator;

/** 检测是空字符串还是数组 */
- (NSArray *)checkResponse;
///冒泡排序
- (NSArray *)change:(NSMutableArray *)array;


/** json数组转模型数组 依赖YYMoJdel */
- (NSArray *)lst_JsonArrFormatToModel:(Class)className;

//数组转为json字符串
- (NSString *)lst_arrayToJSONString:(NSArray *)array;






@end
