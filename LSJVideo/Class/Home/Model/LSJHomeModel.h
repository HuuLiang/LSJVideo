//
//  LSJHomeModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJColumnModel.h"

@interface LSJHomeColumnModel : LSJURLResponse
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

@interface LSJHomeModelResponse : LSJURLResponse
@property (nonatomic) NSArray <LSJHomeColumnModel *> *columnList;
@end

@interface LSJHomeModel : LSJEncryptedURLRequest

- (BOOL)fetchHomeInfoWithCompletionHandler:(LSJCompletionHandler)handler;

@end
