//
//  LSJDetailImgTextCell.m
//  LSJVideo
//
//  Created by Liang on 16/9/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailImgTextCell.h"

@interface LSJDetailImgTextCell ()
{
    LSJContentType _contentType;
    UIImageView *_imgV;
    UILabel *_label;
}
@end

@implementation LSJDetailImgTextCell

- (instancetype)initWithContentType:(NSInteger)type
{
    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _contentType = type;
        
        if (_contentType == LSJContentType_Text) {
            _label = [[UILabel alloc] init];
            _label.textColor = [UIColor colorWithHexString:@"#666666"];
            _label.font = [UIFont systemFontOfSize:kWidth(30)];
            _label.numberOfLines = 0;
            [self addSubview:_label];
            
            {
                [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(kWidth(0), kWidth(30), kWidth(15), kWidth(30)));
                }];
            }
        } else if (_contentType == LSJContentType_Image) {
            _imgV = [[UIImageView alloc] init];
            [self addSubview:_imgV];
            
            {
                [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.edges.mas_equalTo(UIEdgeInsetsMake(kWidth(0), kWidth(30), kWidth(15), kWidth(30)));
                }];
            }
        }
    }
    return self;
}

- (void)setContent:(NSString *)content {
    if (_contentType == LSJContentType_Text) {
        _label.text = content;
    } else if (_contentType == LSJContentType_Image) {
        [_imgV sd_setImageWithURL:[NSURL URLWithString:content]];
    }
}

@end
