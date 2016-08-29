//
//  JFSystemConfigModel.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"
#import "JFSystemConfig.h"

@interface JFSystemConfigResponse : JFURLResponse
@property (nonatomic,retain) NSArray<JFSystemConfig> *confis;
@end

typedef void (^JFFetchSystemConfigCompletionHandler)(BOOL success);

@interface JFSystemConfigModel : JFEncryptedURLRequest

@property (nonatomic) NSInteger payAmount;
@property (nonatomic) NSString *contactScheme;
@property (nonatomic,copy)NSString *contactName;

+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(JFFetchSystemConfigCompletionHandler)handler;

@end
