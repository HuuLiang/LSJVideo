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
    LSJPaymentTypeCell *_payTypeCell;
    QBPayType _payType;
    QBPaySubType _subPayType;
}
@end

@implementation LSJPaymentPopView

- (instancetype)initWithAvailablePaymentTypes:(NSArray *)availablePaymentTypes
{
    self = [super init];
    if (self) {
        _availablePaymentTypes = availablePaymentTypes;
        
        _payType = [_availablePaymentTypes[0][@"type"] unsignedIntegerValue];
        _subPayType = [_availablePaymentTypes[0][@"subType"] unsignedIntegerValue];
        
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.layer.cornerRadius = [LSJUtil isIpad] ? 10 : kWidth(10);
        self.layer.masksToBounds = YES;
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if ([LSJUtil currentVipLevel] == LSJVipLevelVip) {
            UIImageView  *bgImgV = [[UIImageView alloc] init];
            [bgImgV setContentMode:UIViewContentModeScaleToFill];
            bgImgV.clipsToBounds = NO;
            //                        [self insertSubview:bgImgV atIndex:0];
            [bgImgV sd_setImageWithURL:[NSURL URLWithString:[LSJSystemConfigModel sharedModel].sVipImg]];
            self.backgroundView = bgImgV;
            {
                //                            [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                //                                                    make.center.equalTo(self);
                //                                                    make.size.mas_equalTo(CGSizeMake(kWidth(630),kWidth(920)));
                //                            }];
            }
        } else {
            self.backgroundColor = [UIColor colorWithHexString:@"#6b2073"];
        }
    }
    return self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView hasBorderInSection:(NSUInteger)section {
    if (section == PaymentTypeSection) {
        return NO;
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
    if (section == PayPointSection) {
        if ([LSJUtil currentVipLevel] == LSJVipLevelNone) {
            return 2;
        } else if ([LSJUtil currentVipLevel] == LSJVipLevelVip) {
            return 1;
        } else {
            return 0;
        }
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
            
            if ([LSJUtil currentVipLevel] == LSJVipLevelNone) {
                UIImageView *_bgImgV = [[UIImageView alloc] init];
                _bgImgV.layer.cornerRadius = kWidth(10);
                _bgImgV.contentMode = UIViewContentModeScaleToFill;
                _bgImgV.clipsToBounds = NO;
                [_headerCell addSubview:_bgImgV];
                
                [_bgImgV sd_setImageWithURL:[NSURL URLWithString:[LSJSystemConfigModel sharedModel].vipImg]];
                {
                    [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(_headerCell).insets(UIEdgeInsetsMake(kWidth(10), kWidth(10), kWidth(10), kWidth(10)));
                        //                        make.center.equalTo(_headerCell);
                        //                        make.size.mas_equalTo(CGSizeMake(kWidth(610), kWidth(540)));
                    }];
                }
            }
        }
        return _headerCell;
    } else if (indexPath.section == PayPointSection) {
        if (indexPath.row == 0) {
            _payPointACell = [[LSJPayPointCell alloc] initWithCurrentVipLevel:[LSJUtil currentVipLevel] IndexPathRow:indexPath.row];
            @weakify(self);
            _payPointACell.action = ^(NSNumber * vipLevel) {
                @strongify(self);
                self.paymentAction(self->_payType,self->_subPayType,[vipLevel unsignedIntegerValue]);
            };
            return _payPointACell;
        } else {
            _payPointBCell = [[LSJPayPointCell alloc] initWithCurrentVipLevel:[LSJUtil currentVipLevel] IndexPathRow:indexPath.row];
            @weakify(self);
            _payPointBCell.action = ^(NSNumber * vipLevel) {
                @strongify(self);
                self.paymentAction(self->_payType,self->_subPayType,[vipLevel unsignedIntegerValue]);
            };
            return _payPointBCell;
        }
    } else if (indexPath.section == PaymentTypeSection) {
        @weakify(self);
        _payTypeCell = [[LSJPaymentTypeCell alloc] initWithPaymentTypes:_availablePaymentTypes];
        
        _payTypeCell.selectionAction = ^(QBPayType payType,QBPaySubType paySubType) {
            @strongify(self);
            self->_payType = payType;
            self->_subPayType = paySubType;
        };
        
        return _payTypeCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HeaderSection) {
        return kWidth(560);
    } else if (indexPath.section == PayPointSection) {
        if ([LSJUtil currentVipLevel] == LSJVipLevelNone) {
            return kWidth(130);
        } else {
            return kWidth(260);
        }
    } else if (indexPath.section == PaymentTypeSection) {
        return kWidth(100);
    } else {
        return 0;
    }
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    _selectedIndexPath = [self indexPathForSelectedRow];
//    if (_selectedIndexPath.section == indexPath.section) {
//        _selectedIndexPath = indexPath;
//        return indexPath;
//    } else {
//        return _selectedIndexPath;
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section != PaymentTypeSection) {
//        [self selectRowAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    }
//}
@end
