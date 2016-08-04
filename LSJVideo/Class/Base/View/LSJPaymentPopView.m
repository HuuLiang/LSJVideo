//
//  LSJPaymentPopView.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentPopView.h"
#import "LSJPaymentTypeCell.h"
#import "LSJSystemConfigModel.h"

//static const CGFloat kHeaderImageScale = 620./280.;

#define kPaymentCellHeight MIN(kScreenHeight * 0.15, 80)
#define kPayPointTypeCellHeight MIN(kScreenHeight * 0.1, 60)



@interface LSJPaymentPopView () <UITableViewSeparatorDelegate, UITableViewDataSource>
{
    UITableViewCell *_headerCell;
    UITableViewCell *_paypointTypeCell;
    LSJPaymentTypeCell *_alipayCell;
    LSJPaymentTypeCell *_wxpayCell;
    LSJPaymentTypeCell *_iAppPayCell;
    LSJPaymentTypeCell *_qqpayCell;
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
        self.layer.cornerRadius = lround(kScreenWidth*0.04);
        self.layer.masksToBounds = YES;
        [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    }
    return self;
}

//- (CGFloat)viewHeightRelativeToWidth:(CGFloat)width {
//    const CGFloat headerHeight = kScreenHeight*160/1334.;
//
//    __block CGFloat cellHeights = headerHeight;
//    NSUInteger numberOfSections = [self numberOfSections];
//    for (NSUInteger section = 1; section < numberOfSections; ++section) {
//        NSUInteger numberOfItems = [self tableView:self numberOfRowsInSection:section];
//        for (NSUInteger item = 0; item < numberOfItems; ++item) {
//            CGFloat itemHeight = [self tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:item inSection:section]];
//            cellHeights += itemHeight;
//        }
//    }
//    return lround(cellHeights);
//}



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
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HeaderSection) {
        if (!_headerCell) {
            _headerCell = [[UITableViewCell alloc] init];
            _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _headerCell.backgroundColor= [UIColor colorWithHexString:@"#ff05a4"];
            
            UIButton *closeButton = [[UIButton alloc] init];
            closeButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            [closeButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
            [_headerCell addSubview:closeButton];
            
            UILabel * _priceLabel = [[UILabel alloc] init];
            _priceLabel.text = [NSString stringWithFormat:@"%ld",(long)[LSJSystemConfigModel sharedModel].payAmount/100];
            _priceLabel.textAlignment = NSTextAlignmentCenter;
            _priceLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
            _priceLabel.font = [UIFont boldSystemFontOfSize:32.];
            [_headerCell addSubview:_priceLabel];
            
            UILabel * _priceUnitLabel = [[UILabel alloc] init];
            _priceUnitLabel.text = @"元";
            _priceUnitLabel.textAlignment = NSTextAlignmentCenter;
            _priceUnitLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
            _priceUnitLabel.font = [UIFont boldSystemFontOfSize:14.];
            [_headerCell addSubview:_priceUnitLabel];
            
            UILabel * _decLabel = [[UILabel alloc] init];
            _decLabel.text = @"开通会员即可享受顶级片源";
            _decLabel.textAlignment = NSTextAlignmentCenter;
            _decLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
            _decLabel.font = [UIFont boldSystemFontOfSize:14.];
            [_headerCell addSubview:_decLabel];
            
            {
                [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(_headerCell).offset(10);
                    make.top.equalTo(_headerCell).offset(-10);
                    make.size.mas_equalTo(CGSizeMake(50, 50));
                }];
                
                [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_headerCell);
                    make.top.equalTo(_headerCell.mas_top).offset(10.);
                    make.height.mas_equalTo(35);
                }];
                
                [_priceUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_priceLabel.mas_right).offset(3);
                    make.bottom.equalTo(_priceLabel.mas_bottom).offset(-2.5);
                    make.height.mas_equalTo(17);
                }];
                
                [_decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_headerCell);
                    make.bottom.equalTo(_headerCell.mas_bottom).offset(-5);
                    make.height.mas_equalTo(20);
                }];
            }
            @weakify(self);
            [closeButton bk_addEventHandler:^(id sender) {
                @strongify(self);
                if (self.closeAction) {
                    self.closeAction(self);
                }
            } forControlEvents:UIControlEventTouchUpInside];
        }
        return _headerCell;
    } else if (indexPath.section == PayPointSection) {
        _paypointTypeCell = [[UITableViewCell alloc] init];
        _paypointTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _paypointTypeCell.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"选择付款方式";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13.];
        [_paypointTypeCell addSubview:label];
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_paypointTypeCell);
                make.left.equalTo(_paypointTypeCell).offset(15);
                make.right.equalTo(_paypointTypeCell).offset(-15);
                make.height.mas_equalTo(kScreenHeight * 60/1334.);
            }];
        }
        return _paypointTypeCell;
    } else if (indexPath.section == PaymentTypeSection) {
        @weakify(self);
        for (NSInteger i  = 0; i < _availablePaymentTypes.count; i++) {
            NSDictionary *dict = _availablePaymentTypes[i];
            LSJPaymentType type = [dict[@"type"] integerValue];
            LSJSubPayType subType = [dict[@"subType"] integerValue];
            if (indexPath.row == i) {
                
                LSJPaymentTypeCell *cell = [[LSJPaymentTypeCell alloc]initWithPaymentType:type subType:subType];
                cell.selectionAction = ^(LSJPaymentType paymentType){
                    @strongify(self);
                    [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                };
                
                return cell;
                
                //                if (type == LSJPaymentTypeVIAPay) {
                //                    if (subType == LSJSubPayTypeWeChat) {
                //                        _alipayCell = [[LSJPaymentTypeCell alloc] initWithPaymentType:LSJPaymentTypeVIAPay subType:LSJSubPayTypeWeChat];
                //                        _alipayCell.selectionAction = ^(LSJPaymentType paymentType) {
                //                            @strongify(self);
                //                            [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                //                        };
                //                        return _alipayCell;
                //                    } else if (subType == LSJSubPayTypeWeChat) {
                //                        _wxpayCell = [[LSJPaymentTypeCell alloc] initWithPaymentType:LSJPaymentTypeVIAPay subType:LSJSubPayTypeAlipay];
                //                        _wxpayCell.selectionAction = ^(LSJPaymentType paymentType) {
                //                            @strongify(self);
                //                            [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                //                        };
                //                        return _wxpayCell;
                //                    } else if(subType == LSJSubPayTypeQQ){
                //                        _qqpayCell = [[LSJPaymentTypeCell alloc] initWithPaymentType:LSJPaymentTypeVIAPay subType:LSJSubPayTypeQQ];
                //                        _qqpayCell.selectionAction = ^(LSJPaymentType paymentType) {
                //                            @strongify(self);
                //                            [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                //                        };
                //                    }
                //                }else if (type == LSJPaymentTypeIAppPay) {
                //
                //                    _iAppPayCell = [[LSJPaymentTypeCell alloc] initWithPaymentType:LSJPaymentTypeIAppPay subType:LSJSubPayTypeNone];
                //                    _iAppPayCell.selectionAction = ^(LSJPaymentType paymentType){
                //                        @strongify(self);
                //                        [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                //                    };
                //                    return _iAppPayCell;
                //                }
                
            }
        }
    } else if (indexPath.section == PaySection) {
        UITableViewCell * _payCell = [[UITableViewCell alloc] init];
        _payCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _payCell.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        
        UIButton *_payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:16.];
        [_payBtn setTintColor:[UIColor colorWithHexString:@"#ffffff"]];
        _payBtn.backgroundColor = [UIColor colorWithHexString:@"#ff680d"];
        _payBtn.layer.cornerRadius = kScreenHeight * 10 / 1334.;
        _payBtn.layer.masksToBounds = YES;
        [_payCell addSubview:_payBtn];
        @weakify(self);
        [_payBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            LSJPaymentTypeCell * cell = [self cellForRowAtIndexPath:[self indexPathForSelectedRow]];
            if (_paymentAction) {
                _paymentAction(cell.payType,cell.subType);
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_payCell);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 440 / 750., kScreenHeight * 78 / 1334.));
            }];
        }
        return _payCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HeaderSection) {
        return kScreenWidth * 160/750.;
    } else if (indexPath.section == PayPointSection) {
        return kScreenHeight * 60/1334.;
    } else if (indexPath.section == PaymentTypeSection) {
        return kScreenHeight * 110 / 1334.;
    } else if (indexPath.section == PaySection) {
        return kScreenHeight * 630 /1334. + (kScreenHeight * 110 / 1334.) * (_availablePaymentTypes.count - 2.) - kScreenWidth * 160/750. - kScreenHeight * 110 / 1334. * _availablePaymentTypes.count - 30 ;
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
