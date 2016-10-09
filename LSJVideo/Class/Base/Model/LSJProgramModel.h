//
//  LSJProgramModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface LSJCommentModel : NSObject
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *createAt;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *userName;
@end

@interface LSJProgramModel : QBURLResponse
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSString *detailsCoverImg;
@property (nonatomic) NSString *offUrl;
@property (nonatomic) NSInteger payPointType;
@property (nonatomic) NSInteger programId;
@property (nonatomic) NSString *spare;
@property (nonatomic) NSString *spec;
@property (nonatomic) NSString *specialDesc;
@property (nonatomic) NSString *tag;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSArray <LSJCommentModel *> *comments;
@property (nonatomic) NSArray *imgurls;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *createAt;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSInteger commentNum;
@end
