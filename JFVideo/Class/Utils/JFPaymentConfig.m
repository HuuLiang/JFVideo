//
//  JFPaymentConfig.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentConfig.h"

static NSString *const kPaymentConfigKeyName = @"jf_payment_config_key_name";

@implementation JFWeChatPayConfig

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.appId forKey:@"appId"];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.signKey forKey:@"signKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JFWeChatPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

@end



@implementation JFAlipayConfig

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.partner forKey:@"partner"];
    [dicRep safelySetObject:self.seller forKey:@"seller"];
    [dicRep safelySetObject:self.productInfo forKey:@"productInfo"];
    [dicRep safelySetObject:self.privateKey forKey:@"privateKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JFAlipayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

@end



@implementation JFIAppPayConfig

+ (instancetype)defaultConfig {
    JFIAppPayConfig *config = [[self alloc] init];
    config.appid = @"3004666841";
    config.privateKey = @"MIICXAIBAAKBgQCDYjujgETHtro383gco6rXHcZfuyZ8dimK/zub0fMHhESI9JvH/3SLzhhbdIv3mndnGMSCGXFP7rlMW9pf+76CiWuYPHGs9nVzRw5jX6aemiq54WLJCC6syyDKpmzNHWKF1bwjqMbgUVvy2hYb4BJN8ahaE0KjJJ6AOmUi13fgewIDAQABAoGAOV6GnjFfVzmx/MaCdzb8XWxx99FXz9ck8r3agILftTOLXaY5883XTUjUF/M/PwIjC1CkVg7YDMg3/2DIbUsW93XWHcZQP8VkTxmmRxsuq9olk2Z/LrIkoMcDU028gb4BIp/Ea1ujLXpqUDJaIfoFVbhcDqZhr6X3aXhdRRe9isECQQDOSfdacG6lr4EwhZBiYwk/IjcEDX5KEm1RztiUcAyERUyFy83Y7kvdL3kXDBVkV1TnA8d/LNaY+wQ/g4jMKOPbAkEAowtW04M3FzBXf0kdZ5zjau0NRbTt1pnR5FP5Mw+2h5KaqRwGaLlJZNDWyqGScBto/b6/aRkQXbzORhcg/9fn4QJBAMdWwFg7ZyBh/MPHfSMlsky4olMfOtcXAV5ZM/4UXHQAhxaPP0YN129QLYHw4kcJAPkPNNsWl/RSM+OwFiO6q5sCQCLP4/0LUjLwTm5OBSo/VEtbS+8rP3EHrMoMp/OgEkAGLGGZK0Em9qXA9WuUbfjj0VoEZUgiYt0w1/YdMB2QUuECQHO/Xp6+RX8lcWugXd+NWsJQqgpPpO+nDvJJKg5f/9+P5xqfA4Z0Kz0JjmQYRv2NQJX9GOodXG3EsxVKWsJ48gU=";
    config.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDGUdxLNXQ4jvqAZm3oQE1WX014JC1yT2nsL29CSgtma6exJdvLlsrk/QTCKy8SIAEVQ3bawYWRrr6JVZVwx9i98TlmAmZyj5tdvWZbYcfi5xWu2tM0jM/7kH5itgD+LoV7VYpWrdcMbF1No+fK7aO66KMeii/cFxzx2RBxnUJFpQIDAQAB";
    config.waresid = @(1);
    config.supportPayTypes = @(JFSubPayTypeWeChat);
    return config;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JFIAppPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.appid forKey:@"appid"];
    [dicRep safelySetObject:self.privateKey forKey:@"privateKey"];
    [dicRep safelySetObject:self.publicKey forKey:@"publicKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    [dicRep safelySetObject:self.waresid forKey:@"waresid"];
    [dicRep safelySetObject:self.supportPayTypes forKey:@"supportPayTypes"];
    return dicRep;
}

@end


@implementation JFVIAPayConfig

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.packageId forKey:@"packageId"];
    [dicRep safelySetObject:self.supportPayTypes forKey:@"supportPayTypes"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JFVIAPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

@end



@implementation JFSPayConfig

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.signKey forKey:@"signKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JFSPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

@end


@implementation JFHTPayConfig

+ (instancetype)defaultConfig {
    JFHTPayConfig *config = [[self alloc] init];
    config.mchId = @"10605";
    config.key = @"e7c549c833cb9108e6524d075942119d";
    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyHtPay.json";
    return config;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.key forKey:@"key"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JFHTPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

@end



@interface JFPaymentConfigRespCode : NSObject
@property (nonatomic) NSNumber *value;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *message;
@end

@implementation JFPaymentConfigRespCode

@end

static JFPaymentConfig *_shardConfig;

@interface JFPaymentConfig ()
@property (nonatomic) JFPaymentConfigRespCode *code;
@end

@implementation JFPaymentConfig

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shardConfig = [[self alloc] init];
        [_shardConfig loadCachedConfig];
    });
    return _shardConfig;
}

- (NSNumber *)success {
    return self.code.value.unsignedIntegerValue == 100 ? @(1) : (0);
}

- (NSString *)resultCode {
    return self.code.value.stringValue;
}

- (Class)codeClass {
    return [JFPaymentConfigRespCode class];
}

- (Class)weixinInfoClass {
    return [JFWeChatPayConfig class];
}

- (Class)alipayInfoClass {
    return [JFAlipayConfig class];
}

- (Class)iappPayInfoClass {
    return [JFIAppPayConfig class];
}

- (Class)syskPayInfoClass {
    return [JFVIAPayConfig class];
}

- (Class)wftPayInfoClass {
    return [JFSPayConfig class];
}

- (Class)haitunPayInfoClass {
    return [JFHTPayConfig class];
}

- (void)loadCachedConfig {
    NSDictionary *configDic = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentConfigKeyName];
    
    NSDictionary *weixinPayInfo = configDic[@"weixinInfo"];
    if (weixinPayInfo) {
        self.weixinInfo = [JFWeChatPayConfig configFromDictionary:weixinPayInfo];
    }
    
    NSDictionary *iappPayInfo = configDic[@"iappPayInfo"];
    if (iappPayInfo) {
        self.iappPayInfo = [JFIAppPayConfig configFromDictionary:iappPayInfo];
    }
    
    NSDictionary *syskPayInfo = configDic[@"syskPayInfo"];
    if (syskPayInfo) {
        self.syskPayInfo = [JFVIAPayConfig configFromDictionary:syskPayInfo];
    }
    
    NSDictionary *wftPayInfo = configDic[@"wftPayInfo"];
    if (wftPayInfo) {
        self.wftPayInfo = [JFSPayConfig configFromDictionary:wftPayInfo];
    }
    
    NSDictionary *htPayInfo = configDic[@"haitunPayInfo"];
    if (htPayInfo) {
        self.haitunPayInfo = [JFHTPayConfig configFromDictionary:htPayInfo];
    }
    
    if (!self.syskPayInfo && !self.wftPayInfo && !self.iappPayInfo && !self.haitunPayInfo && !self.weixinInfo) {
        self.haitunPayInfo = [JFHTPayConfig defaultConfig];
    }
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [[NSMutableDictionary alloc] init];
    [dicRep safelySetObject:[self.weixinInfo dictionaryRepresentation] forKey:@"weixinInfo"];
    [dicRep safelySetObject:[self.alipayInfo dictionaryRepresentation] forKey:@"alipayInfo"];
    [dicRep safelySetObject:[self.iappPayInfo dictionaryRepresentation] forKey:@"iappPayInfo"];
    [dicRep safelySetObject:[self.syskPayInfo dictionaryRepresentation] forKey:@"syskPayInfo"];
    [dicRep safelySetObject:[self.wftPayInfo dictionaryRepresentation] forKey:@"wftPayInfo"];
    [dicRep safelySetObject:[self.haitunPayInfo dictionaryRepresentation] forKey:@"haitunPayInfo"];
    return dicRep;
}

- (void)setAsCurrentConfig {
    JFPaymentConfig *currentConfig = [[self class] sharedConfig];
    currentConfig.syskPayInfo = self.syskPayInfo;
    currentConfig.wftPayInfo = self.wftPayInfo;
    currentConfig.iappPayInfo = self.iappPayInfo;
    currentConfig.haitunPayInfo = self.haitunPayInfo;
    
    [[NSUserDefaults standardUserDefaults] setObject:[self dictionaryRepresentation] forKey:kPaymentConfigKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
