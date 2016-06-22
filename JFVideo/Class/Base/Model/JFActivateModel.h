//
//  JFActivateModel.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"

typedef void (^JFActivateHandler)(BOOL success, NSString *userId);

@interface JFActivateModel : JFEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)activateWithCompletionHandler:(JFActivateHandler)handler;


@end
