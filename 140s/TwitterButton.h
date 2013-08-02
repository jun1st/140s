//
//  TweittboButton.h
//  Tweittbo
//
//  Created by qijun on 18/4/13.
//  Copyright (c) 2013 qijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialButton.h"
#import "SocialButton_Protected.h"

@interface TwitterButton : SocialButton

-(void)requestAccessWithCompletion:(void (^)(BOOL success, NSString * result))completionHandler;

@end
