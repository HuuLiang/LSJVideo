//
//  LSJHotModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "LSJColumnModel.h"

@interface LSJHotModelResponse : QBURLResponse
@property (nonatomic) NSArray <LSJColumnModel *> *columnList;
@end

@interface LSJHotModel : QBEncryptedURLRequest

- (BOOL)fetchHotInfoWithCompletionHadler:(QBCompletionHandler)handler;

@end
