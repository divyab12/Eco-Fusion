//
//  StepperView.m
//  EHERD
//
//  Created by EHEandme on 11/30/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import "StepperView.h"

@implementation StepperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame percentage:(float)percent
{
    self = [self initWithFrame:frame];
    
    if (self != Nil) {

    float leftwidth = self.frame.size.width * percent/100;
    float rightwidth = self.frame.size.width - leftwidth;
    UIView *percentageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftwidth, self.frame.size.height)];
        percentageView.backgroundColor = DTG_ORANGE_COLOR;//[UIColor colorWithRed:114.0/255.0 green:185.0/255.0 blue:223.0/255.0 alpha:1.0];
    [self addSubview:percentageView];
        
    UIView *remainingView = [[UIView alloc] initWithFrame:CGRectMake(leftwidth, 0, rightwidth, self.frame.size.height)];
    remainingView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:231.0/255.0 blue:213.0/255.0 alpha:1.0];
    [self addSubview:remainingView];
    

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"stepper.png"];
    [self addSubview:imageView];
    }

    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)changeViewPercentage:(float)percent {
}

@end
