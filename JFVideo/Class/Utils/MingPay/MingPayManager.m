//
//  MingPayManager.m
//  JFuaibo
//
//  Created by Sean Yue on 16/8/11.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "MingPayManager.h"
#import <AFNetworking.h>
#import "ApiXml.h"

static NSString *const kMingPayURL = @"http://ltongzy.com:8080/apiTvShow/wxwft/pay";//@"http://ltongzy.com:8080/apiTvShow/wxitf2/pay";
static NSString *const kCheckOrderURL = @"http://ltongzy.com:8080/apiTvShow/wxwft/query";//@"http://ltongzy.com:8080/apiTvShow/wxitf2/query";

@implementation MingPayManager

+ (instancetype)sharedManager {
    static MingPayManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)payWithPaymentInfo:(JFPaymentInfo *)paymentInfo completionHandler:(JFPaymentCompletionHandler)completionHandler {
    if (!paymentInfo.orderId || paymentInfo.orderPrice.unsignedIntegerValue == 0 || self.mch.length == 0) {
        SafelyCallBlock4(completionHandler, PAYRESULT_FAIL, paymentInfo);
        return ;
    }
    
    NSDictionary *params = @{@"out_trade_no":paymentInfo.orderId,
                             @"device_info":@"1",
                             @"body":paymentInfo.orderDescription ?: @"",
                             @"attach":paymentInfo.reservedData?:@"",
                             @"goods_tag":@"1",
                             @"total_fee":@(paymentInfo.orderPrice.unsignedIntegerValue)};
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [sessionManager POST:kMingPayURL
              parameters:params
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
    {
        NSDictionary *xmlDic = [self dictionaryFromXMLData:responseObject];
        DLog(@"MingPay pay response: %@", xmlDic);
        
        NSString *payInfo = xmlDic[@"pay_info"];
        if (!payInfo) {
            SafelyCallBlock4(completionHandler, PAYRESULT_FAIL, paymentInfo);
            return ;
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:payInfo]];
        [self waitForPayResultWithPaymentInfo:paymentInfo withCompletionHandler:completionHandler];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"MingPay Error : %@", error.localizedDescription);
        SafelyCallBlock4(completionHandler, PAYRESULT_FAIL, paymentInfo);
    }];
}

- (NSDictionary *)dictionaryFromXMLData:(NSData *)data {
    XMLHelper *xmlHelper = [[XMLHelper alloc] init];
    [xmlHelper startParse:data];
    
    NSDictionary *xmlDic = [xmlHelper getDict];
    return xmlDic;
}

- (NSString *)processOrderNo:(NSString *)orderNo {
    const CGFloat maxOrderNoLength = 30;
    
    NSMutableString *replacedOrderNo = orderNo.mutableCopy;
    [replacedOrderNo replaceOccurrencesOfString:@"_" withString:@"-" options:0 range:NSMakeRange(0, replacedOrderNo.length)];
    
    if (self.mch.length == 0) {
        return [replacedOrderNo substringFromIndex:MAX(0, replacedOrderNo.length-maxOrderNoLength)];
    }
    
    NSString *trimmedOrderNo = [NSString stringWithFormat:@"%@_%@", self.mch, [replacedOrderNo substringFromIndex:MAX(0, replacedOrderNo.length-(maxOrderNoLength-self.mch.length-1))]];
    return trimmedOrderNo;
}

- (void)waitForPayResultWithPaymentInfo:(JFPaymentInfo *)paymentInfo withCompletionHandler:(JFPaymentCompletionHandler)completionHandler {
    
    @weakify(self);
    [UIAlertView bk_showAlertViewWithTitle:@"是否已经完成支付？"
                                   message:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        @strongify(self);
        [[UIApplication sharedApplication].keyWindow beginProgressingWithTitle:@"查询支付结果..." subtitle:nil];
        [self checkPayment:paymentInfo withCompletionHandler:^(PAYRESULT payResult, JFPaymentInfo *paymentInfo) {
            [[UIApplication sharedApplication].keyWindow endProgressing];
            SafelyCallBlock4(completionHandler, payResult, paymentInfo);
        }];
    }];
}

- (void)checkPayment:(JFPaymentInfo *)paymentInfo withCompletionHandler:(JFPaymentCompletionHandler)completionHandler {
    
    if (!paymentInfo.orderId) {
        SafelyCallBlock4(completionHandler, PAYRESULT_FAIL, paymentInfo);
        return ;
    }
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    
    [sessionManager POST:kCheckOrderURL
              parameters:@{@"out_trade_no":paymentInfo.orderId}
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
    {
        DLog(@"MingPay order check : %@", responseObject);
        
        NSString *message = responseObject[@"message"];
        PAYRESULT payResult = [message isEqualToString:@"success"] ? PAYRESULT_SUCCESS : PAYRESULT_FAIL;
        SafelyCallBlock4(completionHandler, payResult, paymentInfo);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"MingPay Error : %@", error.localizedDescription);
        SafelyCallBlock4(completionHandler, PAYRESULT_FAIL, paymentInfo);
    }];
}
@end
