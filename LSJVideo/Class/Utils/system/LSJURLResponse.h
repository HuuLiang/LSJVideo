//
//  LSJURLResponse.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSJResponseParsable <NSObject>

@optional
- (Class)LSJ_classOfProperty:(NSString *)propName;
- (NSString *)LSJ_propertyOfParsing:(NSString *)parsingName;

@end

@interface LSJURLResponse : NSObject

@property (nonatomic) NSNumber *success;
@property (nonatomic) NSString *resultCode;

- (void)parseResponseWithDictionary:(NSDictionary *)dic;

@end
