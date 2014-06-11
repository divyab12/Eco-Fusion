//
//  ParserMethods.h
//  EHEandme
//
//  Created by EHEandme on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate;

@interface ParserMethods : NSObject{
    
    /**
     * AppDelegate object creating
     */
    AppDelegate *mAppDelegate_;
}

/**
 * Method used to initialize class
 */
- (id)init;
/**
 * Method used to parse Post login response
 */
- (void)parseLogin;
/**
 * Method used to parse Post logout response
 */
-(void)parseLogout;
/**
 * Method used to parse user personal settings response
 */
- (void)parseGetPersonalSettings;
/**
 * Method used to parse user personal settings response and reurn true/false
 */
- (BOOL)parseCheckPersonalSettings;
/**
 * Method used to parse meal plan response
 */
- (void)parseGetMealPlan;
/**
 * Method used to parse search food response
 */
- (void)parseSearchFood;
/**
 * Method used to parse get food info response
 */
- (void)parseFoodInfo;
/**
 * Method used to parse Upload Photo response
 */
- (void)parseUploadPhotoRequest;
/**
 * Method used to parse save private food response
 */
- (void)parseSavePrivateFood;
/**
 * Method used to parse get food units response
 */
- (void)parseFoodUnits;
/**
 * Method used to parse get lookup response
 */
- (void)parseLookUp;
/**
 * Method used to parse get calorie level response
 */
- (void)parseCalorieLevel;
/**
 * Method used to parse get meal plans for calorie level response
 */
- (void)parseMealPlans;
/**
 * Method used to parse meal plan preferences
 */
- (void)parseMealPlanPreferences;
/**
 * Method used to parse get meals for swap
 */
- (void)parseMeals;

#pragma mark Trackers
/**
 * Method used to parse day weight response
 */
- (void)parseDayWeight;
/**
 * Method used to parse weight chart
 */
- (void)parseWeightChart;
/**
* Method used to parse weight logs
*/
- (void)parseWeightList;
/**
 * Method used to parse water logs
 */
- (void)parseWaterList;
/**
 * Method used to parse day measurement response
 */
- (void)parseDayMeasurement;
/**
 * Method used to parse measurement chart
 */
- (void)parseMeasurementChart;
/**
 * Method used to parse measurement logs
 */
- (void)parseMeasurementList;
/**
 * Method used to parse day exercise response
 */
- (void)parseDayExercise;
/**
 * Method used to parse exercise chart
 */
- (void)parseExerciseChart;
/**
 * Method used to parse exercise logs
 */
- (void)parseExerciseList;
/**
 * Method used to parse exercise activities list
 */
- (void)parseExActivities;
/**
 * Method used to parse current weight
 */
- (void)parseExWeight;
/**
 * Method used to parse day glucose response
 */
- (void)parseDayGlucose;
/**
 * Method used to parse glucose chart
 */
- (void)parseGlucoseChart;
/**
 * Method used to parse glucose logs
 */
- (void)parseGlucoseList;
/**
 * Method used to parse journal logs
 */
- (void)parseJournalList;
/**
 * Method used to parse cholesterol logs
 */
- (void)parseCholesterolList;
/**
 * Method used to parse cholesterol chart data
 */
- (void)parseCholesterolChart;
/**
 * Method used to parse BMI logs
 */
- (void)parseBMIList;
/**
 * Method used to parse BMI chart data
 */
- (void)parseBMIChart;
/**
 * Method used to parse BMI day data
 */
- (void)parseDayBMI;
/**
 * Method used to parse goal logs
 */
- (void)parseGoalList;
/**
 * Method used to parse gaol chart data
 */
- (void)parseGoalChart;
/**
 * Method used to parse dashboard goal logs
 */
- (void)parseDashboardGoalList;
/**
 * Method used to parse gaol steps
 */
- (void)parseGoalSteps;
/**
 * Method used to parse gaol step progress
 */
- (void)parseGoalStepProgress;
/**
 * Method used to parse Step logs
 */
- (void)parseStepList;
/**
 * Method used to parse Step chart data
 */
- (void)parseStepChart;
/**
 * Method used to parse Step day data
 */
- (void)parseDayStep;
/**
 * Method used to parse daily goals in settings
 */
- (void)parseTrackerGoals;
/**
 * Method used to parse get notifications and alerts response
 */
- (void)parseNotifications;

#pragma mark messages
/**
 * Method used to parse messages list response
 */
- (void)parseMessages;
/**
 * Method used to parse messages list response
 */
- (void)parseMessageDetail;
/**
 * Method used to parse check recipent response
 */
-(int)parseCheckRecipent;

#pragma mark - Demo Plan
/**
 * Method used to parse Demo Plan response
 */
- (void)parseDemoPlanData;

#pragma mark - Discussion Forum
/**
 * Method used to parse Category list response
 */
- (void)parseCategoryData;
/*
 *Method to parse the forums list response
 */
-(void)parseForums;
/*
 *Method to parse the response of threads
 */
-(void)parseThreads;
/*
 *Method to parse the response of posts
 */
-(void)parsePosts;
/*
 *Method to parse the response of posts
 */
-(void)parseAddNewThread;
/*
 *Method to parse the response of Add new post
 */
-(void)parseAddNewPost;

@end
