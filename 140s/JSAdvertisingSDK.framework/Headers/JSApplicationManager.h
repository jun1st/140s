//
//  JSApplicationManager.h
//  JSApplicationManager
//
//  Created by Hirat on 14-4-14.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface JSApplicationManager : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, strong, readonly) Reachability* reachability; //判断联网状态

@property (nonatomic, strong, readonly) NSString* appStoreID;
@property (nonatomic, strong, readonly) NSString* appName;
@property (nonatomic, strong, readonly) NSString* appURL;
@property (nonatomic, strong, readonly) NSString* appVersion;
@property (nonatomic, strong, readonly) NSString* appBundleID;
@property (nonatomic, strong, readonly) NSString* releaseNotes;

@end

/// 从AppStore获取到本应用的信息
extern NSString *const kJSAdvertisingGetAppInfoNotification;

/// 是否展示广告
extern NSString *const kJSAdvertisingNotificationStatusShowAdvertising;