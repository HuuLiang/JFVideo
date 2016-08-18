//
//  HTPaymentManager.h
//  JFVideo
//
//  Created by ylz on 16/8/18.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPaymentManager : NSObject

//商户密钥值
@property (nonatomic, copy)NSString *signVal;
//商户编号
@property (nonatomic, copy)NSString *merId;
//查询订单请求地址
@property (nonatomic, copy)NSString *selectUrl;

@property (nonatomic)NSString *notifUrl;

@property (nonatomic,retain)UIViewController *currentVC;

+ (instancetype)sharedManager;
- (void)registHaiTunPayWithSignVal:(NSString *)signVal mreId:(NSString *)merId;

- (void)payWithPaymentInfo:(JFPaymentInfo *)paymentInfo completionHandler:(JFPaymentCompletionHandler)completionHandler;

@end
