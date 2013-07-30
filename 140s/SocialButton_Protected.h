//
//  SocialButton_Protected.h
//  140Pulse
//
//  Created by qijun on 29/7/13.
//  Copyright (c) 2013 fengqijun. All rights reserved.
//

#import "SocialButton.h"

@interface SocialButton ()

@property (nonatomic) float imageSizeLimit;
@property (nonatomic, strong) RequestHandler requestHandler;
@property (nonatomic, strong) NSString * hostname;
@property (nonatomic, strong) Reachability * hostReachability;
@end
