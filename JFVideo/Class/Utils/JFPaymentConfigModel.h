//
//  JFPaymentConfigModel.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"

@interface LTIAppPayConfig : NSObject <NSCoding>
@property (nonatomic) NSString *appid;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *publicKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@property (nonatomic) NSNumber *supportPayTypes;
@end

@interface JFPaymentConfigResponse : JFURLResponse
@property (nonatomic) LTIAppPayConfig *iappPayInfo;
@end

@interface JFPaymentConfigModel : JFEncryptedURLRequest
+ (instancetype)sharedModel;
- (BOOL)fetchPaymentConfigInfoWithCompletionHandler:(JFCompletionHandler)handler;
@end
