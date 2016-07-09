//
//  JFPaymentManager.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentManager.h"
#import "JFPaymentConfigModel.h"

@implementation JFPaymentManager

+ (instancetype)sharedManager {
    static JFPaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setup {
    [[JFPaymentConfigModel sharedModel] fetchPaymentConfigInfoWithCompletionHandler:^(BOOL success, id obj) {
        
    }];
}

- (JFPaymentInfo *)startPaymentWithType:(JFPaymentType)type
                                subType:(JFPaymentType)subType
                                  price:(NSUInteger)price
                              baseModel:(JFBaseModel *)model
                      completionHandler:(JFPaymentCompletionHandler)handler {
    return nil;
}

- (void)handleOpenUrl:(NSURL *)url {
    
}

@end
