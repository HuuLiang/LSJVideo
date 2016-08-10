//
//  UIScrollView+Refresh.m
//  LSJVideo
//
//  Created by Liang on 16/6/24.
//  Copyright (c) 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (Refresh)

- (void)LSJ_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)LSJ_triggerPullToRefresh;
- (void)LSJ_endPullToRefresh;

- (void)LSJ_addPagingRefreshWithHandler:(void (^)(void))handler;
- (void)LSJ_pagingRefreshNoMoreData;

- (void)LSJ_addIsRefreshing;

- (void)LSJ_addVIPNotiRefreshWithHandler:(void (^)(void))handler;

@end
