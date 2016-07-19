//
//  JFChannelListViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelListViewController.h"
#import "JFChannelViewController.h"

#import "JFChannelModel.h"
#import "JFChannelColumnModel.h"
#import "JFChannelCell.h"

static NSString *const kChannelCellReusableIdentifier = @"ChannelCellReusableIdentifier";

@interface JFChannelListViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    NSInteger _page;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) JFChannelModel *channelModel;
@end

@implementation JFChannelListViewController

DefineLazyPropertyInitialization(NSMutableArray, dataSource)
DefineLazyPropertyInitialization(JFChannelModel, channelModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = layout.minimumLineSpacing;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[JFChannelCell class] forCellWithReuseIdentifier:kChannelCellReusableIdentifier];

    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [_layoutCollectionView JF_addPullToRefreshWithHandler:^{
        [self loadMoreDataWithRefresh:YES];
    }];
    
    
    [_layoutCollectionView JF_addPagingRefreshWithHandler:^{
        if ([JFUtil isVip]) {
            [_layoutCollectionView JF_pagingRefreshNoMoreData];
        } else {
            [self payWithInfo:nil];
        }
    }];
    
    [_layoutCollectionView JF_triggerPullToRefresh];
    
}

- (void)loadMoreDataWithRefresh:(BOOL)isRefresh {
    @weakify(self);
    [self.channelModel fetchChannelInfoWithPage:_page CompletionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        [_layoutCollectionView JF_endPullToRefresh];
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [_layoutCollectionView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kChannelCellReusableIdentifier forIndexPath:indexPath];
    
    JFChannelColumnModel *column = self.dataSource[indexPath.item];
    if (indexPath.item < self.dataSource.count) {
        cell.title = column.name;
        cell.imgUrl = column.columnImg;
        return cell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        JFChannelColumnModel *column = self.dataSource[indexPath.item];
        JFChannelViewController *channelVC = [[JFChannelViewController alloc] initWithColumnId:column.columnId];
        [self.navigationController pushViewController:channelVC animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
        UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    const CGFloat width = (fullWidth - layout.minimumLineSpacing - insets.left - insets.right)/2;
    const CGFloat height = width * 300 / 227.+30;
    return CGSizeMake(width , height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
@end
