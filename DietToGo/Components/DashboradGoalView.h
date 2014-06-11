//
//  DashboradGoalView.h
//  EHEandme
//
//  Created by Divya Reddy on 16/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboradGoalView : UIView
-(id)initWithFrame:(CGRect)frame
        percentage:(float)percent
             color:(UIColor*)lColor Text:(NSString*)lText
        isFreeGoal:(BOOL)mFlag
          GoalDone:(BOOL)mDone;
-(void)changeViewPercentage:(float)percent;
@end
