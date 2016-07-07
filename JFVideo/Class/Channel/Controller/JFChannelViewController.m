//
//  JFChannelViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelViewController.h"
#import "JFChannelProgramModel.h"
#import "JFChannelProgramCell.h"
#import "JFDetailViewController.h"

static NSString *const kChannelProgramCellReusableIdentifier = @"ChannelProgramCellReusableIdentifier";

@interface JFChannelViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _columnId;
    UICollectionView *_layoutCollectionView;
    NSInteger _page;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) JFChannelProgramModel *channelProgramModel;
@end

@implementation JFChannelViewController
DefineLazyPropertyInitialization(NSMutableArray, dataSource)
DefineLazyPropertyInitialization(JFChannelProgramModel, channelProgramModel)

- (instancetype)initWithColumnId:(NSInteger)columnId
{
    self = [super init];
    if (self) {
        _columnId = columnId;
    }
    return self;
}

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
    [_layoutCollectionView registerClass:[JFChannelProgramCell class] forCellWithReuseIdentifier:kChannelProgramCellReusableIdentifier];
    
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
        [self loadMoreDataWithRefresh:NO];
    }];
    
    [_layoutCollectionView JF_triggerPullToRefresh];
    
}

- (void)loadMoreDataWithRefresh:(BOOL)isRefresh {
    @weakify(self);
    [self.channelProgramModel fecthChannelProgramWithColumnId:_columnId Page:_page CompletionHandler:^(BOOL success, NSArray * obj) {
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
    JFChannelProgramCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kChannelProgramCellReusableIdentifier forIndexPath:indexPath];
    
    JFChannelProgram *program = self.dataSource[indexPath.item];
    if (indexPath.item < self.dataSource.count) {
        cell.title = program.title;
        cell.imgUrl = program.coverImg;
        return cell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        JFChannelProgram *program = self.dataSource[indexPath.item];
        JFDetailViewController *detailVC = [[JFDetailViewController alloc] initWithColumnId:_columnId ProgramId:program.programId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    const CGFloat width = (fullWidth - 2*layout.minimumLineSpacing - insets.left - insets.right)/3;
    const CGFloat height = width * 300 / 227.+30;
    return CGSizeMake(width , height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

@end
