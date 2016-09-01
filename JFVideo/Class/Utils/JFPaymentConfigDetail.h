//
//  JFPaymentConfigDetail.h
//  JFVideo
//
//  Created by Liang on 16/9/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFURLResponse.h"

@class JFIAppPayConfig;
@class JFVIAPayConfig;
@class JFMingPayConfig;
@class JFSPayConfig;
@class JFHTPayConfig;

extern NSString *const kJFIAppPayConfigName;
extern NSString *const kJFVIAPayConfigName;
extern NSString *const kJFMingPayConfigName;
extern NSString *const kJFSPayConfigName;
extern NSString *const kJFHTPayConfigName;

@interface JFPaymentConfigDetail : NSObject <JFResponseParsable>

@property (nonatomic,retain) JFIAppPayConfig *iAppPayConfig; //爱贝支付
@property (nonatomic,retain) JFVIAPayConfig *viaPayConfig; //首游时空
@property (nonatomic,retain) JFMingPayConfig *mingPayConfig; //明鹏支付
@property (nonatomic,retain) JFSPayConfig *spayConfig; //威富通
@property (nonatomic,retain) JFHTPayConfig *htpayConfig;//海豚支付

@end

@interface JFIAppPayConfig : NSObject
@property (nonatomic) NSString *appid;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *publicKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@property (nonatomic) NSNumber *supportPayTypes;

+ (instancetype)defaultConfig;
@end

@interface JFVIAPayConfig : NSObject

//@property (nonatomic) NSString *packageId;
@property (nonatomic) NSNumber *supportPayTypes;

+ (instancetype)defaultConfig;

@end

@interface JFMingPayConfig : NSObject

@property (nonatomic) NSString *payUrl;
@property (nonatomic) NSString *queryOrderUrl;
@property (nonatomic) NSString *mch;

@end

@interface JFSPayConfig : NSObject
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *notifyUrl;
@end

@interface JFHTPayConfig : NSObject
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *notifyUrl;
@end
