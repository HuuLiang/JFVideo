//
//  JFDetailViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFDetailViewController.h"
#import "JFDetailModel.h"

#import "JFBannerCell.h"

@interface JFDetailViewController ()
{
    NSInteger _programId;
    
    JFBannerCell *_bannerCell;
}
@property (nonatomic) JFDetailModel *detailModel;
@end

@implementation JFDetailViewController
DefineLazyPropertyInitialization(JFDetailModel,detailModel)


- (instancetype)initWithProgramId:(NSInteger)programId
{
    self = [super init];
    if (self) {
        _programId = programId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.layoutTableView.hasRowSeparator = YES;
    self.layoutTableView.hasSectionBorder = NO;
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    [self.layoutTableView LT_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadDetail];
    }];
    [self.layoutTableView LT_triggerPullToRefresh];
    
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_bannerCell) {
            [self playVideo];
        } //else if (cell == self->_videoCell) {
//            [self playVideo];
//        } else if (cell == self->_appSpreadCell) {
//            [self downloadApp];
//        } else if (cell == self->_otherProgramCell) {
//            [self gotoOtherProgram];
//        } else if (cell == self->_reportCell) {
//            
//        }
    };

}

- (void)loadDetail {
    [self->_detailModel fetchProgramDetailWithProgramId:_programId
                                      CompletionHandler:^(BOOL success, id obj)
     {
         if (success) {
             [self reloadUI];
         }
    }];
}

- (void)reloadUI {
    [self removeAllLayoutCells];
    
    NSUInteger section = 0;
    
    [self initBannerCell:section++];
}

- (void)initBannerCell:(NSUInteger)section {
    _bannerCell = [[JFBannerCell alloc] initWithHeight:200];
    
    
    
    [self setLayoutCell:_bannerCell cellHeight:200 inRow:0 andSection:section];
}

- (void)playVideo {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
