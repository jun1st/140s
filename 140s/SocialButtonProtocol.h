//
//  SocialButtonProtocol.h
//  140Life
//
//  Created by qijun on 24/7/13.
//  Copyright (c) 2013 fengqijun.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocialButtonProtocol <NSObject>

@required
-(void)sendMessage:(NSString *)message Image:(UIImage *)image completion: (void (^)(BOOL successful, NSString *result)) completionHandler;

@end
