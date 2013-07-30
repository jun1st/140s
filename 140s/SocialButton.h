//
//  SocialButton.h
//  140Pulse
//
//  Created by qijun on 29/7/13.
//  Copyright (c) 2013 fengqijun. All rights reserved.
//

#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

typedef void (^RequestHandler)(NSData *, NSHTTPURLResponse *, NSError *);
typedef void (^AccountRequestHandler)(BOOL, NSError *);

#import <Foundation/Foundation.h>
#import "UIRoundedImageView.h"
#import "Reachability.h"

@protocol SocialButtonProtocol <NSObject>

@required
-(void)sendMessage:(NSString *)message Image:(UIImage *)image completion: (void (^)(BOOL successful, NSString *result)) completionHandler;

@end


@interface SocialButton : UIButton<SocialButtonProtocol>
{
    @protected
    float _imageSizeLimit;
    RequestHandler _requestHandler;
}

@property (strong, nonatomic) UIRoundedImageView * buttonImage;
@property (nonatomic) NetworkStatus networkStatus;

- (void) reachabilityChanged: (NSNotification* )note;
- (NSData *)prepareImageData:(UIImage *)image;
- (RequestHandler)requestHandlerWithCompletion:(void(^)(BOOL, NSString *))completion;


@end
