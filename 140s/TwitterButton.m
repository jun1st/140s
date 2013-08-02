//
//  TweittboButton.m
//  Tweittbo
//
//  Created by qijun on 18/4/13.
//  Copyright (c) 2013 qijun. All rights reserved.
//

#import "TwitterButton.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#define TWITTER_TEXT_URL @"https://api.twitter.com/1.1/statuses/update.json";
#define TWITTER_IMAGE_URL @"https://api.twitter.com/1.1/statuses/update_with_media.json";

@interface TwitterButton()

@end
@implementation TwitterButton

-(id)init
{
    self = [super init];
    if (self)
    {
        self.imageSizeLimit = 3145728.0f;
        self.buttonImage = [[UIRoundedImageView alloc] init];
        self.buttonImage.image = [UIImage imageNamed:@"twitter.png"];
        [self addSubview:self.buttonImage];
        
        self.hostname = @"www.twitter.com";
        
        self.hostReachability = [Reachability reachabilityWithHostName:self.hostname];
        [self.hostReachability startNotifier];
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    self.buttonImage.frame = CGRectMake(0, 0, 57, 57);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, 57, 57/2);
    CGContextAddLineToPoint(context, rect.size.width, 57/2);
    CGContextSetLineWidth(context, 1.0f);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
}

#pragma SocialButton protocol
-(void)sendMessage:(NSString *)message Image:(UIImage *)image completion:(void (^)(BOOL, NSString *))completionHandler
{
    
    if (!self.isHostReachable)
    {
        completionHandler(NO, @"Not able to access twitter");
        return;
    }
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    RequestHandler requestHandler = [self requestHandlerWithCompletion:completionHandler];
    
    NSString * twitterUrl = TWITTER_TEXT_URL;
    if (image)
    {
        twitterUrl = TWITTER_IMAGE_URL;
    }
    
    AccountRequestHandler requestAccessHandler = ^(BOOL granted, NSError * error)
    {
        if (granted)
        {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                NSDictionary *parameters = @{@"status" : message};
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                        requestMethod:SLRequestMethodPOST
                                                                  URL:[NSURL URLWithString:twitterUrl]
                                                           parameters:parameters];
                
                // Set the account used to post the tweet.
                [request setAccount:twitterAccount];
                
                if (image)
                {
                    NSData *imageData;
                    imageData = [self prepareImageData:image];
                    
                    [request addMultipartData:imageData withName:@"media[]" type:@"image/jpeg" filename:@"image.jpg"];
                }
                
                // Perform the request created above and create a handler block to handle the response.
                [request performRequestWithHandler:requestHandler];
            }
        }
        else
        {
            if ([error code] == 6)
            {
                completionHandler(NO, @"Please setup your twitter account in System first!");
            }
            else
            {
                completionHandler(NO, @"Please grant access to your twitter account");
            }
        }
    };
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:requestAccessHandler];
}

-(void)requestAccessWithCompletion:(void (^)(BOOL success, NSString * result))completionHandler
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    AccountRequestHandler requestAccessHandler = ^(BOOL granted, NSError * error)
    {
        if(!granted)
        {
            if ([error code] == 6)
            {
                completionHandler(NO, @"Please setup your twitter account in System first!");
            }
            else
            {
                completionHandler(NO, @"Please grant access to your twitter account");
            }
        }
    };
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:requestAccessHandler];
}

@end
