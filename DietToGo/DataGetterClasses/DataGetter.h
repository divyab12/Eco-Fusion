//
//  DataGetter.h
//  EHEandme
//
//  Created by Divya Reddy on 28/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataGetter : NSObject{
    /**
     * AppDelegate object creating
     */
    AppDelegate *mAppDelegate_;
    
}
@property (nonatomic,retain) NSMutableDictionary *mLoginDict_;
@property (nonatomic,retain) NSMutableDictionary *mPersonalSettingsDict_;
@property (nonatomic,retain) NSMutableDictionary *mMealPlanDict_, *mFoodInfoDict_, *mUserCalorieLevel, *mDailyGoalsDict_, *mNotificationsDict_;
@property (nonatomic,retain) NSMutableArray *mFoodList_, *mGenderList_, *mCalLevelList_, *mActivityLevelList_, *mMealGoalList_, *mPlansList_, *mMealPreferencesList_, *mMealsList_;
@property (nonatomic,retain) NSMutableArray *mFoodUnitList_;
@property (nonatomic,retain) NSMutableDictionary *mEditServingDict_;
@property (nonatomic,retain) NSMutableDictionary *mPrivateFoodDict;

/**
 * Method used to initialize class
 */
- (id)init;
@end
