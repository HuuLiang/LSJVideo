//
//  LSJAppSpreadBannerModel.h
//  LSJVideo
//
//  Created by Liang on 16/9/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "LSJProgramModel.h"

@interface LSJAppSpreadBannerResponse : QBURLResponse
@property (nonatomic,retain) NSArray<LSJProgramModel *> *programList;
@end

@interface LSJAppSpreadBannerModel : QBEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<LSJProgramModel *> *fetchedSpreads;

+ (instancetype)sharedModel;

- (BOOL)fetchAppSpreadWithCompletionHandler:(QBCompletionHandler)handler;

@end
