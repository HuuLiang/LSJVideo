//
//  LSJWelfareModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "LSJColumnModel.h"

@interface LSJWelfareModel : QBEncryptedURLRequest
- (BOOL)fetchWelfareInfoWithCompletionHandler:(QBCompletionHandler)handler;
@end
