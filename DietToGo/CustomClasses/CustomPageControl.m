//
//  CustomPageControl.m
//  EHEandme
//
//  Created by Divya Reddy on 17/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "CustomPageControl.h"

@implementation CustomPageControl
@synthesize activeImage;
@synthesize inactiveImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        activeImage = [UIImage imageNamed:@"pageactive.png"];
        inactiveImage = [UIImage imageNamed:@"pageinactive.png"];
        [self updateDots];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    activeImage = [UIImage imageNamed:@"pageactive.png"];
    inactiveImage = [UIImage imageNamed:@"pageinactive.png"];
    [self updateDots];
    return self;
}

-(void)updateDots
{
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f) {
         self.pageIndicatorTintColor = LIGHT_GRAY_COLOR;
         self.currentPageIndicatorTintColor = BLACK_COLOR;
     }else{
         for (int i = 0; i < [self.subviews count]; i++)
         {
             UIImageView* dot = [self.subviews objectAtIndex:i];
             if (i == self.currentPage)
                 dot.image = activeImage;
             else
                 dot.image = inactiveImage;
         }

     }
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
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
