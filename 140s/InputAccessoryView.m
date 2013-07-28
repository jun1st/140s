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
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickedImageTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.pickedImageView addGestureRecognizer:singleTap];
    [self.pickedImageView setUserInteractionEnabled:YES];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)pickedImageTapped:(UIGestureRecognizer *)gestureRecognizer
{
    [self removeImage];
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
