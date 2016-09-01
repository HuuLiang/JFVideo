//
//  JFPaymentConfigSummary.m
//  JFVideo
//
//  Created by Liang on 16/9/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentConfigSummary.h"

NSString *const kJFWeChatPayConfigName = @"WEIXIN";
NSString *const kJFAlipayPayConfigName = @"ALIPAY";
NSString *const kJFUnionPayConfigName = @"UNIONPAY";
NSString *const kJFQQPayConfigName = @"QQPAY";

@implementation JFPaymentConfigSummary

- (NSString *)JF_propertyOfParsing:(NSString *)parsingName {
    NSDictionary *mapping = @{kJFWeChatPayConfigName:NSStringFromSelector(@selector(wechat)),
                              kJFAlipayPayConfigName:NSStringFromSelector(@selector(alipay)),
                              kJFUnionPayConfigName:NSStringFromSelector(@selector(unionpay)),
                              kJFQQPayConfigName:NSStringFromSelector(@selector(qqpay))};
    return mapping[parsingName];
}

@end
