//
//  UIColor+JGHexColor.m
//  ZJBL-SJ
//
//  Created by 郭军 on 2017/3/14.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "UIColor+JGHexColor.h"

@implementation UIColor (JGHexColor)

/**
 *  创建一个UIColor实例 使用16进制码
 *
 *  @param hexCode 16进制码
 *
 *  @return UIColor instance
 */
+ (UIColor *)colorWithHexCode:(NSString *)hexCode
{
    NSString *cleanString = [hexCode stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 16) & 0xFF)/255.0f;
    float green = ((baseValue >> 8) & 0xFF)/255.0f;
    float blue = ((baseValue >> 0) & 0xFF)/255.0f;
    
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)colorWithHexCode:(NSString *)hexCode alpha:(CGFloat)alpha
{
    return [[self colorWithHexCode:hexCode] colorWithAlphaComponent:alpha];
}





@end
