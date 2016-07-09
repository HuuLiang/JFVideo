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
    [availablePaymentTypes addObject:@(TKPaymentTypeWeChatPay)];
    [availablePaymentTypes addObject:@(TKPaymentTypeAlipay)];
    //    if ([TKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.unsignedIntegerValue & TKSubPayTypeWeChat) {
    //        [availablePaymentTypes addObject:@(TKPaymentTypeWeChatPay)];
    //    }
    //    if ([TKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.unsignedIntegerValue & TKSubPayTypeAlipay) {
    //        [availablePaymentTypes addObject:@(TKPaymentTypeAlipay)];
    //    }
    
    
    _popView = [[JFPaymentPopView alloc] initWithAvailablePaymentTypes:availablePaymentTypes];
    @weakify(self);
    _popView.paymentAction = ^(JFPaymentType paymentType) {
        @strongify(self);
        if (paymentType == TKPaymentTypeWeChatPay) {
//            [self payForPaymentType:TKPaymentTypeVIAPay paymentSubType:paymentType paymentUsage:paymentUsage];
        } else if (paymentType == TKPaymentTypeAlipay) {
//            [self payForPaymentType:TKPaymentTypeVIAPay paymentSubType:paymentType paymentUsage:paymentUsage];
        }
        
        [self hidePayment];
    };
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hidePayment];
        
        
    };
    return _popView;
}

- (void)payForPaymentType:(JFPaymentType)paymentType subPaymentType:(JFPaymentType)subPaymentType {
    //    [JFPaymentManager ]
    JFPaymentInfo *paymentInfo = [[JFPaymentManager sharedManager] startPaymentWithType:paymentType
                                                                                subType:subPaymentType
                                                                                  price:3800
                                                                              baseModel:self.baseModel
                                                                      completionHandler:^(PAYRESULT payResult, JFPaymentInfo *paymentInfo)
                                  {
                                      [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
                                      
                                  }];
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
    {
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            
            const CGFloat width = kScreenWidth * 0.85;
            make.size.mas_equalTo(CGSizeMake(width, [self.popView viewHeightRelativeToWidth:width]));
        }];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)hidePayment {
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
//    if (result == PAYRESULT_SUCCESS) {
//        if (paymentInfo.paymentUsage.unsignedIntegerValue == JFPaymentUsageVIP && [JFUtil isVIP]) {
//            return ;
//        }
//        
//        if (paymentInfo.paymentUsage.unsignedIntegerValue == TKPaymentUsageFeatured && [TKUtil isPaidWithFeaturedGallery:paymentInfo.contentId]) {
//            return ;
//        }
//    }
//    
//    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
//    [dateFormmater setDateFormat:@"yyyyMMddHHmmss"];
//    
//    paymentInfo.paymentResult = @(result);
//    paymentInfo.paymentStatus = @(TKPaymentStatusNotProcessed);
//    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
//    [paymentInfo save];
//    
//    if (result == PAYRESULT_SUCCESS) {
//        [self hidePayment];
//        [[TKHudManager manager] showHudWithText:@"支付成功"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:paymentInfo];
//        
//        // [self.popView reloadData];
//    } else if (result == PAYRESULT_ABANDON) {
//        [[TKHudManager manager] showHudWithText:@"支付取消"];
//    } else {
//        [[TKHudManager manager] showHudWithText:@"支付失败"];
//    }
//    
//    [[TKPaymentModel sharedModel] commitPaymentInfo:paymentInfo];
//    [[TKStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
//                                               forPayAction:TKStatsPayActionPayBack
//                                                andTabIndex:[TKUtil currentTabPageIndex]
//                                                subTabIndex:[TKUtil currentSubTabPageIndex]];
//    
    
}



@end
