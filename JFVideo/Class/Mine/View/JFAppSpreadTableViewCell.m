//
//  JFAppSpreadTableViewCell.m
//  JFVideo
//
//  Created by Liang on 16/6/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFAppSpreadTableViewCell.h"

@interface JFAppSpreadTableViewCell () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_appCollectionView;
}
@end

@implementation JFAppSpreadTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor cyanColor];
        
        _appCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self createLayout]];
        _appCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        _appCollectionView.delegate = self;
        _appCollectionView.dataSource = self;
        _appCollectionView.showsVerticalScrollIndicator = NO;
        [_appCollectionView registerClass:[LTMoreCell class] forCellWithReuseIdentifier:kMoreCellReusableIdentifier];
        [self addSubview:_appCollectionView];
        {
            [_appCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
    }
    return self;
}

- (UICollectionViewLayout *)createLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2, 220);
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    return layout;
}

@end
