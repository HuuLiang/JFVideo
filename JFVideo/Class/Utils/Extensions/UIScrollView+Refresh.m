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

- (void)LT_addPullToRefreshWithHandler:(void (^)(void))handler {
    if (!self.header) {
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:handler];
        refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        self.header = refreshHeader;
    }
}

- (void)LT_triggerPullToRefresh {
    [self.header beginRefreshing];
}

- (void)LT_endPullToRefresh {
    [self.header endRefreshing];
    [self.footer resetNoMoreData];
}

- (void)LT_addPagingRefreshWithHandler:(void (^)(void))handler {
    if (!self.footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        self.footer = refreshFooter;
    }
}

- (void)LT_pagingRefreshNoMoreData {
    [self.footer endRefreshingWithNoMoreData];
}
@end
