//
//  JFVideoTokenManager.h
//  JFVideo
//
//  Created by Liang on 16/9/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JFVideoTokenCompletionHandler)(BOOL success, NSString *token, NSString *userId);

@interface JFVideoTokenManager : NSObject

+ (instancetype)sharedManager;

- (void)requestTokenWithCompletionHandler:(JFVideoTokenCompletionHandler)completionHandler;
- (NSString *)videoLinkWithOriginalLink:(NSString *)originalLink;
- (void)setValue:(NSString *)value forVideoHttpHeader:(NSString *)field;

@end
