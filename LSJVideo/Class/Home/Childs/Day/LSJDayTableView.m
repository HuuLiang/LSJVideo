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
        
        {
            [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)setUserStr:(NSString *)userStr {
    _userLabel.text = userStr;
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
