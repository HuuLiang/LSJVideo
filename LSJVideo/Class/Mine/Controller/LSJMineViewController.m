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
#import "LSJAppSpreadBannerModel.h"
#import "LSJMineAppCell.h"
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
        } else if (cell == self->_protocolCell) {
            LSJWebViewController *webVC = [[LSJWebViewController alloc] initWithURL:[NSURL URLWithString:LSJ_PROTOCOL_URL]];
            webVC.title = @"用户协议";
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (cell == self->_telCell) {
            [self contactCustomerService];
        }
    };
    
    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
        NSString *baseURLString = [LSJ_BASE_URL stringByReplacingCharactersInRange:NSMakeRange(0, LSJ_BASE_URL.length-6) withString:@"******"];
        [[CRKHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@\npV:%@/%@", baseURLString, LSJ_CHANNEL_NO, LSJ_PACKAGE_CERTIFICATE, LSJ_REST_PV, LSJ_PAYMENT_PV]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:kPaidNotificationName object:nil];
}

- (void)refreshView {
    [self.layoutTableView LSJ_triggerPullToRefresh];
}

- (void)contactCustomerService {
    NSString *contactScheme = [LSJSystemConfigModel sharedModel].contactScheme;
    NSString *contactName = [LSJSystemConfigModel sharedModel].contacName;
    
    if (contactScheme.length == 0) {
        return ;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:[NSString stringWithFormat:@"是否联系客服%@？", contactName ?: @""]
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确认"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactScheme]];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initCells {
    [self removeAllLayoutCells];
    
    NSUInteger section = 0;
    
    _bannerCell = [[LSJBannerVipCell alloc] init];
    _bannerCell.accessoryType = UITableViewCellAccessoryNone;
    _bannerCell.bgUrl = [LSJSystemConfigModel sharedModel].mineImgUrl;
    
    @weakify(self);
    _bannerCell.action = ^ {
        @strongify(self);
        LSJBaseModel *model = [[LSJBaseModel alloc] init];
        [self payWithBaseModelInfo:model];
    };
    
    [self setLayoutCell:_bannerCell cellHeight:kScreenWidth*0.4 inRow:0 andSection:section++];

    
    _protocolCell = [[LSJTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_protocol"] title:@"用户协议"];
    _protocolCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _protocolCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self setLayoutCell:_protocolCell cellHeight:44 inRow:0 andSection:section++];

    
    if ([LSJUtil isVip]) {
        _telCell = [[LSJTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_tel"] title:@"客服热线"];
        _telCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _telCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self setLayoutCell:_telCell cellHeight:44 inRow:1 andSection:section];
    }
    
    if ([LSJAppSpreadBannerModel sharedModel].fetchedSpreads.count > 0) {
        for (LSJProgramModel *program in [LSJAppSpreadBannerModel sharedModel].fetchedSpreads) {
            LSJMineAppCell *appCell = [[LSJMineAppCell alloc] init];
            appCell.imgUrl = program.spare;
            [LSJUtil checkAppInstalledWithBundleId:program.specialDesc completionHandler:^(BOOL isInstalled) {
                appCell.isInstalled = isInstalled;
            }];
            [self setLayoutCell:appCell cellHeight:kScreenWidth/5+kWidth(10) inRow:0 andSection:section++];
            
            [appCell bk_whenTapped:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:program.videoUrl]];
            }];
        }
        
    }
    
    [self.layoutTableView reloadData];
    [self.layoutTableView LSJ_endPullToRefresh];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[LSJUtil currentSubTabPageIndex] forSlideCount:1];
}



@end
