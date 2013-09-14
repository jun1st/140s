//
//  MainViewController.m
//  Tweittbo
//
//  Created by qijun on 9/4/13.
//  Copyright (c) 2013 qijun. All rights reserved.
//

#import "MainViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "PrettyAlertView.h"
#import "SocialButton.h"
#import "Tweet+CoreData.h"
#import "TweetsViewController.h"


@interface MainViewController ()

@property (nonatomic, strong) UIImagePickerController * imagePickerController;

@end

@implementation MainViewController

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.textEdit setFont:[UIFont fontWithName:@"Signika" size:20.0f]];
    
    self.inputAccessoryView = [[[NSBundle mainBundle] loadNibNamed:@"InputAccessoryView" owner:self options:nil] lastObject];
    self.inputAccessoryView.delegate = self;
    
    self.textEdit.inputAccessoryView = self.inputAccessoryView;
    self.textEdit.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    self.twitterButton = [[TwitterButton alloc] init];
    [self.twitterButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.twitterButton];
    self.twitterButton.frame = CGRectMake(1000, 1000, 100, 57);
    self.weiboButton = [[WeiboButton alloc] init];
    [self.weiboButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.weiboButton];
    self.weiboButton.frame = CGRectMake(-100, 1000, 100, 57);
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textEdit becomeFirstResponder];
    
    NSString *type = NSLocalizedString(@"Language", @"language");
    if ([type isEqualToString:@"en"])
    {
        [self.twitterButton requestAccessWithCompletion:^(BOOL success, NSString * result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!success)
                {
                    [SVProgressHUD showErrorWithStatus:result];
                }
                
            });
        }];
    }
    else{
        [self.weiboButton requestAccessWithCompletion:^(BOOL success, NSString *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!success)
                {
                    [SVProgressHUD showErrorWithStatus:result];
                }
                
            });
        }];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)keyboardDidShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGSize buttonSize = self.twitterButton.bounds.size;
    if (self.twitterButton.frame.origin.y != screenHeight-kbSize.height - buttonSize.height)
    {
        self.twitterButton.frame =
            CGRectMake(screenWidth, screenHeight-kbSize.height - buttonSize.height, buttonSize.width, buttonSize.height);
    }
    
    if (self.weiboButton.frame.origin.y != screenHeight-kbSize.height - buttonSize.height)
    {
        self.weiboButton.frame =
            CGRectMake(0 - buttonSize.width, screenHeight-kbSize.height - buttonSize.height, buttonSize.width, buttonSize.height);
    }

}

-(void)stopEditing
{
    [self.textEdit resignFirstResponder];
}

-(void)beginEditing
{
    [self.textEdit becomeFirstResponder];
}


-(void)clearContent
{
    self.textEdit.text = @"";
}


-(void)sendMessage:(SocialButton *)sender
{
    if ([self.textEdit.text length] == 0 && !self.inputAccessoryView.pickedImageView.image) {
        PrettyAlertView *alertView = [[PrettyAlertView alloc] initWithTitle:NSLocalizedString(@"No Message", @"Alert Title")
                                                                    message:NSLocalizedString(@"Don't you want to say something?", @"Message")
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil];
        
        [alertView show];
        return;
    }
    else
    {
        if ([sender conformsToProtocol:@protocol(SocialButtonProtocol)])
        {
            NSString * message = self.textEdit.text;
            if (message.length == 0)
            {
                message = NSLocalizedString(@"PostPicture", @"picture only");
            }
            [SVProgressHUD showWithStatus:NSLocalizedString(@"Sending...", @"Sending") maskType:SVProgressHUDMaskTypeGradient];
            [sender sendMessage:self.textEdit.text
                          Image:self.inputAccessoryView.pickedImageView.image
                     completion:^(BOOL successful, NSString *result) {
                         if (successful)
                         {
                             [Tweet insertTweetWithContent:message target:sender.titleLabel.text inManagedObjectContext:self.managedObjectContext];
                         }
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if (successful)
                             {
                                 
                                 [SVProgressHUD showSuccessWithStatus:result];
                             }
                             else
                             {
                                 [SVProgressHUD showErrorWithStatus:result];
                             }

                         });
                    }];
        }
    }
    
}


#pragma TextView Delegate

-(void)textViewDidChange:(UITextView *)textView
{
    if (self.textEdit.text.length > 140)
    {
        self.textEdit.text = [self.textEdit.text substringToIndex:139];
    }

    self.inputAccessoryView.count.text = [NSString stringWithFormat:@"%d", 140 - [self.textEdit.text length]];
    [self hideSendButtons];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual: @"\n"]) {
        
        [self toggleSendButtons];
        return NO;
    }
    
    //press backspace key
    if (range.length > 0 && [text isEqualToString:@""]) {
        return YES;
    }
    
    if ([self.textEdit.text length] >= 140)
    {
        return NO;
    }
    
    return YES;
}

-(void)toggleSendButtons
{
    CGRect oldSendViewRect = self.twitterButton.frame;
    
    if (oldSendViewRect.origin.x == [[UIScreen mainScreen] bounds].size.width)
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat newX = oldSendViewRect.origin.x - oldSendViewRect.size.width;
            self.twitterButton.frame = CGRectMake(newX, oldSendViewRect.origin.y, oldSendViewRect.size.width, oldSendViewRect.size.height);
            
            CGFloat newWeiboX = 0;
            self.weiboButton.frame = CGRectMake(newWeiboX, oldSendViewRect.origin.y, oldSendViewRect.size.width, oldSendViewRect.size.height);
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat newX = oldSendViewRect.origin.x + oldSendViewRect.size.width;
            self.twitterButton.frame = CGRectMake(newX, oldSendViewRect.origin.y, oldSendViewRect.size.width, oldSendViewRect.size.height);
            
            CGFloat newWeiboX = 0 - oldSendViewRect.size.width;
            self.weiboButton.frame = CGRectMake(newWeiboX, oldSendViewRect.origin.y, oldSendViewRect.size.width, oldSendViewRect.size.height);
            
        }];
    }

}

-(void)hideSendButtons
{
    CGRect oldSendViewRect = self.twitterButton.frame;
    if (oldSendViewRect.origin.x == [[UIScreen mainScreen] bounds].size.width - oldSendViewRect.size.width) //buttons are displaying
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat newX = oldSendViewRect.origin.x + oldSendViewRect.size.width;
            self.twitterButton.frame = CGRectMake(newX, oldSendViewRect.origin.y, oldSendViewRect.size.width, oldSendViewRect.size.height);
            
            CGFloat newWeiboX = 0 - oldSendViewRect.size.width;
            self.weiboButton.frame = CGRectMake(newWeiboX, oldSendViewRect.origin.y, oldSendViewRect.size.width, oldSendViewRect.size.height);
            
        }];
    }
}

#pragma  Input Accessary delegate methods
-(void)pickImage
{
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.editing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.imagePickerController.delegate = self;
    self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

-(void)clearTextView
{
    self.textEdit.text = @"";
}

#pragma UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.inputAccessoryView.pickedImageView.roundRadius = 6.0;
    [self.inputAccessoryView setImage:pickedImage];
    //self.inputAccessoryView.pickedImageView.image = pickedImage;
    //self.inputAccessoryView.pickedImageView.hidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


- (IBAction)handlePinch:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer class] == [UIPinchGestureRecognizer class])
    {
        UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)gestureRecognizer;
        
        if (pinch.scale > 1)
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        else
        {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}

-(IBAction)swipeLeft:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        TweetsViewController *tweets = [TweetsViewController new];
        tweets.managedObjectContext = self.managedObjectContext;
        
        [self.navigationController pushViewController:tweets animated:YES];
    }
}

- (IBAction)changeImagePickerSourceToPhotosLibrary:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (IBAction)takePhoto:(id)sender {
    [self.imagePickerController takePicture];
}
@end
