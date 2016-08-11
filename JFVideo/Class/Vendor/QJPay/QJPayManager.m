//
//  QJPayManager.m
//  JFVideo
//
//  Created by Liang on 16/8/11.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QJPayManager.h"
#import "JFPaymentInfo.h"
#import "JFUtil.h"

#import "QJPaySDK.h"

#define APPID @"0000000064"
#define APPKEYS @"f210c25179cef075e60f3c982018a988"
#define QJPayScheme @"comjfyingyuanqjpayscheme"
#define NOTIFYURL @"http://120.24.252.114:8084/pd-has/notifyMtdl.json"

@interface QJPayManager () <QJPayManagerDelegate>
@property (nonatomic,copy) JFPaymentCompletionHandler completionHandler;
@property (nonatomic,retain) JFPaymentInfo *paymentInfo;
@end


@implementation QJPayManager

+ (instancetype)sharedMananger {
    static QJPayManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)payWithPaymentInfo:(JFPaymentInfo *)paymentInfo CompletionHandler:(JFPaymentCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    self.paymentInfo = paymentInfo;
    
    NSDictionary *params = @{@"amount":[paymentInfo.orderPrice stringValue],
                             @"appid":APPID,
                             @"body": @"VIP会员",
                             @"clientIp":@"192.168.1.117",
                             @"mchntOrderNo":paymentInfo.paymentId,
                             @"subject":[paymentInfo.payPointType stringValue],
                             @"notifyUrl":NOTIFYURL,
                             @"source":@"0",
                             @"extra":JF_PAYMENT_RESERVE_DATA};

    [QJPaySDK QJPayStart:params AppScheme:QJPayScheme appKey:APPKEYS andCurrentViewController:[JFUtil currentVisibleViewController] andDelegate:self Flag:0x80];
}

- (void)handleOpenURL:(NSURL *)url {
    [QJPaySDK handleOpenURL:url]; 
}

- (void)QJPayResponseResult:(int)response {
    DLog(@"结果 %d",response);
    SafelyCallBlock4(self.completionHandler, response, self.paymentInfo);
    self.completionHandler = nil;
    self.paymentInfo = nil;

}

@end
