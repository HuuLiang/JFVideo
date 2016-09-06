//
//  NSObject+DictionaryRepresentation.m
//  JFuaibo
//
//  Created by Sean Yue on 16/5/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "NSObject+DictionaryRepresentation.h"
#import "NSObject+Properties.h"

NSString *const kPersistenceTypeKey = @"com.JFuaibo.persistenceTypeKey";

@implementation NSObject (DictionaryRepresentation)

+ (NSArray *)commonExcludedProperties {
    return @[@"debugDescription", @"description", @"hash"];
}

- (NSDictionary *)dictionaryRepresentationWithEncryptBlock:(JFPlistPersistenceCryptBlock)encryptBlock {
    NSArray *properties = self.allProperties;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [properties enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[[self class] commonExcludedProperties] containsObject:obj]) {
            return ;
        }
        
        id value = [self valueForKey:obj];
        if (!value) {
            return ;
        }
        
        if ([value isKindOfClass:[NSNumber class]]
            || [value isKindOfClass:[NSDate class]]) {
            [dic setObject:value forKey:obj];
        } else if ([value isKindOfClass:[NSString class]]) {
            NSString *password;
            if (encryptBlock) {
                password = encryptBlock(obj, self);
            }
            
            if (password) {
                [dic setObject:[value encryptedStringWithPassword:password] forKey:obj];
            } else {
                [dic setObject:value forKey:obj];
            }
        } else if ([value isKindOfClass:[NSArray class]]) {
            NSArray *valueArr = (NSArray *)value;
            if (valueArr.count == 0) {
                return ;
            }
            
            NSMutableDictionary *typeDic = [dic objectForKey:kPersistenceTypeKey];
            if (!typeDic) {
                typeDic = [NSMutableDictionary dictionary];
            }
            
            [typeDic setObject:NSStringFromClass([valueArr.firstObject class]) forKey:obj];
            [dic setObject:typeDic forKey:kPersistenceTypeKey];
            
            if ([valueArr.firstObject isKindOfClass:[NSString class]]
                || [valueArr.firstObject isKindOfClass:[NSNumber class]]
                || [valueArr.firstObject isKindOfClass:[NSDate class]]) {
                [dic setObject:value forKey:obj];
                return ;
            }
            
            NSMutableArray *arr = [NSMutableArray array];
            [dic setObject:arr forKey:obj];
            
            [valueArr enumerateObjectsUsingBlock:^(id  _Nonnull arrObj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *arrDic = [arrObj dictionaryRepresentationWithEncryptBlock:encryptBlock];
                if (arrDic) {
                    [arr addObject:arrDic];
                }
            }];

        } else if (value != nil) {
            NSDictionary *valueDic = [value dictionaryRepresentationWithEncryptBlock:encryptBlock];
            if (valueDic) {
                NSMutableDictionary *typeDic = [dic objectForKey:kPersistenceTypeKey];
                if (!typeDic) {
                    typeDic = [NSMutableDictionary dictionary];
                }
                
                [typeDic setObject:NSStringFromClass([value class]) forKey:obj];
                [dic setObject:typeDic forKey:kPersistenceTypeKey];
                
                [dic setObject:valueDic forKey:obj];
            }
        }
    }];
    return dic.count > 0 ? dic : nil;
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dic withDecryptBlock:(JFPlistPersistenceCryptBlock)decryptBlock {
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id object = [[self alloc] init];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:kPersistenceTypeKey]) {
            return ;
        }
        
        if ([obj isKindOfClass:[NSNumber class]]
            || [obj isKindOfClass:[NSDate class]]) {
            if ([object respondsToSelector:NSSelectorFromString(key)]) {
                [object setValue:obj forKey:key];
            }
        } else if ([obj isKindOfClass:[NSString class]]) {
            NSString *password;
            if (decryptBlock) {
                password = decryptBlock(key, object);
            }
            
            if ([object respondsToSelector:NSSelectorFromString(key)]) {
                if (password) {
                    [object setValue:[obj decryptedStringWithPassword:password] forKey:key];
                } else {
                    [object setValue:obj forKey:key];
                }
            }
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *objArr = (NSArray *)obj;
            if (objArr.count == 0) {
                return ;
            }
            
            if ([objArr.firstObject isKindOfClass:[NSString class]]
                || [objArr.firstObject isKindOfClass:[NSNumber class]]
                || [objArr.firstObject isKindOfClass:[NSDate class]]) {
                if ([object respondsToSelector:NSSelectorFromString(key)]) {
                    [object setValue:obj forKey:key];
                }
            } else if ([objArr.firstObject isKindOfClass:[NSDictionary class]]) {
                NSMutableArray *arr = [NSMutableArray array];
                NSDictionary *typeDic = dic[kPersistenceTypeKey];
                NSString *className = typeDic[key];
                Class objClass = NSClassFromString(className);
                if (!objClass) {
                    objClass = [objArr.firstObject class];
                }
                for (id arrObj in objArr) {
                    [arr addObject:[objClass objectFromDictionary:arrObj withDecryptBlock:decryptBlock]];
                }
                if ([object respondsToSelector:NSSelectorFromString(key)]) {
                    [object setValue:arr forKey:key];
                }
            }
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *className = dic[kPersistenceTypeKey][key];
            Class objClass = NSClassFromString(className);
            if (!objClass) {
                return ;
            }
            
            id instance = [objClass objectFromDictionary:obj withDecryptBlock:nil];
            if (instance) {
                [object setValue:instance forKey:key];
            }
        }
    }];
    return object;
}

+ (BOOL)persist:(NSArray *)objects inSpace:(NSString *)spaceName withPrimaryKey:(NSString *)primaryKey clearBeforePersistence:(BOOL)shouldClear encryptBlock:(JFPlistPersistenceCryptBlock)encryptBlock {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths.firstObject;
    if (!path) {
        return NO;
    }
    
    NSString *file = [NSString stringWithFormat:@"%@/%@", path, spaceName];
    NSMutableArray *arr = shouldClear ? [NSMutableArray array] : [NSArray arrayWithContentsOfFile:file].mutableCopy ?: [NSMutableArray array];
    // Remove all elements that have the same primary key value.
    NSArray *updateObjects = [arr bk_select:^BOOL(id obj) {
        id primaryValue = [arr valueForKey:primaryKey];
        return [objects bk_any:^BOOL(id obj) {
            return [[obj valueForKey:primaryKey] isEqual:primaryValue];
        }];
    }];
    [arr removeObjectsInArray:updateObjects];
    
    [objects enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dicRep = [obj dictionaryRepresentationWithEncryptBlock:encryptBlock];
        if (dicRep) {
            [arr addObject:dicRep];
        }
    }];
    
    if (arr.count == 0) {
        return NO;
    }
    
    return [arr writeToFile:file atomically:YES];
}
@end