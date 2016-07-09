//
//  JFPaymentPopView.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentPopView.h"
#import "JFPaymentTypeCell.h"

static const CGFloat kHeaderImageScale = 620./280.;

#define kPaymentCellHeight MIN(kScreenHeight * 0.15, 80)
#define kPayPointTypeCellHeight MIN(kScreenHeight * 0.1, 60)

typedef NS_ENUM(NSUInteger, TKPaymentPopViewSection) {
    HeaderImageSection,
    PayPointTypeSection,
    PaymentTypeSection,
    SectionCount
};

@interface JFPaymentPopView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableViewCell *_headerImageCell;
    UITableViewCell *_paypointTypeCell;
    JFPaymentTypeCell *_paymentTypeCell;
}
@end

@implementation JFPaymentPopView

- (instancetype)initWithAvailablePaymentTypes:(NSArray *)availablePaymentTypes
{
    self = [super init];
    if (self) {
        _availablePaymentTypes = availablePaymentTypes;
        
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.layer.cornerRadius = lround(kScreenWidth*0.08);
        self.layer.masksToBounds = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    }
    return self;
}

- (CGFloat)viewHeightRelativeToWidth:(CGFloat)width {
    const CGFloat headerImageHeight = width / kHeaderImageScale;
    
    __block CGFloat cellHeights = headerImageHeight;
    NSUInteger numberOfSections = [self numberOfSections];
    for (NSUInteger section = 1; section < numberOfSections; ++section) {
        NSUInteger numberOfItems = [self tableView:self numberOfRowsInSection:section];
        for (NSUInteger item = 0; item < numberOfItems; ++item) {
            CGFloat itemHeight = [self tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:item inSection:section]];
            cellHeights += itemHeight;
        }
    }
    return lround(cellHeights);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HeaderImageSection) {
        if (!_headerImageCell) {
            _headerImageCell = [[UITableViewCell alloc] init];
            _headerImageCell.backgroundView = [[UIImageView alloc] init];
            _headerImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *closeButton = [[UIButton alloc] init];
            closeButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            [closeButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
            [_headerImageCell addSubview:closeButton];
            {
                [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.right.equalTo(_headerImageCell);
                    make.size.mas_equalTo(CGSizeMake(50, 50));
                }];
            }
            
            @weakify(self);
            [closeButton bk_addEventHandler:^(id sender) {
                @strongify(self);
                if (self.closeAction) {
                    self.closeAction(self);
                }
            } forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIImageView *imageView = (UIImageView *)_headerImageCell.backgroundView;
        imageView.image = [UIImage imageNamed:@"tanchaun.jpg"];
        return _headerImageCell;
    } else if (indexPath.section == PayPointTypeSection) {
        _paypointTypeCell = [[UITableViewCell alloc] init];
        _paypointTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"#dc56pe"];
        label.text = @"38元即可享受顶级片源\n抛开烦恼快来爽一爽";
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        [_paypointTypeCell addSubview:label];
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_paypointTypeCell);
                make.left.equalTo(_paypointTypeCell).offset(15);
                make.right.equalTo(_paypointTypeCell).offset(-15);
                make.height.mas_equalTo(80);
            }];
        }
        return _paypointTypeCell;
    } else if (indexPath.section == PaymentTypeSection) {
        if (!_paymentTypeCell) {
            _paymentTypeCell = [[JFPaymentTypeCell alloc] init];
            _paymentTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            @weakify(self);
            _paymentTypeCell.selectionAction = ^(NSUInteger index, id obj) {
                @strongify(self);
                SafelyCallBlock1(self.paymentAction, [[self.availablePaymentTypes objectAtIndex:index] unsignedIntegerValue]);
            };
        }
        _paymentTypeCell.availablePaymentTypes = self.availablePaymentTypes;
        return _paymentTypeCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HeaderImageSection) {
//        DLog("%f",CGRectGetWidth(tableView.bounds) / kHeaderImageScale);
//        DLog(@"%f",self.frame.size.width);
        return CGRectGetWidth(tableView.bounds) / kHeaderImageScale;
    } else if (indexPath.section == PayPointTypeSection) {
        return kPayPointTypeCellHeight;
    } else {
        return kPaymentCellHeight;
    }
}



@end
