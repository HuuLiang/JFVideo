//
//  JFPaymentViewController.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentViewController.h"
#import "JFPaymentPopView.h"
#import <QBPayment/QBPaymentManager.h>
#import "JFSystemConfigModel.h"

@interface JFPaymentViewController ()
@property (nonatomic) JFPaymentPopView *popView;
@property (nonatomic,copy) dispatch_block_t completionHandler;
@property (nonatomic) JFBaseModel *baseModel;
@end

@implementation JFPaymentViewController
QBDefineLazyPropertyInitialization(JFBaseModel, baseModel)

+ (instancetype)sharedPaymentVC {
    static JFPaymentViewController *_sharedPaymentVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPaymentVC = [[JFPaymentViewController alloc] init];
    });
    return _sharedPaymentVC;
}

- (JFPaymentPopView *)popView {
    if (_popView) {
        return _popView;
    }
    
    NSMutableArray *availablePaymentTypes = [NSMutableArray array];
    
//    DLog("%@",[QBPaymentConfig sharedConfig]);
    
    QBPayType wechatPaymentType = [[QBPaymentManager sharedManager] wechatPaymentType];
    if (wechatPaymentType != QBPayTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(wechatPaymentType),@"subType" : @(QBPaySubTypeWeChat)}];
    }
    
    QBPayType alipayPaymentType = [[QBPaymentManager sharedManager] alipayPaymentType];
    if (alipayPaymentType != QBPayTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(alipayPaymentType),@"subType" : @(QBPaySubTypeAlipay)}];
    }
    
    QBPayType qqPaymentType = [[QBPaymentManager sharedManager] qqPaymentType];
    if (qqPaymentType != QBPayTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(qqPaymentType),@"subType" : @(QBPaySubTypeQQ)}];
        
    }

//    JFPaymentType cardPaymentType = [[JFPaymentManager sharedManager] cardPayPaymentType];
//    if (cardPaymentType != JFPaymentTypeNone) {
//        [availablePaymentTypes addObject:@{@"type" : @(JFPaymentTypeIAppPay),@"subType" : @(JFSubPayTypeNone)}];
//    }
    
    
    _popView = [[JFPaymentPopView alloc] initWithAvailablePaymentTypes:availablePaymentTypes];
    @weakify(self);
    _popView.paymentAction = ^(QBPayType payType,QBPaySubType subType, JFPayPriceLevel priceLevel) {
        @strongify(self);
        
        [self payForPaymentType:payType subPaymentType:subType priceLevel:priceLevel];
//        if (subPayType == JFPaymentTypeWeChatPay) {
//            [self payForPaymentType:wechatPaymentType subPaymentType:subPayType];
//        } else if (subPayType == JFPaymentTypeAlipay) {
//            [self payForPaymentType:alipayPaymentType subPaymentType:subPayType];
//        }else {
//            [self payForPaymentType:cardPaymentType subPaymentType:JFPaymentTypeNone];
//        }
        
        [self hidePayment];
    };
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hidePayment];
        [[JFStatsManager sharedManager] statsPayWithOrderNo:nil payAction:JFStatsPayActionClose payResult:QBPayResultUnknown forBaseModel:self.baseModel programLocation:NSNotFound andTabIndex:[JFUtil currentTabPageIndex] subTabIndex:[JFUtil currentSubTabPageIndex]];
        
    };
    return _popView;
}

- (void)payForPaymentType:(QBPayType)paymentType subPaymentType:(QBPaySubType)subPaymentType priceLevel:(JFPayPriceLevel)priceLevel {

    
    ///
    
    QBPaymentInfo *paymentInfo = [self createPaymentInfoWithPaymentType:paymentType subPaymentType:subPaymentType price:priceLevel];

    [[QBPaymentManager sharedManager] startPaymentWithPaymentInfo:paymentInfo completionHandler:^(QBPayResult payResult, QBPaymentInfo *paymentInfo) {
        
        [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
        
    }];
    
//    QBPaymentInfo *paymentInfo = [[QBPaymentManager sharedManager] startPaymentWithType:paymentType
//                                                                                subType:subPaymentType
//                                                                                  price:price
//                                                                              baseModel:self.baseModel
//                                                                      completionHandler:^(PAYRESULT payResult, JFPaymentInfo *paymentInfo)
//                                  {
//                                      [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
//                                      
//                                  }];
//    
//    DLog("%@",paymentInfo);
    if (paymentInfo) {
        [[JFStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:JFStatsPayActionGoToPay andTabIndex:[JFUtil currentTabPageIndex] subTabIndex:[JFUtil currentSubTabPageIndex]];
    }
    
}

- (QBPaymentInfo *)createPaymentInfoWithPaymentType:(QBPayType)payType subPaymentType:(QBPaySubType)subPayType price:(JFPayPriceLevel)priceLevel {
    NSUInteger price = 0;
    if (priceLevel == JFPayPriceLevelA) {
        price = [JFSystemConfigModel sharedModel].payAmount;
    } else if (priceLevel == JFPayPriceLevelB) {
        price = [JFSystemConfigModel sharedModel].payAmountPlus;
    } else if (priceLevel == JFPayPriceLevelC) {
        price = [JFSystemConfigModel sharedModel].payAmountPlus;
    }
//    price = 200;
    NSString *channelNo = JF_CHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    
    QBPaymentInfo *paymentInfo = [[QBPaymentInfo alloc] init];
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = price;
    paymentInfo.contentId = self.baseModel.programId;
    paymentInfo.contentType = self.baseModel.programType;
    paymentInfo.contentLocation = @(self.baseModel.programLocation + 1);
    paymentInfo.columnId = self.baseModel.realColumnId;
    paymentInfo.columnType = self.baseModel.channelType;
    paymentInfo.payPointType = priceLevel;
    paymentInfo.paymentTime = [JFUtil currentTimeString];
    paymentInfo.paymentType = payType;
    paymentInfo.paymentSubType = subPayType;
    paymentInfo.paymentResult = QBPayResultUnknown;
    paymentInfo.paymentStatus = QBPayStatusPaying;
    paymentInfo.reservedData = [JFUtil paymentReservedData];
    paymentInfo.orderDescription = @"VIP";
    paymentInfo.userId = [JFUtil userId];
    
    return paymentInfo;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popupPaymentInView:(UIView *)view
                 baseModel:(JFBaseModel *)model
     withCompletionHandler:(void (^)(void))completionHandler
{
    [self.view beginLoading];
    self.completionHandler = completionHandler;
    self.baseModel = model;
    
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    self.view.frame = view.bounds;
    self.view.alpha = 0;
    
    UIView *hudView = [CRKHudManager manager].hudView;
    if (view == [UIApplication sharedApplication].keyWindow) {
        [view insertSubview:self.view belowSubview:hudView];
    } else {
        [view addSubview:self.view];
    }
    
    [self.view addSubview:self.popView];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:PaymentTypeSection];
    [self.popView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    {
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            
            const CGFloat width = kWidth(600);
            CGFloat height = kWidth(780);
            make.size.mas_equalTo(CGSizeMake(width,height));
        }];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)hidePayment {
    [self.view endLoading];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        
        if (self.completionHandler) {
            self.completionHandler();
            self.completionHandler = nil;
        }
        
        self.baseModel = nil;
        
    }];
}

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo {
//    
//    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
//    [dateFormmater setDateFormat:@"yyyyMMddHHmmss"];
//    
//    paymentInfo.paymentResult = result;
//    paymentInfo.paymentStatus = QBPayStatusNotProcessed;
//    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
//    [paymentInfo save];
    
    if (result == QBPayResultSuccess) {
        [JFUtil registerVip];
        [self hidePayment];
        [[CRKHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:paymentInfo];
        
        // [self.popView reloadData];
    } else if (result == QBPayResultCancelled) {
        [[CRKHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[CRKHudManager manager] showHudWithText:@"支付失败"];
    }
    
//    BOOL success = [self.commitModel commitPaymentInfo:paymentInfo];
//    if (success) {
//        QBLog(@"支付订单同步成功");
//    }
    
    
    [[JFStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
                                               forPayAction:JFStatsPayActionPayBack
                                                andTabIndex:[JFUtil currentTabPageIndex]
                                                subTabIndex:[JFUtil currentSubTabPageIndex]];
}



@end
