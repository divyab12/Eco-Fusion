//
//  DashboradGoalView.m
//  EHEandme
//
//  Created by Divya Reddy on 16/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "DashboradGoalView.h"

@implementation DashboradGoalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
         percentage:(float)percent
              color:(UIColor*)lColor
               Text:(NSString*)lText
         isFreeGoal:(BOOL)mFlag
           GoalDone:(BOOL)mDone
{
    self = [self initWithFrame:frame];
    
    if (self != Nil) {
        
        
        float leftwidth = self.frame.size.width * percent/100;
        float rightwidth = self.frame.size.width - leftwidth;
        UIView *percentageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftwidth, self.frame.size.height)];
        //percentageView.backgroundColor = [UIColor colorWithRed:114.0/255.0 green:185.0/255.0 blue:223.0/255.0 alpha:1.0];
        percentageView.backgroundColor = lColor;
        [self addSubview:percentageView];
        
        UIView *remainingView = [[UIView alloc] initWithFrame:CGRectMake(leftwidth, 0, rightwidth, self.frame.size.height)];
        remainingView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:231.0/255.0 blue:213.0/255.0 alpha:1.0];
        [self addSubview:remainingView];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"GoalBar.png"];
        [self addSubview:imageView];
        
        UILabel *PerLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, 120, 25)];
        PerLbl.font = Bariol_Bold(15);
        PerLbl.backgroundColor = CLEAR_COLOR;
        PerLbl.textColor = WHITE_COLOR;
        PerLbl.textAlignment = UITextAlignmentLeft;
        PerLbl.text = lText;
        [self addSubview:PerLbl];
        
        //for free form goal
        UIImageView *lCheckImgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-10-18, (frame.size.height/2)-(18.5/2), 18, 18.5)];
        lCheckImgView.backgroundColor = CLEAR_COLOR;
        if (mFlag) {
            if (mDone) {
                lCheckImgView.image = [UIImage imageNamed:@"checkmark.png"];
            }else{
                lCheckImgView.image = [UIImage imageNamed:@"crossmark.png"];

            }
            [self addSubview:lCheckImgView];

        }
        
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
