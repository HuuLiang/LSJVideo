//
//  LSJActViewController.m
//  LSJVideo
//
//  Created by Liang on 2016/10/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJActViewController.h"
#import "LSJManualActivationManager.h"
#import "LSJAutoActivateManager.h"

@interface LSJActViewController () <UITextFieldDelegate>
{
    UITextField *_textField;
    UIButton *_nonAutoBtn;
}
@end

@implementation LSJActViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self initCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCells {
    [self removeAllLayoutCells];
    
    NSInteger section = 0;
    
    [self initNonAutoActTitleInSection:section++];
    [self initNonAutoFuncButtonInSection:section++];
}

- (void)initNonAutoActTitleInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(100) inSection:section];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UILabel *aotuLabel = [[UILabel alloc] init];
    aotuLabel.text = @"输入支付订单号自助激活";
    aotuLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    aotuLabel.font = [UIFont systemFontOfSize:kWidth(32)];
    aotuLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:aotuLabel];
    
    {
        [aotuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView);
            make.height.mas_equalTo(kWidth(44));
        }];
    }
    [self setLayoutCell:cell cellHeight:kWidth(82) inRow:0 andSection:section];
}

- (void)initNonAutoFuncButtonInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    _textField = [[UITextField alloc] init];
    _textField.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    _textField.font = [UIFont systemFontOfSize:kWidth(34)];
    _textField.textColor = [UIColor colorWithHexString:@"#000000"];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.placeholder = @"  请输入正确的订单号";
    _textField.layer.borderColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.layer.masksToBounds = YES;
    [_textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.contentView addSubview:_textField];
    
    _nonAutoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nonAutoBtn setTitle:@"提交激活" forState:UIControlStateNormal];
    [_nonAutoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _nonAutoBtn.backgroundColor = [UIColor colorWithHexString:@"#FF680D"];
    _nonAutoBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
    _nonAutoBtn.layer.cornerRadius = kWidth(10);
    _nonAutoBtn.layer.masksToBounds = YES;
    [cell.contentView addSubview:_nonAutoBtn];
    
    @weakify(self);
    [_nonAutoBtn bk_addEventHandler:^(id sender) {
        [[LSJAutoActivateManager sharedManager] requestExchangeCode:self->_textField.text];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.centerX.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(kWidth(560), kWidth(88)));
        }];
        
        [_nonAutoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView);
            make.centerX.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(kWidth(542), kWidth(88)));
        }];
    }
    
    [self setLayoutCell:cell cellHeight:kWidth(236) inRow:0 andSection:section];
}

@end
