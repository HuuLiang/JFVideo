//
//  JFUserAccessModel.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"

typedef void (^JFUserAccessCompletionHandler)(BOOL success);

@interface JFUserAccessModel : JFEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)requestUserAccess;

@end
