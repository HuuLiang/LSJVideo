//
//  LSJTabBarViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJTabBarViewController.h"
#import "LSJHomeViewController.h"
#import "LSJWelfareViewController.h"
#import "LSJHotViewController.h"
#import "LSJLechersViewController.h"
#import "LSJMineViewController.h"

@interface LSJTabBarViewController ()

@end

@implementation LSJTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LSJHomeViewController *homeVC = [[LSJHomeViewController alloc] initWithTitle:@"首页"];
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:homeVC.title
                                                       image:[UIImage imageNamed:@"tabbar_home_normal"]
                                               selectedImage:[[UIImage imageNamed:@"tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    LSJWelfareViewController *welfareVC = [[LSJWelfareViewController alloc] initWithTitle:@"福利"];
    UINavigationController *welfareNC = [[UINavigationController alloc] initWithRootViewController:welfareVC];
    welfareNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:welfareVC.title
                                                       image:[UIImage imageNamed:@"tabbar_welfare_normal"]
                                               selectedImage:[[UIImage imageNamed:@"tabbar_welfare_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    LSJLechersViewController *lecherVC = [[LSJLechersViewController alloc] initWithTitle:@"狼友圈"];
    UINavigationController *lecherNC = [[UINavigationController alloc] initWithRootViewController:lecherVC];
    lecherNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:lecherVC.title
                                                        image:[UIImage imageNamed:@"tabbar_lecher_normal"]
                                                selectedImage:[[UIImage imageNamed:@"tabbar_lecher_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    LSJHotViewController *hotVC = [[LSJHotViewController alloc] initWithTitle:@"热搜"];
    UINavigationController *hotNC = [[UINavigationController alloc] initWithRootViewController:hotVC];
    hotNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:hotVC.title
                                                         image:[UIImage imageNamed:@"tabbar_hot_normal"]
                                                 selectedImage:[[UIImage imageNamed:@"tabbar_hot_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    LSJMineViewController *mineVC = [[LSJMineViewController alloc] initWithTitle:@"我的"];
    UINavigationController *mineNC = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                       image:[UIImage imageNamed:@"tabbar_mine_normal"]
                                               selectedImage:[[UIImage imageNamed:@"tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    self.viewControllers = @[homeNC,welfareNC,lecherNC,hotNC,mineNC];
    self.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
