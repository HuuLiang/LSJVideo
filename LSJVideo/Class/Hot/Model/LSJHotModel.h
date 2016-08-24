//
//  LSJHotModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJColumnModel.h"

@interface LSJHotModelResponse : LSJURLResponse
@property (nonatomic) NSArray <LSJColumnModel *> *columnList;
@end

@interface LSJHotModel : LSJEncryptedURLRequest

- (BOOL)fetchHotInfoWithCompletionHadler:(LSJCompletionHandler)handler;

@end
