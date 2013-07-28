//
//  UIRoundedImageView.m
//  iAroundYou
//
//  Created by 琦钧 冯 on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIRoundedImageView.h"
#import <QuartzCore/CALayer.h>

@implementation UIRoundedImageView

-(id)init
{
    self = [super init];
    if (self)
    {
        self.roundRadius = 20.0;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.roundRadius = 20.0;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.roundRadius = 20.0;
    }
    
    return self;
}


-(void)willMoveToWindow:(UIWindow *)newWindow
{
    CALayer *roundedLayer = [self layer];
    [roundedLayer setMasksToBounds:YES];

    roundedLayer.cornerRadius = self.roundRadius;
    roundedLayer.borderWidth = 1.0;
    roundedLayer.borderColor = [[UIColor grayColor] CGColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
