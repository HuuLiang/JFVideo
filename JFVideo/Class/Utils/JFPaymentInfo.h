//
//  JFPaymentInfo.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JFPaymentStatus) {
    JFPaymentStatusUnknown,
    JFPaymentStatusPaying,
    JFPaymentStatusNotProcessed,
    JFPaymentStatusProcessed
};


@interface JFPaymentInfo : NSObject

@property (nonatomic) NSString *paymentId;
@property (nonatomic) NSString *orderId;
@property (nonatomic) NSNumber *orderPrice;
@property (nonatomic) NSNumber *contentId;
@property (nonatomic) NSNumber *contentType;
@property (nonatomic) NSNumber *payPointType;
@property (nonatomic) NSString *paymentTime;
@property (nonatomic) NSNumber *paymentType;
@property (nonatomic) NSNumber *paymentResult;
@property (nonatomic) NSNumber *paymentStatus;
@property (nonatomic) NSString *reservedData;

@property (nonatomic) NSNumber *contentLocation;
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *columnType;

// 商户信息
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *notifyUrl;

+ (instancetype)paymentInfoFromDictionary:(NSDictionary *)payment;
- (void)save;


@end
