//
//  LSJTabStatsModel.h
//  LSJuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJStatsBaseModel.h"

@interface LSJTabStatsModel : LSJStatsBaseModel

- (BOOL)statsTabWithStatsInfos:(NSArray<LSJStatsInfo *> *)statsInfos completionHandler:(QBCompletionHandler)completionHandler;

@end
