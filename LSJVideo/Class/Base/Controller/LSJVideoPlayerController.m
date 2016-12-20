//
//  LSJVideoViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJVideoPlayerController.h"
#import "LSJVideoPlayer.h"
//#import "LSJVideoTokenManager.h"

@interface LSJVideoPlayerController ()
{
    LSJVideoPlayer *_videoPlayer;
    UIButton *_closeButton;
}
@end

@implementation LSJVideoPlayerController

- (instancetype)initWithVideo:(NSString *)videoUrl {
    self = [self init];
    if (self) {
        _videoUrl = videoUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
//    _videoPlayer = [[LSJVideoPlayer alloc] initWithVideoURL:[NSURL URLWithString:_videoUrl]];
//    @weakify(self);
//    _videoPlayer.endPlayAction = ^(id sender) {
//        @strongify(self);
//        [self dismissAndPopPayment];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    };
//    [self.view addSubview:_videoPlayer];
//    {
//        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
//    }
//    
//    [_videoPlayer startToPlay];
    
    @weakify(self);
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"video_close"] forState:UIControlStateNormal];
    [self.view addSubview:_closeButton];
    {
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.view).offset(30);
        }];
    }
    
    [_closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self->_videoPlayer pause];
        
        [self dismissAndPopPayment];
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view beginProgressingWithTitle:@"加载中..." subtitle:nil];
    
//    [[LSJVideoTokenManager sharedManager] requestTokenWithCompletionHandler:^(BOOL success, NSString *token, NSString *userId) {
//        @strongify(self);
//        if (!self) {
//            return ;
//        }
//        [self.view endProgressing];
//        
//        if (success) {
//            [self loadVideo:[NSURL URLWithString:[[LSJVideoTokenManager sharedManager]videoLinkWithOriginalLink:_videoUrl]]];
//        } else {
//            [UIAlertView bk_showAlertViewWithTitle:@"无法获取视频信息" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                @strongify(self);
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//        }
//    }];
     [self loadVideo:[NSURL URLWithString:[LSJUtil encodeVideoUrlWithVideoUrlStr:self.videoUrl]]];
    
}

- (void)loadVideo:(NSURL *)videoUrl {
    
    _videoPlayer = [[LSJVideoPlayer alloc] initWithVideoURL:videoUrl];
    [self.view insertSubview:_videoPlayer atIndex:0];
    {
        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    @weakify(self);
    _videoPlayer.endPlayAction = ^(id obj) {
        @strongify(self);
        [self dismissAndPopPayment];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
//#ifdef YYK_DISPLAY_VIDEO_URL
//    NSString *url = videoUrl.absoluteString;
//    [UIAlertView bk_showAlertViewWithTitle:@"视频链接" message:url cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
//#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_videoPlayer startToPlay];
}
- (void)dismissAndPopPayment {
    if ([LSJUtil isVip]) {
        return;
    }
    [self payWithBaseModelInfo:self.baseModel];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
@end
