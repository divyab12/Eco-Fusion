//
//  Timeview.m
//  EHERD
//
//  Created by EHEandme on 11/30/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import "Timeview.h"
#import "PieChartView.h"

@implementation Timeview

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

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"clock.png"];
    [self addSubview:imageView];
    
    PieChartView *_pieChart = [[PieChartView alloc] initWithFrame:CGRectMake(1, 0+5, self.frame.size.width-2, self.frame.size.height-5)];
    [self addSubview:_pieChart];
    [_pieChart clearItems];
        
    float totalPercent = 100;
    float filledPercent = percent;
    float emptyPercent = totalPercent-filledPercent;
    
    float filledPortion = (360.0 * (filledPercent/totalPercent));
    float emptyPortion = (360.0 * (emptyPercent/totalPercent));
    [_pieChart addItemValue:filledPortion withColor:PieChartItemColorMake(255.0/255.0, 145.0/255.0, 2.0/255.0, 1.0)];
    //DTG_ORANGE_COLOR = [UIColor colorWithRed:255.0/255.0 green:145.0/255.0 blue:2.0/255.0 alpha:1.0]
    //[UIColor colorWithRed:114.0/255.0 green:184.0/255.0 blue:223.0/255.0 alpha:1.0]
	[_pieChart addItemValue:emptyPortion withColor:PieChartItemColorMake(255.0, 255.0, 255.0, 1.0)];
		
	//[_pieChart addItemValue:0.3 withColor:PieChartItemColorMake(0.5, 0.5, 1.0, 0.8)];
    
	_pieChart.alpha = 0.0;
	[_pieChart setHidden:NO];
	[_pieChart setNeedsDisplay];
	
	// Animate the fade-in
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	_pieChart.alpha = 1.0;
	[UIView commitAnimations];
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
