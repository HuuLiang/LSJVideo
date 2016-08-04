//
//  UIScrollView+Refresh.m
//  JFVideo
//
//  Created by Liang on 16/6/24.
//  Copyright (c) 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (Refresh)

- (void)JF_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)JF_triggerPullToRefresh;
- (void)JF_endPullToRefresh;

- (void)JF_addPagingRefreshWithHandler:(void (^)(void))handler;
- (void)JF_pagingRefreshNoMoreData;

- (void)JF_addIsRefreshing;

- (void)JF_addVIPNotiRefreshWithHandler:(void (^)(void))handler;

@end
