//
//  JFChannelModel.m
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelModel.h"

@implementation JFChannelModelResponse

- (Class)columnListElementClass {
    return [JFChannelColumnModel class];
}

@end

@implementation JFChannelModel

+ (Class)responseClass {
    return [JFChannelModelResponse class];
}

- (BOOL)fetchChannelInfoWithPage:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JF_CHANNELRANKING_URL
                             withParams:nil
                        responseHandler:^(JFURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        NSArray *array = nil;
                        if (respStatus == JFURLResponseSuccess) {
                            JFChannelModelResponse *resp = self.response;
                            array = resp.columnList;
                        }
                        
                        if (handler) {
                            handler(respStatus==JFURLResponseSuccess, array);
                        }
                    }];
    
    return success;
}

@end
