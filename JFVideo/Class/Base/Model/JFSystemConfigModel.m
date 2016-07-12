//
//  JFSystemConfigModel.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFSystemConfigModel.h"

@implementation JFSystemConfigResponse

- (Class)confisElementClass {
    return [JFSystemConfig class];
}

@end

@implementation JFSystemConfigModel

+ (instancetype)sharedModel {
    static JFSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JFSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [JFSystemConfigResponse class];
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(JFFetchSystemConfigCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JF_SYSTEM_CONFIG_URL
                             withParams:nil
                        responseHandler:^(JFURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        DLog("%ld %@",respStatus,errorMessage);
                        
                        if (respStatus == JFURLResponseSuccess) {
                            JFSystemConfigResponse *resp = self.response;
                            
                            [resp.confis enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                JFSystemConfig *config = obj;
                                
                                if ([config.name isEqualToString:@"PAY_AMOUNT"]) {
                                    [JFSystemConfigModel sharedModel].payAmount = [config.value integerValue];
                                }
                            }];
                        }
                        
                        if (handler) {
                            handler(respStatus == JFURLResponseSuccess);
                        }
                        
                    }];
    return success;
    
}


@end
