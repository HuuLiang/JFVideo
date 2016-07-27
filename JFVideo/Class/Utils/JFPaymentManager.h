//
//  JFPaymentManager.h
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JFBaseModel;

@interface JFPaymentManager : NSObject

+ (instancetype)sharedManager;

- (void)setup;

- (JFPaymentInfo *)startPaymentWithType:(JFPaymentType)type
                                subType:(JFSubPayType)subType
                                  price:(NSUInteger)price
                              baseModel:(JFBaseModel *)model
                      completionHandler:(JFPaymentCompletionHandler)handler;


- (void)handleOpenUrl:(NSURL *)url;

- (JFPaymentType)wechatPaymentType;
- (JFPaymentType)alipayPaymentType;
- (JFPaymentType)cardPayPaymentType;
- (JFPaymentType)qqPaymentType;

@end
