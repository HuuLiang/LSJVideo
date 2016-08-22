//
//  LSJLecherModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJColumnModel.h"

@interface LSJLecherColumnsModel : LSJURLResponse
@property (nonatomic) NSString *columnDesc;
@property (nonatomic) NSInteger columnId;
@property (nonatomic) NSString *columnImg;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger realColumnId;
@property (nonatomic) NSInteger showNumber;
@property (nonatomic) NSString *spare;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSArray <LSJColumnModel *> *columnList;
@end

@interface LSJLecherModelResponse : LSJURLResponse
@property (nonatomic) NSArray <LSJLecherColumnsModel *> *columnList;
@end


@interface LSJLecherModel : LSJEncryptedURLRequest

- (BOOL)fetchLechersInfoWithCompletionHandler:(LSJCompletionHandler)handler;

@end
