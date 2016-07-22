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
                    if (respStatus == JFURLResponseSuccess) {
                        JFAppSpreadResponse *resp = self.response;
//                        _fetchSpreadChannel = resp;
                        _fetchedSpreads = [NSMutableArray arrayWithArray:resp.programList];
                    }
                    for (NSInteger i = 0; i < _fetchedSpreads.count; i++) {
                        JFAppSpread *app = _fetchedSpreads[i];
                        [JFUtil checkAppInstalledWithBundleId:app.specialDesc completionHandler:^(BOOL isInstall) {
                            if (isInstall) {
                                app.isInstall = isInstall;
                                [_fetchedSpreads removeObject:app];
                                [_fetchedSpreads addObject:app];
                            }
                            if (i == _fetchedSpreads.count - 1) {
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
