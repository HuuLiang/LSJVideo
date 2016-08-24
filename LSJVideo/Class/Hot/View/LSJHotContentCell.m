//
//  LSJHotContentCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHotContentCell.h"

@interface LSJHotContentCell ()
{
    UIImageView *_imgV;
    UILabel *_titleLabel;
}
@end

@implementation LSJHotContentCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _imgV = [[UIImageView alloc] init];
        _imgV.layer.cornerRadius = kWidth(8);
        _imgV.layer.masksToBounds = YES;
        [self addSubview:_imgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        [self addSubview:_titleLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self);
                make.height.mas_equalTo(kWidth(60));
            }];
            
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.bottom.equalTo(_titleLabel.mas_top);
            }];
        }
    }
    return self;
}

-(void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}
@end
