//
//  AppDelegate.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "AppDelegate.h"
#import "LSJTabBarViewController.h"
#import "MobClick.h"
#import "LSJActivateModel.h"
#import "LSJUserAccessModel.h"
#import "LSJSystemConfigModel.h"
#import <QBPaymentManager.h>
#import "QBNetworkingConfiguration.h"

static NSString *const kIappPaySchemeUrl = @"comtiantianyingyuan2016appAliPayUrlScheme";

@interface AppDelegate () <UITabBarControllerDelegate>
@property (nonatomic,retain) UIViewController *rootViewController;
@end

@implementation AppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window                              = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor              = [UIColor whiteColor];
    
    return _window;
}

- (UIViewController *)rootViewController {
    if (_rootViewController) {
        return _rootViewController;
    }
    LSJTabBarViewController *tabBarVC = [[LSJTabBarViewController alloc] init];
    tabBarVC.delegate = self;
    _rootViewController = tabBarVC;
    return _rootViewController;
}

- (void)setupCommonStyles {
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#212121"]];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#ffe100"]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[LSJUtil isIpad] ? 21 : kWidth(36)],
                                                           NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   if (thisVC.navigationController.viewControllers.count > 1) {
                                       thisVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
                                           [thisVC.navigationController popViewControllerAnimated:YES];
                                       }];
                                   }
                                   thisVC.navigationController.navigationBar.translucent = NO;
                               } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(shouldAutorotate)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     BOOL autoRotate = NO;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         autoRotate = [((UINavigationController *)selectedVC).topViewController shouldAutorotate];
                                     } else {
                                         autoRotate = [selectedVC shouldAutorotate];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&autoRotate];
                                 } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(supportedInterfaceOrientations)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     NSUInteger result = 0;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         result = [((UINavigationController *)selectedVC).topViewController supportedInterfaceOrientations];
                                     } else {
                                         result = [selectedVC supportedInterfaceOrientations];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&result];
                                 } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(hidesBottomBarWhenPushed)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo)
     {
         UIViewController *thisVC = [aspectInfo instance];
         BOOL hidesBottomBar = NO;
         if (thisVC.navigationController.viewControllers.count > 1) {
             hidesBottomBar = YES;
         }
         [[aspectInfo originalInvocation] setReturnValue:&hidesBottomBar];
     } error:nil];
    
    [UINavigationController aspect_hookSelector:@selector(preferredStatusBarStyle)
                                    withOptions:AspectPositionInstead
                                     usingBlock:^(id<AspectInfo> aspectInfo){
                                         UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                         [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                                     } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(preferredStatusBarStyle)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                   [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                               } error:nil];
    
    [UIScrollView aspect_hookSelector:@selector(showsVerticalScrollIndicator)
                          withOptions:AspectPositionInstead
                           usingBlock:^(id<AspectInfo> aspectInfo)
     {
         BOOL bShow = NO;
         [[aspectInfo originalInvocation] setReturnValue:&bShow];
     } error:nil];
    
    [UIImageView aspect_hookSelector:@selector(init)
                         withOptions:AspectPositionAfter
                          usingBlock:^(id<AspectInfo> aspectInfo) {
                              UIImageView *thisImgV = [aspectInfo instance];
                              [thisImgV setContentMode:UIViewContentModeScaleAspectFill];
                              thisImgV.clipsToBounds = YES;
                          } error:nil];
}

- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (bundleVersion) {
        [MobClick setAppVersion:bundleVersion];
    }
    [MobClick startWithAppkey:LSJ_UMENG_APP_ID reportPolicy:BATCH channelId:LSJ_CHANNEL_NO];
}
//
//- (void)setupCrashReporter {
//    KSCrashInstallationStandard* installation = [KSCrashInstallationStandard sharedInstance];
//    installation.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://collector.bughd.com/kscrash?key=%@", LSJ_KSCRASH_APP_ID]];
//    [installation install];
//    [installation sendAllReportsWithCompletion:nil];
//}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = LSJ_REST_APPID;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = @([LSJ_REST_PV integerValue]);
    [QBNetworkingConfiguration defaultConfiguration].channelNo = LSJ_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].baseURL = LSJ_BASE_URL;
    
//    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];
    

    
    
    [LSJUtil accumateLaunchSeq];
    [LSJUtil setCurrenthHomenSub:1];
    [self setupCommonStyles];
    
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:LSJ_REST_APPID paymentPv:@([LSJ_PAYMENT_PV integerValue]) channelNo:LSJ_CHANNEL_NO urlScheme:kIappPaySchemeUrl];
    
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^(BOOL reachable) {
        if (reachable && ![LSJSystemConfigModel sharedModel].loaded) {
            [self fetchSystemConfigWithCompletionHandler:nil];
        }
        if (reachable && ![LSJUtil isRegistered]) {
            [[LSJActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
                if (success) {
                    [LSJUtil setRegisteredWithUserId:userId];
                    [[LSJUserAccessModel sharedModel] requestUserAccess];
                }
            }];
        } else {
            [[LSJUserAccessModel sharedModel] requestUserAccess];
        }
        if ([QBNetworkInfo sharedInfo].networkStatus <= QBNetworkStatusNotReachable && (![LSJUtil isRegistered] || ![LSJSystemConfigModel sharedModel].loaded)) {
            [UIAlertView bk_showAlertViewWithTitle:@"很抱歉!" message:@"您的应用未连接到网络,请检查您的网络设置" cancelButtonTitle:@"稍后" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
        }
    };

    
    [self setupMobStatistics];
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
    BOOL requestedSystemConfig = NO;
    //#ifdef JF_IMAGE_TOKEN_ENABLED
    NSString *imageToken = [LSJUtil imageToken];
    if (imageToken) {
        [[SDWebImageManager sharedManager].imageDownloader setValue:imageToken forHTTPHeaderField:@"Referer"];
        self.window.rootViewController = self.rootViewController;
    } else {
        self.window.rootViewController = [[UIViewController alloc] init];
        [self.window makeKeyAndVisible];
        
        [self.window beginProgressingWithTitle:@"更新系统配置..." subtitle:nil];
        
        requestedSystemConfig = [self fetchSystemConfigWithCompletionHandler:^(BOOL success) {
             [self.window endProgressing];
            self.window.rootViewController = self.rootViewController;
        }];
        
//        requestedSystemConfig = [[LSJSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
//            [self.window endProgressing];
//            
//            if (success) {
//                NSString *fetchedToken = [LSJSystemConfigModel sharedModel].imageToken;
//                [LSJUtil setImageToken:fetchedToken];
//                if (fetchedToken) {
//                    [[SDWebImageManager sharedManager].imageDownloader setValue:fetchedToken forHTTPHeaderField:@"Referer"];
//                }
//                
//            }
//            self.window.rootViewController = self.rootViewController;
//            NSUInteger statsTimeInterval = 180;
//            [[LSJStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
//        }];
    }

    if (!requestedSystemConfig) {
        [[LSJSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            if (success) {
                [LSJUtil setImageToken:[LSJSystemConfigModel sharedModel].imageToken];
            }
            NSUInteger statsTimeInterval = 180;
            [[LSJStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        }];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (BOOL)fetchSystemConfigWithCompletionHandler:(void (^)(BOOL success))completionHandler {
    return [[LSJSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSString *fetchedToken = [LSJSystemConfigModel sharedModel].imageToken;
            [LSJUtil setImageToken:fetchedToken];
            if (fetchedToken) {
                [[SDWebImageManager sharedManager].imageDownloader setValue:fetchedToken forHTTPHeaderField:@"Referer"];
            }
            
        }
        
        NSUInteger statsTimeInterval = 180;
        [[LSJStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        
        QBSafelyCallBlock(completionHandler, success);
    }];
}


- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[QBPaymentManager sharedManager] applicationWillEnterForeground:application];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [[LSJStatsManager sharedManager] statsTabIndex:tabBarController.selectedIndex subTabIndex:[LSJUtil currentSubTabPageIndex] forClickCount:1];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 0) {
          [[LSJStatsManager sharedManager] statsStopDurationAtTabIndex:tabBarController.selectedIndex subTabIndex:[LSJUtil gerCurrentHomeSub]];
    }else{
        [[LSJStatsManager sharedManager] statsStopDurationAtTabIndex:tabBarController.selectedIndex subTabIndex:[LSJUtil currentSubTabPageIndex]];
    }
    return YES;
}
@end
