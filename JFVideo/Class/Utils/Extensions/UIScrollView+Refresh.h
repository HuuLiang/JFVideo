//
//  UIScrollView+Refresh.m
//  Lulushequ
//
//  Created by Liang on 16/6/4.
//  Copyright (c) 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (Refresh)

- (void)LT_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)LT_triggerPullToRefresh;
- (void)LT_endPullToRefresh;

- (void)LT_addPagingRefreshWithHandler:(void (^)(void))handler;
- (void)LT_pagingRefreshNoMoreData;

@end
