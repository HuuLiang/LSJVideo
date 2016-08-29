//
//  LSJDetailModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"

@interface LSJDetailModel : LSJEncryptedURLRequest

- (BOOL)fetchProgramDetailInfoWithProgramId:(NSInteger)programId CompletionHandler:(LSJCompletionHandler)handler;

@end
