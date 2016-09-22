//
//  LSJColumnConfigModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "LSJColumnModel.h"


@interface LSJColumnConfigResponse : QBURLResponse
@property (nonatomic) NSArray <LSJColumnModel *> *columnList;
@end


@interface LSJColumnConfigModel : QBEncryptedURLRequest
- (BOOL)fetchColumnsInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(QBCompletionHandler)handler;
@end


@interface LSJColumnDayModel : QBEncryptedURLRequest
- (BOOL)fetchDayInfoWithColumnId:(NSInteger)columnId CompletionHandler:(QBCompletionHandler)handler;
@end