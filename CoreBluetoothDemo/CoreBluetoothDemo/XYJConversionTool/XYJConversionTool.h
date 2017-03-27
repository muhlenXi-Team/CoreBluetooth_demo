//
//  XYJConversionTool.h
//  dataProcessingDemo
//
//  Created by muhlenXi on 2017/3/15.
//  Copyright © 2017年 XiYinjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYJConversionTool : NSObject

// 16进制字符串转为10进制整数  @"bb" -> 187
+ (uint8_t) convertHexadecimalToDecimal:(NSString *) hex;

// 10进制整数转为16进制字符串  187 -> @"BB"
+ (NSString *) convertDecimalToHexadecimal:(uint8_t) value;

// 16进制字符串转10进制数  @"A" -> 10
+ (uint8_t) convertAlphabetToUint8:(NSString *) alphabet;

// 数字转16进制字母  10 -> @"A"
+ (NSString *) convertUint8ToUppercaseAlphabet:(uint8_t) value;

//将十进制转化为十六进制
+ (NSString *) ToHex:(long long int)tmpid;
@end
