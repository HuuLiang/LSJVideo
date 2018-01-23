//
//  UIScrollView+Refresh.m
//  Lulushequ
//
//  Created by Liang on 16/6/4.
//  Copyright (c) 2016年 iqu8. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <MJRefresh.h>

@implementation UIScrollView (Refresh)

- (void)LSJ_addPullToRefreshWithHandler:(void (^)(void))handler {
    if (!self.header) {
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:handler];
        refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        self.header = refreshHeader;
    }
}

- (void)LSJ_triggerPullToRefresh {
    [self.header beginRefreshing];
}

- (void)LSJ_endPullToRefresh {
    [self.header endRefreshing];
    [self.footer resetNoMoreData];
}

- (void)LSJ_addPagingRefreshWithHandler:(void (^)(void))handler {
    if (!self.footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        self.footer = refreshFooter;
    }
}

- (void)LSJ_pagingRefreshNoMoreData {
    [self.footer endRefreshingWithNoMoreData];
}

- (void)LSJ_addIsRefreshing {
    if (!self.header) {
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:nil];
        [refreshHeader setTitle:@"正在刷新中" forState:MJRefreshStateRefreshing];
        self.header = refreshHeader;
    }
}

- (void)LSJ_addVIPNotiRefreshWithHandler:(void (^)(void))handler {
    if (!self.footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        [refreshFooter setTitle:@"点击成为VIP可观看更多" forState:MJRefreshStateIdle];
        self.footer = refreshFooter;
    }
}

@end
