//
//  JFDetailModel.h
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"







@interface JFDetailModel : JFEncryptedURLRequest

- (void)fetchProgramDetailWithProgramId:(NSInteger)programId CompletionHandler:(JFCompletionHandler)handler;

@end
