//
//  LSJHomeProgramModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJProgramModel.h"


@interface LSJHomeProgramListModel : LSJURLResponse
@property (nonatomic) NSString *columnDesc;
@property (nonatomic) NSInteger columnId;
@property (nonatomic) NSString *columnImg;
@property (nonatomic) NSString *name;
@property (nonatomic) NSArray <LSJProgramModel *> *programList;
@property (nonatomic) NSInteger realColumnId;
@property (nonatomic) NSInteger showNumber;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger showMode;
@end


@interface LSJHomeProgramResponse : LSJURLResponse
@property (nonatomic) NSArray <LSJHomeProgramListModel *> *columnList;
@end


@interface LSJHomeProgramModel : LSJEncryptedURLRequest
- (BOOL)fetchHomeInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(LSJCompletionHandler)handler;
@end
