//
//  InputAccessoryView.m
//  Tweittbo
//
//  Created by qijun on 9/4/13.
//  Copyright (c) 2013 qijun. All rights reserved.
//

#import "InputAccessoryView.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>

@implementation InputAccessoryView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *singleTapForImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickedImageTapped:)];
    singleTapForImageView.numberOfTapsRequired = 1;
    singleTapForImageView.numberOfTouchesRequired = 1;
    [self.pickedImageView addGestureRecognizer:singleTapForImageView];
    [self.pickedImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickedImageTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.count addGestureRecognizer:singleTap];
    [self.count setUserInteractionEnabled:YES];
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)pickedImageTapped:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.view == self.pickedImageView)
    {
        [self removeImage];
    }
    else
    {
        if (self.delegate)
        {
            [self.delegate clearTextView];
            self.count.text = @"140";
        }
    }
    
}

- (IBAction)pickerImage:(id)sender {
    if (self.delegate)
    {
        [self.delegate pickImage];
    }
}

- (void)setImage:(UIImage *)image
{
    if (image)
    {
                
        self.pickedImageView.frame = self.cameraButton.frame;
        self.pickedImageView.hidden = NO;
        self.pickedImageView.image = image;
        
        self.cameraButton.hidden = YES;
    }
}

- (void)removeImage
{
    self.cameraButton.hidden = NO;
    self.pickedImageView.image = nil;
    self.pickedImageView.hidden = YES;
}
@end
