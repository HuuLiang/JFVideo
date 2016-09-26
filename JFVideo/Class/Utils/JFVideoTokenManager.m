//
//  JFVideoTokenManager.m
//  JFVideo
//
//  Created by Liang on 16/9/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFVideoTokenManager.h"
#import <AFNetworking.h>
#import <NSDate+Utilities.h>
#import "JFActivateModel.h"

static NSString *const kTokenURL = @"http://token.iqu8.cn/token";//@"http://bbs.qu8cc.com/token";
static NSString *const kTokenDataEncryptionPassword = @"fdl_2016$@Ask^we";

@interface JFVideoTokenManager ()
@property (nonatomic) NSString *token;
@property (nonatomic,retain) NSDate *expireTime;
@property (nonatomic) NSString *userId;
@end

@implementation JFVideoTokenManager

+ (instancetype)sharedManager {
    static JFVideoTokenManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)requestTokenWithCompletionHandler:(JFVideoTokenCompletionHandler)completionHandler {
    
    if (self.token && self.expireTime && self.userId) {
        if ([self.expireTime isLaterThanDate:[NSDate date]]) {
            QBSafelyCallBlock(completionHandler, YES, self.token, self.userId);
            return ;
        }
    }
    
    if (![JFUtil userId]) {
        @weakify(self);
        [[JFActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
            @strongify(self);
            if (success) {
                [self httpRequestTokenWithUserId:userId completionHandler:completionHandler];
            } else {
                QBSafelyCallBlock(completionHandler, NO, nil, nil);
            }
        }];
    } else {
        [self httpRequestTokenWithUserId:[JFUtil userId] completionHandler:completionHandler];
    }
    
}

- (void)httpRequestTokenWithUserId:(NSString *)userId completionHandler:(JFVideoTokenCompletionHandler)completionHandler {
    if (userId == nil) {
        QBSafelyCallBlock(completionHandler, NO, nil, nil);
        return ;
    }
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *dataString = [NSString stringWithFormat:@"uid=%@&channelNo=%@&appId=%@", userId, JF_CHANNEL_NO, JF_REST_APPID];
    NSDictionary *params = @{@"data":[dataString encryptedStringWithPassword:kTokenDataEncryptionPassword]};
    
    @weakify(self);
    [sessionManager POST:kTokenURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *encryptedData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *dataString = [encryptedData decryptedStringWithPassword:kTokenDataEncryptionPassword];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        QBLog(@"Token request response: %@", dic);
        
        NSString *token = dic[@"token"];
        NSNumber *expireTime = dic[@"expireTime"];
        
        if (!token || !expireTime) {
            QBSafelyCallBlock(completionHandler, NO, nil, nil);
            return ;
        }
        
        @strongify(self);
        self.userId = userId;
        self.token = token;
        self.expireTime = [NSDate dateWithTimeIntervalSinceNow:expireTime.integerValue/2];
        QBSafelyCallBlock(completionHandler, YES, token, userId);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QBLog(@"Token request error: %@", error.localizedDescription);
        QBSafelyCallBlock(completionHandler, NO, nil, nil);
    }];
}

- (NSString *)videoLinkWithOriginalLink:(NSString *)originalLink {
    if (!self.token || !self.userId) {
        return originalLink;
    }
    
    NSString *videoLink = [NSString stringWithFormat:@"%@?uid=%@&token=%@&verCode=%@", originalLink, self.userId, self.token, @"20160923"];
    return videoLink;
}
@end

