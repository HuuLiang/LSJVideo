//
//  LSJURLResponse.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJURLResponse.h"

@implementation LSJURLResponse
- (void)parseResponseWithDictionary:(NSDictionary *)dic {
    [self parseDataWithDictionary:dic inInstance:self];
}

- (void)parseDataWithDictionary:(NSDictionary *)dic inInstance:(id)instance {
    if (!dic || !instance) {
        return ;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSArray *properties = [NSObject propertiesOfClass:[instance class]];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *propertyName = (NSString *)obj;
        
        id value = [dic objectForKey:propertyName];
        if ([value isKindOfClass:[NSString class]]
            || [value isKindOfClass:[NSNumber class]]) {
            [instance setValue:value forKey:propertyName];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            id property = [instance valueForKey:propertyName];
            Class subclass = [property class];
            if (!subclass) {
                NSString *classPropertyName = [propertyName stringByAppendingString:@"Class"];
                subclass = [instance valueForKey:classPropertyName];
            }
            id subinstance = [[subclass alloc] init];
            [instance setValue:subinstance forKey:propertyName];
            
            [self parseDataWithDictionary:(NSDictionary *)value inInstance:subinstance];
        } else if ([value isKindOfClass:[NSArray class]]) {
            Class subclass = [instance valueForKey:[propertyName stringByAppendingString:@"ElementClass"]];
            
            if (!subclass) {
                DLog(@"JSON Parsing Warning: cannot find element class of property: %@ in class: %@\n", propertyName, [[instance class] description])
                return;
            }
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [instance setValue:arr forKey:propertyName];
            
            for (id obj in (NSArray *)value) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    id subinstance = [[subclass alloc] init];
                    [arr addObject:subinstance];
                    [self parseDataWithDictionary:obj inInstance:subinstance];
                } else if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
                    [arr addObject:obj];
                }
            }
        }
    }];
#pragma clang diagnostic pop
}

@end
