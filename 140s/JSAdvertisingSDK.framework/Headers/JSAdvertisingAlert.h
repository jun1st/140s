//
//  JSAdvertisingAlert.h
//  JSAdvertisingSDK
//
//  Created by Hirat on 14-4-15.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

#import "JSAdvertising.h"

@interface JSAdvertisingAlert : JSAdvertising

@property (readonly, nonatomic, strong) NSString* title;    //广告标题
@property (readonly, nonatomic, strong) NSString* text;     //广告描述
@property (readonly, nonatomic, strong) NSString* sure;     //确定按钮的文字
@property (readonly, nonatomic, strong) NSString* cancel;   //取消按钮的文字

@end
