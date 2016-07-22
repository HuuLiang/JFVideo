//
//  JFAppSpreadModel.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFAppSpreadModel.h"

@implementation JFAppSpread

@end


@implementation JFAppSpreadResponse
- (Class)programListElementClass {
    return [JFAppSpread class];
}

@end

@implementation JFAppSpreadModel

+ (Class)responseClass {
    return [JFAppSpreadResponse class];
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(JFCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:JF_APPSPREAD_URL
                         withParams:nil
                    responseHandler:^(JFURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    NSArray *array = nil;
                    if (respStatus == JFURLResponseSuccess) {
                        JFAppSpreadResponse *resp = self.response;
                        array = [NSArray arrayWithArray:resp.programList];
                        _fetchedSpreads = [[NSMutableArray alloc] init];
                    }
                    for (NSInteger i = 0; i < array.count; i++) {
                        JFAppSpread *app = array[i];
                        [JFUtil checkAppInstalledWithBundleId:app.specialDesc completionHandler:^(BOOL isInstall) {
                            if (isInstall) {
                                app.isInstall = isInstall;
                                [_fetchedSpreads addObject:app];
                            } else {
                                [_fetchedSpreads insertObject:app atIndex:0];
                            }
                            if (_fetchedSpreads.count == array.count) {
                                if (handler) {
                                    handler(respStatus == JFURLResponseSuccess, _fetchedSpreads);
                                }
                            }
                        }];

                    }
                }];
    return ret;
}

@end
