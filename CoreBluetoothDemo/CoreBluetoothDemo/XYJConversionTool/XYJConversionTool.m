//
//  XYJConversionTool.m
//  dataProcessingDemo
//
//  Created by muhlenXi on 2017/3/15.
//  Copyright © 2017年 XiYinjun. All rights reserved.
//

#import "XYJConversionTool.h"

@implementation XYJConversionTool


// 16进制字符串转为10进制整数  @"bb" -> 187
+ (uint8_t) convertHexadecimalToDecimal:(NSString *) hex
{
    if (hex.length != 2) {
        return -1;
    }
    
    NSMutableString * low = [NSMutableString stringWithString:hex];
    [low deleteCharactersInRange:NSMakeRange(0, 1)];
    NSMutableString * high = [NSMutableString stringWithString:hex];
    [high deleteCharactersInRange:NSMakeRange(1, 1)];
    
    return [self convertAlphabetToUint8:high] * 16 + [self convertAlphabetToUint8:low];
}

// 16进制字符串转10进制数  @"A" -> 10
+ (uint8_t) convertAlphabetToUint8:(NSString *) alphabet
{
    if ([alphabet isEqualToString:@"0"]) {
        return 0;
    } else if ([alphabet isEqualToString:@"1"]) {
        return 1;
    } else if ([alphabet isEqualToString:@"2"]) {
        return 2;
    } else if ([alphabet isEqualToString:@"3"]) {
        return 3;
    } else if ([alphabet isEqualToString:@"4"]) {
        return 4;
    } else if ([alphabet isEqualToString:@"5"]) {
        return 5;
    } else if ([alphabet isEqualToString:@"6"]) {
        return 6;
    } else if ([alphabet isEqualToString:@"7"]) {
        return 7;
    } else if ([alphabet isEqualToString:@"8"]) {
        return 8;
    } else if ([alphabet isEqualToString:@"9"]) {
        return 9;
    } else if ([alphabet isEqualToString:@"a"] || [alphabet isEqualToString:@"A"]) {
        return 10;
    } else if ([alphabet isEqualToString:@"b"]  || [alphabet isEqualToString:@"B"]) {
        return 11;
    } else if ([alphabet isEqualToString:@"c"]  || [alphabet isEqualToString:@"C"]) {
        return 12;
    } else if ([alphabet isEqualToString:@"d"]  || [alphabet isEqualToString:@"D"]) {
        return 13;
    } else if ([alphabet isEqualToString:@"e"] || [alphabet isEqualToString:@"E"]) {
        return 14;
    } else if ([alphabet isEqualToString:@"f"] || [alphabet isEqualToString:@"F"]) {
        return 15;
    }
    return -1;
}

//将十进制整数转化为十六进制字符串
+ (NSString *) convertllintToHexString:(long long int) value
{
    NSString *string = [NSString stringWithFormat:@"%llx",value];
    return [string uppercaseString];
}

// NSData 转换成十六进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0)
    {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}


@end
