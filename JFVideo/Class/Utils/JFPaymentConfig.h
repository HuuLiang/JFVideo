//
//  JFPaymentConfig.h
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFURLResponse.h"
#import "JFPaymentConfigDetail.h"
#import "JFPaymentConfigSummary.h"

@interface JFPaymentConfig : JFURLResponse

@property (nonatomic,retain) JFPaymentConfigSummary *payConfig;
@property (nonatomic,retain) JFPaymentConfigDetail *configDetails;

+ (instancetype)sharedConfig;
- (void)setAsCurrentConfig;

- (JFPaymentType)wechatPaymentType;
- (JFPaymentType)alipayPaymentType;
- (JFPaymentType)qqPaymentType;

@end

