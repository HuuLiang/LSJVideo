//
//  LSJLecherModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJColumnModel.h"

@interface LSJLecherColumnResponse : LSJURLResponse
@property (nonatomic) NSArray <LSJColumnModel *> *columnList;
@end


@interface LSJLecherModel : LSJEncryptedURLRequest

- (BOOL)fetchLechersInfoWithCompletionHandler:(LSJCompletionHandler)handler;

@end
