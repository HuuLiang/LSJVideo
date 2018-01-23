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
                                      Spec:(NSInteger)spec
                                    subTab:(NSInteger)subTab{
    LSJBaseModel *model = [[LSJBaseModel alloc] init];
    model.programId = programId.integerValue != 0 ? programId:nil;
    model.programType = programType.integerValue != 0 ? programType : nil;
    model.realColumnId = realColumnId.integerValue != 0 ? realColumnId : nil;
    model.channelType = channelType != 0 ? channelType : nil;
    model.programLocation = programLocation;
    model.spec = spec;
    model.subTab = subTab;
    return model;
}

@end
