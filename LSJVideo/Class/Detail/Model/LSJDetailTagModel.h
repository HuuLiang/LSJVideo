//
//  LSJDetailTagModel.h
//  LSJVideo
//
//  Created by Liang on 16/9/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSJDetailTagModel : NSObject

+ (NSDictionary *)randomCountFirst;
+ (NSDictionary *)randomCountSecond:(NSDictionary *)firstDic;
@end
