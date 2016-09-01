//
//  JFURLResponse.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JFResponseParsable <NSObject>

@optional
- (Class)JF_classOfProperty:(NSString *)propName;
- (NSString *)JF_propertyOfParsing:(NSString *)parsingName;

@end


@interface JFURLResponse : NSObject

@property (nonatomic) NSNumber *success;
@property (nonatomic) NSString *resultCode;
@property (nonatomic) NSString *response_code;
//@property (nonatomic) NSUI

- (void)parseResponseWithDictionary:(NSDictionary *)dic;

@end
