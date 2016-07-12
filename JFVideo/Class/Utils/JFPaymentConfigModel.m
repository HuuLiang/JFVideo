//
//  JFPaymentConfigModel.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentConfigModel.h"

static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kPaymentEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

@implementation JFPaymentConfigModel

+ (Class)responseClass {
    return [JFPaymentConfig class];
}

+ (instancetype)sharedModel {
    static JFPaymentConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
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
                                   @"pV":JF_PAYMENT_PV };
    
    NSString *sign = [signParams signWithDictionary:[self class].commonParams keyOrders:[self class].keyOrdersOfCommonParams];
    NSString *encryptedDataString = [params encryptedStringWithSign:sign password:kPaymentEncryptionPassword excludeKeys:@[@"key"]];
    return @{@"data":encryptedDataString, @"appId":JF_REST_APPID};
}

- (BOOL)fetchPaymentConfigInfoWithCompletionHandler:(JFCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:JF_PAYMENT_CONFIG_URL
                     standbyURLPath:[NSString stringWithFormat:JF_STANDBY_PAYMENT_CONFIG_URL, JF_REST_APPID]
                         withParams:@{@"appId":JF_REST_APPID, @"channelNo":JF_CHANNEL_NO, @"pV":JF_PAYMENT_PV}
                    responseHandler:^(JFURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    if (!self) {
                        return ;
                    }
                    
                    JFPaymentConfig *config;
                    if (respStatus == JFURLResponseSuccess) {
                        self->_loaded = YES;
                        
                        config = self.response;
                        [config setAsCurrentConfig];
                        DLog("%@",[JFPaymentConfig sharedConfig]);
                        
                        
                        DLog(@"Payment config loaded!");
                    }
                    
                    if (handler) {
                        handler(respStatus == JFURLResponseSuccess, config);
                    }
                }];
    return ret;
}
@end
