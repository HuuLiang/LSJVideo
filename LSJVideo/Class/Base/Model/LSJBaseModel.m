//
//  LSJBaseModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJBaseModel.h"

@implementation LSJBaseModel

+ (LSJBaseModel *)createModelWithProgramId:(NSNumber *)programId
                               ProgramType:(NSNumber *)programType
                              RealColumnId:(NSNumber *)realColumnId
                               ChannelType:(NSNumber *)channelType
                            PrgramLocation:(NSInteger)programLocation
                                      Spec:(NSInteger)spec {
    LSJBaseModel *model = [[LSJBaseModel alloc] init];
    model.programId = programId;
    model.programType = programType;
    model.realColumnId = realColumnId;
    model.channelType = channelType;
    model.programLocation = programLocation;
    model.spec = spec;
    return model;
}

@end
