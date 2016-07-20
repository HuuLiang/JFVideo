//
//  JFHomeModel.m
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFHomeModel.h"

@implementation JFHomeModelResponse

- (Class)columnListElementClass {
    return [JFHomeColumnModel class];
}
@end

@implementation JFHomeModel

+ (Class)responseClass {
    return [JFHomeModelResponse class];
}

- (BOOL)fetchHomeInfoWithPage:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"page":@(page)};
    BOOL success = [self requestURLPath:JF_HOME_URL
                             withParams:params
                        responseHandler:^(JFURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        NSArray *array = nil;
                        if (respStatus == JFURLResponseSuccess) {
                            JFHomeModelResponse *resp = self.response;
                            array = resp.columnList;
                        }
                        
                        if (handler) {
                            handler(respStatus==JFURLResponseSuccess, array);
                        }
                    }];
    
    return success;
}

@end