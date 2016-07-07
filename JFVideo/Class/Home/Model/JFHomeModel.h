//
//  JFHomeModel.h
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"
#import "JFHomeColumnModel.h"

@interface JFHomeModelResponse : JFURLResponse
@property (nonatomic) NSArray <JFHomeColumnModel *> *columnList;
@end

@interface JFHomeModel : JFEncryptedURLRequest

- (BOOL)fetchHomeInfoWithPage:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler;

@end
