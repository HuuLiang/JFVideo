//
//  JFPaymentModel.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentModel.h"
#import "NSDictionary+LTSign.h"

static const NSTimeInterval kRetryingTimeInterval = 180;

static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kPaymentEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

@interface JFPaymentModel ()
@property (nonatomic,retain) NSTimer *retryingTimer;
@end

@implementation JFPaymentModel
+ (instancetype)sharedModel {
    static JFPaymentModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JFPaymentModel alloc] init];
    });
    return _sharedModel;
}

- (NSURL *)baseURL {
    return nil;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (JFURLRequestMethod)requestMethod {
    return JFURLPostRequest;
}

+ (NSString *)signKey {
    return kSignKey;
}

- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
    NSDictionary *signParams = @{  @"appId":JF_REST_APPID,
                                   @"key":kSignKey,
                                   @"imsi":@"999999999999999",
                                   @"channelNo":JF_CHANNEL_NO,
                                   @"pV":JF_REST_PV };
    
    NSString *sign = [signParams signWithDictionary:[self class].commonParams keyOrders:[self class].keyOrdersOfCommonParams];
    NSString *encryptedDataString = [params encryptedStringWithSign:sign password:kPaymentEncryptionPassword excludeKeys:@[@"key"]];
    return @{@"data":encryptedDataString, @"appId":JF_REST_APPID};
}

- (void)startRetryingToCommitUnprocessedOrders {
    if (!self.retryingTimer) {
        @weakify(self);
        self.retryingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:kRetryingTimeInterval block:^(NSTimer *timer) {
            @strongify(self);
            DLog(@"Payment: on retrying to commit unprocessed orders!");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self commitUnprocessedOrders];
            });
        } repeats:YES];
    }
}

- (void)stopRetryingToCommitUnprocessedOrders {
    [self.retryingTimer invalidate];
    self.retryingTimer = nil;
}

//- (void)commitUnprocessedOrders {
//    NSArray<LTPaymentInfo *> *unprocessedPaymentInfos = [LTUtils paidNotProcessedPaymentInfos];
//    [unprocessedPaymentInfos enumerateObjectsUsingBlock:^(LTPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self commitPaymentInfo:obj];
//    }];
//}

- (BOOL)commitPaymentInfo:(JFPaymentInfo *)paymentInfo {
    return [self commitPaymentInfo:paymentInfo withCompletionHandler:nil];
}

- (BOOL)commitPaymentInfo:(JFPaymentInfo *)paymentInfo withCompletionHandler:(JFCompletionHandler)handler {
    NSDictionary *statusDic = @{@(PAYRESULT_SUCCESS):@(1), @(PAYRESULT_FAIL):@(0), @(PAYRESULT_ABANDON):@(2), @(PAYRESULT_UNKNOWN):@(0)};
    
    if (nil == [JFUtil userId] || paymentInfo.orderId.length == 0) {
        return NO;
    }
    
    NSDictionary *params = @{@"uuid":[JFUtil userId],
                             @"orderNo":paymentInfo.orderId,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"payMoney":paymentInfo.orderPrice.stringValue,
                             @"channelNo":JF_CHANNEL_NO,
                             @"contentId":paymentInfo.contentId.stringValue ?: @"0",
                             @"contentType":paymentInfo.contentType.stringValue ?: @"0",
                             @"pluginType":paymentInfo.paymentType,
                             @"payPointType":paymentInfo.payPointType ?: @"1",
                             @"appId":JF_REST_APPID,
                             @"versionNo":@([JFUtil appVersion].integerValue),
                             @"status":statusDic[paymentInfo.paymentResult],
                             @"pV":JF_REST_PV,
                             @"payTime":paymentInfo.paymentTime};
    
    BOOL success = [super requestURLPath:JF_PAYMENT_COMMIT_URL
                              withParams:params
                         responseHandler:^(JFURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        if (respStatus == JFURLResponseSuccess) {
                            paymentInfo.paymentStatus = @(JFPaymentStatusProcessed);
                        } else {
                            DLog(@"Payment: fails to commit the order with orderId:%@", paymentInfo.orderId);
                        }
                        
                        if (handler) {
                            handler(respStatus == JFURLResponseSuccess, errorMessage);
                        }
                    }];
    return success;
}




@end
