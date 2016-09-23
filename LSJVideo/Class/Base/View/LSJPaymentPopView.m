//
//  LSJPaymentPopView.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentPopView.h"
#import "LSJPayPointCell.h"
#import "LSJPaymentTypeCell.h"
#import "LSJSystemConfigModel.h"

//static const CGFloat kHeaderImageScale = 620./280.;

#define kPaymentCellHeight MIN(kScreenHeight * 0.15, 80)
#define kPayPointTypeCellHeight MIN(kScreenHeight * 0.1, 60)

@interface LSJPaymentPopView () <UITableViewSeparatorDelegate, UITableViewDataSource>
{
    UITableViewCell *_headerCell;
    LSJPayPointCell *_payPointACell;
    LSJPayPointCell *_payPointBCell;
    NSIndexPath *_selectedIndexPath;
}
@end

@implementation LSJPaymentPopView

- (instancetype)initWithAvailablePaymentTypes:(NSArray *)availablePaymentTypes
{
    self = [super init];
    if (self) {
        _availablePaymentTypes = availablePaymentTypes;
        
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.layer.cornerRadius = [LSJUtil isIpad] ? 10 : kWidth(10);
        self.layer.masksToBounds = YES;
        [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        self.backgroundColor = [UIColor colorWithHexString:@"#6b2073"];
    }
    return self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView hasBorderInSection:(NSUInteger)section {
    if (section == PaymentTypeSection) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView hasSeparatorBetweenIndexPath:(NSIndexPath *)lowerIndexPath andIndexPath:(NSIndexPath *)upperIndexPath {
    if (upperIndexPath.section == PaymentTypeSection && lowerIndexPath.section == PaymentTypeSection && _availablePaymentTypes.count == 2) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PaymentTypeSection) {
        return _availablePaymentTypes.count;
    } else if (section == PayPointSection) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HeaderSection) {
        if (!_headerCell) {
            _headerCell = [[UITableViewCell alloc] init];
            _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _headerCell.backgroundColor = [UIColor clearColor];
            
            UIImageView *_bgImgV = [[UIImageView alloc] init];
            _bgImgV.layer.cornerRadius = kWidth(10);
            _bgImgV.layer.masksToBounds = YES;
            [_headerCell addSubview:_bgImgV];
            
            [_bgImgV sd_setImageWithURL:[NSURL URLWithString:[LSJSystemConfigModel sharedModel].vipImg] placeholderImage:[UIImage imageNamed:@""]];
            {
                [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(kWidth(10), kWidth(10), kWidth(10), kWidth(10)));
                }];
            }
        }
        return _headerCell;
    } else if (indexPath.section == PayPointSection) {
        if (indexPath.row == 0) {
            _payPointACell = [[LSJPayPointCell alloc] initWithCurrentVipLevel:[LSJUtil currentVipLevel] IndexPathRow:indexPath.row];
            
            return _payPointACell;
        } else {
            _payPointBCell = [[LSJPayPointCell alloc] initWithCurrentVipLevel:[LSJUtil currentVipLevel] IndexPathRow:indexPath.row];
            
            return _payPointBCell;
        }
    } else if (indexPath.section == PaymentTypeSection) {
        @weakify(self);
        for (NSInteger i  = 0; i < _availablePaymentTypes.count; i++) {
            NSDictionary *dict = _availablePaymentTypes[i];
            QBPayType type = [dict[@"type"] integerValue];
            QBPaySubType subType = [dict[@"subType"] integerValue];
            if (indexPath.row == i) {
                
                LSJPaymentTypeCell *cell = [[LSJPaymentTypeCell alloc]initWithPaymentType:type subType:subType];
                cell.selectionAction = ^(QBPayType paymentType){
                    @strongify(self);
                    [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                };
                
                return cell;
            }
        }
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HeaderSection) {
        return kWidth(560);
    } else if (indexPath.section == PayPointSection) {
        return kWidth(130);
    } else if (indexPath.section == PaymentTypeSection) {
        return kWidth(100);
    } else {
        return 0;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndexPath = [self indexPathForSelectedRow];
    if (_selectedIndexPath.section == indexPath.section) {
        _selectedIndexPath = indexPath;
        return indexPath;
    } else {
        return _selectedIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != PaymentTypeSection) {
        [self selectRowAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}
@end
