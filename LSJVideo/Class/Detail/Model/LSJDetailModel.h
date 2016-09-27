//
//  LSJDetailModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "LSJProgramModel.h"

@interface LSJProgramUrlModel : NSObject
@property (nonatomic) NSString *content;
@property (nonatomic) NSInteger type;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *title;
@end

@interface LSJDetailResponse : QBURLResponse
@property (nonatomic) NSArray <LSJCommentModel *>*commentJson;
@property (nonatomic) LSJProgramModel *program;
@property (nonatomic) NSArray <LSJProgramUrlModel *>*programUrlList;
@end

@interface LSJDetailModel : QBEncryptedURLRequest
- (BOOL)fetchProgramDetailInfoWithColumnId:(NSInteger)columnId ProgramId:(NSInteger)programId isImageText:(BOOL)isImageText CompletionHandler:(QBCompletionHandler)handler;
@end
