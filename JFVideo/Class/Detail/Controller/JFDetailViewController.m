//
//  JFDetailViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFDetailViewController.h"
#import <SDCycleScrollView.h>
#import "JFDetailModel.h"

#import "JFBannerCell.h"
#import "JFScrollCell.h"
#import "JFCommentCell.h"

static NSString *const kScrollCellReusableIdentifier = @"ScrollCellReusableIdentifier";


@interface JFDetailViewController ()
{
    NSInteger _programId;
    
    JFBannerCell *_bannerCell;
    UITableViewCell *_scrollCell;
    JFCommentCell *_commentCell;
    
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
    [self.layoutTableView JF_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadDetail];
    }];
    [self.layoutTableView JF_triggerPullToRefresh];
    
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
    [self initScrollCell:section++];
    if (1) {
        [self initCommentTitleCell:section++];
    }
    
    if (1) {
        [self initCommentCell:section++];
    }
    
}

- (void)initBannerCell:(NSUInteger)section {
    _bannerCell = [[JFBannerCell alloc] initWithHeight:200];
    
    
    
    [self setLayoutCell:_bannerCell cellHeight:200 inRow:0 andSection:section];
}

- (void)playVideo {
    
}

- (void)initScrollCell:(NSUInteger)section {
    _scrollCell = [[UITableViewCell alloc] init];

    UITableView *_scrollView = [[UITableView alloc] init];
    _scrollView.hasRowSeparator = NO;
    _scrollView.hasSectionBorder = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.dataSource = self;
    _scrollView.separatorInset = UIEdgeInsetsZero;
    _scrollView.separatorColor = [UIColor colorWithWhite:0.5 alpha:1];
    [_scrollView registerClass:[JFScrollCell class] forCellReuseIdentifier:kScrollCellReusableIdentifier];
    _scrollView.transform = CGAffineTransformMakeRotation(-90.);
    [_scrollCell.contentView addSubview:_scrollView];
    {
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollCell);
        }];
    }
    
    [self setLayoutCell:_scrollCell cellHeight:150 inRow:0 andSection:section];
}

- (void)initCommentTitleCell:(NSUInteger)section {
    UITableViewCell *_commentTitleCell = [[UITableViewCell alloc] init];
    _commentTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *_titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"热门评论";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#ec5382"];
    _titleLabel.font = [UIFont systemFontOfSize:16.];
    [_commentTitleCell.contentView addSubview:_titleLabel];
    
    [self setLayoutCell:_commentTitleCell cellHeight:30 inRow:0 andSection:section];
}

- (void)initCommentCell:(NSUInteger)section {
//    CGFloat height = [comment.content sizeWithFont:[UIFont systemFontOfSize:14.] maxSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)].height;
    _commentCell = [[JFCommentCell alloc] initWithHeight:200];
    _commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [self setLayoutCell:_commentCell cellHeight:200 inRow:0 andSection:section];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:kScrollCellReusableIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH/4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
