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

static NSString *const kPaymentConfigIappPayAppid               = @"kPaymentConfigIappPayAppid";
static NSString *const kPaymentConfigIappPayNotifyUrl           = @"kPaymentConfigIappPayNotifyUrl";
static NSString *const kPaymentConfigIappPayPrivateKey          = @"kPaymentConfigIappPayPrivateKey";
static NSString *const kPaymentConfigIappPayPublicKey           = @"kPaymentConfigIappPayPublicKey";
static NSString *const kPaymentConfigIappPaySupportPaytypes     = @"kPaymentConfigIappPaySupportPaytypes";
static NSString *const kPaymentConfigIappPayWaresid             = @"kPaymentConfigIappPayWaresid";

@interface JFPaymentConfigRespCode : NSObject
@property (nonatomic) NSNumber *value;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *message;
@end

@implementation JFPaymentConfigRespCode

@end


@interface JFPaymentConfigResponse ()
@property (nonatomic) JFPaymentConfigRespCode *code;
@end

@implementation JFPaymentConfigResponse

- (Class)iappPayInfoClass {
    return [LTIAppPayConfig class];
}


- (Class)codeClass {
    return [JFPaymentConfigRespCode class];
}

- (NSNumber *)Result {
    return self.code.value.unsignedIntegerValue == 100 ? @(1) : (0);
}

- (NSString *)Msg {
    return self.code.value.stringValue;
}

- (void)parseResponseWithDictionary:(NSDictionary *)dic {
    return [super parseResponseWithDictionary:dic];
}
@end


@implementation LTIAppPayConfig

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.appid = [coder decodeObjectForKey:kPaymentConfigIappPayAppid];
        self.notifyUrl = [coder decodeObjectForKey:kPaymentConfigIappPayNotifyUrl];
        self.privateKey = [coder decodeObjectForKey:kPaymentConfigIappPayPrivateKey];
        self.publicKey = [coder decodeObjectForKey:kPaymentConfigIappPayPublicKey];
        self.supportPayTypes = [coder decodeObjectForKey:kPaymentConfigIappPaySupportPaytypes];
        self.waresid = [coder decodeObjectForKey:kPaymentConfigIappPayWaresid];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.appid forKey:kPaymentConfigIappPayAppid];
    [aCoder encodeObject:self.notifyUrl forKey:kPaymentConfigIappPayNotifyUrl];
    [aCoder encodeObject:self.privateKey forKey:kPaymentConfigIappPayPrivateKey];
    [aCoder encodeObject:self.publicKey forKey:kPaymentConfigIappPayPublicKey];
    [aCoder encodeObject:self.supportPayTypes forKey:kPaymentConfigIappPaySupportPaytypes];
    [aCoder encodeObject:self.waresid forKey:kPaymentConfigIappPayWaresid];
}

@end

@implementation JFPaymentConfigModel

+ (Class)responseClass {
    return [JFPaymentConfigResponse class];
}

+ (instancetype)sharedModel {
    static JFPaymentConfigModel *_configModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _configModel = [[JFPaymentConfigModel alloc] init];
    });
    return _configModel;
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

- (BOOL)fetchPaymentConfigInfoWithCompletionHandler:(JFCompletionHandler)handler {
    NSDictionary *params = @{@"appId":JF_REST_APPID,
                             @"channelNo":JF_CHANNEL_NO,
                             @"pV":JF_REST_PV};
    BOOL success = [self requestURLPath:JF_PAYMENT_CONFIG_URL
                             withParams:params
                        responseHandler:^(JFURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        JFPaymentConfigResponse *config = nil;
                        if (respStatus == JFURLResponseSuccess) {
                            config = self.response;
                        }
                        handler(respStatus == JFURLResponseSuccess,config);
                    }];
    return success;
}


@end
