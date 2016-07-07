//
//  JFChannelProgramModel.m
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelProgramModel.h"

@implementation JFChannelProgram

@end

@implementation JFChannelProgramResponse

- (Class)programListElementClass {
    return [JFChannelProgram class];
}
@end

@implementation JFChannelProgramModel

+ (Class)responseClass {
    return [JFChannelProgramResponse class];
}

- (BOOL)fecthChannelProgramWithColumnId:(NSInteger)columnId Page:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"page":[NSString stringWithFormat:@"%ld",page],
                             @"columnId":[NSString stringWithFormat:@"%ld",columnId]};
    BOOL success = [self requestURLPath:JF_PROGRAM_URL
                             withParams:params
                        responseHandler:^(JFURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        NSArray *array = nil;
                        if (respStatus == JFURLResponseSuccess) {
                            JFChannelProgramResponse *resp = self.response;
                            array = resp.programList;
                        }
                        
                        if (handler) {
                            handler(respStatus==JFURLResponseSuccess, array);
                        }
                    }];
    
    return success;

}

@end
