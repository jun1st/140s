//
//  TweittboButton.m
//  Tweittbo
//
//  Created by qijun on 18/4/13.
//  Copyright (c) 2013 qijun. All rights reserved.
//

#import "TwitterButton.h"
#import "UIRoundedImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TwitterButton()

@property (strong, nonatomic) UIRoundedImageView * buttonImage;

@end
@implementation TwitterButton

-(id)init
{
    self = [super init];
    if (self)
    {
        self.buttonImage = [[UIRoundedImageView alloc] init];
        self.buttonImage.image = [UIImage imageNamed:@"twitter.png"];
        [self addSubview:self.buttonImage];
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
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    void (^requestHandler)(NSData *, NSHTTPURLResponse *, NSError *) = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
        int status = [urlResponse statusCode];
        
        if (status >= 200 && status < 300) {
            completionHandler(YES, nil);
        }
        else
        {
            NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            completionHandler(NO, @"Failed");
        }
        
    };
    
    NSString * twitterUrl = @"https://api.twitter.com/1.1/statuses/update.json";
    if (image)
    {
        twitterUrl = @"https://api.twitter.com/1.1/statuses/update_with_media.json";
    }
    
    void (^requestAccessHandler)(BOOL, NSError *) = ^(BOOL granted, NSError * error)
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
                    NSData *imageData = UIImageJPEGRepresentation(image, 1.f);

                    
                    //3145728
                    //[imageData length];
                    
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

@end
