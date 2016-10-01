//
//  LSJSystemConfigModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "LSJSystemConfig.h"

@interface LSJSystemConfigResponse : QBURLResponse

@property (nonatomic,retain) NSArray<LSJSystemConfig *> *confis;

@end

typedef void (^LSJFetchSystemConfigCompletionHandler)(BOOL success);

@interface LSJSystemConfigModel : QBEncryptedURLRequest

@property (nonatomic) NSInteger payAmount;
@property (nonatomic) NSInteger svipPayAmount;
@property (nonatomic) NSString *mineImgUrl;
@property (nonatomic) NSString *contacName;
@property (nonatomic) NSString *contactScheme;
@property (nonatomic) NSString *vipImg;
@property (nonatomic) NSString *sVipImg;
@property (nonatomic) NSString *imageToken;
@property (nonatomic,readonly) BOOL loaded;

+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(LSJFetchSystemConfigCompletionHandler)handler;

@end
