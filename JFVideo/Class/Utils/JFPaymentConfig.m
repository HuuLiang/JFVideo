//
//  JFPaymentConfig.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentConfig.h"

static JFPaymentConfig *_shardConfig;
static NSString *const kPaymentConfigKeyName = @"JFuaibo_payment_config_key_name";

@interface JFPaymentConfig ()
@property (nonatomic) NSNumber *code;
@property (nonatomic,retain) NSDictionary *paymentTypeMapping;
@end

@implementation JFPaymentConfig

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *configDic = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentConfigKeyName];
        _shardConfig = [self objectFromDictionary:configDic withDecryptBlock:nil];
        
        if (!_shardConfig) {
            _shardConfig = [self defaultConfig];
        }
    });
    return _shardConfig;
}

+ (instancetype)defaultConfig {
    JFPaymentConfig *defaultConfig = [[self alloc] init];
    
    defaultConfig.payConfig = [[JFPaymentConfigSummary alloc] init];
    defaultConfig.payConfig.wechat = kJFVIAPayConfigName;
    defaultConfig.payConfig.alipay = kJFVIAPayConfigName;
    
    defaultConfig.configDetails = [[JFPaymentConfigDetail alloc] init];
    defaultConfig.configDetails.viaPayConfig = [JFVIAPayConfig defaultConfig];
    
    return defaultConfig;
}

- (NSDictionary *)paymentTypeMapping {
    if (_paymentTypeMapping) {
        return _paymentTypeMapping;
    }
    
    _paymentTypeMapping = @{kJFVIAPayConfigName:@(JFPaymentTypeVIAPay),
                            kJFIAppPayConfigName:@(JFPaymentTypeIAppPay),
                            kJFMingPayConfigName:@(JFPaymentTypeMingPay),
                            kJFSPayConfigName:@(JFPaymentTypeSPay)};
    return _paymentTypeMapping;
}

- (JFPaymentType)wechatPaymentType {
    if (self.payConfig.wechat) {
        NSNumber *type = self.paymentTypeMapping[self.payConfig.wechat];
        return type ? type.unsignedIntegerValue : JFPaymentTypeNone;
    }
    return JFPaymentTypeNone;
}

- (JFPaymentType)alipayPaymentType {
    if (self.payConfig.alipay) {
        NSNumber *type = self.paymentTypeMapping[self.payConfig.alipay];
        return type ? type.unsignedIntegerValue : JFPaymentTypeNone;
    }
    return JFPaymentTypeNone;
}

- (JFPaymentType)qqPaymentType {
    if (self.payConfig.qqpay) {
        NSNumber *type = self.paymentTypeMapping[self.payConfig.qqpay];
        return type ? type.unsignedIntegerValue : JFPaymentTypeNone;
    }
    return JFPaymentTypeNone;
}

- (NSNumber *)success {
    return _code.unsignedIntegerValue == 100 ? @(YES) : @(NO);
}

- (NSString *)resultCode {
    return _code.stringValue;
}

- (Class)payConfigClass {
    return [JFPaymentConfigSummary class];
}

- (Class)configDetailsClass {
    return [JFPaymentConfigDetail class];
}

- (void)setAsCurrentConfig {
    JFPaymentConfig *currentConfig = [[self class] sharedConfig];
    currentConfig.payConfig = self.payConfig;
    currentConfig.configDetails = self.configDetails;
    
    [[NSUserDefaults standardUserDefaults] setObject:[self dictionaryRepresentationWithEncryptBlock:nil] forKey:kPaymentConfigKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
