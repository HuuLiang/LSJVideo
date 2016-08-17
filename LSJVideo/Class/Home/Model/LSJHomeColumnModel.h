//
//  LSJHomeColumnModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/16.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJColumnModel.h"

@interface LSJHomeColumnResponse : LSJURLResponse
@property (nonatomic) NSArray <LSJColumnModel *> *columnList;
@end


@interface LSJHomeColumnModel : LSJEncryptedURLRequest
- (BOOL)fetchHomeInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(LSJCompletionHandler)handler;
@end
