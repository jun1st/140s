//
//  JSAdvertisingForcibly.h
//  JSAdvertisingSDK
//
//  Created by Hirat on 14-4-15.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

#import <JSAdvertisingSDK/JSAdvertisingSDK.h>

@interface JSAdvertisingForcibly : JSAdvertising

@property (readonly, nonatomic, strong) NSString* title;    //广告标题
@property (readonly, nonatomic, strong) NSString* text;     //广告描述
@property (readonly, nonatomic, strong) NSString* sure;     //确定按钮的文字

@end
