//
//  LSJMineAppCell.m
//  LSJVideo
//
//  Created by Liang on 16/9/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJMineAppCell.h"

@interface LSJMineAppCell ()
{
    UIImageView *_imgV;
}
@end

@implementation LSJMineAppCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _imgV = [[UIImageView alloc] init];
        
        [self addSubview:_imgV];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(kWidth(10), 0, 0, 0));
            }];
        }
        
        
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"place_51"]];
}

- (void)setIsInstalled:(BOOL)isInstalled {
    if (isInstalled) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"已安装";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        label.font = [UIFont systemFontOfSize:kWidth(70)];
        label.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:label];
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(kWidth(10), 0, 0, 0));
            }];
        }
    }
}

@end
