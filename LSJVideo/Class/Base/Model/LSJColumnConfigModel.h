//
//  LSJColumnConfigModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJColumnModel.h"

@interface LSJColumnConfigResponse : LSJURLResponse
@property (nonatomic) NSArray <LSJColumnModel *> *columnList;
@end


@interface LSJColumnConfigModel : LSJEncryptedURLRequest
- (BOOL)fetchColumnsInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(LSJCompletionHandler)handler;
@end
