//
//  ParserMethods.m
//  EHEandme
//
//  Created by EHEandme on 14/09/12.
//  Copyright (c) 2012 EHEandme. All rights reserved.
//
//

#import "ParserMethods.h"
#import "AppDelegate.h"
#import "WebEngine.h"
#import "JSON.h"

@implementation ParserMethods

- (id)init
{
    if (self = [super init])
    {
        // Initialization code here
        mAppDelegate_ = [AppDelegate appDelegateInstance];
    }
    
    return self;
    
}
- (void)parseLogin
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseLogin %@",response);
    mAppDelegate_.mDataGetter_.mLoginDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
-(void)parseLogout {
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseLogout %@",response);

    if ([response isEqualToString:@"false"]) {
        [mAppDelegate_ showCustomAlert:NSLocalizedString(@"ERROR", nil) Message:NSLocalizedString(@"NO_RESPONSE", nil)];
        
    } else {
      //  [mAppDelegate_ showCustomAlert:NSLocalizedString(@"CONGRATULATIONS_TITLE", nil) Message:NSLocalizedString(@"SUCCESS_ADDTHREAD_TEXT", nil)];
        [mAppDelegate_.mResponseMethods_ successResponse];
    }
}
- (void)parseGetPersonalSettings
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseGetPersonalSettings %@",response);
    mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ = [response JSONValue];
    
    if ([mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ count] > 0) {
        [mAppDelegate_.mResponseMethods_ successResponse];
    } else {
        [mAppDelegate_ removeLoadView];
        [mAppDelegate_ showCustomAlert:NSLocalizedString(@"ERROR", nil) Message:NSLocalizedString(@"NO_RESPONSE", nil)];
    }
    
}
- (BOOL)parseCheckPersonalSettings{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseCheckPersonalSettings %@",response);
    return [response boolValue];
}
- (void)parseGetMealPlan
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseGetMealPlan %@",response);
    mAppDelegate_.mDataGetter_.mMealPlanDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseSearchFood{
   // NSDate* date = [NSDate date];
   // NSLog(@"elapsed date %@",date);

    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    mAppDelegate_.mDataGetter_.mFoodList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseSavePrivateFood{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"SavePrivateFood %@",response);
    mAppDelegate_.mDataGetter_.mPrivateFoodDict = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseUploadPhotoRequest{
  //  NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes] length:[ mAppDelegate_.mWebEngine_->webData length]                                            encoding:NSUTF8StringEncoding];
    //DLog(@"UploadPhoto %@",response);
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseFoodUnits{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseFoodUnits %@",response);
    mAppDelegate_.mDataGetter_.mFoodUnitList_ = [response JSONValue];
     [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseFoodInfo
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    mAppDelegate_.mDataGetter_.mFoodInfoDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseLookUp
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseLookUp %@",response);
    if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GENDER]) {
        mAppDelegate_.mDataGetter_.mGenderList_ = [response JSONValue];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:CALORIELEVEL]) {
        mAppDelegate_.mDataGetter_.mCalLevelList_ = [response JSONValue];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ACTIVITYLEVEL]) {
        mAppDelegate_.mDataGetter_.mActivityLevelList_ = [response JSONValue];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:MEALGOAL]) {
        mAppDelegate_.mDataGetter_.mMealGoalList_ = [response JSONValue];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:JOURNALCATEGORY]) {
        mAppDelegate_.mTrackerDataGetter_.mJournalCatList_ = [response JSONValue];
    }
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseCalorieLevel{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseCalorieLevel %@",response);
    mAppDelegate_.mDataGetter_.mUserCalorieLevel = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];


}
- (void)parseMealPlans
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseMealPlans %@",response);
    mAppDelegate_.mDataGetter_.mPlansList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseMealPlanPreferences
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mDataGetter_.mMealPreferencesList_ removeAllObjects];
    mAppDelegate_.mDataGetter_.mMealPreferencesList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseMeals
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mDataGetter_.mMealsList_ removeAllObjects];
    mAppDelegate_.mDataGetter_.mMealsList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseDayWeight
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mDayWeightDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mDayWeightDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseWeightChart{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseWeightChart %@",response);
    [mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseWeightList
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseWeightList %@",response);
    [mAppDelegate_.mTrackerDataGetter_.mWeightList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mWeightList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseWaterList
{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mWaterList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mWaterList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseDayMeasurement{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mDayMeasurementDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mDayMeasurementDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseMeasurementChart{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseMeasurementChart %@",response);
    [mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseMeasurementList{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseMeasurementList %@",response);
    [mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseDayExercise{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mDayExerciseDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mDayExerciseDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseExerciseChart{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseExerciseChart %@",response);
    [mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseExerciseList{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseExerciseList %@",response);
    [mAppDelegate_.mTrackerDataGetter_.mExerciseList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mExerciseList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseExActivities{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseExActivities %@",response);
    [mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseExWeight{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseExWeight %@",response);
    [mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseDayGlucose{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mDayGlucoseDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mDayGlucoseDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseGlucoseChart{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mGlucoseChartDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mGlucoseChartDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseGlucoseList{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mGlucoseList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mGlucoseList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseJournalList{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mJournalList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mJournalList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseCholesterolList{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseCholesterolChart{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mCholChartDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mCholChartDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseBMIList{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mBMIList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mBMIList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseBMIChart{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mBMIChartDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mBMIChartDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseDayBMI{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mDayBMIDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mDayBMIDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseGoalList{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mGoalList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mGoalList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseGoalChart{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseDashboardGoalList{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mDashBoardGoalList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mDashBoardGoalList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseGoalSteps{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseGoalStepProgress{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseStepList{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mStepList_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mStepList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseStepChart{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseStepChart %@",response);
    [mAppDelegate_.mTrackerDataGetter_.mStepChartDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mStepChartDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseDayStep{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mTrackerDataGetter_.mDayStepDict_ removeAllObjects];
    mAppDelegate_.mTrackerDataGetter_.mDayStepDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseTrackerGoals{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseTrackerGoals %@",response);
    [mAppDelegate_.mDataGetter_.mDailyGoalsDict_ removeAllObjects];
    mAppDelegate_.mDataGetter_.mDailyGoalsDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseNotifications{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mDataGetter_.mNotificationsDict_ removeAllObjects];
    mAppDelegate_.mDataGetter_.mNotificationsDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
- (void)parseMessages{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ removeAllObjects];
    mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
- (void)parseMessageDetail{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"%@",response);
    [mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ removeAllObjects];
    mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ = [[response JSONValue] objectAtIndex:0];
    [mAppDelegate_.mResponseMethods_ successResponse];

}
-(int)parseCheckRecipent{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    return [response intValue];
}
#pragma mark - Demo Plan
- (void)parseDemoPlanData {
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseDemoPlanData %@",response);
    mAppDelegate_.mDataGetter_.mPlansList_ = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
    
}

#pragma mark - Discussion Forum
- (void)parseCategoryData {
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseCategoryData %@",response);
    [mAppDelegate_.mCommunityDataGetter.mcategoriesArray removeAllObjects];
    mAppDelegate_.mCommunityDataGetter.mcategoriesArray = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
    
}
/*
 *Method to parse the response of forums
 */
-(void)parseForums{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    
    //DLog(@"parseForums %@",response);
    mAppDelegate_.mCommunityDataGetter.mForumsArray = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
/*
 *Method to parse the response of threads
 */
-(void)parseThreads{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    
    
    //DLog(@"parseThreads %@",response);

    mAppDelegate_.mCommunityDataGetter.mThreadsArray = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
    
    
}
/*
 *Method to parse the response of posts
 */
-(void)parsePosts{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parsePosts %@",response);
    mAppDelegate_.mCommunityDataGetter.mPostsArray = [response JSONValue];
    [mAppDelegate_.mResponseMethods_ successResponse];
}
/*
 *Method to parse the response of Add new thread
 */
-(void)parseAddNewThread{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parsePosts %@",response);
    if ([response isEqualToString:@"false"]) {
        [mAppDelegate_ showCustomAlert:NSLocalizedString(@"ERROR", nil) Message:NSLocalizedString(@"ERROR_ADDTHREAD_TEXT", nil)];

    } else {
        [mAppDelegate_ showCustomAlert:NSLocalizedString(@"CONGRATULATIONS_TITLE", nil) Message:NSLocalizedString(@"SUCCESS_ADDTHREAD_TEXT", nil)];

    }
    [mAppDelegate_.mResponseMethods_ successResponse];
}
/*
 *Method to parse the response of Add new post
 */
-(void)parseAddNewPost{
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //DLog(@"parseAddNewPost %@",response);
    if ([response isEqualToString:@"false"]) {
        [mAppDelegate_ showCustomAlert:NSLocalizedString(@"ERROR", nil) Message:NSLocalizedString(@"ERROR_ADDPOST_TEXT", nil)];
        
    } else {
        [mAppDelegate_ showCustomAlert:NSLocalizedString(@"CONGRATULATIONS_TITLE", nil) Message:NSLocalizedString(@"SUCCESS_ADDPOST_TEXT", nil)];
        
    }
    [mAppDelegate_.mResponseMethods_ successResponse];
}


@end
