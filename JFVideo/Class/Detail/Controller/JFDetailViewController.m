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


@interface JFDetailViewController () <UITableViewSeparatorDelegate,UITableViewDataSource>
{
    NSInteger _programId;
    NSInteger _columnId;
    
    JFBannerCell *_bannerCell;
    UITableViewCell *_scrollCell;
    JFCommentCell *_commentCell;
    
}
@property (nonatomic) JFDetailModel *detailModel;
@property (nonatomic) JFDetailModelResponse *response;
@end

@implementation JFDetailViewController
DefineLazyPropertyInitialization(JFDetailModel,detailModel)
DefineLazyPropertyInitialization(JFDetailModelResponse, response)


- (instancetype)initWithColumnId:(NSInteger)columnId ProgramId:(NSInteger)programId
{
    self = [super init];
    if (self) {
        _columnId = columnId;
        _programId = programId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#464646"];
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
//        if (cell == self->_bannerCell) {
//            [self playVideo];
//        } else if (cell == self->_videoCell) {
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
    [self.detailModel fetchProgramDetailWithColumnId:_columnId
                                             ProgramId:_programId
                                     CompletionHandler:^(BOOL success, id obj) {
        if (success) {
            self.response = obj;
            [self.layoutTableView JF_endPullToRefresh];
            [self reloadUI];
        }
    }];
}

- (void)reloadUI {
    [self removeAllLayoutCells];
    
    NSUInteger section = 0;
    
    [self initBannerCell:section++];
    if (self.response.programUrlList.count > 0) {
        [self initScrollCell:section++];
    }
    if (self.response.commentJson.count > 0) {
        [self initCommentTitleCell:section++];
        [self initCommentCell:section++];
    }

    [self.layoutTableView reloadData];
}

- (void)initBannerCell:(NSUInteger)section {
    _bannerCell = [[JFBannerCell alloc] init];
    JFDetailProgramModel *program = self.response.program;
    _bannerCell.bgImgUrl = program.detailsCoverImg;
    _bannerCell.title = program.title;
    _bannerCell.num = [program.spare integerValue];

    [self setLayoutCell:_bannerCell cellHeight:SCREEN_WIDTH*0.6+60 inRow:0 andSection:section];
}

- (void)playVideo {
    
}

- (void)initScrollCell:(NSUInteger)section {
    _scrollCell = [[UITableViewCell alloc] init];
    _scrollCell.backgroundColor = [UIColor redColor];


    [self setLayoutCell:_scrollCell cellHeight:150 inRow:0 andSection:section];
}

- (void)initCommentTitleCell:(NSUInteger)section {
    UITableViewCell *_commentTitleCell = [[UITableViewCell alloc] init];
    _commentTitleCell.backgroundColor = [UIColor clearColor];
    _commentTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *_titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"热门评论";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#ec5382"];
    _titleLabel.font = [UIFont systemFontOfSize:16.];
    [_commentTitleCell.contentView addSubview:_titleLabel];
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_commentTitleCell.contentView);
            make.left.equalTo(_commentTitleCell.mas_left).offset(10);
            make.height.mas_equalTo(20);
        }];
    }
    [self setLayoutCell:_commentTitleCell cellHeight:30 inRow:0 andSection:section];
}

- (void)initCommentCell:(NSUInteger)section {
    for (NSInteger i = 0; i < self.response.commentJson.count; i++) {
        JFDetailCommentModel *comment = self.response.commentJson[i];
        CGFloat height = [comment.content sizeWithFont:[UIFont systemFontOfSize:16.] maxSize:CGSizeMake(SCREEN_WIDTH - 69, MAXFLOAT)].height;
        _commentCell = [[JFCommentCell alloc] initWithHeight:height];
        DLog(@"%f",height);
        _commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _commentCell.userImgUrl = comment.icon;
        _commentCell.userNameStr = comment.userName;
        _commentCell.commentStr = comment.content;
        _commentCell.timeStr = comment.createAt;
        if (i == self.response.commentJson.count - 1) {
            [self setLayoutCell:_commentCell cellHeight:height+80 inRow:0 andSection:section++];
        } else {
            [self setLayoutCell:_commentCell cellHeight:height+60 inRow:0 andSection:section++];
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor colorWithHexString:@"#464646"];
            UIImageView *imgV = [[UIImageView alloc] init];
            imgV.backgroundColor = [UIColor colorWithHexString:@"#575757"];
            [cell addSubview:imgV];
            {
                [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(cell);
                    make.left.equalTo(cell.mas_left).offset(0);
                    make.right.equalTo(cell.mas_right).offset(0);
                }];
            }
            [self setLayoutCell:cell cellHeight:0.5 inRow:0 andSection:section++];

        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
