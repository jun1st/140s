//
//  SocialButton.m
//  140Pulse
//
//  Created by qijun on 29/7/13.
//  Copyright (c) 2013 fengqijun. All rights reserved.
//

#import "SocialButton.h"
#import "SocialButton_Protected.h"

@interface SocialButton()

@property (nonatomic, strong) Reachability * internetReachability;

@end

@implementation SocialButton

@synthesize imageSizeLimit = _imageSizeLimit;
@synthesize requestHandler = _requestHandler;
@synthesize hostname = _hostname;
@synthesize hostReachability = _hostReachability;

-(id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
    }
    
    return self;
}

- (void)reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NSLog(@"%u", [curReach currentReachabilityStatus]);
    if (curReach == self.internetReachability)
    {
        self.networkStatus = [curReach currentReachabilityStatus];
    }
    if (curReach == self.hostReachability)
    {
        self.isHostReachable = [curReach currentReachabilityStatus] != NotReachable;
    }
    
}


- (NSData *)prepareImageData:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
    
    CGFloat compressionRate = floorf(self.imageSizeLimit / [imageData length]);
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
            completion(YES, NSLocalizedString(@"Message Posted", @"success"));
        }
        else
        {
            completion(NO, NSLocalizedString(@"Sorry, Please try again later", @"failed"));
        }
        
    };
    
    return requestHandler;
}


-(void)sendMessage:(NSString *)message Image:(UIImage *)image completion:(void (^)(BOOL, NSString *))completionHandler
{
    
}



@end
