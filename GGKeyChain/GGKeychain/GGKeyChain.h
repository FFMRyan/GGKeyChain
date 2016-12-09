//
//  GGKeyChain.h
//  GGKeyChain
//
//  Created by iOSGeekOfChina on 2016/12/9.
//  Copyright © 2016年 iOSGeekOfChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGKeyChain : NSObject

//add key
+ (BOOL)addPasswordAndUserName:(NSString *)userName andPassword:(NSString *)password andUserId: (NSString *)userId andServiceName:(NSString *)serviceName;

//delete all key
+ (BOOL)delteAllKeyWithService:(NSString *)serviceName;

//delete key
+ (BOOL)deletedPasswordAndUserNameWithUserId:(NSString *)userId andServiceName:(NSString *)serviceName;


//updata key
+ (BOOL)updataPasswordAndUserName:(NSString *)userName andPassword:(NSString *)password andUserId:(NSString *)userId andServiceName:(NSString *)serviceName;

//find key
+ (NSArray *)findPasswordAndUserNameWithService:(NSString *)serviceName;

//find key
+ (NSDictionary *)findOnePasswordAndUserNameWithService:(NSString *)serviceName andUserId:(NSString *)userId;

@end
