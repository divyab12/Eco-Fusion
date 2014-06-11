//
//  CustomButton.m
//  EHEandme
//
//  Created by Divya Reddy on 29/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
@synthesize isChecked,name;
//@synthesize  mTextField;
@synthesize totalScore;
@synthesize CurrentScore;
//for log meals
@synthesize mSelectedRow;
@synthesize mSelectedSection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

@end
