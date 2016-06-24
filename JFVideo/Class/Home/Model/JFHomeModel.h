//
//  JFHomeModel.h
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"

@interface JFHomeModel : JFEncryptedURLRequest

- (void)fetchHomeInfoWithPage:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler;

@end
