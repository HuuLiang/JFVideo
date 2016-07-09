//
//  JFPaymentConfigModel.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"
#import "JFPaymentConfig.h"

@interface JFPaymentConfigModel : JFEncryptedURLRequest
@property (nonatomic,readonly) BOOL loaded;
+ (instancetype)sharedModel;
- (BOOL)fetchPaymentConfigInfoWithCompletionHandler:(JFCompletionHandler)handler;
@end
