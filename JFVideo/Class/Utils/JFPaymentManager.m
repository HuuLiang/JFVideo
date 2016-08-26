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
#import "MingPayManager.h"
#import "JFSystemConfigModel.h"
#import "HTPaymentManager.h"

typedef NS_ENUM(NSUInteger, JFVIAPayType) {
    JFVIAPayTypeNone,
    JFVIAPayTypeWeChat = 2,
    JFVIAPayTypeQQ = 3,
    JFVIAPayTypeUPPay = 4,
    JFVIAPayTypeShenZhou = 5
};

static NSString *const KAliPaySchemeUrl = @"comjfyingyuanappalipayurlscheme";
static NSString *const kIappPaySchemeUrl = @"comjfyingyuanappiapppayurlscheme";

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

- (void)setup {
    [[PayUitls getIntents] initSdk];
    [paySender getIntents].delegate = self;
    
    [[JFPaymentConfigModel sharedModel] fetchPaymentConfigInfoWithCompletionHandler:^(BOOL success, id obj) {
        [MingPayManager sharedManager].mch = [JFPaymentConfig sharedConfig].mpPayInfo.mch;
        JFPaymentConfig *config = (JFPaymentConfig *)obj;
        [[HTPaymentManager sharedManager] registHaiTunPayWithSignVal:config.haitunPayInfo.key mreId:config.haitunPayInfo.mchId];
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
    if ([JFPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.integerValue & JFSubPayTypeWeChat) {
        return JFPaymentTypeVIAPay;
    }else if ([JFPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.integerValue & JFSubPayTypeWeChat){
        
        return JFPaymentTypeIAppPay;
    }else if ([JFPaymentConfig sharedConfig].mpPayInfo.mch.length >0){
        return JFPaymentTypeMingPay;
    }else if ([JFPaymentConfig sharedConfig].haitunPayInfo.mchId.length >0) {
        return JFPaymentTypeHTPay;
    }
    //    else if ([JFPaymentConfig sharedConfig].wftPayInfo) {
    //        return JFPaymentTypeSPay;
    //    } else if ([JFPaymentConfig sharedConfig].iappPayInfo) {
    //        return JFPaymentTypeIAppPay;
    //        } 
    return JFPaymentTypeNone;
}

- (JFPaymentType)alipayPaymentType {
    if ([JFPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.integerValue & JFSubPayTypeAlipay) {
        return JFPaymentTypeVIAPay;
    }else if ([JFPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.integerValue & JFSubPayTypeAlipay){
        return JFPaymentTypeIAppPay;
    }
    return JFPaymentTypeNone;
}

- (JFPaymentType)cardPayPaymentType {
    if ([JFPaymentConfig sharedConfig].iappPayInfo) {
        return JFPaymentTypeIAppPay;
    }
    return JFPaymentTypeNone;
}

- (JFPaymentType)qqPaymentType {
    if ([JFPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.unsignedIntegerValue & JFSubPayTypeQQ) {
        return JFPaymentTypeVIAPay;
    }
    return JFPaymentTypeNone;
}

- (void)handleOpenUrl:(NSURL *)url {
    
    if ([url.absoluteString rangeOfString:kIappPaySchemeUrl].location == 0) {
        [[IappPayMananger sharedMananger] handleOpenURL:url];
    } else if ([url.absoluteString rangeOfString:KAliPaySchemeUrl].location == 0) {
        [[PayUitls getIntents] paytoAli:url];
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
#if DEBUG
    if (type == JFPaymentTypeIAppPay) {
        price = 200;
    } else {
        price = 100;
    }
#endif
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
    paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
    paymentInfo.paymentStatus = @(JFPaymentStatusPaying);
    paymentInfo.reservedData = [JFUtil paymentReservedData];
    
    //    NSString *servicePhone = [JFSystemConfigModel sharedModel].contact;
    if (type == JFPaymentTypeMingPay) {
        paymentInfo.orderDescription =  @"VIP";
        paymentInfo.orderId = [[MingPayManager sharedManager] processOrderNo:orderNo];
    }
    
    [paymentInfo save];
    
    self.completionHandler = handler;
    self.paymentInfo = paymentInfo;
    
    BOOL success = YES;
    
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
        iAppMgr.appId = [JFPaymentConfig sharedConfig].iappPayInfo.appid;
        iAppMgr.privateKey = [JFPaymentConfig sharedConfig].iappPayInfo.privateKey;
        iAppMgr.waresid = [JFPaymentConfig sharedConfig].iappPayInfo.waresid.stringValue;
        iAppMgr.appUserId = [JFUtil userId] ?: @"UnregisterUser";
        iAppMgr.privateInfo = JF_PAYMENT_RESERVE_DATA;
        iAppMgr.notifyUrl = [JFPaymentConfig sharedConfig].iappPayInfo.notifyUrl;
        iAppMgr.publicKey = [JFPaymentConfig sharedConfig].iappPayInfo.publicKey;
        
        [iAppMgr payWithPaymentInfo:paymentInfo payType:subType completionHandler:^(PAYRESULT payResult, JFPaymentInfo *paymentInfo) {
            @strongify(self);
            if (self.completionHandler) {
                self.completionHandler(payResult, self.paymentInfo);
            }
        }];
        
        
    }else if (type == JFPaymentTypeMingPay){
        @weakify(self);
        [[MingPayManager sharedManager] payWithPaymentInfo:paymentInfo completionHandler:^(PAYRESULT payResult, JFPaymentInfo *paymentInfo) {
            @strongify(self);
            
            if (self.completionHandler) {
                self.completionHandler(payResult, self.paymentInfo);
            }
        }];
    }else if (type == JFPaymentTypeHTPay){
        @weakify(self);
        HTPaymentManager *htPayManager =  [HTPaymentManager sharedManager];
        JFPaymentConfig *paymentConfig = [JFPaymentConfig sharedConfig];
        htPayManager.signVal = paymentConfig.haitunPayInfo.key;
        htPayManager.notifUrl = paymentConfig.haitunPayInfo.notifyUrl;
        htPayManager.merId = paymentConfig.haitunPayInfo.mchId;
        htPayManager.currentVC = [JFUtil currentVisibleViewController];
        [htPayManager payWithPaymentInfo:paymentInfo completionHandler:^(PAYRESULT payResult, JFPaymentInfo *paymentInfo) {
            @strongify(self);
            if (self.completionHandler) {
                self.completionHandler (payResult,self.paymentInfo);
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
