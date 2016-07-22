//
//  JFNetworkInfo.h
//  JFuaibo
//
//  Created by Sean Yue on 16/5/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JFNetworkStatus) {
    JFNetworkStatusUnknown = -1,
    JFNetworkStatusNotReachable = 0,
    JFNetworkStatusWiFi = 1,
    JFNetworkStatus2G = 2,
    JFNetworkStatus3G = 3,
    JFNetworkStatus4G = 4
};

@interface JFNetworkInfo : NSObject

@property (nonatomic,readonly) JFNetworkStatus networkStatus;
@property (nonatomic,readonly) NSString *carriarName;

+ (instancetype)sharedInfo;
- (void)startMonitoring;

@end
