//
//  TrackerDataGetter.h
//  EHEandme
//
//  Created by Divya Reddy on 13/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackerDataGetter : NSObject{
    /**
     * AppDelegate object creating
     */
    AppDelegate *mAppDelegate_;
    
}
@property (nonatomic,retain) NSMutableDictionary *mDayWeightDict_;
@property (nonatomic,retain) NSMutableArray *mWeightList_;
@property (nonatomic,retain) NSMutableArray *mWaterList_;
@property (nonatomic,retain) NSMutableDictionary *mDayMeasurementDict_;
@property (nonatomic,retain) NSMutableArray *mMeasurementList_;
@property (nonatomic,retain) NSMutableDictionary *mDayExerciseDict_, *mCurrentWeightDict_;
@property (nonatomic,retain) NSMutableArray *mExerciseList_, *mExActivitiesList_;
@property (nonatomic,retain) NSMutableDictionary *mDayGlucoseDict_;
@property (nonatomic,retain) NSMutableArray *mGlucoseList_;
@property (nonatomic,retain) NSMutableArray *mJournalList_, *mJournalCatList_;
@property (nonatomic,retain) NSMutableArray *mCholesterolList_;
@property (nonatomic,retain) NSMutableDictionary *mDayBMIDict_ ;
@property (nonatomic,retain) NSMutableArray *mBMIList_;
@property (nonatomic, retain) NSMutableArray *mDashBoardGoalList_, *mGoalList_, *mGoalStepList_;
@property (nonatomic, retain) NSMutableArray *mStepList_;
@property (nonatomic, retain) NSMutableDictionary *mDayStepDict_, *mGoalStepProgressDict__;
@property (nonatomic,retain) id mWeightChartDict_, mGlucoseChartDict_, mExerciseChartDict_, mMeasurementChartDict_, mCholChartDict_, mBMIChartDict_, mStepChartDict_, mGoalChartDict_;
@property (nonatomic,retain) NSMutableDictionary *mLogsourceAppManualDict_;
@property (nonatomic, retain) NSString *mRecommendedCalorie;
/**
 * Method used to initialize class
 */
- (id)init;
/*
 * Method to fetch the category name in journal based on id
 * @param mID for the category id
 */
- (NSString*)returnTheCategoryName:(NSString*)mID;
/*
 * Method to fetch the category id in journal based on name
 * @param mCatName for the category name
 */
- (NSString*)returnTheCategoryID:(NSString*)mCatName;
/*
 * Method to fetch the image name based on exercise from plist file in LogExercise
 * @param mExName for exercise name to which image is to fetched from plist
 */
- (NSString*)readImagesFromPlist:(NSString*)mExName;
/*
 * Method used to take only 20 values on graph if we have more than 20 values i.e for month/3months section
 * @param mActualArray refers to the original array from which 20 values are to be retrieved
 */
- (NSMutableArray*)returnOnly20RecordsForGraph:(NSMutableArray*)mActualArray;
@end
