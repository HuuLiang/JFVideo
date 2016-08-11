//
//  QJPayManager.h
//  JFVideo
//
//  Created by Liang on 16/8/11.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJPayManager : NSObject
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *publicKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSString *waresid;
@property (nonatomic) NSString *appUserId;
@property (nonatomic) NSString *privateInfo;
@property (nonatomic) NSString *alipayURLScheme;

+ (instancetype)sharedMananger;

- (void)payWithPaymentInfo:(JFPaymentInfo *)paymentInfo CompletionHandler:(JFPaymentCompletionHandler)completionHandler;

- (void)handleOpenURL:(NSURL *)url;


@end
