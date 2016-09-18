//
//  LSJBaseViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJBaseViewController.h"
#import "LSJDetailVideoVC.h"
#import "LSJPhotoBrowseView.h"

@interface LSJBaseViewController ()
{
    LSJPhotoBrowseView *_photoBrowseView;
}
@end

@implementation LSJBaseViewController

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)pushToDetailVideoWithController:(UIViewController *)VC programId:(NSInteger )programId {
    LSJDetailVideoVC *detailVC = [[LSJDetailVideoVC alloc] initWithProgram:programId];
    [VC.navigationController pushViewController:detailVC animated:YES];
}

- (void)playPhotoUrlWithInfo:(LSJBaseModel *)model urlArray:(NSArray *)urlArray index:(NSInteger)index {
    if ([LSJUtil isVip]) {
        [UIAlertView bk_showAlertViewWithTitle:@"非VIP用户只能浏览小图哦" message:@"开通VIP,高清大图即刻欣赏" cancelButtonTitle:@"再考虑看看" otherButtonTitles:@[@"立即开通"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //支付弹窗
            }
        }];
    } else {
        _photoBrowseView = [[LSJPhotoBrowseView alloc] initWithUrlsArray:urlArray andIndex:index];
        UIViewController *vc = (UIViewController *)[LSJUtil currentVisibleViewController];
        [vc.view addSubview:_photoBrowseView];
        {
            [_photoBrowseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(vc.view);
            }];
        }
        
        @weakify(self);
        _photoBrowseView.closePhotoBrowse = ^ {
            @strongify(self);
            [self->_photoBrowseView removeFromSuperview];
            self->_photoBrowseView = nil;
        };
        
    }
}


@end
