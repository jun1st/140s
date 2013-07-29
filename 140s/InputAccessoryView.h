//
//  InputAccessoryView.h
//  Tweittbo
//
//  Created by qijun on 9/4/13.
//  Copyright (c) 2013 qijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRoundedImageView.h"

@protocol InputAccessoryViewDelegate <NSObject>

@required
-(void)pickImage;
-(void)clearTextView;

@end

@interface InputAccessoryView : UIView

@property (weak, nonatomic) IBOutlet UILabel *count;


@property (assign, nonatomic) id<InputAccessoryViewDelegate> delegate;
@property (assign, nonatomic) IBOutlet UIButton *statusImagePicker;
@property (assign, nonatomic) IBOutlet UIRoundedImageView *pickedImageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

- (IBAction)pickerImage:(id)sender;
- (void)setImage:(UIImage *)image;
- (void)removeImage;

@end
