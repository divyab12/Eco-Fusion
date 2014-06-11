//
//  UnderLineButton.m
//  EHEandme
//
//  Created by Divya Reddy on 18/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "UnderLineButton.h"

@implementation UnderLineButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.currentTitleColor.CGColor);
    
    // Draw them with a 1.0 stroke width.
    CGContextSetLineWidth(context, 1.0);
    
    CGFloat baseline = rect.size.height + self.titleLabel.font.descender + 2;
    
    // Draw a single line from left to right
    CGContextMoveToPoint(context, 0, baseline);
    CGContextAddLineToPoint(context, rect.size.width, baseline);
    CGContextStrokePath(context);
}


@end
