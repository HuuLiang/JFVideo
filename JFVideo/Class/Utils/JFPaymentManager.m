//
//  JFPaymentManager.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentManager.h"
#import "JFPaymentConfigModel.h"
#import "JFBaseModel.h"
#import <PayUtil/PayUtil.h>
#import "IappPayMananger.h"

#import "JFSystemConfigModel.h"
//#import "DXTXPayManager.h"
#import "HTPayManager.h"



typedef NS_ENUM(NSUInteger, JFVIAPayType) {
    JFVIAPayTypeNone,
    JFVIAPayTypeWeChat = 2,
    JFVIAPayTypeQQ = 3,
    JFVIAPayTypeUPPay = 4,
    JFVIAPayTypeShenZhou = 5
};

static NSString *const KAliPaySchemeUrl = @"comjfyingyuanappalipayurlscheme";
static NSString *const kIappPaySchemeUrl = @"comjfyingyuanappiapppayurlscheme";
static NSString *const kDxtxSchemeUrl = @"comjfyingyuanDXTXPayDemoscheme";


@interface JFPaymentManager () <stringDelegate>
@property (nonatomic,retain) JFPaymentInfo *paymentInfo;

@property (nonatomic,copy) JFPaymentCompletionHandler completionHandler;
@end

@implementation JFPaymentManager

+ (instancetype)sharedManager {
    static JFPaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setupWithCompletionHandler:(JFCompletionHandler)handler {
    [[PayUitls getIntents] initSdk];
    [paySender getIntents].delegate = self;
    
    [[JFPaymentConfigModel sharedModel] fetchPaymentConfigInfoWithCompletionHandler:^(BOOL success, id obj) {
        if (success) {
            handler(success,obj);
        }
        
    }];
    [IappPayMananger sharedMananger].alipayURLScheme = kIappPaySchemeUrl;
    
    Class class = NSClassFromString(@"VIASZFViewController");
    if (class) {
        [class aspect_hookSelector:NSSelectorFromString(@"viewWillAppear:")
                       withOptions:AspectPositionAfter
                        usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated)
         {
             UIViewController *thisVC = [aspectInfo instance];
             if ([thisVC respondsToSelector:NSSelectorFromString(@"buy")]) {
                 UIViewController *buyVC = [thisVC valueForKey:@"buy"];
                 [buyVC.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj isKindOfClass:[UIButton class]]) {
                         UIButton *buyButton = (UIButton *)obj;
                         if ([[buyButton titleForState:UIControlStateNormal] isEqualToString:@"购卡支付"]) {
                             [buyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                         }
                     }
                 }];
             }
         } error:nil];
    }
}


- (JFPaymentType)wechatPaymentType {
    return [JFPaymentConfig sharedConfig].wechatPaymentType;
}

- (JFPaymentType)alipayPaymentType {
    return [JFPaymentConfig sharedConfig].alipayPaymentType;
}

- (JFPaymentType)cardPayPaymentType {
    //    if ([JFPaymentConfig sharedConfig].iappPayInfo) {
    //        return JFPaymentTypeIAppPay;
    //    }
    return JFPaymentTypeNone;
}

- (JFPaymentType)qqPaymentType {
    return [JFPaymentConfig sharedConfig].qqPaymentType;
}

- (void)handleOpenUrl:(NSURL *)url {
    if ([url.absoluteString rangeOfString:kIappPaySchemeUrl].location == 0) {
        [[IappPayMananger sharedMananger] handleOpenURL:url];
    } else if ([url.absoluteString rangeOfString:KAliPaySchemeUrl].location == 0) {
        [[PayUitls getIntents] paytoAli:url];
    } else if ([url.absoluteString rangeOfString:kDxtxSchemeUrl].location == 0) {
//        [[DXTXPayManager sharedManager] handleOpenURL:url];
    }
}

- (JFPaymentInfo *)startPaymentWithType:(JFPaymentType)type
                                subType:(JFSubPayType)subType
                                  price:(NSUInteger)price
                              baseModel:(JFBaseModel *)model
                      completionHandler:(JFPaymentCompletionHandler)handler {
    
    NSString *channelNo = JF_CHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
//#if DEBUG
//    if (type == JFPaymentTypeIAppPay) {
//        price = 200;
//    } else {
//        price = 100;
//    }
//#endif
//    price = 200;
    JFPaymentInfo *paymentInfo = [[JFPaymentInfo alloc] init];
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = @(price);
    paymentInfo.contentId = model.programId;
    paymentInfo.contentType = model.programType;
    paymentInfo.contentLocation = @(model.programLocation + 1);
    paymentInfo.columnId = model.realColumnId;
    paymentInfo.columnType = model.channelType;
    paymentInfo.payPointType = @(1);
    paymentInfo.paymentTime = [JFUtil currentTimeString];
    paymentInfo.paymentType = @(type);
    paymentInfo.paymentSubType = @(subType);
    paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
    paymentInfo.paymentStatus = @(JFPaymentStatusPaying);
    paymentInfo.reservedData = [JFUtil paymentReservedData];
    

    if (type == JFPaymentTypeDXTXPay || type == JFPaymentTypeHTPay) {
        NSString *contactName = [JFSystemConfigModel sharedModel].contactName;
        NSString *tradeName = @"VIP会员";
        paymentInfo.orderDescription = contactName.length > 0 ? [tradeName stringByAppendingFormat:@"(%@)", contactName] : tradeName;
    }
    
    [paymentInfo save];
    
    self.completionHandler = handler;
    self.paymentInfo = paymentInfo;
    
    BOOL success = YES;
    
    JFPaymentConfig *config = [JFPaymentConfig sharedConfig];
    
    if (type == JFPaymentTypeVIAPay && (subType == JFSubPayTypeWeChat || subType == JFSubPayTypeAlipay || subType == JFSubPayTypeQQ)) {
        
        NSDictionary *viaPayTypeMapping = @{@(JFSubPayTypeAlipay):@(JFVIAPayTypeShenZhou),
                                            @(JFSubPayTypeWeChat):@(JFVIAPayTypeWeChat),
                                            @(JFSubPayTypeQQ):@(JFVIAPayTypeQQ)};
        NSString *tradeName = @"VIP会员";
        [[PayUitls getIntents]   gotoPayByFee:@(price).stringValue
                                 andTradeName:tradeName
                              andGoodsDetails:tradeName
                                    andScheme:KAliPaySchemeUrl
                            andchannelOrderId:[orderNo stringByAppendingFormat:@"$%@", JF_REST_APPID]
                                      andType:[viaPayTypeMapping[@(subType)] stringValue]
                             andViewControler:[JFUtil currentVisibleViewController]];
    }else if (type == JFPaymentTypeIAppPay && (subType == JFSubPayTypeWeChat || subType == JFSubPayTypeAlipay)){
        
        @weakify(self);
        IappPayMananger *iAppMgr = [IappPayMananger sharedMananger];
        iAppMgr.appId = [JFPaymentConfig sharedConfig].configDetails.iAppPayConfig.appid;
        iAppMgr.privateKey = [JFPaymentConfig sharedConfig].configDetails.iAppPayConfig.privateKey;
        iAppMgr.waresid = [JFPaymentConfig sharedConfig].configDetails.iAppPayConfig.waresid.stringValue;
        iAppMgr.appUserId = [JFUtil userId] ?: @"UnregisterUser";
        iAppMgr.privateInfo = JF_PAYMENT_RESERVE_DATA;
        iAppMgr.notifyUrl = [JFPaymentConfig sharedConfig].configDetails.iAppPayConfig.notifyUrl;
        iAppMgr.publicKey = [JFPaymentConfig sharedConfig].configDetails.iAppPayConfig.publicKey;
        
        [iAppMgr payWithPaymentInfo:paymentInfo payType:subType completionHandler:^(PAYRESULT payResult, JFPaymentInfo *paymentInfo) {
            @strongify(self);
            if (self.completionHandler) {
                self.completionHandler(payResult, self.paymentInfo);
            }
        }];
        
        
    } else if (type == JFPaymentTypeDXTXPay && (subType == JFSubPayTypeWeChat || subType == JFSubPayTypeAlipay)) {
//        @weakify(self);
//        [DXTXPayManager sharedManager].appKey = [JFPaymentConfig sharedConfig].configDetails.dxtxPayConfig.appKey;
//        [DXTXPayManager sharedManager].notifyUrl = [JFPaymentConfig sharedConfig].configDetails.dxtxPayConfig.notifyUrl;
//        [DXTXPayManager sharedManager].waresid = [JFPaymentConfig sharedConfig].configDetails.dxtxPayConfig.waresid;
//        [[DXTXPayManager sharedManager] payWithPaymentInfo:paymentInfo
//                                         completionHandler:^(PAYRESULT payResult, JFPaymentInfo *paymentInfo)
//         {
//             @strongify(self);
//             [self onPaymentResult:payResult withPaymentInfo:paymentInfo];
//             SafelyCallBlock4(self.completionHandler, payResult, paymentInfo);
//         }];
    } else if (type == JFPaymentTypeHTPay) {
        @weakify(self);
        [[HTPayManager sharedManager] payWithPaymentInfo:paymentInfo completionHandler:^(PAYRESULT payResult, JFPaymentInfo *paymentInfo) {
            @strongify(self);
            if (self.completionHandler) {
                SafelyCallBlock4(self.completionHandler,payResult,paymentInfo);
            }
        }];
        
    } else {
        success = NO;
        
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, paymentInfo);
        }
    }
    
    return success ? paymentInfo : nil;
}

- (void)onPaymentResult:(PAYRESULT)payResult withPaymentInfo:(JFPaymentInfo *)paymentInfo {
    
}

#pragma mark - stringDelegate

- (void)getResult:(NSDictionary *)sender {
    PAYRESULT paymentResult = [sender[@"result"] integerValue] == 0 ? PAYRESULT_SUCCESS : PAYRESULT_FAIL;
    
    //    [self onPaymentResult:paymentResult withPaymentInfo:self.paymentInfo];
    
    if (self.completionHandler) {
        if ([NSThread currentThread].isMainThread) {
            self.completionHandler(paymentResult, self.paymentInfo);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionHandler(paymentResult, self.paymentInfo);
            });
        }
    }
}



@end
