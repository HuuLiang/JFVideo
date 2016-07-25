//
//  IappPayMananger.m
//  JFuaibo
//
//  Created by Sean Yue on 16/6/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "IappPayMananger.h"
#import <IapppayKit/IapppayKit.h>
#import <IapppayKit/IapppayOrderUtils.h>
#import "JFPaymentInfo.h"

static NSString *const kIappPreOrderURL = @"http://ipay.iapppay.com:9999/payapi/order";

@interface IappPayMananger () <IapppayKitPayRetDelegate>
@property (nonatomic,copy) JFPaymentCompletionHandler completionHandler;
@property (nonatomic,retain) JFPaymentInfo *paymentInfo;
@end

@implementation IappPayMananger

+ (instancetype)sharedMananger {
    static IappPayMananger *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)payWithPaymentInfo:(JFPaymentInfo *)paymentInfo completionHandler:(JFPaymentCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    self.paymentInfo = paymentInfo;
    
    IapppayOrderUtils *order = [[IapppayOrderUtils alloc] init];
    order.appId = self.appId;
    order.cpPrivateKey = self.privateKey;
    order.cpOrderId = paymentInfo.orderId;
    order.waresId = self.waresid;
    order.price = [NSString stringWithFormat:@"%.2f", paymentInfo.orderPrice.unsignedIntegerValue/100.];
    order.appUserId = self.appUserId;
    order.cpPrivateInfo = self.privateInfo;
    order.notifyUrl = self.notifyUrl;

    NSString *trandData = [order getTrandData];
    [[IapppayKit sharedInstance] makePayForTrandInfo:trandData payResultDelegate:self];
}

#pragma mark - IapppayKitPayRetDelegate

- (void)iapppayKitRetPayStatusCode:(IapppayKitPayRetCodeType)statusCode resultInfo:(NSDictionary *)resultInfo {
    NSDictionary *paymentStatusMapping = @{@(IAPPPAY_PAYRETCODE_SUCCESS):@(PAYRESULT_SUCCESS),
                                           @(IAPPPAY_PAYRETCODE_FAILED):@(PAYRESULT_FAIL),
                                           @(IAPPPAY_PAYRETCODE_CANCELED):@(PAYRESULT_ABANDON)};
    NSNumber *paymentResult = paymentStatusMapping[@(statusCode)];
    if (!paymentResult) {
        paymentResult = @(PAYRESULT_UNKNOWN);
    }

    NSString *signature = [resultInfo objectForKey:@"Signature"];
    if (paymentResult.unsignedIntegerValue == PAYRESULT_SUCCESS) {
        if (![IapppayOrderUtils checkPayResult:signature withAppKey:self.publicKey]) {
            DLog(@"支付成功，但是延签失败！");
            paymentResult = @(PAYRESULT_FAIL);
        }
    }
    SafelyCallBlock4(self.completionHandler, paymentResult.unsignedIntegerValue, self.paymentInfo);
    self.completionHandler = nil;
    self.paymentInfo = nil;
}
@end