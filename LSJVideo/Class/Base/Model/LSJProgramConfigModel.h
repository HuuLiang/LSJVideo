//
//  LSJProgramConfigModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "LSJColumnModel.h"

@interface LSJProgramConfigModel : QBEncryptedURLRequest
- (BOOL)fetchProgramsInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(QBCompletionHandler)handler;
@end
