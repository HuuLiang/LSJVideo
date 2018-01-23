//
//  LSJDeetailImgTextCell.h
//  LSJVideo
//
//  Created by Liang on 16/9/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LSJContentType) {
    LSJContentType_Image = 2,
    LSJContentType_Text = 3
};

@interface LSJDetailImgTextCell : UITableViewCell

- (instancetype)initWithContentType:(NSInteger)type;

@property (nonatomic) NSString *content;

@end
