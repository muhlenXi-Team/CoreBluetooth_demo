//
//  XYJConversionTool.h
//  dataProcessingDemo
//
//  Created by muhlenXi on 2017/3/15.
//  Copyright © 2017年 XiYinjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYJConversionTool : NSObject

/**
 @ 16进制字符串转为10进制整数  @"bb" -> 187
 
 @param hex NSString 数据
 @return uint8_t 10 进制整数
 */
+ (uint8_t) convertHexadecimalToDecimal:(NSString *) hex;

/**
 @"0"~@"F" 转 0~15 如：@"A" -> 10
 
 @param alphabet unsigned char 数据
 @return NSString 十六进制字符串
 */
+ (uint8_t) convertAlphabetToUint8:(NSString *) alphabet;


/**
 整数 转换成十六进制字符串
 
 @param value long long int 数据
 @return NSString 十六进制字符串
 */
+ (NSString *) convertllintToHexString:(long long int) value;

/**
 NSData 转换成十六进制字符串

 @param data NSData 数据
 @return NSString 数据
 */
+ (NSString *)convertDataToHexStr:(NSData *)data;

@end
