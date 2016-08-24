//
//  LSJHotTitleCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHotTitleCell.h"

@implementation LSJHotTitleCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = kScreenHeight * 24 / 1334.;
        self.layer.masksToBounds = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, kScreenHeight * 48 / 1334.)];
        _titleLabel.font = [UIFont systemFontOfSize:kScreenWidth * 26 / 750.];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.layer.cornerRadius = kScreenHeight * 24 / 1334.;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _titleLabel.layer.borderWidth = 1.0f;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:kScreenWidth*26/750.] maxSize:CGSizeMake(MAXFLOAT, kScreenHeight * 48 / 1334.)].width + 10.;
    _titleLabel.frame = CGRectMake(0, 0, width + 15 , kScreenHeight * 48 /1334.);
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _titleLabel.backgroundColor = [UIColor colorWithHexString:@"#cf4343"];
        _titleLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    } else {
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#222222 "];
        _titleLabel.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    }
}

@end
