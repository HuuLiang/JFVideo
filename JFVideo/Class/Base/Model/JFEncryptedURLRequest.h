//
//  JFEncryptedURLRequest.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFURLRequest.h"

@interface JFEncryptedURLRequest : JFURLRequest

+ (NSString *)signKey;
+ (NSDictionary *)commonParams;
+ (NSArray *)keyOrdersOfCommonParams;
- (NSDictionary *)encryptWithParams:(NSDictionary *)params;
- (id)decryptResponse:(id)encryptedResponse;


@end
