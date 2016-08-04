//
//  UIImage+color.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "UIImage+color.h"

@implementation UIImage (color)
+ (UIImage *)imageWithColor:(UIColor *)aColor {
    CGRect imageRect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(imageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, imageRect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
