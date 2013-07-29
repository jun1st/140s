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

- (NSData *)prepareImageData:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
    
    if ([imageData length] > self.imageSizeLimit)
    {
        CGFloat compressionRate = self.imageSizeLimit / [imageData length];
        imageData = UIImageJPEGRepresentation(image, compressionRate);
    }
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
            NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            completion(NO, @"Failed");
        }
        
    };
    
    return requestHandler;
}


-(void)sendMessage:(NSString *)message Image:(UIImage *)image completion:(void (^)(BOOL, NSString *))completionHandler
{
    
}



@end
