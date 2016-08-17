//
//  JFPaymentConfig.h
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFURLResponse.h"
//typedef NS_ENUM(NSUInteger, JFSubPayType) {
//    JFSubPayTypeUnknown = 0,
//    JFSubPayTypeWeChat = 1 << 0,
//    JFSubPayTypeAlipay = 1 << 1
//};

@interface JFWeChatPaymentConfig : NSObject
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *notifyUrl;

//+ (instancetype)defaultConfig;
@end

@interface JFAlipayConfig : NSObject
@property (nonatomic) NSString *partner;
@property (nonatomic) NSString *seller;
@property (nonatomic) NSString *productInfo;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *notifyUrl;
@end

@interface JFIAppPayConfig : NSObject
@property (nonatomic) NSString *appid;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *publicKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@property (nonatomic) NSNumber *supportPayTypes;

//+ (instancetype)defaultConfig;
@end

@interface JFVIAPayConfig : NSObject

//@property (nonatomic) NSString *packageId;
@property (nonatomic) NSNumber *supportPayTypes;

@end

@interface JFSPayConfig : NSObject
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *notifyUrl;
@end

@interface JFHTPayConfig : NSObject
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *notifyUrl;
@end

@interface JFMingPayConfig : NSObject

@property (nonatomic) NSString *mch;

@end

@interface JFPaymentConfig : JFURLResponse

@property (nonatomic,retain) JFWeChatPaymentConfig *weixinInfo;
@property (nonatomic,retain) JFAlipayConfig *alipayInfo;
@property (nonatomic,retain) JFIAppPayConfig *iappPayInfo;
@property (nonatomic,retain) JFVIAPayConfig *syskPayInfo;
@property (nonatomic,retain) JFSPayConfig *wftPayInfo;
@property (nonatomic,retain) JFHTPayConfig *haitunPayInfo;
@property (nonatomic,retain) JFMingPayConfig *mpPayInfo;

+ (instancetype)sharedConfig;
- (void)setAsCurrentConfig;
@end
