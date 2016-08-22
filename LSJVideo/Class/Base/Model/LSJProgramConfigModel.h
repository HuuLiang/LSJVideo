//
//  LSJProgramConfigModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJColumnModel.h"

@interface LSJProgramConfigModel : LSJEncryptedURLRequest
- (BOOL)fetchProgramsInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(LSJCompletionHandler)handler;
@end
