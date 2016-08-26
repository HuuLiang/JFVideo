//
//  JFPaymentPopView.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentPopView.h"
#import "JFPaymentTypeCell.h"
#import "JFSystemConfigModel.h"
#import "JFPayTypeView.h"

//static const CGFloat kHeaderImageScale = 620./280.;

#define kPaymentCellHeight MIN(kScreenHeight * 0.15, 80)
#define kPayPointTypeCellHeight MIN(kScreenHeight * 0.1, 60)



@interface JFPaymentPopView () <UITableViewSeparatorDelegate, UITableViewDataSource>
{
    UITableViewCell *_headerCell;
    UITableViewCell *_paypointTypeCell;
    JFPaymentTypeCell *_alipayCell;
    JFPaymentTypeCell *_wxpayCell;
    JFPaymentTypeCell *_iAppPayCell;
    JFPaymentTypeCell *_qqpayCell;
    NSIndexPath *_selectedIndexPath;
    JFPayTypeView *_payTypeView;
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
        self.layer.cornerRadius = lround(kScreenWidth*0.04);
        self.layer.masksToBounds = YES;
        [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    }
    return self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//SectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == PaymentTypeSection) {
//        return _availablePaymentTypes.count;
//    } else {
//        return 1;
//    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HeaderSection) {
        if (!_headerCell) {
            _headerCell = [[UITableViewCell alloc] init];
            _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView * bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_bgimg"]];
            _headerCell.backgroundView = bgImgV;
            
            UIButton *closeButton = [[UIButton alloc] init];
            closeButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            [closeButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
            [_headerCell addSubview:closeButton];
            
            UILabel * _priceLabel = [[UILabel alloc] init];
            _priceLabel.text = [NSString stringWithFormat:@"%ld",(long)[JFSystemConfigModel sharedModel].payAmount/100];
            _priceLabel.textAlignment = NSTextAlignmentCenter;
            _priceLabel.textColor = [UIColor colorWithHexString:@"#eaff00"];
            _priceLabel.font = [UIFont systemFontOfSize:kWidth(32)];
            [_headerCell addSubview:_priceLabel];
            
            _payTypeView = [[JFPayTypeView alloc] initWithPayTypesArray:_availablePaymentTypes];
            [_headerCell addSubview:_payTypeView];
            

            
            
            {
                [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(_headerCell).offset(10);
                    make.top.equalTo(_headerCell).offset(-10);
                    make.size.mas_equalTo(CGSizeMake(50, 50));
                }];
                
                [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_headerCell).offset(kWidth(295));
                    make.top.equalTo(_headerCell.mas_top).offset(kWidth(555));
                    make.height.mas_equalTo(27);
                }];
                
                [_payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(_headerCell);
                    make.height.mas_equalTo(kWidth(100));
                    make.bottom.equalTo(_headerCell.mas_bottom).offset(-kWidth(90));
                }];

            }
            
            @weakify(self);
            _payTypeView.payAction = ^(JFPaymentType type,JFSubPayType subType) {
                @strongify(self);
                self.paymentAction(type,subType);
            };
            
            
            [closeButton bk_addEventHandler:^(id sender) {
                @strongify(self);
                if (self.closeAction) {
                    self.closeAction(self);
                }
            } forControlEvents:UIControlEventTouchUpInside];
        }
        return _headerCell;
    }
//    }  else if (indexPath.section == PaymentTypeSection) {
//        @weakify(self);
//        for (NSInteger i  = 0; i < _availablePaymentTypes.count; i++) {
//            NSDictionary *dict = _availablePaymentTypes[i];
//            JFPaymentType type = [dict[@"type"] integerValue];
//            JFSubPayType subType = [dict[@"subType"] integerValue];
//            if (indexPath.row == i) {
//                
//                JFPaymentTypeCell *cell = [[JFPaymentTypeCell alloc]initWithPaymentType:type subType:subType];
//                cell.selectionAction = ^(JFPaymentType paymentType){
//                    @strongify(self);
//                    [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//                };
//                
//                return cell;
//            }
//        }
//    } else if (indexPath.section == PaySection) {
//        UITableViewCell * _payCell = [[UITableViewCell alloc] init];
//        _payCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        _payCell.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
//        
//        UIButton *_payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
//        _payBtn.titleLabel.font = [UIFont systemFontOfSize:16.];
//        [_payBtn setTintColor:[UIColor colorWithHexString:@"#ffffff"]];
//        _payBtn.backgroundColor = [UIColor colorWithHexString:@"#ff680d"];
//        _payBtn.layer.cornerRadius = kScreenHeight * 10 / 1334.;
//        _payBtn.layer.masksToBounds = YES;
//        [_payCell addSubview:_payBtn];
//        @weakify(self);
//        [_payBtn bk_addEventHandler:^(id sender) {
//            @strongify(self);
//            JFPaymentTypeCell * cell = [self cellForRowAtIndexPath:[self indexPathForSelectedRow]];
//            if (_paymentAction) {
//                 _paymentAction(cell.payType,cell.subType);
//            }
//           
//        } forControlEvents:UIControlEventTouchUpInside];
//        
//        {
//            [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(_payCell);
//                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 440 / 750., kScreenHeight * 78 / 1334.));
//            }];
//        }
//        return _payCell;
//    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return kWidth(898);
}

@end
