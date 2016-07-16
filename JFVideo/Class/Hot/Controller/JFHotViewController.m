//
//  JFHotViewController.m
//  JFVideo
//
//  Created by Liang on 16/7/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFHotViewController.h"

#import "JFChannelModel.h"
#import "JFChannelColumnModel.h"
#import "JFTitleLabelCell.h"

#define LINESPACING kScreenHeight * 20 / 1334.
#define INTERITEMSPACING kScreenWidth * 23 / 750.
#define EDGINSETS UIEdgeInsetsMake(kScreenHeight * 25 / 1334., kScreenWidth * 30 / 750. , kScreenHeight * 25 / 1334., kScreenWidth * 30 / 750.)

static NSString *const kHotTitleCellReusableIdentifier = @"hottitleCellReusableIdentifier";

@interface JFHotViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_layoutTitleCollectionView;
}
@property (nonatomic) JFChannelModel *channelModel;
@property (nonatomic) NSMutableArray *titleArray;
@property (nonatomic) NSMutableArray *titleWidthArray;
@end

@implementation JFHotViewController
DefineLazyPropertyInitialization(JFChannelModel, channelModel)
DefineLazyPropertyInitialization(NSMutableArray, titleArray)
DefineLazyPropertyInitialization(NSMutableArray, titleWidthArray)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = LINESPACING;
    layout.minimumInteritemSpacing = INTERITEMSPACING;
    
    _layoutTitleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutTitleCollectionView.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    _layoutTitleCollectionView.delegate = self;
    _layoutTitleCollectionView.dataSource = self;
    _layoutTitleCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutTitleCollectionView registerClass:[JFTitleLabelCell class] forCellWithReuseIdentifier:kHotTitleCellReusableIdentifier];
    
    [self.view addSubview:_layoutTitleCollectionView];
    {
        [_layoutTitleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.mas_equalTo(200);
        }];
    }
    
    [_layoutTitleCollectionView JF_addPullToRefreshWithHandler:^{
        [self loadMoreDataWithRefresh:YES];
    }];
//    
//    [_layoutTitleCollectionView JF_addPagingRefreshWithHandler:^{
//        [self loadMoreDataWithRefresh:NO];
//    }];
    
    [_layoutTitleCollectionView JF_triggerPullToRefresh];

}

- (void)loadMoreDataWithRefresh:(BOOL)isRefresh {
    @weakify(self);
    [self.channelModel fetchChannelInfoWithPage:1 CompletionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        [_layoutTitleCollectionView JF_endPullToRefresh];
        if (success) {
            [self.titleArray removeAllObjects];
            [self.titleWidthArray removeAllObjects];
            [self titleItemWidth:obj];
            [self.titleArray addObjectsFromArray:obj];
            [_layoutTitleCollectionView reloadData];
        }
    }];
}

- (void)titleItemWidth:(NSArray *)array {
    CGFloat fullwidth = kScreenWidth - EDGINSETS.left - EDGINSETS.right;
    NSInteger count = 0;
    CGFloat currentWidth = 0;
    CGFloat nextWidth = 0;
    CGFloat rowWidth = fullwidth;
    for (NSInteger i = 0; i < array.count ; i++) {
        JFChannelColumnModel *columnModel = array[i];
        if (i == 0) {
            currentWidth = [columnModel.name sizeWithFont:[UIFont systemFontOfSize:SCREEN_WIDTH*26/750.] maxSize:CGSizeMake(MAXFLOAT, kScreenHeight * 48 / 1334.)].width + 30.;
        } else {
            currentWidth = nextWidth;
        }
        
        if (i + 1 < array.count) {
            columnModel = array[i + 1];
            nextWidth = [columnModel.name sizeWithFont:[UIFont systemFontOfSize:SCREEN_WIDTH*26/750.] maxSize:CGSizeMake(MAXFLOAT, kScreenHeight * 48 / 1334.)].width + 30.;
            if (rowWidth - currentWidth - INTERITEMSPACING >= nextWidth && count < 3) {
                count++;
                rowWidth = rowWidth - currentWidth - INTERITEMSPACING;
                [self.titleWidthArray addObject:@((long)currentWidth)];
            } else {
                count = 0;
                currentWidth = rowWidth;
                [self.titleWidthArray addObject:@((long)currentWidth)];
                rowWidth = kScreenWidth - EDGINSETS.left - EDGINSETS.right;
            }
        } else {
            if (count <= 3 && rowWidth > currentWidth) {
                currentWidth = rowWidth;
                [self.titleWidthArray addObject:@((long)currentWidth)];
            } else {
                [self.titleWidthArray addObject:@((long)currentWidth)];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFTitleLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotTitleCellReusableIdentifier forIndexPath:indexPath];
    
    JFChannelColumnModel *column = self.titleArray[indexPath.item];
    if (indexPath.item < self.titleArray.count) {
        cell.title = column.name;
        
        [cell.titleLabel bk_whenTapped:^{
            
        }];
        return cell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat width = [self.titleWidthArray[indexPath.item] floatValue];
    const CGFloat height = kScreenHeight * 48 / 1334.;
    return CGSizeMake(width , height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return EDGINSETS;
}


@end
