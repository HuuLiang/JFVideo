//
//  JFURLResponse.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFURLResponse : NSObject

@property (nonatomic) NSNumber *Result;
@property (nonatomic) NSString *Msg;

- (void)parseResponseWithDictionary:(NSDictionary *)dic;

@end
