//
//  JFHomeViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFHomeViewController.h"
#import <SDCycleScrollView.h>

#import "JFHomeModel.h"
#import "JFHomeColumnModel.h"
#import "JFHomeProgramModel.h"

#import "JFHomeSectionHeaderView.h"
#import "JFHomeCell.h"
#import "JFHomeHotCell.h"

#import "JFDetailViewController.h"

static NSString *const kHomeCellReusableIdentifier = @"HomeCellReusableIdentifier";
static NSString *const kHomeHotCellReusableIdentifier = @"HomeHotCellReusableIdentifier";
static NSString *const kBannerCellReusableIdentifier = @"BannerCellReusableIdentifier";
static NSString *const kHomeSectionHeaderReusableIdentifier = @"HomeSectionHeaderReusableIdentifier";

@interface JFHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    UICollectionViewCell *_bannerCell;
    SDCycleScrollView *_bannerView;
    NSInteger _page;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic ,retain) JFHomeModel *homeModel;
@end

@implementation JFHomeViewController
DefineLazyPropertyInitialization(JFHomeModel, homeModel)
DefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.titleLabelBackgroundColor = [UIColor clearColor];
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = layout.minimumLineSpacing;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[JFHomeCell class] forCellWithReuseIdentifier:kHomeCellReusableIdentifier];
    [_layoutCollectionView registerClass:[JFHomeHotCell class] forCellWithReuseIdentifier:kHomeHotCellReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kBannerCellReusableIdentifier];
    [_layoutCollectionView registerClass:[JFHomeSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeSectionHeaderReusableIdentifier];
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
    [self.homeModel fetchHomeInfoWithPage:_page CompletionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        [_layoutCollectionView JF_endPullToRefresh];
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [self refreshBannerView];
            [_layoutCollectionView reloadData];
        }
    }];
}

- (void)refreshBannerView {
    NSMutableArray *imageUrlGroup = [NSMutableArray array];
    NSMutableArray *titlesGroup = [NSMutableArray array];
    
    for (JFHomeColumnModel *column in self.dataSource) {
        if (column.type == 4) {
            for (JFHomeProgramModel *program in column.programList) {
                [imageUrlGroup addObject:program.coverImg];
                [titlesGroup addObject:program.title];
            }
            _bannerView.imageURLStringsGroup = imageUrlGroup;
            _bannerView.titlesGroup = titlesGroup;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JFHomeColumnModel *column = self.dataSource[section];
    if (column.type == 4) {
        return 1;
    } else {
        return column.programList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellReusableIdentifier forIndexPath:indexPath];
    JFHomeHotCell *hotCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeHotCellReusableIdentifier forIndexPath:indexPath];
    
    JFHomeColumnModel *column = _dataSource[indexPath.section];
    JFHomeProgramModel *program = column.programList[indexPath.item];
    
    if (column.type == 4) {
        if (!_bannerCell) {
            _bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellReusableIdentifier forIndexPath:indexPath];
            [_bannerCell.contentView addSubview:_bannerView];
            {
                [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_bannerCell.contentView);
                }];
            }
        }
        return _bannerCell;
    } else {
        if (indexPath.item < column.programList.count) {
            if (column.type == 5) {
                cell.imgUrl = program.coverImg;
                cell.title = program.title;
                cell.isFree = [program.spec isEqual:@(4)];
                return cell;
            } else if (column.type == 1) {
                hotCell.imgUrl = program.coverImg;
                hotCell.title = program.title;
                hotCell.isFree = [program.spec isEqual:@(4)];
                return hotCell;
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JFHomeSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHomeSectionHeaderReusableIdentifier forIndexPath:indexPath];
    JFHomeColumnModel *column = self.dataSource[indexPath.section];
    if (indexPath.section == 1 || indexPath.section == 2) {
        headerView.titleStr = column.name;
    }    
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JFHomeColumnModel *column = _dataSource[indexPath.section];
    JFHomeProgramModel *program = column.programList[indexPath.item];
    
    JFDetailViewController *detailVC = [[JFDetailViewController alloc] initWithColumnId:column.columnId ProgramId:program.programId];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    if (indexPath.section == 0 && indexPath.item == 0) {
        return CGSizeMake(fullWidth, fullWidth/2);
    } else if (indexPath.section == 1) {
        const CGFloat width = (fullWidth - layout.minimumInteritemSpacing - insets.left - insets.right)/2;
        const CGFloat height = width*0.8;
        return CGSizeMake(width, height);
    } else {
        const CGFloat width = (fullWidth - 2*layout.minimumLineSpacing - insets.left - insets.right)/3;
        const CGFloat height = width * 300 / 227.+30;
        return CGSizeMake(width , height);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 5, 0);
    } else if (section == 1) {
        return UIEdgeInsetsMake(5, 10, 5, 10);
    } else if (section == 2) {
        return UIEdgeInsetsMake(5, 10, 5, 10);
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    return CGSizeMake(CGRectGetWidth(collectionView.bounds)-insets.left-insets.right, 30);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    for (JFHomeColumnModel *column in self.dataSource) {
        if (column.type == 4) {
            JFHomeProgramModel * program = column.programList[index];
            JFDetailViewController *detailVC = [[JFDetailViewController alloc] initWithColumnId:column.columnId ProgramId:program.programId];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}



@end
