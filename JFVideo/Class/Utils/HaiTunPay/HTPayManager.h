//
//  HTPaymentManager.h
//  JFVideo
//
//  Created by ylz on 16/8/18.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPayManager : NSObject

@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *notifyUrl;

+ (instancetype)sharedManager;

- (void)payWithPaymentInfo:(JFPaymentInfo *)paymentInfo
         completionHandler:(JFPaymentCompletionHandler)completionHandler;

@end
