//
//  JSApplicationNetworkManager.h
//  JSApplicationNetworkManager
//
//  Created by Hirat on 14-4-14.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  向苹果服务器请求App数据，获取App名称/Icon/版本号等数据
 */

@interface JSApplicationNetworkManager : NSObject

/*!
 *   通过这个单例调用请求数据的接口
 *
 *  @return 单例
 */
+ (instancetype)sharedInstance;

/*!
 *  向苹果服务器请求App数据
 *
 *  @param appIds  appID 数组
 *  @param success 成功（返回App数据）
 *  @param failure 失败（返回错误信息）
 */
- (void)loadAppsWithIds:(NSArray*)appIds
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

/*!
 *  向苹果服务器请求App数据
 *
 *  @param appBundleIds bundleID 数组
 *  @param success      成功（返回App数据）
 *  @param failure      失败（返回错误信息）
 */
- (void)loadAppsWithBundleIds:(NSArray*)appBundleIds
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/*!
 *  向苹果服务器请求App数据
 *
 *  @param appIds       appID 数组
 *  @param appBundleIds bundleID 数组 （跟上一个参数2选1，只有当appID没填写时，才调用该参数）
 *  @param success      成功（返回App数据）
 *  @param failure      失败（返回错误信息）
 */
- (void)loadAppsWithIds:(NSArray*)appIds
           appBundleIds:(NSArray*)appBundleIds
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;


@end
