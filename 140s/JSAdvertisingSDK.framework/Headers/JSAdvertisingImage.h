//
//  JSAdvertisingImage.h
//  JSAdvertisingSDK
//
//  Created by Hirat on 14-4-15.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSAdvertisingImage : NSObject

/*!
 *  图片宽度
 */
@property (nonatomic) NSInteger width;

/*!
 *  图片高度
 */
@property (nonatomic) NSInteger height;

/*!
 *  图片路径
 */
@property (nonatomic, strong) NSString* path;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
