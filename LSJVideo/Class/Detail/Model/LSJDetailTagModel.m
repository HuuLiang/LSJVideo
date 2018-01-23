//
//  LSJDetailTagModel.m
//  LSJVideo
//
//  Created by Liang on 16/9/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailTagModel.h"

@interface LSJDetailTagModel ()
{
    
}
@end

@implementation LSJDetailTagModel

+ (NSArray *)tagTitlesAndColor {
    return @[@{@"title":@"制服",@"color":@"#E51C23"},
             @{@"title":@"人妻",@"color":@"#E91E63"},
             @{@"title":@"巨乳",@"color":@"#8E24AA"},
             @{@"title":@"强奸",@"color":@"#7E57C2"},
             @{@"title":@"乱伦",@"color":@"#FF680D"},
             @{@"title":@"调教",@"color":@"#259B24"},
             @{@"title":@"性奴",@"color":@"#F5A623"},
             @{@"title":@"熟女",@"color":@"#7ED321"},
             @{@"title":@"无码",@"color":@"#5677FC"},
             @{@"title":@"多P ",@"color":@"#00ACC1"},
             @{@"title":@"欧美",@"color":@"#009688"},
             @{@"title":@"高清",@"color":@"#E65100"},
             @{@"title":@"美腿",@"color":@"#C74378"},];
}

+ (NSDictionary *)randomCountFirst {
    NSArray * array = [self tagTitlesAndColor];
    NSInteger count = arc4random() % array.count;
    return array[count];
}

+ (NSDictionary *)randomCountSecond:(NSDictionary *)firstDic {
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self tagTitlesAndColor]];
    [array removeObject:firstDic];
    NSInteger count = arc4random() % array.count;
    return array[count];
}


@end
