//
//  JFAppSpreadModel.h
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFEncryptedURLRequest.h"

@interface JFAppSpread : NSObject
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSString *pkgName;
@property (nonatomic) NSString *postTime;
@property (nonatomic) NSUInteger programId;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSString *title;
@property (nonatomic) NSUInteger type;
@property (nonatomic) NSString *specialDesc;
@property (nonatomic) NSString *spreadImg;
@property (nonatomic) BOOL isInstall;
@end

@interface JFAppSpreadResponse : JFURLResponse
@property (nonatomic) NSArray <JFAppSpread *> *programList;
@end

@interface JFAppSpreadModel : JFEncryptedURLRequest
@property (nonatomic,retain,readonly) NSMutableArray<JFAppSpread *> *fetchedSpreads;
- (BOOL)fetchAppSpreadWithCompletionHandler:(JFCompletionHandler)handler;
@end
