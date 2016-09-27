//
//  LSJMineViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJMineViewController.h"
#import "LSJTableViewCell.h"
#import "LSJWebViewController.h"
#import "LSJBannerVipCell.h"
#import "LSJSystemConfigModel.h"
@interface LSJMineViewController ()
{
    LSJBannerVipCell *_bannerCell;
    LSJTableViewCell *_vipCell;
    LSJTableViewCell *_statementCell;
    LSJTableViewCell *_protocolCell;
    LSJTableViewCell *_telCell;
}
@end

@implementation LSJMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.layoutTableView.hasSectionBorder = NO;
//    self.layoutTableView.hasRowSeparator = NO;
    
//    [self.layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.layoutTableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(30), 0, kWidth(30))];
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.layoutTableView LSJ_addPullToRefreshWithHandler:^{
        [self initCells];
    }];
    [self.layoutTableView LSJ_triggerPullToRefresh];
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_vipCell || cell == self->_bannerCell) {
            LSJBaseModel *model = [[LSJBaseModel alloc] init];
            [self payWithBaseModelInfo:model];
        } else if (cell == self->_statementCell) {
            LSJWebViewController *webVC = [[LSJWebViewController alloc] initWithURL:[NSURL URLWithString:LSJ_STATEMENT_URL]];
            webVC.title = @"免责声明";
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (cell == self->_protocolCell) {
            LSJWebViewController *webVC = [[LSJWebViewController alloc] initWithURL:[NSURL URLWithString:LSJ_PROTOCOL_URL]];
            webVC.title = @"用户协议";
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (cell == self->_telCell) {
            [UIAlertView bk_showAlertViewWithTitle:nil message:@"4006296682" cancelButtonTitle:@"取消" otherButtonTitles:@[@"呼叫"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006296682"]];
                }
            }];
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initCells {
    NSUInteger section = 0;
    
    _bannerCell = [[LSJBannerVipCell alloc] init];
    _bannerCell.accessoryType = UITableViewCellAccessoryNone;
    _bannerCell.bgUrl = [LSJSystemConfigModel sharedModel].mineImgUrl;
    [self setLayoutCell:_bannerCell cellHeight:kScreenWidth*0.4 inRow:0 andSection:section++];
    
//    [self setHeaderHeight:10 inSection:section];
    
    _statementCell = [[LSJTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_statement"] title:@"免责声明"];
    _statementCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _statementCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self setLayoutCell:_statementCell cellHeight:44 inRow:0 andSection:section];
    
    _protocolCell = [[LSJTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_protocol"] title:@"用户协议"];
    _protocolCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _protocolCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self setLayoutCell:_protocolCell cellHeight:44 inRow:1 andSection:section];
    
//    UITableViewCell *lineCell = [[UITableViewCell alloc] init];
//    lineCell.backgroundColor = [UIColor colorWithHexString:@"#575757"];
//    [self setLayoutCell:lineCell cellHeight:0.5 inRow:0 andSection:section++];
    
//    if ([LSJUtil isVip]) {
        _telCell = [[LSJTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_tel"] title:@"客服热线"];
        _telCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _telCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self setLayoutCell:_telCell cellHeight:44 inRow:2 andSection:section];
//    }
    
    [self.layoutTableView reloadData];
    [self.layoutTableView LSJ_endPullToRefresh];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[LSJUtil currentSubTabPageIndex] forSlideCount:1];
}



@end
