//
//  TodayStepView.h
//  EHEandme
//
//  Created by Divya Reddy on 12/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayStepView : UIView{
    UIView *percentageView,*remainingView;
    UILabel *PerLbl;
}
-(id)initWithFrame:(CGRect)frame percentage:(float)percent;
-(void)changeViewPercentage:(float)percent;
@end
