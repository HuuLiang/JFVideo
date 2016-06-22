//
//  JFUtil.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFPaymentInfo.h"

extern NSString *const kPaymentInfoKeyName;

@interface JFUtil : NSObject

+ (NSString *)accessId;
+ (NSString *)userId;
+ (BOOL)isRegistered;
+ (void)setRegisteredWithUserId:(NSString *)userId;

+ (NSString *)deviceName;
+ (NSString *)appVersion;

+ (void)registerVip;
+ (BOOL)isVip;

+ (NSUInteger)launchSeq;
+ (void)accumateLaunchSeq;

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler;

+ (NSArray<JFPaymentInfo *> *)allPaymentInfos;
+ (NSArray<JFPaymentInfo *> *)payingPaymentInfos;
+ (NSArray<JFPaymentInfo *> *)paidNotProcessedPaymentInfos;
+ (JFPaymentInfo *)successfulPaymentInfo;


@end
