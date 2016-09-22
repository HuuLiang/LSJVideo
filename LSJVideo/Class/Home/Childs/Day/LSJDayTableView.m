//
//  LSJDayTableView.m
//  LSJVideo
//
//  Created by Liang on 16/8/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDayTableView.h"



@interface LSJDayTableViewCell ()
{
    UILabel * _userLabel;
    UILabel * _contentLabel;
}
@end

@implementation LSJDayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _userLabel = [[UILabel alloc] init];
        _userLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _userLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        [self addSubview:_userLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _contentLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        [self addSubview:_contentLabel];
        
        {
            [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
            }];
            
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userLabel.mas_right);
                make.top.right.bottom.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)setUserStr:(NSString *)userStr {
    _userLabel.text = [NSString stringWithFormat:@"%@:",userStr];
}

- (void)setContent:(NSString *)content {
    _contentLabel.text = content;
}

@end




@implementation LSJDayTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self registerClass:[LSJDayTableViewCell class] forCellReuseIdentifier:kDayTableViewCellReusableIdentifier];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.userInteractionEnabled = NO;
        
    }
    return self;
}

@end
