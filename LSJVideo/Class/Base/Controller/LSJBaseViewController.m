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
#import "LSJPaymentViewController.h"
#import "LSJVideoPlayerController.h"
#import <AVFoundation/AVPlayer.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LSJVideoTokenManager.h"

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

- (void)pushToDetailVideoWithController:(UIViewController *)VC ColumnId:(NSInteger)columnId program:(LSJProgramModel *)program baseModel:(LSJBaseModel *)baseModel {
    LSJDetailVideoVC *detailVC = [[LSJDetailVideoVC alloc] initWithColumnId:columnId Program:program baseModel:baseModel];
    [VC.navigationController pushViewController:detailVC animated:YES];
}

- (void)playPhotoUrlWithModel:(LSJBaseModel *)model urlArray:(NSArray *)urlArray index:(NSInteger)index {
    if (![LSJUtil isVip]) {
        [UIAlertView bk_showAlertViewWithTitle:@"非VIP用户只能浏览小图哦" message:@"开通VIP,高清大图即刻欣赏" cancelButtonTitle:@"再考虑看看" otherButtonTitles:@[@"立即开通"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //支付弹窗
                [self payWithBaseModelInfo:model];
            }
        }];
    } else {
        _photoBrowseView = [[LSJPhotoBrowseView alloc] initWithUrlsArray:urlArray andIndex:index frame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIViewController *vc = (UIViewController *)[LSJUtil currentVisibleViewController];
        [vc.view addSubview:_photoBrowseView];
        
        @weakify(self);
        _photoBrowseView.closePhotoBrowse = ^ {
            @strongify(self);
            [self->_photoBrowseView removeFromSuperview];
            self->_photoBrowseView = nil;
        };
        
    }
}

- (void)playVideoWithUrl:(NSString *)videoUrlStr baseModel:(LSJBaseModel *)baseModel {
    
    [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:[LSJUtil currentTabPageIndex] subTabIndex:[LSJUtil currentSubTabPageIndex]];
    
    if (![LSJUtil isVip] && baseModel.spec != 4) {
        [self payWithBaseModelInfo:baseModel];
    } else {
        if (baseModel.spec == 4) {
            LSJVideoPlayerController *videoVC = [[LSJVideoPlayerController alloc] initWithVideo:videoUrlStr];
            [self presentViewController:videoVC animated:YES completion:nil];
        } else {
            
            @weakify(self);
            [[LSJVideoTokenManager sharedManager] requestTokenWithCompletionHandler:^(BOOL success, NSString *token, NSString *userId) {
                @strongify(self);
                if (!self) {
                    return ;
                }
                [self.view endProgressing];
                
                [UIAlertView bk_showAlertViewWithTitle:@"视频链接" message:[[LSJVideoTokenManager sharedManager] videoLinkWithOriginalLink:videoUrlStr] cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];

                
                if (success) {
                    UIViewController *videoPlayVC = [self playerVCWithVideo:[[LSJVideoTokenManager sharedManager] videoLinkWithOriginalLink:videoUrlStr]];
                    videoPlayVC.hidesBottomBarWhenPushed = YES;
                    [self presentViewController:videoPlayVC animated:YES completion:nil];
                } else {
                    [UIAlertView bk_showAlertViewWithTitle:@"无法获取视频信息" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }
            }];
//            
//            UIViewController *videoPlayVC = [self playerVCWithVideo:videoUrlStr];
//            videoPlayVC.hidesBottomBarWhenPushed = YES;
//            [self presentViewController:videoPlayVC animated:YES completion:nil];
        }
    }
}

- (UIViewController *)playerVCWithVideo:(NSString *)videoUrl {
    UIViewController *retVC;
    if (NSClassFromString(@"AVPlayerViewController")) {
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
        playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:videoUrl]];
        [playerVC aspect_hookSelector:@selector(viewDidAppear:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo){
                               AVPlayerViewController *thisPlayerVC = [aspectInfo instance];
                               [thisPlayerVC.player play];
                           } error:nil];
        
        retVC = playerVC;
    } else {
        retVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:videoUrl]];
    }
    
    [retVC aspect_hookSelector:@selector(supportedInterfaceOrientations) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskAll;
        [[aspectInfo originalInvocation] setReturnValue:&mask];
    } error:nil];
    
    [retVC aspect_hookSelector:@selector(shouldAutorotate) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        BOOL rotate = YES;
        [[aspectInfo originalInvocation] setReturnValue:&rotate];
    } error:nil];
    return retVC;
}

- (void)payWithBaseModelInfo:(LSJBaseModel *)baseModel {
    [[LSJPaymentViewController sharedPaymentVC] popupPaymentInView:self.view.window baseModel:baseModel withCompletionHandler:nil];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
