//
//  LSJHomeSectionHeaderView.m
//  LSJVideo
//
//  Created by Liang on 16/8/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeSectionHeaderView.h"

@interface LSJHomeSectionHeaderView ()
{
    UILabel *_titleLabel;
    
//    UIImageView *_leftImg;
//    UIImageView *_rightImg;
    
//    CAShapeLayer *lineA;
}
@end

@implementation LSJHomeSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        UIView *grayView = [[UIView alloc] init];
        grayView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [self addSubview:grayView];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#fee102"];
        [self addSubview:lineView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        {
            [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.height.equalTo(@(kWidth(20)));
            }];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self).offset(kWidth(10));
                make.left.equalTo(self).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(6), kWidth(44)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lineView);
                make.left.equalTo(lineView.mas_right).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(44));
            }];
        }
        
//        _leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_kiss_icon"]];
//        [self addSubview:_leftImg];
        
//        _rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_kiss_icon"]];
//        [self addSubview:_rightImg];
        
        {
//            [_leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self);
//                make.right.equalTo(_titleLabel.mas_left).offset(-kScreenWidth * 11 / 750.);
//                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 38 /750., kScreenHeight * 27 / 1334.));
//            }];
//            
//            [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self);
//                make.left.equalTo(_titleLabel.mas_right).offset(kScreenWidth * 11 / 750.);
//                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 38 /750., kScreenHeight * 27 / 1334.));
//            }];
        }
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

//- (void)setSection:(NSInteger)section {
//    _section = section;
//    if (section == 1) {
//        lineA.hidden = YES;
//    } else {
//        lineA.hidden = NO;
//    }
//}

//-(void)drawRect:(CGRect)rect {
//    lineA = [CAShapeLayer layer];
//    CGMutablePathRef linePathA = CGPathCreateMutable();
//    [lineA setFillColor:[[UIColor clearColor] CGColor]];
//    [lineA setStrokeColor:[[UIColor colorWithHexString:@"#3f3f3f"] CGColor]];
//    lineA.lineWidth = 0.5f;
//    CGPathMoveToPoint(linePathA, NULL, 0 , kScreenHeight * 3 / 1334.);
//    CGPathAddLineToPoint(linePathA, NULL, kScreenWidth , kScreenHeight * 3 / 1334.);
//    [lineA setPath:linePathA];
//    CGPathRelease(linePathA);
//    [self.layer addSublayer:lineA];
//    
//    if (_section == 1) {
//        lineA.hidden = YES;
//    } else {
//        lineA.hidden = NO;
//    }
//}
@end
