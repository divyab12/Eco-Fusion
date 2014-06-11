//
//  DataGetter.m
//  EHEandme
//
//  Created by Divya Reddy on 28/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "DataGetter.h"

@implementation DataGetter

@synthesize mLoginDict_,mPersonalSettingsDict_,mMealPlanDict_,mFoodInfoDict_, mCalLevelList_,mActivityLevelList_,mGenderList_,mMealGoalList_, mDailyGoalsDict_, mNotificationsDict_;
@synthesize mFoodList_,mUserCalorieLevel,mPlansList_, mMealPreferencesList_, mMealsList_;
@synthesize mFoodUnitList_,mEditServingDict_;
@synthesize mPrivateFoodDict;

- (id)init
{
    if (self = [super init])
    {
        // Initialization code here
        mAppDelegate_ = [AppDelegate appDelegateInstance];
        mMealPreferencesList_ = [[NSMutableArray alloc]init];
        mEditServingDict_ = [[NSMutableDictionary alloc] init];
    }
    
    return self;
    
}
@end
