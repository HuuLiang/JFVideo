//
//  JFPaymentViewController.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentViewController.h"
#import "JFPaymentPopView.h"
#import "JFPaymentManager.h"
#import "JFPaymentConfig.h"
#import "JFPaymentModel.h"
#import "JFSystemConfigModel.h"

@interface JFPaymentViewController ()
@property (nonatomic) JFPaymentPopView *popView;
@property (nonatomic,copy) dispatch_block_t completionHandler;
@property (nonatomic) JFBaseModel *baseModel;
@end

@implementation JFPaymentViewController
DefineLazyPropertyInitialization(JFBaseModel, baseModel)

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
    
    DLog("%@",[JFPaymentConfig sharedConfig]);
    
    JFPaymentType wechatPaymentType = [[JFPaymentManager sharedManager] wechatPaymentType];
    if (wechatPaymentType != JFPaymentTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(wechatPaymentType),@"subType" : @(JFSubPayTypeWeChat)}];
    }
    
    JFPaymentType alipayPaymentType = [[JFPaymentManager sharedManager] alipayPaymentType];
    if (alipayPaymentType != JFPaymentTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(alipayPaymentType),@"subType" : @(JFSubPayTypeAlipay)}];
    }
    
    JFPaymentType qqPaymentType = [[JFPaymentManager sharedManager] qqPaymentType];
    if (qqPaymentType != JFPaymentTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(qqPaymentType),@"subType" : @(JFSubPayTypeQQ)}];
        
    }
//    JFPaymentType cardPaymentType = [[JFPaymentManager sharedManager] cardPayPaymentType];
//    if (cardPaymentType != JFPaymentTypeNone) {
//        [availablePaymentTypes addObject:@{@"type" : @(JFPaymentTypeIAppPay),@"subType" : @(JFSubPayTypeNone)}];
//    }
    
    
    _popView = [[JFPaymentPopView alloc] initWithAvailablePaymentTypes:availablePaymentTypes];
    @weakify(self);
    _popView.paymentAction = ^(JFPaymentType payType,JFSubPayType subType) {
        @strongify(self);
        
        [self payForPaymentType:payType subPaymentType:subType];
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
        [[JFStatsManager sharedManager] statsPayWithOrderNo:nil payAction:JFStatsPayActionClose payResult:PAYRESULT_UNKNOWN forBaseModel:self.baseModel programLocation:NSNotFound andTabIndex:[JFUtil currentTabPageIndex] subTabIndex:[JFUtil currentSubTabPageIndex]];
        
    };
    return _popView;
}

- (void)payForPaymentType:(JFPaymentType)paymentType subPaymentType:(JFSubPayType)subPaymentType {
    JFPaymentInfo *paymentInfo = [[JFPaymentManager sharedManager] startPaymentWithType:paymentType
                                                                                subType:subPaymentType
                                                                                  price:[JFSystemConfigModel sharedModel].payAmount
                                                                              baseModel:self.baseModel
                                                                      completionHandler:^(PAYRESULT payResult, JFPaymentInfo *paymentInfo)
                                  {
                                      [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
                                      
                                  }];
    
    DLog("%@",paymentInfo);
    if (paymentInfo) {
        [[JFStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:JFStatsPayActionGoToPay andTabIndex:[JFUtil currentTabPageIndex] subTabIndex:[JFUtil currentSubTabPageIndex]];
    }
    
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
            
            const CGFloat width = kScreenWidth * 580/750.;
            CGFloat height = kScreenHeight * 630 /1334. + (kScreenHeight * 110 / 1334.) * (self.popView.availablePaymentTypes.count - 2.);
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

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(JFPaymentInfo *)paymentInfo {
    
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyyMMddHHmmss"];
    
    paymentInfo.paymentResult = @(result);
    paymentInfo.paymentStatus = @(JFPaymentStatusNotProcessed);
    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
    [paymentInfo save];
    
    if (result == PAYRESULT_SUCCESS) {
        [JFUtil registerVip];
        [self hidePayment];
        [[CRKHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:paymentInfo];
        
        // [self.popView reloadData];
    } else if (result == PAYRESULT_ABANDON) {
        [[CRKHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[CRKHudManager manager] showHudWithText:@"支付失败"];
    }
    
    [[JFPaymentModel sharedModel] commitPaymentInfo:paymentInfo];
    [[JFStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
                                               forPayAction:JFStatsPayActionPayBack
                                                andTabIndex:[JFUtil currentTabPageIndex]
                                                subTabIndex:[JFUtil currentSubTabPageIndex]];
}



@end
