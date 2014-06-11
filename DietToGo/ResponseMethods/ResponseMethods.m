
//
//  ResponseMethods.m
//  EHEandme
//
//  Created by EHEandme on 17/09/12.
//  Copyright (c) 2012 EHEandme. All rights reserved.
//
#import "ResponseMethods.h"
#import "AppDelegate.h"
#import "UtilitiesLibrary.h"
#import "WebEngine.h"
#import "JSON.h"
#import "ParserMethods.h"
#import "LoginViewController.h"
#import "MealPlannerSettingsViewController.h"
#import "AddFoodViewController.h"
#import "FoodDetailsViewController.h"
#import "MenuViewController.h"
#import "SettingsViewController.h"
#import "WeightListViewController.h"
#import "WaterListViewController.h"
#import "MeasurementListViewController.h"
#import "ExerciseListViewController.h"
#import "GlucoseListViewController.h"
#import "MyJournalListViewController.h"
#import "CholesterolListViewController.h"
#import "BMIListViewController.h"
#import "StepListViewController.h"
#import "GoalListViewController.h"
#import "DailyGoalsSettingViewController.h"
#import "AddGoalViewController.h"
#import "LandingViewController.h"
#import "NotificationsSettngsViewController.h"
#import "MessagesListViewController.h"
#import "NewMessageViewController.h"
#import "EditServingViewController.h"
#import "AddNewPrivateFoodController.h"
#import "AddEditFoodDetailController.h"

//Discussion forum
#import "CategotyViewController.h"
#import "ForumsViewController.h"
#import "ThreadsViewController.h"
#import "PostsViewController.h"

@implementation ResponseMethods
@synthesize userName,userType,authToken,sessionToken,mPrevViewOfSlider,mIsLogMealReported,coachID;

@synthesize mErrorStr;
- (id)init
{
    if (self = [super init])
    {
        // Initialization code here
        mAppDelegate_ = [AppDelegate appDelegateInstance];
        //notifications
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(onResponseObserver:) 
                                                     name: @"onResponse" 
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(onNilResponseObserver:) 
                                                     name: @"onNilResponse" 
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(ResponseFailed:) 
                                                     name: @"ResponseFailed" 
                                                   object: nil];
        
    }
    
    return self;
    
}

#pragma mark onResponse methods
#pragma mark response observer

- (void)onResponseObserver:(NSNotification*)notification {
    // [self removeLoadView];
   
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
     DLog(@"response found server %@",response);

    [mAppDelegate_ removeLoadView];
    //to check for valid response or not
    if ([self isResponseValid]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"AN_ERROR_OCCURED", nil)];
        //[UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :self.mErrorStr];
        return;
    }
    if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETTOKENS]) {
        [mAppDelegate_.mParserMethods_ parseLogin];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETPERSONALSETTINGS]) {
        [mAppDelegate_.mParserMethods_ parseGetPersonalSettings];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:CHECKPERSONALSETTINGS] ) {
        //if(!FALSE){
       if(![mAppDelegate_.mParserMethods_ parseCheckPersonalSettings]){//false show personal settings
            [self successResponse];
        }else{
            [mAppDelegate_ displayMainView];

        }
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:CHECKMEALPLANSETTINGS] ) {
        if(![mAppDelegate_.mParserMethods_ parseCheckPersonalSettings]){//false show meal plan settings
            [self successResponse];
        }else{
            LogMealsViewController *lVC = [[LogMealsViewController alloc]initWithNibName:@"LogMealsViewController" bundle:nil];
            mAppDelegate_.mLogMealsViewController = lVC;
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:mAppDelegate_.mLogMealsViewController];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            [mAppDelegate_.mSlidingViewController resetTopView];
        }
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GENDER] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ACTIVITYLEVEL] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:MEALGOAL] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:CALORIELEVEL] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:JOURNALCATEGORY]) {
        [mAppDelegate_.mParserMethods_ parseLookUp];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETCALORIELEVEL]) {
        [mAppDelegate_.mParserMethods_ parseCalorieLevel];
    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETMEALPLANS]){
        [mAppDelegate_.mParserMethods_ parseMealPlans];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SAVEMEALPLANS] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SAVEMEALPREFERENCES]){
        [self successResponse];
    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETMEALPREFERENCES]){
        [mAppDelegate_.mParserMethods_ parseMealPlanPreferences];
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:UPDATEPERSONALSETTINGS]) {
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:CHANGEREPORTSTATUS])
    {
        [self successResponse];
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETMEALPLAN]) {
        [mAppDelegate_.mParserMethods_ parseGetMealPlan];
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SEARCHGFOOD]||[mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETPRIVATEFOODS]||[mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETFAVORITEFOODS] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETRECENTFOODS] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETDTGMEALS] ) {
        [mAppDelegate_.mParserMethods_ parseSearchFood];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETFOODUNITS])
    {
        [mAppDelegate_.mParserMethods_ parseFoodUnits];
        
    } else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SAVEPRIVATEFOOD])
    {
        [mAppDelegate_.mParserMethods_ parseSavePrivateFood];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:FOODINFO]) {
        [mAppDelegate_.mParserMethods_ parseFoodInfo];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ADDGFOOD])
    {
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ADDPHOTOFOOD])
    {
        [mAppDelegate_.mParserMethods_ parseUploadPhotoRequest];
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DELETELOGFOOD]||[mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:EDITLOGFOOD])
    {
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ADDFOODTOFAVORITEFOODS]|| [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:REMOVEFOODFROMFAVORITEFOODS] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SWAPMEAL])
    {
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETMEALS])
    {
        [mAppDelegate_.mParserMethods_ parseMeals];
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:LOGOUT]) {
        [mAppDelegate_.mParserMethods_ parseLogout];
    }
    //trackers
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:EditWeight] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteWeightLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddWeightLog]) {
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetWeightChartData]){
        [mAppDelegate_.mParserMethods_ parseWeightChart];

    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetWeightLogs]){
        [mAppDelegate_.mParserMethods_ parseWeightList];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDayWeight]){
        [mAppDelegate_.mParserMethods_ parseDayWeight];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetWaterLogs]){
        [mAppDelegate_.mParserMethods_ parseWaterList];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetMeasurementChartData]){
        [mAppDelegate_.mParserMethods_ parseMeasurementChart];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetMeasurementLogs]){
        [mAppDelegate_.mParserMethods_ parseMeasurementList];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDayMeasurement]){
        [mAppDelegate_.mParserMethods_ parseDayMeasurement];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:EditMeasurement] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteMeasurementLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddMeasurementLog]) {
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetExerciseChartData]){
        [mAppDelegate_.mParserMethods_ parseExerciseChart];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetExerciseLogs]){
        [mAppDelegate_.mParserMethods_ parseExerciseList];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDayExercise]){
        [mAppDelegate_.mParserMethods_ parseDayExercise];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetActivities]){
        [mAppDelegate_.mParserMethods_ parseExActivities];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetCurrentWeight]){
        [mAppDelegate_.mParserMethods_ parseExWeight];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteExerciseLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddExerciseLog]) {
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetGlucoseChartData]){
        [mAppDelegate_.mParserMethods_ parseGlucoseChart];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetGlucoseLogs]){
        [mAppDelegate_.mParserMethods_ parseGlucoseList];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDayGlucose]){
        [mAppDelegate_.mParserMethods_ parseDayExercise];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteGlucoseLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddGlucoseLog]) {
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteJournalLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddJournalLog]) {
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetJournalLogs]){
        [mAppDelegate_.mParserMethods_ parseJournalList];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetCholesterolChartData]){
        [mAppDelegate_.mParserMethods_ parseCholesterolChart];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetCholesterolLogs]){
        [mAppDelegate_.mParserMethods_ parseCholesterolList];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteCholesterolLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddCholesterolLog]) {
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetBMIChartData]){
        [mAppDelegate_.mParserMethods_ parseBMIChart];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetBMILogs]){
        [mAppDelegate_.mParserMethods_ parseBMIList];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDayBMI]){
        [mAppDelegate_.mParserMethods_ parseDayBMI];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteBMILog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddBMILog]) {
        [self successResponse];
    }
    //goal tracker
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetGoalChartData]){
        [mAppDelegate_.mParserMethods_ parseGoalChart];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetGoalLogs]){
        [mAppDelegate_.mParserMethods_ parseGoalList];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetGoalSteps]){
        [mAppDelegate_.mParserMethods_ parseGoalSteps];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDashboardGoals]){
        [mAppDelegate_.mParserMethods_ parseDashboardGoalList];
        
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteGoal] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddGoal]) {
        [self successResponse];
    }
    //step tracker
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetStepChartData]){
        [mAppDelegate_.mParserMethods_ parseStepChart];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetStepLogs]){
        [mAppDelegate_.mParserMethods_ parseStepList];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDaySteps]){
        [mAppDelegate_.mParserMethods_ parseDayStep];
        
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteStepLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddStepLog]) {
        [self successResponse];
    }
    //daily goals settings
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetTrackerGoals]){
        [mAppDelegate_.mParserMethods_ parseTrackerGoals];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetStepProgress]){
        [mAppDelegate_.mParserMethods_ parseGoalStepProgress];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetNotifications]){
        [mAppDelegate_.mParserMethods_ parseNotifications];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SaveNotifications]){
        [self successResponse];
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteMessage]||[mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ArchiveMessage]){
        [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetMessagesList]){
        [mAppDelegate_.mParserMethods_ parseMessages];

    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetMessage]){
        [mAppDelegate_.mParserMethods_ parseMessageDetail];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ReplyMessage] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SendNewMessage]){
         [self successResponse];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:CheckRecipent]){
        int value = [mAppDelegate_.mParserMethods_ parseCheckRecipent];
        if (value < 0) {
            [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"The entered Screen name does not exist. Please check again."];
            return;
        }else{
            [mAppDelegate_.mNewMessageViewController postSendMessageRequest:value];
        }
    }//Demo Plan
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETDEMOPLAN]){
        [mAppDelegate_.mParserMethods_ parseDemoPlanData];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETCATEGORYDATA]){
        [mAppDelegate_.mParserMethods_ parseCategoryData];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETFORUMSINCATEGORY]){
        [mAppDelegate_.mParserMethods_ parseForums];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETTHREADSINFORUM]){
        [mAppDelegate_.mParserMethods_ parseThreads];
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETPOSTSINTHREADS]){
        [mAppDelegate_.mParserMethods_ parsePosts];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ADDNEWTHREAD]){
        [mAppDelegate_.mParserMethods_ parseAddNewThread];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ADDPOSTTOTHREAD]){
        [mAppDelegate_.mParserMethods_ parseAddNewPost];
    }
   
}
#pragma mark nil response observer
- (void)onNilResponseObserver: (NSNotification*)notification {
    
    [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"NO_RESPONSE", nil)];
    if ([mShowLogs isEqualToString:@"TRUE"]) 
        NSLog(@"nil response from server");
    [mAppDelegate_ removeLoadView];
    
}

#pragma mark  response failed
- (void)ResponseFailed: (NSNotification*)notification {
	
    [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"NO_RESPONSE", nil)];
    if ([mShowLogs isEqualToString:@"TRUE"]) 
        NSLog(@"response failed from server");
    [mAppDelegate_ removeLoadView];
}
- (BOOL)isResponseValid
{
    BOOL flag = FALSE;
    NSString *response = [[NSString alloc] initWithBytes: [mAppDelegate_.mWebEngine_->webData mutableBytes]
                                                  length:[ mAppDelegate_.mWebEngine_->webData length]
                                                encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",response);
    if ([[response JSONValue] isKindOfClass:[NSMutableArray class]]) {
        return flag;
    }
    else
    {
        NSMutableDictionary *mDict = [response JSONValue];
        if ([mDict objectForKey:@"Message"]!=nil ) {
            self.mErrorStr = [mDict objectForKey:@"Message"];
            flag = TRUE;
        }
    }
    
    return flag;
    
}

- (void)successResponse{
    if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETTOKENS]){
        [self StoreUserDetails:[[mAppDelegate_.mDataGetter_.mLoginDict_ objectForKey:@"User"]objectForKey:@"UserName"] AuthToken:[[mAppDelegate_.mDataGetter_.mLoginDict_ objectForKey:@"Tokens"]objectForKey:@"AuthToken"] SessionToken:[[mAppDelegate_.mDataGetter_.mLoginDict_ objectForKey:@"Tokens"] objectForKey:@"SessionToken"] UserType:[[mAppDelegate_.mDataGetter_.mLoginDict_ objectForKey:@"User"] objectForKey:@"UserType"] CoachID:[mAppDelegate_.mDataGetter_.mLoginDict_ objectForKey:@"CoachID"]];
        //if([[mAppDelegate_.mDataGetter_.mLoginDict_ objectForKey:@"HasPersonalSettings"] boolValue])
        {
                       
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToCheckUserPersonalSettings:self.authToken
                                                                        SessionToken:self.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
        }/*else{
            [mAppDelegate_ displayMainView];

        }*/
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:CHECKPERSONALSETTINGS]){
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate_.mRequestMethods_ postRequestToGetUserPersonalSettings:self.authToken
                                                                      SessionToken:self.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:CHECKMEALPLANSETTINGS]){

        //to retrieve the user calorie level from look ups
        if (mAppDelegate_.mDataGetter_.mCalLevelList_.count == 0) {
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetLookUp:CALORIELEVEL
                                                             AuthToken:self.authToken
                                                          SessionToken:self.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
        }else{
            //to retrieve the user calorie level of the user
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetUserCalories:self.authToken
                                                                SessionToken:self.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
        }
        

    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:CALORIELEVEL]){
        
        //when calorie in from meal plan(menu list) or from settings section
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]] || [mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[SettingsViewController class]] || [mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[LandingViewController class]] || [mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[LogMealsViewController class]]) {
            //to retrieve the user calorie level of the user
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetUserCalories:self.authToken
                                                                SessionToken:self.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[DailyGoalsSettingViewController class]]){
           // [mAppDelegate_.mDailyGoalsSettingViewController postRequestToGetMealPlan];
        }
        
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETCALORIELEVEL]){
        //post req to get meal plan for calorie level
        
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetMealPlans:[mAppDelegate_.mDataGetter_.mUserCalorieLevel  objectForKey:@"UserCaloriesLevel"] AuthToken:self.authToken SessionToken:self.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETMEALPLANS]){
        
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[LogMealsViewController class]]) {
            [mAppDelegate_.mLogMealsViewController populateTheView];

        }else{
            //post req to get meal plan prefrences
            
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetMealPreferences:self.authToken
                                                                   SessionToken:self.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }

        }
        
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SAVEMEALPLANS]){
       // [mAppDelegate_.mMealPlannerSettingsViewController postRequestToSavePref];
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETMEALPREFERENCES])
    {
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to meal plan settings page
            MealPlannerSettingsViewController *lVC = [[MealPlannerSettingsViewController alloc]initWithNibName:@"MealPlannerSettingsViewController" bundle:nil];
            lVC.isFromSlider = TRUE;
            mAppDelegate_.mMealPlannerSettingsViewController = lVC;
            self.mPrevViewOfSlider = mAppDelegate_.mSlidingViewController.topViewController;
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            [mAppDelegate_.mSlidingViewController resetTopView];

        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[SettingsViewController class]]){
            //to move user to meal plan settings page
            MealPlannerSettingsViewController *lVC = [[MealPlannerSettingsViewController alloc]initWithNibName:@"MealPlannerSettingsViewController" bundle:nil];
            lVC.isFromSlider = FALSE;
            mAppDelegate_.mMealPlannerSettingsViewController = lVC;
            [mAppDelegate_.mSettingsViewController.navigationController pushViewController:lVC animated:TRUE];
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[LandingViewController class]]){
            MealPlannerSettingsViewController *lVC = [[MealPlannerSettingsViewController alloc]initWithNibName:@"MealPlannerSettingsViewController" bundle:nil];
            lVC.isFromSlider = FALSE;
            mAppDelegate_.mMealPlannerSettingsViewController = lVC;
            self.mPrevViewOfSlider = mAppDelegate_.mSlidingViewController.topViewController;
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            [mAppDelegate_.mSlidingViewController resetTopView];
        }
        
    } else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SAVEMEALPREFERENCES])
    {
        
        [mAppDelegate_ showCustomAlert:@"" Message:NSLocalizedString(@"MEAL_DETAILS_UPDATE_SUCCESS", nil)];
        if (mAppDelegate_.mMealPlannerSettingsViewController.isFromSlider) {
            LogMealsViewController *lVC = [[LogMealsViewController alloc]initWithNibName:@"LogMealsViewController" bundle:nil];
            mAppDelegate_.mLogMealsViewController = lVC;
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:mAppDelegate_.mLogMealsViewController];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            [mAppDelegate_.mSlidingViewController resetTopView];
        }else{
            if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[SettingsViewController class]]) {
                [mAppDelegate_.mMealPlannerSettingsViewController.navigationController popViewControllerAnimated:TRUE];
                
            }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[LandingViewController class]]){
                LogMealsViewController *lVC = [[LogMealsViewController alloc]initWithNibName:@"LogMealsViewController" bundle:nil];
                mAppDelegate_.mLogMealsViewController = lVC;
                UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:mAppDelegate_.mLogMealsViewController];
                mAppDelegate_.mSlidingViewController.topViewController = NVGController;
                [mAppDelegate_.mSlidingViewController resetTopView];
                
            }
        }
       
    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETPERSONALSETTINGS]){
        
        //post request for activity levels
        if (mAppDelegate_.mDataGetter_.mActivityLevelList_.count == 0) {
            if ([[NetworkMonitor instance] isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetLookUp:ACTIVITYLEVEL
                                                             AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance] displayNetworkMonitorAlert];
            }
        }/*else if (mAppDelegate_.mDataGetter_.mMealGoalList_.count == 0){
            if ([[NetworkMonitor instance] isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetLookUp:MEALGOAL
                                                             AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance] displayNetworkMonitorAlert];
            }
        }*/else  {
            if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[SettingsViewController class]]) {
                [mAppDelegate_.mSettingsViewController pushToSettingsPage];
            }else{
                [mAppDelegate_.mLoginViewController displayPersonalSettingsView];
                
            }
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ACTIVITYLEVEL]){
       /* if (mAppDelegate_.mDataGetter_.mMealGoalList_.count == 0)
        {
            if ([[NetworkMonitor instance] isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetLookUp:MEALGOAL
                                                             AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance] displayNetworkMonitorAlert];
            }
        }else */{
            if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[SettingsViewController class]]) {
                [mAppDelegate_.mSettingsViewController pushToSettingsPage];
            }else{
                [mAppDelegate_.mLoginViewController displayPersonalSettingsView];
                
            }
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:MEALGOAL]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[SettingsViewController class]]) {
            [mAppDelegate_.mSettingsViewController pushToSettingsPage];
        }else{
            [mAppDelegate_.mLoginViewController displayPersonalSettingsView];
            
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:UPDATEPERSONALSETTINGS]){
        [mAppDelegate_ showCustomAlert:@"" Message:NSLocalizedString(@"PERSONAL_DETAILS_UPDATE_SUCCESS", nil)];
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[SettingsViewController class]]) {
            [mAppDelegate_.mSettingsViewController.navigationController popToRootViewControllerAnimated:TRUE];
        }else{
            [mAppDelegate_ displayMainView];
        }

    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETMEALPLAN]){
        
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[LogMealsViewController class]]) {
            [mAppDelegate_.mLogMealsViewController populateTheView];
            
        }
        /* //Commenting on April 16
        //to retrieve the user calorie level from look ups
        if (mAppDelegate_.mDataGetter_.mCalLevelList_.count == 0) {
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetLookUp:CALORIELEVEL
                                                             AuthToken:self.authToken
                                                          SessionToken:self.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
        }else{
            //to retrieve the user calorie level of the user
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetUserCalories:self.authToken
                                                                SessionToken:self.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
        }*/

    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:CHANGEREPORTSTATUS]){
        
        if ([self.mIsLogMealReported boolValue]) {
            //[UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"CONGRATULATIONS_TITLE", nil) :NSLocalizedString(@"CHANGEREPORT_REPORTED_SUCCESS_RESPONSE", nil)];
        }else
        {
            [mAppDelegate_ showCustomAlert:@"" Message:NSLocalizedString(@"CHANGEREPORT_UNREPORTED_SUCCESS_RESPONSE", nil)];

        }

        /*
         * post request for get the recent logs per day
         */
        [mAppDelegate_.mLogMealsViewController postRequestForMealPlan:mAppDelegate_.mLogMealsViewController.mCurrentDate_];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SAVEPRIVATEFOOD]) {
        if ([[mAppDelegate_.mDataGetter_.mPrivateFoodDict valueForKey:@"FoodIDExists"] boolValue]) {
            [mAppDelegate_ showCustomAlert:@"" Message:@"The selected food name already exists, please enter a different name."];

        } else {
            [mAppDelegate_ showCustomAlert:@"" Message:@"Your food is added successfully."];
            [mAppDelegate_.mAddNewPrivateFoodController.navigationController popViewControllerAnimated:YES];
            [mAppDelegate_.mAddFoodViewController postRequestForPrivateFood];

        }
    } else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SEARCHGFOOD]||[mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETPRIVATEFOODS]||[mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETFAVORITEFOODS] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETRECENTFOODS] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETDTGMEALS]) {
        
       /* NSString *mAlertMsg;
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETFAVORITEFOODS]) {
            mAlertMsg = NSLocalizedString(@"NO_FAVORITE", nil);
        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETPRIVATEFOODS]) {
            mAlertMsg = NSLocalizedString(@"NO_PRIVATEFOODS", nil);
        }
        if (mAppDelegate_.mDataGetter_.mFoodList_.count == 0) {
            [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :mAlertMsg];
            return;

        }*/

        [mAppDelegate_.mAddFoodViewController reloadContentsOfTableView];
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETFOODUNITS]){
        [mAppDelegate_.mEditServingViewController displayPicker];
    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:FOODINFO]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[LogMealsViewController class]]) {
            [mAppDelegate_.mLogMealsViewController pushToDetailPage];

            
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[AddFoodViewController class]]) {
            [mAppDelegate_.mAddFoodViewController pushToDetailPage];

        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ADDPHOTOFOOD]){
        [mAppDelegate_ showCustomAlert:@"" Message:@"Photo uploaded successfully"];
        [mAppDelegate_.mAddEditFoodDetailController.navigationController popViewControllerAnimated:YES];
        [mAppDelegate_.mLogMealsViewController refreshThePage];
        
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ADDGFOOD]){
        [mAppDelegate_ showCustomAlert:@"" Message:NSLocalizedString(@"ADD_LOGFOOD_SUCCESS", nil)];

        [mAppDelegate_.mAddFoodViewController dismissModalViewControllerAnimated:TRUE];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DELETELOGFOOD])
    {
        [mAppDelegate_ showCustomAlert:@"" Message:NSLocalizedString(@"DELETE_LOGFOOD_SUCCESS", nil)];

        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[LogMealsViewController class]]) {
            [mAppDelegate_.mLogMealsViewController postRequestForMealPlan:mAppDelegate_.mLogMealsViewController.mCurrentDate_];
        }else{
            [mAppDelegate_.mLogMealsViewController.mFoodDetailsViewController.navigationController popViewControllerAnimated:TRUE];

        }
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:EDITLOGFOOD])
    {
        //[UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"UPDATE_LOGFOOD_SUCCESS", nil)];
        [mAppDelegate_.mLogMealsViewController.mFoodDetailsViewController.navigationController popViewControllerAnimated:TRUE];
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ADDFOODTOFAVORITEFOODS])
    {
        [mAppDelegate_ showCustomAlert:@"" Message:NSLocalizedString(@"ADD_FAVORITE_SUCCESS", nil)];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:REMOVEFOODFROMFAVORITEFOODS])
    {
        [mAppDelegate_ showCustomAlert:@"" Message:NSLocalizedString(@"DELETE_FAVORITE_SUCCESS", nil)];

    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SWAPMEAL])
    {
        [mAppDelegate_ showCustomAlert:@"" Message:@"Meal swapped successfully."];

        [mAppDelegate_.mLogMealsViewController.mSwapMealViewController dismissModalViewControllerAnimated:TRUE];
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETMEALS])
    {
        [mAppDelegate_.mLogMealsViewController pushToSwapPage];
    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:LOGOUT]){
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        /*
        [mAppDelegate_ createLoadView];
        
        //This is to reset the camera guide.
        //[mAppDelegate_ clearCameraGuideData];
        
        //to unsubscribe the notification
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];       
        NSString *post =[NSString stringWithFormat:@"Device=1&Token=%@", [loginUserDefaults objectForKey:DEVICE_TOKEN]];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Notifications/Subscription", WEBSERVICEURL]]];
        [request setHTTPMethod:@"DELETE"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:self.sessionToken forHTTPHeaderField:@"SessionToken"];
        [request setValue:self.authToken forHTTPHeaderField:@"AuthToken"];
        [request setHTTPBody:postData];
        
        NSError *error;
        NSHTTPURLResponse *response;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *json_string = [[NSString alloc]
                                 initWithData:urlData encoding:NSUTF8StringEncoding];
        DLog(@"%@", json_string);
        [mAppDelegate_ removeLoadView];
         */
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        [loginUserDefaults setValue:nil forKey:USERNAME];
        [loginUserDefaults setValue:nil forKey:AUTH_TOKEN];
        [loginUserDefaults setValue:nil forKey:SESSION_TOKEN];
        [loginUserDefaults setValue:nil forKey:USERTYPE];
        [loginUserDefaults setValue:nil forKey:EXTERNALUSERID];
        [loginUserDefaults setValue:nil forKey:@"BannerVisitNum"];
        [loginUserDefaults setValue:nil forKey:Step_Tracking];
        [loginUserDefaults setValue:nil forKey:NUMBER_OF_STEPS];
        [loginUserDefaults setValue:nil forKey:DEVICE_ID];
        [loginUserDefaults setValue:nil forKey:DEVICE_TOKEN];
        [loginUserDefaults setValue:nil forKey:DTGDevSession_Token];
        [loginUserDefaults synchronize];
        
        self.userName = nil;
        self.authToken = nil;
        self.sessionToken = nil;
        self.userType =nil;
        [mAppDelegate_.mGenericDataBase_ clearGoalOrder];
        [mAppDelegate_.mGenericDataBase_ clearTrackerOrder];
        [mAppDelegate_ displayLoginView];
    }
    //trackers
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDayWeight]){
        
        
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetWeightChartData]){
        //to get the weight logs
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetWeightLogs:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetWeightLogs]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to weight tracker page
            WeightListViewController *lVC = [[WeightListViewController alloc]initWithNibName:@"WeightListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mWeightListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];
            return;
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[WeightListViewController class]]) {
            [mAppDelegate_.mWeightListViewController reloadContentsOftableView];
        }
       
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteWeightLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddWeightLog]){
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteWeightLog]) {
              [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Weight %@",NSLocalizedString(@"LOGS_DELETE_SUCCESS_RESPONSE", nil)]];

        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddWeightLog]){
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Weight %@",NSLocalizedString(@"LOGS_ADD_SUCCESS_RESPONSE", nil)]];

        }
        
        //to get the weight log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mWeightListViewController;
            [mAppDelegate_.mRequestMethods_ postRequestToGetWeightChartData:mAppDelegate_.mWeightListViewController.mRange
                                                                 AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                              SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetWaterLogs]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to water tracker page
            WaterListViewController *lVC = [[WaterListViewController alloc]initWithNibName:@"WaterListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mWaterListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];
            return;
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[WaterListViewController class]]) {
            [mAppDelegate_.mWaterListViewController reloadContentsOftableView];
            [mAppDelegate_.mWaterListViewController.mWaterAddEditViewController dismissModalViewControllerAnimated:TRUE];
        }
        
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDayMeasurement]){
        

    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetMeasurementChartData]){
        //to get the measurement logs
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetMeasurementLogs:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetMeasurementLogs]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to measurement tracker page
            MeasurementListViewController *lVC = [[MeasurementListViewController alloc]initWithNibName:@"MeasurementListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mMeasurementListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];
            return;
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MeasurementListViewController class]]) {
            [mAppDelegate_.mMeasurementListViewController reloadContentsOftableView];
        }
        
    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteMeasurementLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddMeasurementLog]){
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteMeasurementLog]) {
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Measurement %@",NSLocalizedString(@"LOGS_DELETE_SUCCESS_RESPONSE", nil)]];

            
        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddMeasurementLog]){
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Measurement %@",NSLocalizedString(@"LOGS_ADD_SUCCESS_RESPONSE", nil)]];

            
        }
        //to get the weight log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mMeasurementListViewController;
            [mAppDelegate_.mRequestMethods_ postRequestToGetMeasurementChartData:mAppDelegate_.mMeasurementListViewController.mRange
                                                                 AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                              SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDayExercise]){
        
        
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetExerciseChartData]){
        //to get the measurement logs
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetExerciseLogs:mAppDelegate_.mResponseMethods_.authToken
                                                               SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetExerciseLogs]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to measurement tracker page
            ExerciseListViewController *lVC = [[ExerciseListViewController alloc]initWithNibName:@"ExerciseListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mExerciseListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];
            return;
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[ExerciseListViewController class]]) {
            [mAppDelegate_.mExerciseListViewController reloadContentsOftableView];
        }
        
    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteExerciseLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddExerciseLog]){
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteExerciseLog]) {
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Exercise %@",NSLocalizedString(@"LOGS_DELETE_SUCCESS_RESPONSE", nil)]];

            
        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddExerciseLog]){
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Exercise %@",NSLocalizedString(@"LOGS_ADD_SUCCESS_RESPONSE", nil)]];

            
        }
        //to get the exercise log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mExerciseListViewController;
            [mAppDelegate_.mRequestMethods_ postRequestToGetExerciseChartData:mAppDelegate_.mExerciseListViewController.mRange
                                                                    AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                                 SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetCurrentWeight]){
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            
            [mAppDelegate_.mRequestMethods_ postRequestToGetExerciseActivities:mAppDelegate_.mResponseMethods_.authToken
                                                                  SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetActivities]){
        [mAppDelegate_.mExerciseListViewController pushToAddPage];
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetDayGlucose]){
               
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetGlucoseChartData]){
        //to get the measurement logs
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetGlucoseLogs:mAppDelegate_.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetGlucoseLogs]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to measurement tracker page
            GlucoseListViewController *lVC = [[GlucoseListViewController alloc]initWithNibName:@"GlucoseListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mGlucoseListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];
            return;
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[GlucoseListViewController class]]) {
            [mAppDelegate_.mGlucoseListViewController reloadContentsOftableView];
        }
        
    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteGlucoseLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddGlucoseLog]){
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteGlucoseLog]) {
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Blood Glucose %@",NSLocalizedString(@"LOGS_DELETE_SUCCESS_RESPONSE", nil)]];

            
        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddGlucoseLog]){
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Blood Glucose %@",NSLocalizedString(@"LOGS_ADD_SUCCESS_RESPONSE", nil)]];

            
        }
        //to get the glucose log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mGlucoseListViewController;
            [mAppDelegate_.mRequestMethods_ postRequestToGetGlucoseChartData:mAppDelegate_.mGlucoseListViewController.mRange
                                                                  AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                               SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetJournalLogs]){
        if ( mAppDelegate_.mTrackerDataGetter_.mJournalCatList_.count == 0) {
            if ([[NetworkMonitor instance] isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetLookUp:JOURNALCATEGORY
                                                             AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance] displayNetworkMonitorAlert];
            }
        }else{
            if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
                //to move user to tracker page
                MyJournalListViewController *lVC = [[MyJournalListViewController alloc]initWithNibName:@"MyJournalListViewController" bundle:nil];
                UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
                mAppDelegate_.mSlidingViewController.topViewController = NVGController;
                mAppDelegate_.mMyJournalListViewController = lVC;
                [mAppDelegate_.mSlidingViewController resetTopView];
                return;
            }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MyJournalListViewController class]]) {
                [mAppDelegate_.mMyJournalListViewController reloadContentsOftableView];
            }
        }
        
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:JOURNALCATEGORY]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to tracker page
            MyJournalListViewController *lVC = [[MyJournalListViewController alloc]initWithNibName:@"MyJournalListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mMyJournalListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];
            return;
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MyJournalListViewController class]]) {
            [mAppDelegate_.mMyJournalListViewController reloadContentsOftableView];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteJournalLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddJournalLog]){
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteJournalLog]) {
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Journal %@",NSLocalizedString(@"LOGS_DELETE_SUCCESS_RESPONSE", nil)]];

            
        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddJournalLog]){
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Journal %@",NSLocalizedString(@"LOGS_ADD_SUCCESS_RESPONSE", nil)]];

            
        }
        //to get the measurement day log
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mMyJournalListViewController;
            [mAppDelegate_.mRequestMethods_ postRequestToGetJournalLogs:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetCholesterolChartData]){
        //to get the logs
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetCholesterolLogs:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetCholesterolLogs]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to tracker page
            CholesterolListViewController *lVC = [[CholesterolListViewController alloc]initWithNibName:@"CholesterolListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mCholesterolListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];
            return;
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[CholesterolListViewController class]]) {
            [mAppDelegate_.mCholesterolListViewController reloadContentsOftableView];
        }
        
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteCholesterolLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddCholesterolLog]){
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteCholesterolLog]) {
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Cholesterol %@",NSLocalizedString(@"LOGS_DELETE_SUCCESS_RESPONSE", nil)]];

            
        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddCholesterolLog]){
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Cholesterol %@",NSLocalizedString(@"LOGS_ADD_SUCCESS_RESPONSE", nil)]];

            
        }
        //to get the measurement log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mCholesterolListViewController;
            [mAppDelegate_.mRequestMethods_ postRequestToGetCholesterolChartData:mAppDelegate_.mCholesterolListViewController.mRange
                                                                      AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                                   SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetBMIChartData]){
        //to get the logs
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetBMILogs:mAppDelegate_.mResponseMethods_.authToken
                                                               SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetBMILogs]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to tracker page
            BMIListViewController *lVC = [[BMIListViewController alloc]initWithNibName:@"BMIListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mBMIListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];
            return;
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[BMIListViewController class]]) {
            [mAppDelegate_.mBMIListViewController reloadContentsOftableView];
        }
        
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteBMILog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddBMILog]){
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteBMILog]) {
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"BMI %@",NSLocalizedString(@"LOGS_DELETE_SUCCESS_RESPONSE", nil)]];

            
        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddBMILog]){
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"BMI %@",NSLocalizedString(@"LOGS_ADD_SUCCESS_RESPONSE", nil)]];

            
        }
        //to get the logs
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mBMIListViewController;
            [mAppDelegate_.mRequestMethods_ postRequestToGetBMIChartData:mAppDelegate_.mBMIListViewController.mRange
                                                               AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetStepChartData]){
        //post request to get tracker goals to display the today section in step tracker
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetTrackerGoals:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
       
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetStepLogs]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to tracker page
            StepListViewController *lVC = [[StepListViewController alloc]initWithNibName:@"StepListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mStepListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];
            return;
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[StepListViewController class]]) {
            [mAppDelegate_.mStepListViewController reloadContentsOftableView];
        }
        
    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteStepLog] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddStepLog]){
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteStepLog]) {
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Step %@",NSLocalizedString(@"LOGS_DELETE_SUCCESS_RESPONSE", nil)]];

            
        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddStepLog]){
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Step %@",NSLocalizedString(@"LOGS_ADD_SUCCESS_RESPONSE", nil)]];

            
        }
        if ([mAppDelegate_.mStepListViewController.mRange isEqualToString:@"Today"]) {
            //psot request to get logs
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mStepListViewController;
                [mAppDelegate_.mRequestMethods_ postRequestToGetStepLogs:mAppDelegate_.mResponseMethods_.authToken
                                                                 SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
        }else{
            //to get the step chart data
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mStepListViewController;
                [mAppDelegate_.mRequestMethods_ postRequestToGetStepChartData:mAppDelegate_.mStepListViewController.mRange
                                                                    AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                                 SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }

        }
        }
    //goal tracker
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetGoalSteps]){
        if (mAppDelegate_.mTrackerDataGetter_.mGoalStepList_.count > 0) {
            //to get the goal chart data
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetGoalChartData:[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:0] objectForKey:@"GoalStep"]
                                                                        Range:@"Week"
                                                                    AuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }

        }else{
            [UtilitiesLibrary showAlertViewWithTitle:@"" :@"Oops! There seem to be an issue, please try again later."];
            return;
        }
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetGoalChartData]){
       
        NSString *mUserStepId= @"";
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[AddGoalViewController class]] || [mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[GoalListViewController class]]) {
            mUserStepId = mAppDelegate_.mGoalListViewController.mUserStepID;
        }else{
            mUserStepId = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:0] objectForKey:@"UserStepID"] intValue]];
        }
        //to get the goal step progress data
        NSDate *lDate = [NSDate date];
        NSDateFormatter *ldateformatter = [[NSDateFormatter alloc] init];
        [GenricUI setLocaleZoneForDateFormatter:ldateformatter];
        [ldateformatter setDateFormat:@"yyyy-MM-dd"];
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetGoalStepProgress:mUserStepId
                                                                        Date:[ldateformatter stringFromDate:lDate]
                                                                   AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                                SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        return;
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetStepProgress]){
        //to get the goal chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetGoalLogs:mAppDelegate_.mResponseMethods_.authToken
                                                        SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetGoalLogs])
    {
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to tracker page
            GoalListViewController *lVC = [[GoalListViewController alloc]initWithNibName:@"GoalListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mGoalListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];
            return;
        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[AddGoalViewController class]] || [mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[GoalListViewController class]]) {
            [mAppDelegate_.mGoalListViewController reloadContentsOftableView];
        }
       

    }else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteGoal] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddGoal]){
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteGoal]) {
            [mAppDelegate_ showCustomAlert:@"" Message:@"Goal deleted successfully."];

            
        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:AddGoal]){
            [mAppDelegate_ showCustomAlert:@"" Message:@"Goal added successfully."];
            
        }
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[AddGoalViewController class]] || [mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[GoalListViewController class]]) {
            //to get the goal chart data
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mGoalListViewController;
                [mAppDelegate_.mRequestMethods_ postRequestToGetGoalChartData:mAppDelegate_.mGoalListViewController.mStepID
                                                                        Range:mAppDelegate_.mGoalListViewController.mRange
                                                                    AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                                 SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }

        }else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[LandingViewController class]]){
            [mAppDelegate_.mLandingViewController onSuccessAddGoal];
        }
    } else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetTrackerGoals]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[DailyGoalsSettingViewController class]]) {
            [mAppDelegate_.mDailyGoalsSettingViewController loadData];

        }else{
            //to get the logs
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToGetStepLogs:mAppDelegate_.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
        }
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetNotifications]){
        NotificationsSettngsViewController *lVc = [[NotificationsSettngsViewController alloc]initWithNibName:@"NotificationsSettngsViewController" bundle:nil];
        [mAppDelegate_.mSettingsViewController.navigationController pushViewController:lVc animated:TRUE];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SaveNotifications]){
        [mAppDelegate_ showCustomAlert:@"" Message:NSLocalizedString(@"NOTIFICATION_DETAILS_UPDATE_SUCCESS", nil)];

        NSArray *mViewcontrollers = [mAppDelegate_.mSettingsViewController.navigationController viewControllers];
        if (mViewcontrollers.count >0) {
            NotificationsSettngsViewController *lVC = (NotificationsSettngsViewController*)[mViewcontrollers objectAtIndex:0];
            [lVC.navigationController popViewControllerAnimated:TRUE];

        }
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetMessagesList]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MenuViewController class]]) {
            //to move user to messages page
            MessagesListViewController *lVC = [[MessagesListViewController alloc]initWithNibName:@"MessagesListViewController" bundle:nil];
            UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
            mAppDelegate_.mSlidingViewController.topViewController = NVGController;
            mAppDelegate_.mMessagesListViewController = lVC;
            [mAppDelegate_.mSlidingViewController resetTopView];

        }else  if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[MessagesListViewController class]]) {
            [mAppDelegate_.mMessagesListViewController reloadContentsOftableView];
        }
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteMessage] || [mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ArchiveMessage]){
        if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:DeleteMessage]) {
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Message deleted successfully."]];
            
        }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ArchiveMessage]){
            [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Message archived successfully."]];

            
        }
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetMessagesList:mAppDelegate_.mMessagesListViewController.mFolderType
                                                                    Page:@"1"
                                                              UnreadOnly:@"false"
                                                               AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance] displayNetworkMonitorAlert];
        }
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GetMessage]){
        [mAppDelegate_.mMessagesListViewController PushToDetailView];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ReplyMessage]){
        [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Message sent successfully."]];

        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetMessagesList:mAppDelegate_.mMessagesListViewController.mFolderType
                                                                    Page:@"1"
                                                              UnreadOnly:@"false"
                                                               AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance] displayNetworkMonitorAlert];
        }
    }
    else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:SendNewMessage]){
        [mAppDelegate_ showCustomAlert:@"" Message:[NSString stringWithFormat:@"Message sent successfully."]];
        [mAppDelegate_.mNewMessageViewController.navigationController popViewControllerAnimated:TRUE];
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mMessagesListViewController;
            [mAppDelegate_.mRequestMethods_ postRequestToGetMessagesList:mAppDelegate_.mMessagesListViewController.mFolderType
                                                                    Page:@"1"
                                                              UnreadOnly:@"false"
                                                               AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance] displayNetworkMonitorAlert];
        }
    }//Demo Plan
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETDEMOPLAN]){
        if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[SettingsViewController class]]) {
            //to move user to meal plan settings page
            MealPlannerSettingsViewController *lVC = [[MealPlannerSettingsViewController alloc]initWithNibName:@"MealPlannerSettingsViewController" bundle:nil];
            lVC.isFromSlider = FALSE;
            mAppDelegate_.mMealPlannerSettingsViewController = lVC;
            [mAppDelegate_.mSettingsViewController.navigationController pushViewController:lVC animated:TRUE];
        } else if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[LogMealsViewController class]]){
            //to move user to meal plan settings page
            MealPlannerSettingsViewController *lVC = [[MealPlannerSettingsViewController alloc]initWithNibName:@"MealPlannerSettingsViewController" bundle:nil];
            lVC.isFromSlider = FALSE;
            mAppDelegate_.mMealPlannerSettingsViewController = lVC;
            [mAppDelegate_.mLogMealsViewController.navigationController pushViewController:lVC animated:TRUE];
        }
       
    }
    //Discussion forum
    else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETCATEGORYDATA]){
        CategotyViewController *lCategoriesViewController = [[CategotyViewController alloc]initWithNibName:@"CategotyViewController" bundle:nil];
        [mAppDelegate_ setMCategotyViewController:lCategoriesViewController];
        UINavigationController* categoryNavigator = [[UINavigationController alloc]initWithRootViewController:lCategoriesViewController];
        mAppDelegate_.mSlidingViewController.topViewController = categoryNavigator;
        [mAppDelegate_.mSlidingViewController resetTopView];
    } else if([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETFORUMSINCATEGORY]){
        ForumsViewController *lForumsViewController = [[ForumsViewController alloc]initWithNibName:@"ForumsViewController" bundle:nil];
        [mAppDelegate_ setMForumsViewController:lForumsViewController];
        [mAppDelegate_.mCategotyViewController.navigationController pushViewController:lForumsViewController animated:YES];
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETTHREADSINFORUM]){
        BOOL isAdded = FALSE;
        
        UIViewController* lViewController = nil;
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: mAppDelegate_.mForumsViewController.navigationController.viewControllers];
        for (int i=0; i<[allViewControllers count]; i++) {
            if ([[allViewControllers objectAtIndex:i] isKindOfClass:[ThreadsViewController class]]) {
                isAdded = TRUE;
                lViewController = (ThreadsViewController*)[allViewControllers objectAtIndex:i];
            }
        }
        if (isAdded) {
            ThreadsViewController *threadView = (ThreadsViewController*)lViewController;
            [threadView.mTableView reloadData];
            
        } else {
            ThreadsViewController *lThreadsViewController = [[ThreadsViewController alloc]initWithNibName:@"ThreadsViewController" bundle:nil];
            [mAppDelegate_ setMThreadsViewController:lThreadsViewController];
            [mAppDelegate_.mForumsViewController.navigationController pushViewController:lThreadsViewController animated:YES];
            
        }
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:GETPOSTSINTHREADS]){
        BOOL isAdded = FALSE;
        
        UIViewController* lViewController = nil;
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: mAppDelegate_.mThreadsViewController.navigationController.viewControllers];
        for (int i=0; i<[allViewControllers count]; i++) {
            if ([[allViewControllers objectAtIndex:i] isKindOfClass:[PostsViewController class]]) {
                isAdded = TRUE;
                lViewController = (PostsViewController*)[allViewControllers objectAtIndex:i];
            }
        }
        if (isAdded) {
            PostsViewController *newPost = (PostsViewController*)lViewController;
            [newPost LoadDetails];
            
        } else {
            PostsViewController *lPostsViewController = [[PostsViewController alloc]initWithNibName:@"PostsViewController" bundle:nil];
            [mAppDelegate_ setMPostsViewController:lPostsViewController];
            [mAppDelegate_.mThreadsViewController.navigationController pushViewController:lPostsViewController animated:YES];
            
        }
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ADDNEWTHREAD]){
        
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            
            [mAppDelegate_ createLoadView];
            NSString* selectedCatogeryId = [mAppDelegate_.mCommunityDataGetter.mSelectedCategoryDict valueForKey:CategoryIDKey];
            NSString* selectedForumId = [mAppDelegate_.mCommunityDataGetter.mSelectedForumDict valueForKey:forumidKey];

           [mAppDelegate_.mRequestMethods_ postRequestForThreads:selectedCatogeryId forum:selectedForumId page:@"1" AuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            
        }else {
            [[NetworkMonitor instance] displayNetworkMonitorAlert];
        }
    }else if ([mAppDelegate_.mWebEngine_.mWebMethodName_ isEqualToString:ADDPOSTTOTHREAD]){
        
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            NSString* selectedCatogeryId = [mAppDelegate_.mCommunityDataGetter.mSelectedCategoryDict valueForKey:CategoryIDKey];
            NSString* selectedForumId = [mAppDelegate_.mCommunityDataGetter.mSelectedForumDict valueForKey:forumidKey];
            NSString* selectedThreadId = [mAppDelegate_.mCommunityDataGetter.mSelectedThreadDict valueForKey:threadidKey];
            
            [mAppDelegate_.mRequestMethods_ postRequestForPosts:selectedCatogeryId forum:selectedForumId thread:selectedThreadId page:@"1" AuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            
        }else {
            [[NetworkMonitor instance] displayNetworkMonitorAlert];
        }
    }
}
- (void)StoreUserDetails:(NSString*)lUsername
               AuthToken:(NSString*)lAuthToken
            SessionToken:(NSString*)lToken
                UserType:(NSString*)lUserType CoachID:(NSString*)lCoachID
{
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    if (![lUsername isKindOfClass:[NSNull class]]) {
        [loginUserDefaults setValue:lUsername forKey:USERNAME];
        self.userName = lUsername;


    }
    NSString *ExternalUserID = [[mAppDelegate_.mDataGetter_.mLoginDict_ objectForKey:@"User"]objectForKey:@"ExternalUserID"];
    [loginUserDefaults setValue:ExternalUserID forKey:EXTERNALUSERID];
    [loginUserDefaults setValue:lAuthToken forKey:AUTH_TOKEN];
    [loginUserDefaults setValue:lToken forKey:SESSION_TOKEN];
    [loginUserDefaults setValue:lUserType forKey:USERTYPE];
    [loginUserDefaults setValue:lCoachID forKey:COACHID];
    [loginUserDefaults synchronize];
    
    self.authToken = lAuthToken;
    self.sessionToken = lToken;
    self.userType =lUserType;
    self.coachID = lCoachID;
    
    //store log-in time
    [mAppDelegate_ setLastLoggedInTimestamp:[[NSDate date] timeIntervalSince1970]];
    
    //Ser Goal for Water
    NSMutableDictionary *mGoalWaterDict = [mAppDelegate_.mGenericDataBase_ getWaterGoalFormUser:ExternalUserID];
    if ([mGoalWaterDict count] == 0) {
        //i.e. No Water Goal for this new user..set default goal as 8.
        [mAppDelegate_.mGenericDataBase_ insertWaterGoals:@"8" UserID:ExternalUserID];
    }
    
    //for push notifications
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    // Let the device know we want to receive push notifications
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
    // (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    

}
@end
