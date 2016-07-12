//
//  JFPaymentConfig.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentConfig.h"

static NSString *const kPaymentConfigKeyName = @"jf_payment_config_key_name";

@implementation JFWeChatPaymentConfig

//+ (instancetype)defaultConfig {
//    JFWeChatPaymentConfig *config = [[self alloc] init];
//    config.appId = @"wx4af04eb5b3dbfb56";
//    config.mchId = @"1281148901";
//    config.signKey = @"hangzhouquba20151112qwertyuiopas";
//    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyWx.json";
//    return config;
//}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.appId forKey:@"appId"];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.signKey forKey:@"signKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JFWeChatPaymentConfig *config = [[self alloc] init];
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
    config.appid = @"3004262770";
    config.privateKey = @"MIICXQIBAAKBgQCAlkSlxfOCLY/6NPA5VaLvlJjKByjUk2HRGxXDMCZhxucckfvY2yJ0eInTKoqVmkof3+Sp22TNlAdfsMFbsw/9qyHalRclfjhXlKzjurXtGGZ+7uDZGIHM3BV492n1gSbWMAFZE7l5tNPiANkxFjfid7771S3vYB7lthaEcvgRmwIDAQABAoGAMG/qdgOmIcBl/ttYLlDK6rKwB1JBGCpYa3tnbDpECwrw3ftDwkFxriwFxuy8fXQ8PduJ+E3zn9kGGg6sF43RFLVNlEwJMZXWXj0tA1rtbk56vbISXzK+/McDqfhk89abdvdS1HngXRXsYZSFSwt67IwsLRPNCz5vYkS+56kLckkCQQC8IF5zbr+9zLRoUP5H7URNvvYceUHB500skyVfB/kE2KqfP9NCwt7OlTaZG0iFOqSGtG1bqXawiGuTzk+bxvd/AkEArvq/p0dBv00OVFeo7j/OZ2d/usAYSTGCWcGib7vb8xlXHvWkwKSR2priG2vTTNlx7K2r35YheyQcfjV0G4HT5QJBALEF8HrEmw7ZomWK2UwLezuBVwuCGpuAsMEiEYdz9CJYU22Y3I20234fMIov/zTG8uyCuWkIdNQ2+qvR9l1Kg7cCQQCEKAp8cwsrSy2ZciO63iIsYzVLfS5aibQjymW+8inrb6YnUew/O4yViQlhII0Uq96pnXoEgsWC1gFXKVQqOmIpAkBtljLpXAoLNGku5cvGpZycAck9Mbwz4tNzixf4Q/eCuLH6rmUcoNI9q5zQjp8GSITN/7PyzZ+Mw3TahCysC5fl";
    config.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9NgdzqMPgAySHtV02jw8alHb/es/4NOBfjmNwi2uO50No1DM85S/THpNbBLPS7etLunb8XBqGDOQ3cILxCcWOggdcqjaHvmJ/OliWNofDu2QImMrM3t129wSjhfbvUA1btqnDuNcKz0yawZWt9YIIk/jQxutEmxYMq1eN1uvWHQIDAQAB";
    config.waresid = @(1);
    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyIpay.json";
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
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    [dicRep safelySetObject:self.waresid forKey:@"waresid"];
    [dicRep safelySetObject:self.supportPayTypes forKey:@"supportPayTypes"];
    [dicRep safelySetObject:self.publicKey forKey:@"publicKey"];
    return dicRep;
}
@end

@implementation JFVIAPayConfig

//+ (instancetype)defaultConfig {
//    JFVIAPayConfig *config = [[self alloc] init];
//    //config.packageId = @"5361";
//    config.supportPayTypes = @(JFSubPayTypeAlipay);
//    return config;
//}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    //    [dicRep safelySetObject:self.packageId forKey:@"packageId"];
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

//+ (instancetype)defaultConfig {
//    JFSPayConfig *config = [[self alloc] init];
//    config.mchId = @"5712000010";
//    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyWft.json";
//    config.signKey = @"5afe11de0df374f5f78839db1904ff0d";
//    return config;
//}

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
    return [JFWeChatPaymentConfig class];
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
    //    NSDictionary *weixinInfo = configDic[@"weixinInfo"];
    //    if (weixinInfo) {
    //        self.weixinInfo = [JFWeChatPaymentConfig configFromDictionary:weixinInfo];
    //    }
    //    NSDictionary *alipayInfo = configDic[@"alipayInfo"];
    //    if (alipayInfo) {
    //        self.alipayInfo = [JFAlipayConfig configFromDictionary:alipayInfo];
    //    }
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
    
    if (!self.syskPayInfo && !self.wftPayInfo && !self.iappPayInfo && !self.haitunPayInfo) {
        self.haitunPayInfo = [JFHTPayConfig defaultConfig];
    }
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [[NSMutableDictionary alloc] init];
    //    [dicRep safelySetObject:[self.weixinInfo dictionaryRepresentation] forKey:@"weixinInfo"];
    //    [dicRep safelySetObject:[self.alipayInfo dictionaryRepresentation] forKey:@"alipayInfo"];
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
