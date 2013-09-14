//
//  MainViewController.h
//  Tweittbo
//
//  Created by qijun on 9/4/13.
//  Copyright (c) 2013 qijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterButton.h"
#import "WeiboButton.h"
#import "InputAccessoryView.h"
#import <SVProgressHUD.h>


@interface MainViewController : UIViewController<UITextViewDelegate, InputAccessoryViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate>
{
}
@property (weak, nonatomic) IBOutlet UITextView *textEdit;
@property (weak, nonatomic) IBOutlet InputAccessoryView *inputAccessoryView;
@property (strong, nonatomic) TwitterButton *twitterButton;
@property (strong, nonatomic) WeiboButton *weiboButton;
@property (weak, nonatomic) IBOutlet UIView * cameraOverlay;
@property (weak, nonatomic) IBOutlet UILabel *count;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)changeImagePickerSourceToPhotosLibrary:(id)sender;
- (IBAction)takePhoto:(id)sender;

- (IBAction)handlePinch:(UIGestureRecognizer *)gestureRecognizer;

-(void)stopEditing;
-(void)beginEditing;

-(void)clearContent;

@end
