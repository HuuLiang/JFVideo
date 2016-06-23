//
//  JFMineViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFMineViewController.h"
#import "JFTableViewCell.h"
#import "JFAppSpreadCell.h"
#import "JFWebViewController.h"

static NSString *const kMoreCellReusableIdentifier = @"MoreCellReusableIdentifier";

@interface JFMineViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    JFTableViewCell *_bannerCell;
    JFTableViewCell *_vipCell;
    JFTableViewCell *_protocolCell;
    JFTableViewCell *_telCell;
    UICollectionView *_appCollectionView;
}
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation JFMineViewController
DefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_vipCell) {
            
        } else if (cell == self->_protocolCell) {
            JFWebViewController *webVC = [[JFWebViewController alloc] initWithURL:[NSURL URLWithString:@""]];
            webVC.title = @"用户协议";
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (cell == self->_telCell) {
            [UIAlertView bk_showAlertViewWithTitle:nil message:@"4006296682" cancelButtonTitle:@"取消" otherButtonTitles:@[@"呼叫"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006296682"]];
                }
            }];
        }
    };
    
    [self initCells];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initCells {
    NSUInteger section = 0;
    
    _bannerCell = [[JFTableViewCell alloc] init];
    _bannerCell.accessoryType = UITableViewCellAccessoryNone;
    _bannerCell.backgroundColor = [UIColor colorWithHexString:@"#464646"];
    _bannerCell.backgroundImageView.image = [UIImage imageNamed:@""];
    [self setLayoutCell:_bannerCell cellHeight:SCREEN_WIDTH*0.4 inRow:0 andSection:section++];
    
    if (![JFUtil isVip]) {
        _vipCell = [[JFTableViewCell alloc] initWithImage:nil title:@"开通VIP"];
        _vipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _vipCell.backgroundColor = [UIColor colorWithHexString:@"#464646"];
        [self setLayoutCell:_vipCell cellHeight:44 inRow:0 andSection:section++];
    }
    
    [self setHeaderHeight:10 inSection:section];
    
    _protocolCell = [[JFTableViewCell alloc] initWithImage:nil title:@"用户协议"];
    _protocolCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _protocolCell.backgroundColor = [UIColor colorWithHexString:@"#464646"];
    [self setLayoutCell:_protocolCell cellHeight:44 inRow:0 andSection:section++];
    
    UITableViewCell *lineCell = [[UITableViewCell alloc] init];
    lineCell.backgroundColor = [UIColor colorWithHexString:@"#575757"];
    [self setLayoutCell:lineCell cellHeight:0.5 inRow:0 andSection:section++];
    
    _telCell = [[JFTableViewCell alloc] initWithImage:nil title:@"客服热线"];
    _telCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _telCell.backgroundColor = [UIColor colorWithHexString:@"#464646"];
    [self setLayoutCell:_telCell cellHeight:44 inRow:0 andSection:section++];
    
    UITableViewCell * _appCell = [[UITableViewCell alloc] init];
    _appCell.backgroundColor = [UIColor blueColor];
    _appCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self createLayout]];
    _appCollectionView.backgroundColor = [UIColor yellowColor];
    _appCollectionView.delegate = self;
    _appCollectionView.dataSource = self;
    _appCollectionView.showsVerticalScrollIndicator = NO;
    [_appCollectionView registerClass:[JFAppSpreadCell class] forCellWithReuseIdentifier:kMoreCellReusableIdentifier];
    [_appCell addSubview:_appCollectionView];
    {
        [_appCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_appCell);
        }];
    }

    [self setLayoutCell:_appCell cellHeight:((SCREEN_WIDTH-50-50)/3+30)*2+30 inRow:0 andSection:section];
}

- (UICollectionViewLayout *)createLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 25;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-50-50)/3, (SCREEN_WIDTH-50-50)/3+30);
    layout.sectionInset = UIEdgeInsetsMake(14, 22.5, 5, 22.5);
    return layout;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFAppSpreadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMoreCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < 6) {
        cell.imgUrl = @"";
        cell.titleStr = @"什么快播";
        cell.isInstall = YES;
//        LTAppSpread *app = self.dataSource[indexPath.item];
//        cell.title = app.title;
//        DLog("%@",app.title);
//        cell.imageURL = app.coverImg;
//        cell.subtitle = @"";
//        cell.isInsatall = app.isInstall;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.dataSource.count;
    return 6;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item < self.dataSource.count) {
//        LTAppSpread *app = self.dataSource[indexPath.item];
//        if (app.isInstall) {
//            return;
//        } else {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.spreadUrl]];
//        }
//        
//    }
}


@end
