//
//  JFMineViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFMineViewController.h"
#import "JFTableViewCell.h"
#import "JFAppSpreadTableViewCell.h"

@interface JFMineViewController ()
{
    JFTableViewCell *_bannerCell;
    JFTableViewCell *_vipCell;
    JFTableViewCell *_protocolCell;
    JFTableViewCell *_telCell;
    JFAppSpreadTableViewCell *_appCell;
}
@end

@implementation JFMineViewController

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
        if (cell == self->_bannerCell) {
            
        } else if (cell == self->_vipCell) {
            
        } else if (cell == self->_protocolCell) {
            
        } else if (cell == self->_telCell) {
            
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
    
    _appCell = [[JFAppSpreadTableViewCell alloc] init];
    [self setLayoutCell:_appCell cellHeight:200 inRow:0 andSection:section];
    
}

@end
