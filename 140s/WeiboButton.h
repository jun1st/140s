//
//  WeiboButton.h
//  140Life
//
//  Created by qijun on 23/7/13.
//  Copyright (c) 2013 fengqijun.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialButton.h"
#import "SocialButton_Protected.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface WeiboButton : SocialButton

-(void)requestAccessWithCompletion:(void (^)(BOOL success, NSString * result))completionHandler;

@end
