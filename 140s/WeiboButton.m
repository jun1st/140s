//
//  WeiboButton.m
//  140Life
//
//  Created by qijun on 23/7/13.
//  Copyright (c) 2013 fengqijun.me. All rights reserved.
//

#import "WeiboButton.h"

#define WEIBO_TEXT_URL @"https://upload.api.weibo.com/2/statuses/update.json";
#define WEIBO_IMAGE_URL @"https://upload.api.weibo.com/2/statuses/upload.json";

@interface WeiboButton()
@property (strong, nonatomic) UIRoundedImageView * buttonImage;

@end

@implementation WeiboButton

-(id)init
{
    self = [super init];
    if (self)
    {
        self.titleLabel.text = @"Weibo";
        self.imageSizeLimit = 5 * 1024 * 1024; //5m
        self.buttonImage = [[UIRoundedImageView alloc] init];
        self.buttonImage.image = [UIImage imageNamed:@"weibo.png"];

        [self addSubview:self.buttonImage];
        self.hostname = @"www.weibo.com";
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
    self.buttonImage.frame = CGRectMake(self.frame.size.width - 57, 0, 57, 57);
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
    CGContextMoveToPoint(context, 0, 57/2);
    CGContextAddLineToPoint(context, rect.size.width-57, 57/2);
    CGContextSetLineWidth(context, 1.0f);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

-(void)sendMessage:(NSString *)message Image:(UIImage *)image completion:(void (^)(BOOL, NSString *))completionHandler
{
    
    if (!self.isHostReachable)
    {
        completionHandler(NO, @"Not able to access Weibo");
        return;
    }
    
    // Create an account store object.
	ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierSinaWeibo];
	
    RequestHandler requestHandler = [self requestHandlerWithCompletion:completionHandler];
    
    NSString * weiboUrl = WEIBO_TEXT_URL
    if (image)
    {
        weiboUrl = WEIBO_IMAGE_URL
    }
    
    AccountRequestHandler accountRequestHander = ^(BOOL granted, NSError *error)
    {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                
                ACAccount *sinaWeiboAccount = [accountsArray objectAtIndex:0];
                
                NSDictionary * parameters = @{@"status" : message, @"uid" : [sinaWeiboAccount valueForKeyPath:@"properties.user_id"] };
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeSinaWeibo
                                                        requestMethod:SLRequestMethodPOST
                                                                  URL:[NSURL URLWithString:weiboUrl]
                                                           parameters:parameters];
                if (image)
                {
                    NSData *imageData;
                    imageData = [self prepareImageData:image];

                    [request addMultipartData:imageData withName:@"pic" type:@"image/jpeg" filename:@"image.jpg"];
                }

                [request setAccount:sinaWeiboAccount];
                [request performRequestWithHandler:requestHandler];
                
            }
        }
        else
        {
            NSLog(@"%@", error);
            //No Account Settup
            if ([error code] == 6) {
                completionHandler(NO, @"Please setup your system weibo account first.");
            }
            else{
                completionHandler(NO, @"Please grant access to your weibo account");
            }
        }
    };
    
	// Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:accountRequestHander];
}

-(void)requestAccessWithCompletion:(void (^)(BOOL success, NSString * result))completionHandler;
{
    // Create an account store object.
	ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierSinaWeibo];
    
    AccountRequestHandler requestAccessHandler = ^(BOOL granted, NSError * error)
    {
        if(!granted)
        {
            //No Account Settup
            if ([error code] == 6) {
                completionHandler(NO, @"Please setup your system weibo account first.");
            }
            else{
                completionHandler(NO, @"Please grant access to your weibo account");
            }
        }
    };
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:requestAccessHandler];
}

@end
