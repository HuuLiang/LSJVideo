//
//  LSJProgramModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJProgramModel.h"

@implementation LSJCommentModel

@end


@implementation LSJProgramModel

- (Class)commentsElementClass {
    return [LSJCommentModel class];
}

- (Class)imgurlsElementClass {
    return [LSJProgramModel class];
}

@end
