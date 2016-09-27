//
//  LSJBaseModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSJBaseModel : NSObject

@property (nonatomic) NSNumber * programId;
@property (nonatomic) NSNumber * programType;
@property (nonatomic) NSNumber * realColumnId;
@property (nonatomic) NSNumber * channelType;
@property (nonatomic) NSInteger programLocation;
@property (nonatomic) NSInteger spec;
@property (nonatomic) NSInteger subTab;

+ (LSJBaseModel *)createModelWithProgramId:(NSNumber *)programId
                               ProgramType:(NSNumber *)programType
                              RealColumnId:(NSNumber *)realColumnId
                               ChannelType:(NSNumber *)channelType
                            PrgramLocation:(NSInteger)programLocation
                                      Spec:(NSInteger)spec
                                    subTab:(NSInteger)subTab;

@end
