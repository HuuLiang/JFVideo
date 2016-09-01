//
//  NSObject+DictionaryRepresentation.h
//  JFuaibo
//
//  Created by Sean Yue on 16/5/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPersistenceTypeKey;

typedef NSString * (^JFPlistPersistenceCryptBlock)(NSString *propertyName, id instance);

@interface NSObject (DictionaryRepresentation)

- (NSDictionary *)dictionaryRepresentationWithEncryptBlock:(JFPlistPersistenceCryptBlock)encryptBlock;
+ (instancetype)objectFromDictionary:(NSDictionary *)dic withDecryptBlock:(JFPlistPersistenceCryptBlock)decryptBlock;
+ (BOOL)persist:(NSArray *)objects inSpace:(NSString *)spaceName withPrimaryKey:(NSString *)primaryKey clearBeforePersistence:(BOOL)shouldClear encryptBlock:(JFPlistPersistenceCryptBlock)encryptBlock;


@end
