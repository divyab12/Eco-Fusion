//
//  TrackerDataGetter.m
//  EHEandme
//
//  Created by Divya Reddy on 13/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "TrackerDataGetter.h"

@implementation TrackerDataGetter
@synthesize mDayWeightDict_,mWeightChartDict_,mWeightList_;
@synthesize mWaterList_;
@synthesize mDayMeasurementDict_,mMeasurementChartDict_,mMeasurementList_;
@synthesize mExActivitiesList_,mExerciseChartDict_,mExerciseList_,mCurrentWeightDict_,mDayExerciseDict_;
@synthesize mGlucoseChartDict_, mGlucoseList_, mDayGlucoseDict_;
@synthesize mJournalList_, mJournalCatList_;
@synthesize mCholChartDict_, mCholesterolList_;
@synthesize mBMIChartDict_,mBMIList_,mDayBMIDict_;
@synthesize mGoalChartDict_,mDashBoardGoalList_,mGoalList_,mGoalStepList_, mGoalStepProgressDict__;
@synthesize mDayStepDict_, mStepChartDict_, mStepList_;
@synthesize mLogsourceAppManualDict_;
@synthesize mRecommendedCalorie;
- (id)init
{
    if (self = [super init])
    {
        // Initialization code here
        mAppDelegate_ = [AppDelegate appDelegateInstance];
    }
    
    return self;
    
}
- (NSString*)returnTheCategoryName:(NSString*)mID
{
    NSString *mCatName=@"";
    for (int iCount =0; iCount < self.mJournalCatList_.count; iCount++) {
        if ([[[self.mJournalCatList_ objectAtIndex:iCount] objectForKey:@"Code"] intValue] == [mID intValue]) {
            mCatName = [[self.mJournalCatList_ objectAtIndex:iCount] objectForKey:@"Value"];
        }
    }
    return mCatName;
}
- (NSString*)returnTheCategoryID:(NSString*)mCatName{
    NSString *mID=@"";
    for (int iCount =0; iCount < self.mJournalCatList_.count; iCount++) {
        if ([[[self.mJournalCatList_ objectAtIndex:iCount] objectForKey:@"Value"] isEqualToString:mCatName]) {
            mID = [NSString stringWithFormat:@"%d", [[[self.mJournalCatList_ objectAtIndex:iCount] objectForKey:@"Code"] intValue]];
        }
    }
    return mID;
}
- (NSString*)readImagesFromPlist:(NSString*)mExName
{
    NSString *path1 = [[NSBundle mainBundle] pathForResource:
                       @"ExerciseImages" ofType:@"plist"];
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path1] ;
    if([mExName isEqualToString:@"Home & Garden"])
    {
        mExName=@"Home_Garden";
    }
    else if([mExName isEqualToString:@"More Sports & Activities"])
    {
        mExName=@"More Sports";
    }
    else if([mExName isEqualToString:@"Track & Field"])
    {
        mExName=@"Track_Field";
    }
    NSString *imgName=[myDictionary objectForKey:mExName];

    //[myDictionary release];
    return imgName;
}
- (NSMutableArray*)returnOnly20RecordsForGraph:(NSMutableArray*)mActualArray{
    NSMutableArray *lFinalArray = [[NSMutableArray alloc] init];
    [lFinalArray addObject:[mActualArray objectAtIndex:0]];
    
    int mValue = ([mActualArray count]-2)/18;
    if (mValue <=0) {
        mValue =1;
    }
    for (int i = 0; i < mActualArray.count; i++) {
        if (i == mValue && lFinalArray.count < 19) {
            [lFinalArray addObject:[mActualArray objectAtIndex:i]];
            int Value = ([mActualArray count]-2)/18;
            if (Value <=0) {
                Value =1;
            }
            mValue+=Value;
            
        }
    }
    [lFinalArray addObject:[mActualArray objectAtIndex:[mActualArray count]-1]];
    return lFinalArray;
}
@end
