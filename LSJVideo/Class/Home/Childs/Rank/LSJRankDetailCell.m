//
//  LSJRankDetailCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJRankDetailCell.h"

@interface LSJRankDetailCell ()
{
    UIImageView *_imgV;
    
    UILabel *_titleLabel;
}
@end

@implementation LSJRankDetailCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        [self addSubview:_titleLabel];
        
        
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
