//
//  JSAdvertisingManager.h
//  JSAdvertisingSDK
//
//  Created by Hirat on 14-4-14.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JSAdvertisingStatus)
{
    JSAdvertisingStatusHide,    //隐藏广告
    JSAdvertisingStatusShow     //显示广告
};

typedef NS_ENUM(NSInteger, JSAdvertisingStyle)
{
    JSAdvertisingStylePop,      //弹出广告
    JSAdvertisingStyleAlert,    //系统风格弹出广告
    JSAdvertisingStyleOnlyOne,  //这种类型的广告只弹出一次
    JSAdvertisingStyleList,     //列表插播广告（需要手动获取+展示）
    JSAdvertisingStyleForcibly, //强制广告
    JSAdvertisingStyleBanner,   //Banner条广告 (预留)
    JSAdvertisingStyleDefault   //其他 (预留)
};

@interface JSAdvertisingManager : NSObject

/// 配置广告的应用ID，后台通过这个ID来配置相应的广告数据
@property (nonatomic, strong) NSString* appId;

/// 列表广告广告位ID数组
@property (nonatomic, strong) NSArray* listAdIdArray;

/// 列表广告在列表中展示的位置
@property (nonatomic, strong) NSArray* listAdPositionArray;

/// 是否显示广告
@property (readonly ,nonatomic) JSAdvertisingStatus status;

/*!
 *  广告管理模块的单例
 *
 *  @return 单例
 */
+ (instancetype)sharedInstance;

/*!
 *  广告点击事件上传到服务器
 *
 *  @param adID 广告ID
 */
- (void)advertisingClick:(NSString*)adID;

/**
 *  根据广告类型从所有广告数据中分离出相应的广告
 *
 *  @param style 广告类型
 *
 *  @return 筛选出来的广告数据
 */
- (NSDictionary*)advertisingWithStyle:(JSAdvertisingStyle)style;

/*!
 *  根据广告类型返回相应的广告，在接受到 kJSAdvertisingGetInfoNotification 通知之后调用，否则返回的数据为空
 *
 *  @param style 广告类型
 *
 *  @return 广告数据数组
 */
- (NSArray*)advertisingsWithStyle:(JSAdvertisingStyle)style;

/*!
 *  返回列表广告在列表中的位置
 *
 *  @param adInfo 广告位ID
 *
 *  @return 广告位置
 */
- (NSInteger)advertisingPosition:(NSString*)theAdid;

@end

///获取到广告数据，可以截获这个消息，处理相应的广告数据
extern NSString* const kJSAdvertisingGetInfoNotification;

