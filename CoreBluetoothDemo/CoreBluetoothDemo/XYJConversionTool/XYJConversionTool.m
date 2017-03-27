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

// 10进制整数转为16进制字符串  187 -> @"BB"
+ (NSString *) convertDecimalToHexadecimal:(uint8_t) value
{
    uint8_t high = value / 16;
    uint8_t low = value % 16;
    return [NSString stringWithFormat:@"%@%@",[self convertUint8ToUppercaseAlphabet:high],[self convertUint8ToUppercaseAlphabet:low]];
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

// 数字转16进制字母  10 -> @"A"
+ (NSString *) convertUint8ToUppercaseAlphabet:(uint8_t) value
{
    NSString * str = nil;
    if (value >= 10) {
        switch (value) {
            case 10:
                str = @"A";
                break;
            case 11:
                str = @"B";
                break;
            case 12:
                str = @"C";
                break;
            case 13:
                str = @"D";
                break;
            case 14:
                str = @"E";
                break;
            case 15:
                str = @"F";
                break;
            default:
                break;
        }
    } else {
        str = [NSString stringWithFormat:@"%d",value];
    }
    return str;
}

//将十进制转化为十六进制
+ (NSString *) ToHex:(long long int)tmpid
{
    NSString * nLetterValue;
    NSString *str = @"";
    long long int ttmpig;
    for (int i = 0; i< 9; i++) {
        ttmpig= tmpid % 16;
        tmpid= tmpid / 16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

@end
