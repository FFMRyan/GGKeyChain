//
//  GGKeyChain.m
//  GGKeyChain
//
//
//
//  Created by iOSGeekOfChina on 2016/12/9.
//  Copyright © 2016年 iOSGeekOfChina. All rights reserved.
//
//  @dict:
//        NSString *acccount = dict[(id)kSecAttrAccount];
//        NSData *data = dict[(id)kSecValueData];
//        NSString *pwd = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSString *service = dict[(id)kSecAttrService];
//        NSLog(@"==result:%@", dict);
//


#import "GGKeyChain.h"

@implementation GGKeyChain


//add key
+ (BOOL)addPasswordAndUserName:(NSString *)userName andPassword:(NSString *)password andUserId: (NSString *)userId andServiceName:(NSString *)serviceName{
    
    if (!userName || !password || !userId || !serviceName) {
        return NO;
    }
    //is have?
    NSDictionary * findOneDict =  [GGKeyChain findOnePasswordAndUserNameWithService:serviceName andUserId:userId];
    if (findOneDict) {
        BOOL updateSuccess = NO;
        updateSuccess = [GGKeyChain updataPasswordAndUserName:userName andPassword:password andUserId:userId andServiceName:serviceName];
        return updateSuccess;
    }else{
        NSDictionary *query = @{(__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlocked,
                                (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecValueData : [password dataUsingEncoding:NSUTF8StringEncoding],
                                (__bridge id)kSecAttrAccount : userName,
                                (__bridge id)kSecAttrService : serviceName,
                                (__bridge id)kSecAttrDescription: userId,
                                };
        
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, nil);
        
        if (status != noErr) {
            return NO;
        }
        return YES;
    }
    
}
//delete all key
+ (BOOL)delteAllKeyWithService:(NSString *)serviceName{
    NSDictionary *query = @{
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService : serviceName,
                            };
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != noErr) {
        return NO;
    }
    return YES;
}
//delete key
+ (BOOL)deletedPasswordAndUserNameWithUserId:(NSString *)userId andServiceName:(NSString *)serviceName{
    
    if (!userId || !serviceName || !userId) {
        return NO;
    }
    
    //is have
    NSDictionary * findOneDict =  [GGKeyChain findOnePasswordAndUserNameWithService:serviceName andUserId:userId];
    if (!findOneDict) {
        return NO;
    }
    
    NSDictionary *query = @{
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService : serviceName,
                            (__bridge id)kSecAttrDescription : userId,
                            };
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != noErr) {
        return NO;
    }
    return YES;
}
//update key
+ (BOOL)updataPasswordAndUserName:(NSString *)userName andPassword:(NSString *)password andUserId:(NSString *)userId andServiceName:(NSString *)serviceName{
    
    if (!userName || !password || !userId || !serviceName) {
        return NO;
    }
    //is have
    NSDictionary * findOneDict =  [GGKeyChain findOnePasswordAndUserNameWithService:serviceName andUserId:userId];
    if (!findOneDict) {
        return NO;
    }
    
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrDescription : userId,
                            (__bridge id)kSecAttrService : serviceName,
                            };
    NSDictionary *update = @{
                             (__bridge id)kSecValueData : [password dataUsingEncoding:NSUTF8StringEncoding],
                             (__bridge id)kSecAttrAccount : userName,
                             };
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
    if (status != noErr) {
        return NO;
    }
    return YES;
}
//find key
+ (NSArray *)findPasswordAndUserNameWithService:(NSString *)serviceName{
    
    if (!serviceName) {
        return nil;
    }
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecReturnRef : @YES,
                            (__bridge id)kSecReturnData : @YES,
                            (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitAll,
                            (__bridge id)kSecAttrService : serviceName,
                            };
    
    CFTypeRef dataTypeRef = NULL;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataTypeRef);
    
    if (status == errSecSuccess) {
        
        NSArray *array = (__bridge NSArray *)dataTypeRef;
        return array;

    }
    return nil;
}
//find key
+ (NSDictionary *)findOnePasswordAndUserNameWithService:(NSString *)serviceName andUserId:(NSString *)userId{
    
    if (!serviceName || !userId) {
        return nil;
    }
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecReturnRef : @YES,
                            (__bridge id)kSecReturnData : @YES,
                            (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne,
                            (__bridge id)kSecAttrDescription : userId,
                            (__bridge id)kSecAttrService : serviceName,
                            };
    
    CFTypeRef dataTypeRef = NULL;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataTypeRef);
    
    if (status == errSecSuccess) {
        NSDictionary *dict = (__bridge NSDictionary *)dataTypeRef;
        return dict;
    }
    return nil;
}
@end
