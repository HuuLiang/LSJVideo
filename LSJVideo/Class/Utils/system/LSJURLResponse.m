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
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *propertyName = key;
        NSString *setPropertyName = propertyName;
        
        NSString *const kNameMappingProperty = @"LSJ_propertyOfParsing:";
        if ([instance respondsToSelector:NSSelectorFromString(kNameMappingProperty)]) {
            setPropertyName = [instance performSelector:NSSelectorFromString(kNameMappingProperty) withObject:propertyName];
        }
        
        if (![properties containsObject:setPropertyName]) {
            return ;
        }
        
        id value = obj;
        if ([value isKindOfClass:[NSString class]]
            || [value isKindOfClass:[NSNumber class]]) {
            [instance setValue:value forKey:setPropertyName];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            id property = [instance valueForKey:setPropertyName];
            Class subclass = [property class];
            if (!subclass) {
                NSString *classPropertyName = [propertyName stringByAppendingString:@"Class"];
                if ([instance respondsToSelector:NSSelectorFromString(classPropertyName)]) {
                    subclass = [instance valueForKey:classPropertyName];
                }
            }
            
            if (!subclass) {
                NSString *const kClassSelectorName = @"LSJ_classOfProperty:";
                if ([instance respondsToSelector:NSSelectorFromString(kClassSelectorName)]) {
                    subclass = [instance performSelector:NSSelectorFromString(kClassSelectorName) withObject:setPropertyName];
                }
            }
            
            id subinstance = [[subclass alloc] init];
            [instance setValue:subinstance forKey:setPropertyName];
            
            [self parseDataWithDictionary:(NSDictionary *)value inInstance:subinstance];
        } else if ([value isKindOfClass:[NSArray class]]) {
            Class subclass = [instance valueForKey:[propertyName stringByAppendingString:@"ElementClass"]];
            if (!subclass) {
                DLog(@"JSON Parsing Warning: cannot find element class of property: %@ in class: %@\n", propertyName, [[instance class] description])
                return;
            }
            
            
            if ([propertyName isEqualToString:@"icons"]) {
                
            }
            
            if (subclass == [NSString class] || subclass == [NSNumber class]) {
                [instance setValue:value forKey:setPropertyName];
                return ;
            }
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [instance setValue:arr forKey:setPropertyName];
            
            
            for (id subobj in (NSArray *)value) {
                if ([subobj isKindOfClass:[NSDictionary class]]) {
                    id subinstance = [[subclass alloc] init];
                    [arr addObject:subinstance];
                    [self parseDataWithDictionary:(NSDictionary *)subobj inInstance:subinstance];
                } else if ([subobj isKindOfClass:[NSString class]]) {
                    [arr addObject:subobj];
                }
            }
        }
    }];

#pragma clang diagnostic pop
}


@end
