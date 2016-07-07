//
//  JFChannelModel.h
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"
#import "JFChannelColumnModel.h"

@interface JFChannelModelResponse : JFURLResponse
@property (nonatomic) NSArray <JFChannelColumnModel *> *columnList;
@end

@interface JFChannelModel : JFEncryptedURLRequest

- (BOOL)fetchChannelInfoWithPage:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler;

@end
