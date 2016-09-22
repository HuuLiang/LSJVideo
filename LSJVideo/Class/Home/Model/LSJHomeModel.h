//
//  LSJHomeModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "LSJColumnModel.h"

@interface LSJHomeColumnsModel : QBURLResponse
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

@interface LSJHomeModelResponse : QBURLResponse
@property (nonatomic) NSArray <LSJHomeColumnsModel *> *columnList;
@end

@interface LSJHomeModel : QBEncryptedURLRequest

- (BOOL)fetchHomeInfoWithCompletionHandler:(QBCompletionHandler)handler;

@end
