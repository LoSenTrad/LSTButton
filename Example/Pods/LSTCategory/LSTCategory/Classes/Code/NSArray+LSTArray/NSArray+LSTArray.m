//
//  NSArray+LSTArray.m
//  DYwttai
//
//  Created by LoSenTrad on 2017/5/5.
//  Copyright © 2017年 dongyu. All rights reserved.
//

#import "NSArray+LSTArray.h"
#import "YYModel.h"


@implementation NSArray (LSTArray)

- (NSString *)arrayToStringWithSeparator:(NSString *)separator {
    return [self componentsJoinedByString:separator];
}

- (NSArray *)checkResponse {
    if ([self isKindOfClass:[NSString class]]) {
        return [NSArray array];
    }else {
        return self;
    }
}

///冒泡排序
- (NSArray *)change:(NSMutableArray *)array
{
    if (array.count > 1) {
        for (int  i =0; i<[array count]-1; i++) {
            
            for (int j = i+1; j<[array count]; j++) {
                
                if ([array[i] intValue]>[array[j] intValue]) {
                    
                    //交换
                    
                    [array exchangeObjectAtIndex:i withObjectAtIndex:j];
                    
                }
                
            }
            
        }
    }
    NSArray * resultArray = [[NSArray alloc]initWithArray:array];
    
    return resultArray;
}


/** json数组转模型数组 依赖YYMoJdel */
- (NSArray *)lst_JsonArrFormatToModel:(Class)className {
    
//    Class modelClass = NSClassFromString(className);
    
    NSMutableArray *tempMarr = [NSMutableArray array];
    for (int i = 0; i<self.count; i++) {
        
        
        NSObject *model = [className yy_modelWithJSON:self[i]];
        
        [tempMarr addObject:model];
    }
    
    return tempMarr.copy;
    
}

//数组转为json字符串
- (NSString *)lst_arrayToJSONString:(NSArray *)array {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonTemp;
}

@end
