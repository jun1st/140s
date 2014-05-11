//
//  JSAdvertisingPop.h
//  JSAdvertisingSDK
//
//  Created by Hirat on 14-4-15.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

#import "JSAdvertising.h"
#import "JSAdvertisingImage.h"

@interface JSAdvertisingPop : JSAdvertising

@property (readonly, nonatomic, strong) JSAdvertisingImage* image;     //图片
@property (readonly, nonatomic, strong) NSString* text;   //广告描述

@end
