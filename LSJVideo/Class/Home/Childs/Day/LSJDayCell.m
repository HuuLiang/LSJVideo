//
//  LSJDayCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDayCell.h"
#import "LSJDayTableView.h"

@interface LSJDayCell () <UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *_imgV;
    UILabel *_titleLabel;
    UILabel *_commandCountLabel;
    LSJDayTableView *_dayTableView;
    NSIndexPath * _currentIndexPath;
}
@property (nonatomic) NSMutableArray *userContacts;
@end

@implementation LSJDayCell
QBDefineLazyPropertyInitialization(NSMutableArray, userContacts)

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _start = NO;
        
        _currentIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        _imgV = [[UIImageView alloc] init];
        _imgV.layer.cornerRadius = kWidth(10);
        _imgV.layer.masksToBounds = YES;
        [bgView addSubview:_imgV];
        
        UIView *shadeView = [[UIView alloc] init];
        shadeView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.2];
        [_imgV addSubview:shadeView];
        
        UIImage  *playImage = [UIImage imageNamed:@"lecher_play"];
        UIImageView *playImgV = [[UIImageView alloc] initWithImage:playImage];
        [shadeView addSubview:playImgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        [bgView addSubview:_titleLabel];
        
        UIImage *contactImage = [UIImage imageNamed:@"lecher_contact"];
        UIImageView *_contactImgV = [[UIImageView alloc] initWithImage:contactImage];
        [bgView addSubview:_contactImgV];
        
        _commandCountLabel = [[UILabel alloc] init];
        _commandCountLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _commandCountLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [bgView addSubview:_commandCountLabel];
        
        _dayTableView = [[LSJDayTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dayTableView.dataSource = self;
        _dayTableView.delegate = self;
        [bgView addSubview:_dayTableView];
        
        {
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(kScreenWidth * 14 /15 - kWidth(20));
            }];
            
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(bgView);
                make.top.equalTo(bgView).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kScreenWidth - 2 * kWidth(20), (kScreenWidth - 2 * kWidth(20)) / 2));
            }];
            
            [shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_imgV);
            }];
            
            [playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(shadeView);
                make.size.mas_equalTo(CGSizeMake(kWidth(playImage.size.width*2), kWidth(playImage.size.height*2)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imgV.mas_bottom).offset(15);
                make.left.equalTo(bgView).offset(kWidth(40));
                make.height.mas_equalTo(kWidth(48));
            }];
            
            [_contactImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(32));
                make.left.equalTo(bgView).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(contactImage.size.width * 2), kWidth(contactImage.size.height * 2)));
            }];
            
            [_commandCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_contactImgV);
                make.left.equalTo(_contactImgV.mas_right).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_dayTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_commandCountLabel.mas_bottom).offset(kWidth(15));
                make.bottom.equalTo(bgView.mas_bottom).offset(-kWidth(10));
                make.right.equalTo(bgView);
                make.left.equalTo(bgView).offset(kWidth(40));
            }];
        }
        
    }
    return self;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setContact:(NSString *)contact {
    _commandCountLabel.text = contact;
}

- (void)setUserComments:(NSArray<LSJCommentModel *> *)userComments {
    [self.userContacts removeAllObjects];
    [self.userContacts addObjectsFromArray:userComments];
    
    if (userComments.count > 3) {
        if (userComments.count == 4) {
            [self.userContacts addObject:userComments[0]];
        } else if (userComments.count == 5) {
            [self.userContacts addObject:userComments[0]];
            [self.userContacts addObject:userComments[1]];
        } else if (userComments.count >= 6) {
            [self.userContacts addObject:userComments[0]];
            [self.userContacts addObject:userComments[1]];
            [self.userContacts addObject:userComments[2]];
        }
    }
    
    [_dayTableView reloadData];
}

- (void)setStart:(BOOL)start {
    if (_start) {
        return;
    }
    _start = start;
    if (_start) {
        [self performSelector:@selector(scrollTitle) withObject:nil afterDelay:1];
    }
}

- (void)scrollTitle {
    if (_userContacts.count < 4 || !_start) {
        return;
    }
    
    if (_currentIndexPath.row == _userContacts.count - 1) {
        _currentIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [_dayTableView scrollToRowAtIndexPath:_currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        _currentIndexPath = [NSIndexPath indexPathForRow:_currentIndexPath.row + 1 inSection:0];
        [_dayTableView scrollToRowAtIndexPath:_currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else {
        _currentIndexPath = [NSIndexPath indexPathForRow:_currentIndexPath.row + 1 inSection:0];
        [_dayTableView scrollToRowAtIndexPath:_currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
//    DLog(@"currentIndexPath:%ld",_currentIndexPath.row);
    if (_start) {
        [self performSelector:@selector(scrollTitle) withObject:nil afterDelay:1];
    }
}

- (void)drawRect:(CGRect)rect {
    QBLog(@"%@",NSStringFromCGRect(_titleLabel.frame));
    
    CAShapeLayer *line = [CAShapeLayer layer];
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    [line setFillColor:[[UIColor clearColor] CGColor]];
    [line setStrokeColor:[[UIColor colorWithHexString:@"#dcdcdc"] CGColor]];
    line.lineWidth = kWidth(2);
    CGPathMoveToPoint(linePath, NULL, kWidth(20), _titleLabel.frame.origin.y + _titleLabel.frame.size.height + kWidth(10));
    CGPathAddLineToPoint(linePath, NULL, kScreenWidth - kWidth(20), _titleLabel.frame.origin.y + _titleLabel.frame.size.height + kWidth(10));
    [line setPath:linePath];
    CGPathRelease(linePath);
    [self.layer addSublayer:line];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _userContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DLog(@"indexPath:%ld",indexPath.row);
    LSJDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDayTableViewCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < _userContacts.count) {
        LSJCommentModel *comment = _userContacts[indexPath.row];
        cell.userStr = comment.userName;
        cell.content = comment.content;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _dayTableView.frame.size.height / 3;
}


@end
