//
//  JFPaymentModel.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"
#import "JFPaymentInfo.h"

@interface JFPaymentModel : JFEncryptedURLRequest
+ (instancetype)sharedModel;

- (void)startRetryingToCommitUnprocessedOrders;
- (void)commitUnprocessedOrders;
- (BOOL)commitPaymentInfo:(JFPaymentInfo *)paymentInfo;
@end
