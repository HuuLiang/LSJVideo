//
//  NSString+StringHeight.m
//  Lulushequ
//
//  Created by Liang on 16/6/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "NSString+StringHeight.h"

@implementation NSString (StringHeight)

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
