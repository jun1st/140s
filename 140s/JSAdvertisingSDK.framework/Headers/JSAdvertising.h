//
//  JSAdvertising.h
//  JSAdvertisingSDK
//
//  Created by Hirat on 14-4-15.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  广告数据模型的父类
 */

@interface JSAdvertising : NSObject

/*!
 *  广告ID
 */
@property (nonatomic, strong, readonly) NSString* adID;

/*!
 *  广告链接
 */
@property (nonatomic, strong, readonly) NSString* link;


/*!
 *  弹出时间 (没有时间类型的广告直接返回0)
 */
@property (readonly, nonatomic) double time;

/*!
 *  广告数据的初始化
 *
 *  @param adID       广告位ID
 *  @param attributes 广告数据
 *
 *  @return 广告
 */
- (instancetype)initWithID:(NSString*)adID
                attributes:(NSDictionary *)attributes;

@end
