//
//  SocialButton.m
//  140Pulse
//
//  Created by qijun on 29/7/13.
//  Copyright (c) 2013 fengqijun. All rights reserved.
//

#import "SocialButton.h"
#import "SocialButton_Protected.h"

@implementation SocialButton

@synthesize imageSizeLimit = _imageSizeLimit;
@synthesize requestHandler = _requestHandler;

-(id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    }
    
    return self;
}

- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    self.networkStatus = [curReach currentReachabilityStatus];
}



- (NSData *)prepareImageData:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
    
    CGFloat compressionRate = self.imageSizeLimit / [imageData length];
    if (compressionRate > 1)
    {
        compressionRate = 1;
    }
    
    if (self.networkStatus != ReachableViaWiFi)
    {
        NSLog(@"connect not through wifi");
        if (compressionRate > 0.5)
        {
            compressionRate = 0.5;
        }
        
        NSLog(@"%f", compressionRate);
    }
    
    imageData = UIImageJPEGRepresentation(image, compressionRate);
    
    return imageData;
}

-(RequestHandler)requestHandlerWithCompletion:(void(^)(BOOL, NSString *))completion
{
    RequestHandler requestHandler = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
        int status = [urlResponse statusCode];
        
        if (status >= 200 && status < 300) {
            completion(YES, nil);
        }
        else
        {
            completion(NO, @"Failed");
        }
        
    };
    
    return requestHandler;
}


-(void)sendMessage:(NSString *)message Image:(UIImage *)image completion:(void (^)(BOOL, NSString *))completionHandler
{
    
}



@end
