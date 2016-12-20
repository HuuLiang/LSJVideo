//
//  LSJVersionUpdateModel.h
//  LSJuaibo
//
//  Created by ylz on 2016/12/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface LSJVersionUpdateInfo : QBURLResponse

@property (nonatomic) NSString *versionNo;
@property (nonatomic) NSString *linkUrl;
@property (nonatomic) NSNumber *isForceToUpdate;
@property (nonatomic) NSNumber *up;
@end

@interface LSJVersionUpdateModel : QBEncryptedURLRequest

@property (nonatomic,retain,readonly) LSJVersionUpdateInfo *fetchedVersionInfo;
+ (instancetype)sharedModel;
- (BOOL)fetchLatestVersionWithCompletionHandler:(QBCompletionHandler)completionHandler;


@end
