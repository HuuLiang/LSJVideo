//
//  LSJWelfareModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"

@interface LSJWelfareModel : LSJEncryptedURLRequest
- (BOOL)fetchWelfareInfoWithCompletionHandler:(LSJCompletionHandler)handler;
@end
