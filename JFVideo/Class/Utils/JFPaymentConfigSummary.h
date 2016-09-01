//
//  JFPaymentConfigSummary.h
//  JFVideo
//
//  Created by Liang on 16/9/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFURLResponse.h"

extern NSString *const kYYKWeChatPayConfigName;
extern NSString *const kYYKAlipayPayConfigName;
extern NSString *const kYYKUnionPayConfigName;
extern NSString *const kYYKQQPayConfigName;

@interface JFPaymentConfigSummary : NSObject <JFResponseParsable>

@property (nonatomic) NSString *wechat;
@property (nonatomic) NSString *alipay;
@property (nonatomic) NSString *unionpay;
@property (nonatomic) NSString *qqpay;

@end
