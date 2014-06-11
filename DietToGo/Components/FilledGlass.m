//
//  FilledGlass.m
//  EHERD
//
//  Created by EHEandme on 12/3/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import "FilledGlass.h"

@implementation FilledGlass

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame percentage:(float)percent
{
    self = [self initWithFrame:frame];
    
    if (self != Nil) {

    percentage = percent;
    }
  //  NSLog(@"initWithFrame");
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    float glassWidth = 25;
    float glassHieght = 54;
    
    float desirableHeight =  glassHieght - (glassHieght * percentage /100);
    
    float glassX = 30;
    float glassY = 35;
    float padding = 6;
    
    
    float leftPadding = padding - padding * percentage /100 ;
    float rightPadding =  padding * percentage /100 ;// padding - leftPadding ;
    NSLog(@" leftPadding %f %f", percentage,rightPadding);
    /*
     float leftPadding = 0;
     float rightPadding = 6;

     if (percentage >= 80 && percentage <= 65 ) {
     rightPadding = 4;
     leftPadding = 2;
     }
     if (percentage <= 50) {
     leftPadding = 3;
     rightPadding = 3;
     }
     */
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, glassX + padding, glassY + glassHieght);
    CGContextAddLineToPoint(context, glassX + glassWidth + padding, glassY + glassHieght);
    CGContextAddLineToPoint(context, glassX + glassWidth + leftPadding +(rightPadding*2 ), glassY + desirableHeight);
    CGContextAddLineToPoint(context, glassX + (leftPadding), glassY + desirableHeight);
    
    CGContextMoveToPoint(context, glassX , glassY + glassHieght);
    [DTG_ORANGE_COLOR setFill];
    //[[UIColor colorWithRed:114.0/255.0 green:185.0/255.0 blue:223.0/255.0 alpha:1.0] setFill];
    
    /* CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextSetLineWidth(context, 2);
     CGContextMoveToPoint(context, glassX, glassY);
     CGContextAddLineToPoint(context, glassX + padding, glassY + desirableHeight);
     CGContextAddLineToPoint(context, glassX + glassWidth + padding, glassY + desirableHeight);
     CGContextAddLineToPoint(context, glassX + glassWidth + (padding*2), glassY);
     CGContextMoveToPoint(context, glassX, glassY);
     [[UIColor colorWithRed:114.0/255.0 green:184.0/255.0 blue:223.0/255.0 alpha:1.0] setFill];
*/
    
    //[[UIColor blueColor] setFill];
    CGContextFillPath(context);
}


@end
