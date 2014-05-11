//
//  JSAdvertisingList.h
//  JSAdvertisingSDK
//
//  Created by Hirat on 14-4-15.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

#import "JSAdvertising.h"
#import "JSAdvertisingImage.h"

/*!
 *  列表中的插播广告
 */

@interface JSAdvertisingList : JSAdvertising

/*!
 *  图片
 */
@property (readonly, nonatomic, strong) JSAdvertisingImage* image;

/*!
 *  广告文案
 */
@property (readonly, nonatomic, strong) NSString* text;


@end
