//
//  LSJVideoViewController.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJBaseViewController.h"
#import "LSJBaseModel.h"

@interface LSJVideoPlayerController : LSJBaseViewController

@property (nonatomic) NSString *videoUrl;

- (instancetype)initWithVideo:(NSString *)videoUrl;

@property (nonatomic,retain)LSJBaseModel *baseModel;

@end
