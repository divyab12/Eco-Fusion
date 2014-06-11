//
//  RequestMethods.h
//  EHEandme
//
//  Created by EHEandme on 17/09/12.
//  Copyright (c) 2012 EHEandme. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate;

@interface RequestMethods : NSObject{
    
    /**
     * AppDelegate object creating
     */
    AppDelegate *mAppDelegate_;
    
}

@property(nonatomic,strong) id mViewRefrence;
/**
 * Method used to initialize class
 */
- (id)init;
/**
 * Method used to retrieve the user token and type information
 * @param mUserID for the user id
 * @param mName for the user name
 * @param mID for the user coach id
 */
- (void)postRequestForLoginWithUserID:(NSString*)mUserID
                             UserName:(NSString*)mName
                              CoachID:(NSString*)mID;

/**
 * Method used to retrieve the user tokens from the cookies
 * @param mRT for the user RT cookie
 * @param mSV for the user SV cookie
 * @param mCD for the user CD cookie
 */
- (void)postRequestToValidateCookies:(NSString*)mRT
                                  SV:(NSString*)mSV
                                  CD:(NSString*)mCD;
/**
 * Method used to url encode the string
 * @param string for the string to be encoded
 */
-(NSString*)encodeToPercentEscapeString:(NSString *)string;

/**
 * Method used to retrieve the user personal settings
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetUserPersonalSettings:(NSString*)mAuthToken
                                SessionToken:(NSString*)mSessionToken;
/**
 * Method used to check if user has personal settings or not
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToCheckUserPersonalSettings:(NSString*)mAuthToken
                                SessionToken:(NSString*)mSessionToken;
/**
 * Method used to update user has personal settings or not
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 * @param mStartWeight for the start weight of user
 * @param mGoalWeight for the goal weight of user
 * @param mHeightInch for the height of user in inches
 * @param mHeightFeet for the height of user in feets
 * @param mGender for the user gender 0/1
 * @param mActivityLevel for the activity level
 * @param mGoal for the user goals
 */
- (void)postRequestToUpdateUserPersonalSettings:(NSString*)mAuthToken
                                  SessionToken:(NSString*)mSessionToken
                                   StartWeight:(NSString*)mStartWeight
                                    GoalWeight:(NSString*)mGoalWeight
                                  HeightInches:(NSString*)mHeightInch
                                   HeightFeets:(NSString*)mHeightFeet
                                        Gender:(NSString*)mGender
                                 ActivityLevel:(NSString*)mActivityLevel
                                          Goal:(NSString*)mGoal
                                            DOB:(NSString*)mDOB;
/**
 * Method used to check if user has meal plan settings or not
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToCheckUserMealPlanSettings:(NSString*)mAuthToken
                                  SessionToken:(NSString*)mSessionToken;
/**
 * Method used to get user calories
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetUserCalories:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken;
/**
 * Method used to get user meal plan based on the calorie level
 * @param mCalLevel for the user calorie level
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetMealPlans:(NSString*)mCalLevel
                        AuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken;
/**
 * Method used to save user meal plan and the calorie level
 * @param mCalLevel for the user calorie level
 * @param mMealPlan for the meal plan id
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToSaveMealPlans:(NSString*)mCalLevel
                         MealPlan:(NSString*)mMealPlan
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken;
/**
 * Method used to get user meal plan preferences
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetMealPreferences:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken;
/**
 * Method used to save user meal plan preferences
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToSaveMealPreferences:(NSData*)mBody
                               AuthToken:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken;
//request methods
/**
 * Method used to retrieve the user meal plan
 * @param mDate for the date
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestForGetMealPlan:(NSString*)mDate
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for the change report status of a meal
 * @param mDate for the date
 * @param mType for the meal type i.e breakfast/dinner/lunch/snacks/dessert
 * @param mFoodLogId for the logged food id
 * @param mReported for the reported status i.e true/false
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToChangeReportStatus:(NSString *)mDate
                         FoodLogDailyId:(NSString *)mFoodLogDailyId
                              FoodLogID:(NSString *)mFoodLogId
                               Reported:(NSString *)mReported
                              AuthToken:(NSString *)mAuthToken
                           SessionToken:(NSString *)mSessionToken;
/**
 * Method used to post request to update the logged food item quantity
 * @param mDate for the date
 * @param mType for the meal type i.e breakfast/dinner/lunch/snacks/dessert
 * @param mFoodLogId for the logged food id
 * @param mQty for the quantity
 * @param mUnitID for the unit ID
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestForEditLogFood:(NSString *)mDate
                         MealType:(NSString *)mType
                   FoodLogDailyId:(NSString *)mFoodLogDailyId
                        FoodLogID:(NSString *)mFoodLogId
                           FoodID:(NSString *)mFoodID
                         Quantity:(NSString *)mQty
                           UnitID:(NSString *)mUnitID
                         Favorite:(NSString *)mFavorite
                        AuthToken:(NSString *)mAuthToken
                     SessionToken:(NSString *)mSessionToken;
/**
 * Method used to delete the  logged Food
 * @param mDate for the date
 * @param mType for the meal type i.e breakfast/dinner/lunch/snacks/dessert
 * @param mFoodLogId for the logged food id
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestForDeleteLogFood:(NSString*)mDate
                     FoodLogDailyId:(NSString*)mFoodLogDailyId
                          FoodLogID:(NSString*)mFoodLogId
                          AuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post the  request to add a food item to the meal planner
 * @param mDate for the date
 * @param mType for the meal type i.e breakfast/dinner/lunch/snacks/dessert
 * @param mFoodId for the food id
 * @param mQty for the quantity
 * @param mUnitID for the unit ID
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestForFoodAdd:(NSString*)mDate
                     MealType:(NSString*)mType
                       FoodID:(NSString*)mFoodId
                     Quantity:(NSString*)mQty
                       UnitID:(NSString*)mUnitID
                    AuthToken:(NSString*)mAuthToken
                 SessionToken:(NSString*)mSessionToken;

//Upload photo
- (void)postRequestForUploadPhoto:(NSString*)mDate
                         MealName:(NSString*)mMeal
                         FoodName:(NSString*)mFoodName
                         Calories:(NSString*)mCalory
                            Image:(UIImage*)mImage
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken;
/*
 * Method used to search the food
 * @param mSearchText for the text entered in the search bar by the user
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestForSearchFood:(NSString*)mSearchText
                       AuthToken:(NSString*)mAuthToken
                    SessionToken:(NSString*)mSessionToken;
/*
 * Method used to get the food info
 * @param mFoodId for the food id
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetFoodInfo:(NSString*)mFoodId
                       AuthToken:(NSString*)mAuthToken
                    SessionToken:(NSString*)mSessionToken;
/*
 * Method used to get the private foods
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetPrivateFoods:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken;

- (void)postRequestToGetAvailableDTGMeals:(NSString*)mDate
                                 MealType:(NSString*)mMealType
                            withAuthToken:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken;
//Save Private Food
- (void)postRequestToSavePrivateFood:(NSString*)body withAuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken;
//Get Food Units
- (void)postRequestToGetFoodUnits:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken;

/*
 * Method used to get the favorites foods
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetRecentFoods:(NSString*)mMealtype
                      withAuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken;
/*
 * Method used to get the favorites foods
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetFavoritesFoods:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken;
/*
 * Method used to add food to the favorite foods
 * @param mFoodId for the food id
 * @param mQty for the quantity
 * @param mUnitID for the unit ID
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToAddFoodToFavorites:(NSString*)mFoodId
                               Quantity:(NSString*)mQty
                                 UnitID:(NSString*)mUnitID
                              AuthToken:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken;
/*
 * Method used to remove food to the favorite foods
 * @param mFoodId for the food id
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToRemoveFoodToFavorites:(NSString*)mFoodId
                                 AuthToken:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken;

/*
* Method used to retreive the LookUp table values
* @param mType for the LookUp type i.e Gender/CalorieLevel etc
* @param mAuthToken for the Authorization token
* @param mSessionToken for the session token
*/
- (void)postRequestToGetLookUp:(NSString*)mType
                     AuthToken:(NSString*)mAuthToken
                  SessionToken:(NSString*)mSessionToken;
/*
 * Method used to get the avaliable meals from swapping meal
 * @param mDate for the date
 * @param mMeal for the meal type i.e breakfast/lunch/snacks/dessert
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetMeals:(NSString*)mDate
                         Meal:(NSString*)mMeal
                    AuthToken:(NSString*)mAuthToken
                 SessionToken:(NSString*)mSessionToken;
/*
 * Method used to swap meals 
 * @param mDate for the date
 * @param mMealId for the selected meal id
 * @param mMeal for the meal type i.e breakfast/lunch/snacks/dessert
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToSwapMeal:(NSString*)mDate
                         Meal:(NSString*)mMeal
                       MealID:(NSString*)mMealId
                    AuthToken:(NSString*)mAuthToken
                 SessionToken:(NSString*)mSessionToken;


 /**
 * Method used to post request for logout
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToLogout:(NSString*)mAuthToken
               SessionToken:(NSString*)mSessionToken;

#pragma mark Trackers
/**
 * Method used to post request for retrieving weight day log
 * @param mDate for the date
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetDayWeight:(NSString*)mDate
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for retrieving recent weight logs
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetWeightLogs:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for adding weight log
 * @param mDate for the date
 * @param mweight for the weight
 * @param mNotes for the notes
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToAddWeightLog:(NSString*)mDate
                           Weight:(NSString*)mweight
                            Notes:(NSString*)mNotes
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request to retreive weight chart data
 * @param mRange for the Week/Month/Quarter range
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetWeightChartData:(NSString*)mRange
                              AuthToken:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to delete weight log
 * @param mId for the weight log id to be deleted
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToDeleteWeightLog:(NSString*)mId
                              AuthToken:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken;
//water tracker
/**
 *Method used to get the  Recent Log water
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetWaterLogs:(NSString *)mAuthToken
                          SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request for retrieving measurement day log
 * @param mDate for the date
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetDayMeasurement:(NSString*)mDate
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for retrieving recent measurement logs
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetMeasurementLogs:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for adding measurement log
 * @param mDate for the date
 * @param mArms for the arms
 * @param mChest for the chest
 * @param mWaist for the waist
 * @param mHips for the hips
 * @param mThighs for the thighs
 * @param mNotes for the notes
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToAddMeasurementLog:(NSString*)mDate
                                  Arms:(NSString*)mArms
                                 Chest:(NSString*)mChest
                                 Waist:(NSString*)mWaist
                                  Hips:(NSString*)mHips
                                Thighs:(NSString*)mThighs
                                 Notes:(NSString*)mNotes
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request to retreive measurement chart data
 * @param mRange for the Week/Month/Quarter range
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetMeasurementChartData:(NSString*)mRange
                                   AuthToken:(NSString*)mAuthToken
                                SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to delete measurement log
 * @param mId for the measurement log id to be deleted
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToDeleteMeasurementLog:(NSString*)mId
                           AuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken;

//exercise tracker
/**
 * Method used to get the  Recent Log exercise
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetExerciseLogs:(NSString *)mAuthToken
                     SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request for retrieving exercise day log
 * @param mDate for the date
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetDayExercise:(NSString*)mDate
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for adding exercise log
 * @param mDate for the date
 * @param mActivity for the activity
 * @param mDuration for the duration
 * @param mCal for the calories
 * @param mNotes for the notes
 * @param mLogSource for the LogSource
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToAddExerciseLog:(NSString*)mDate
                           Activity:(NSString*)mActivity
                           Duration:(NSString*)mDuration
                           Calories:(NSString*)mCal
                              Notes:(NSString*)mNotes
                          LogSource:(NSString*)mLogSource
                          AuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request to retreive exercise chart data
 * @param mRange for the Week/Month/Quarter range
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetExerciseChartData:(NSString*)mRange
                                   AuthToken:(NSString*)mAuthToken
                                SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to delete exercise log
 * @param mId for the measurement log id to be deleted
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToDeleteExerciseLog:(NSString*)mId
                                AuthToken:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to get user current weight for calories caluclation
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetUserCurrentWeight:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to get exercise activities list
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetExerciseActivities:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken;
//glucose tracker
/**
 * Method used to get the  Recent Log glucose
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetGlucoseLogs:(NSString *)mAuthToken
                        SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request for retrieving glucose day log
 * @param mDate for the date
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetDayGlucose:(NSString*)mDate
                          AuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for adding glucose log
 * @param mDate for the date
 * @param mGlucose for the glucose
 * @param mNotes for the notes
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToAddGlucoseLog:(NSString*)mDate
                           Glucose:(NSString*)mGlucose
                              Notes:(NSString*)mNotes
                          AuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request to retreive glucose chart data
 * @param mRange for the Week/Month/Quarter range
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetGlucoseChartData:(NSString*)mRange
                                AuthToken:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to delete glucose log
 * @param mId for the measurement log id to be deleted
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToDeleteGlucoseLog:(NSString*)mId
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken;
//journal tracker
/**
 * Method used to get the  Recent Log journal
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetJournalLogs:(NSString *)mAuthToken
                       SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for adding journal log
 * @param mDate for the date
 * @param mCat for the journal category
 * @param mNotes for the notes
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToAddJournalLog:(NSString*)mDate
                           Category:(NSString*)mCat
                             Notes:(NSString*)mNotes
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to delete journal log
 * @param mId for the journal log id to be deleted
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToDeleteJournalLog:(NSString*)mId
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken;
//cholesterol tracker
/**
 * Method used to get the  Recent Log cholesterol
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetCholesterolLogs:(NSString *)mAuthToken
                           SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for adding cholesterol log
 * @param mDate for the date
 * @param UserID for the userid
 * @param mCholesterol for the total cholesterol
 * @param mNotes for the notes
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToAddCholesterolLog:(NSString*)mDate
                      TotalCholesterol:(NSString*)mCholesterol
                        LDLCholesterol:(NSString*)mLDL
                        HDLCholesterol:(NSString*)mHDL
                             Notes:(NSString*)mNotes
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to delete cholesterol log
 * @param mId for the journal log id to be deleted
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToDeleteCholesterolLog:(NSString*)mId
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to retreive cholesterol chart data
 * @param mRange for the Week/Month/Quarter range
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetCholesterolChartData:(NSString*)mRange
                                AuthToken:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken;

//BMI tracker
/**
 * Method used to get the  Recent Log BMI
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetBMILogs:(NSString *)mAuthToken
                       SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request for retrieving BMI day log
 * @param mDate for the date
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetDayBMI:(NSString*)mDate
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for BMI glucose log
 * @param mDate for the date
 * @param mUserId for the userID
 * @param mHeightFt for the height in feets
 * @param mHeightInch for the height in inches
 * @param mWeight for the weight
 * @param mNotes for the notes
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToAddBMILog:(NSString*)mDate
                      HeightFt:(NSString*)mHeightFt
                   HeightInchs:(NSString*)mHeightInch
                        Weight:(NSString*)mWeight
                         Notes:(NSString*)mNotes
                     AuthToken:(NSString*)mAuthToken
                  SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request to retreive BMI chart data
 * @param mRange for the Week/Month/Quarter range
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetBMIChartData:(NSString*)mRange
                               AuthToken:(NSString*)mAuthToken
                            SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to delete BMI log
 * @param mId for the measurement log id to be deleted
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToDeleteBMIGlucoseLog:(NSString*)mId
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken;

//Goal Trcaker
/**
 * Method used to post request to retreive the goals for dashboard
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetGoalsForDashboard:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to retreive the goals steps for drowpdown
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetGoalSteps:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to retreive goal chart data
 * @param mStep for the goal step
 * @param mRange for the Week/Month/Quarter range
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetGoalChartData:(NSString*)mStep
                               Range:(NSString*)mRange
                           AuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken;
/*
 * Method used to get the goal step progress for a day
 * @param mUserStepId
 * @param mDate
 */
- (void)postRequestToGetGoalStepProgress:(NSString*)mUserStepId
                                    Date:(NSString*)mDate
                               AuthToken:(NSString*)mAuthToken
                            SessionToken:(NSString*)mSessionToken;

/**
 * Method used to get the  Recent Log goal
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetGoalLogs:(NSString *)mAuthToken
                   SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to add a goal
 * @param mDate for the date
 * @param mStep for the goal step
 * @param mUserStepId for the user step id
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToAddGoal:(NSString*)mDate
                      StepID:(NSString*)mStep
                  UserStepID:(NSString*)mUserStepId
                       Value:(NSString*)mValue
                       Notes:(NSString*)mNotes
                   AuthToken:(NSString*)mAuthToken
                SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to delete goal
 * @param mId for the goal log id to be deleted
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToDeleteGoal:(NSString*)mId
                      AuthToken:(NSString*)mAuthToken
                   SessionToken:(NSString*)mSessionToken;

//step tracker
/**
 * Method used to get the  Recent Log step
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetStepLogs:(NSString *)mAuthToken
                       SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request for retrieving step day log
 * @param mDate for the date
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetDayStep:(NSString*)mDate
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request for adding step log
 * @param mDate for the date
 * @param mSteps for the steps
 * @param mNotes for the notes
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToAddStepLog:(NSString*)mDate
                          Steps:(NSString*)mSteps
                          Notes:(NSString*)mNotes
                      LogSource:(NSString*)mLogSource
                      AuthToken:(NSString*)mAuthToken
                   SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request to retreive step chart data
 * @param mRange for the Week/Month/Quarter/Today range
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetStepChartData:(NSString*)mRange
                               AuthToken:(NSString*)mAuthToken
                            SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to delete step log
 * @param mId for the measurement log id to be deleted
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToDeleteStepLog:(NSString*)mId
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to get tracker goals to display in the daily goals settings screen
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestToGetTrackerGoals:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to get the alert and notifications page settings
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 * @param mId for the device id
 */
- (void)postRequestToGetNotifications:(NSString*)mID
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to save the alert and notifications page settings
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 * @param mCoachMessages for the new message alert true/false
 * @param mGoalReached for the goal reached alert true/false
 * @param mDailyReminder for the daily reminder alert true/false
 * @param mWeeklyReminder for the weekly reminder alert true/false
 */
- (void)postRequestToSaveNotifications:(NSString*)mID
                               Message:(NSString*)mCoachMessages
                                  Goal:(NSString*)mGoalReached
                                 Daily:(NSString*)mDailyReminder
                                Weekly:(NSString*)mWeeklyReminder
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken;
#pragma mark Messages
/**
 * Method used to post request to get messages list
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 * @param mFolder for the messages in (Inbox/Sent/Archive/Trash)
 * @param mNum for the page number
 * @param mFlag for the unreadonly true/false flag value
 */
- (void)postRequestToGetMessagesList:(NSString*)mFolder
                                Page:(NSString*)mNum
                          UnreadOnly:(NSString*)mFlag
                           AuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to get messages thread
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 * @param mID for the message id
 */
- (void)postRequestToGetMessageThread:(NSString*)mID
                           AuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to archive message
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 * @param mID for the message id
 */
- (void)postRequestToArchiveMessage:(NSString*)mID
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to delete message
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 * @param mID for the message id
 */
- (void)postRequestToDeleteMessage:(NSString*)mID
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to reply a message
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 * @param mRecipentID for the recipent ID
 * @param mType for the recipent Type i.e Coach/User
 * @param mSubject for the message subject
 * @param mBody for the message body
 */
- (void)postRequestToReplyToMessage:(NSString*)mRecipentID
                               Type:(NSString*)mType
                            Subject:(NSString*)mSubject
                               Body:(NSString*)mBody
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to check whether user available or not
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 * @param mRecipentName for the recipent name
 */
- (void)postRequestToCheckRecipent:(NSString*)mRecipentName
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request to send new message
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 * @param mRecipentID for the recipent ID
 * @param mType for the recipent Type i.e Coach/User
 * @param mSubject for the message subject
 * @param mBody for the message body
 */
- (void)postRequestToSendNewMessage:(NSString*)mRecipentID
                               Type:(NSString*)mType
                            Subject:(NSString*)mSubject
                               Body:(NSString*)mBody
                          AuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken;
#pragma mark - Demo Meal Plans
-(void)postRequestTogetDemoMealPlan:(NSString *)mAuthToken
                       SessionToken:(NSString*)mSessionToken;

#pragma mark - Discussion forums
/**
 * Method used to post request to Category list data
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
-(void)postRequestForcategory:(NSString *)mAuthToken
                 SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request to Forum list data for a category.
 * @param category for the category id
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestForforums:(NSString*)category
                   AuthToken:(NSString*)mAuthToken
                SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request to Forum list data for a category.
 * @param category for the category id
 * @param forum for the forum id
 * @param page for the page id
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
- (void)postRequestForThreads:(NSString*)category
                        forum:(NSString*)forumId
                         page:(NSString*)pageNo
                    AuthToken:(NSString*)mAuthToken
                 SessionToken:(NSString*)mSessionToken;

/**
 * Method used to post request to Post list data for a category.
 * @param category for the category id
 * @param forum for the forum id
 * @param threadId for the thread id
 * @param page for the page id
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
-(void)postRequestForPosts:(NSString*)category
                     forum:(NSString*)forumId
                    thread:(NSString*)threadId
                      page:(NSString*)pageNo
                 AuthToken:(NSString*)mAuthToken
              SessionToken:(NSString*)mSessionToken;

/**
 * Method used to Add a new thread.
 * @param category for the category id
 * @param forum for the forum id
 * @param mTitle for the mTitle
 * @param mBody for the page mBody
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
-(void)postRequestForAddNewThread:(NSString*)category
                            forum:(NSString*)forumId
                            Title:(NSString*)mTitle
                             Body:(NSString*)mBody
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken;

/**
 * Method used to Add a new thread.
 * @param category for the category id
 * @param forum for the forum id
 * @param thread for the threadId
 * @param mBody for the page mBody
 * @param mAuthToken for the Authorization token
 * @param mSessionToken for the session token
 */
-(void)postRequestForAddNewPost:(NSString*)category
                          forum:(NSString*)forumId
                         Thread:(NSString*)threadId
                           Body:(NSString*)mBody
                      AuthToken:(NSString*)mAuthToken
                   SessionToken:(NSString*)mSessionToken;
@end
