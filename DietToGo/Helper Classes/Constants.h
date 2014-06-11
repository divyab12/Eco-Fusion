//
//  Constants.h
//  EHEandme
//
//  Created by EHEandme on 13/09/12.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//
//
#ifndef EHEandme_Constants_h
#pragma mark -
#pragma mark DLOG

#ifdef DEBUG
#define DLog(fmt, ...) NSLog(fmt, ## __VA_ARGS__)
#else
#define DLog(...)
#endif

#pragma mark -
#pragma mark RELEASE_NIL

#define RELEASE_NIL(object) [object release]; object=nil

#define IOS7VERSION 7.0
#define CURRENTDEVICEVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#pragma mark -
#pragma mark COLOR

#define BLACK_COLOR [UIColor blackColor]
#define CLEAR_COLOR [UIColor clearColor]
#define GREEN_COLOR [UIColor greenColor]

#define WHITE_COLOR [UIColor whiteColor]
#define BLUE_COLOR [UIColor blueColor]
#define RED_COLOR [UIColor redColor]
#define LIGHT_GRAY_COLOR [UIColor lightGrayColor]
#define GRAY_COLOR [UIColor grayColor]

#define SELECTED_CELL_COLOR [UIColor colorWithRed:71/255.0 green:184/255.0 blue:230/255.0 alpha:1.0]
#define RGB_A(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define DTG_MAROON_COLOR [UIColor colorWithRed:179.0/255.0 green:35.0/255.0 blue:23.0/255.0 alpha:1.0] //b32317
#define DTG_GRAYLIGHT_COLOR [UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:1.0] //a9a9a9
#define DTG_GRAYTHIK_COLOR [UIColor colorWithRed:108.0/255.0 green:109.0/255.0 blue:108.0/255.0 alpha:1.0] //6c6d6c
#define DTG_ORANGE_COLOR [UIColor colorWithRed:255.0/255.0 green:145.0/255.0 blue:2.0/255.0 alpha:1.0]

#define DTG_CELLTITLE_COLOR [UIColor colorWithRed:108.0/255.0 green:109.0/255.0 blue:108.0/255.0 alpha:1.0]
#pragma mark -
#pragma mark SYSTEM_FONT

#define FONT_SYSTEM(lsize) [UIFont systemFontOfSize:lsize]
#define FONT_HELVETICANEUE(lsize) [UIFont fontWithName:@"HelveticaNeue" size:lsize]
#define FONT_SYSTEM_BOLD(lsize) [UIFont boldSystemFontOfSize:lsize]

#pragma mark Custom Fonts

//Fonts
#define Bariol_Regular(lsize) [UIFont fontWithName:@"Bariol-Regular" size:lsize]
#define Bariol_Bold(lsize) [UIFont fontWithName:@"Bariol-Bold" size:lsize]
#define Bariol_Light(lsize) [UIFont fontWithName:@"Bariol-Light" size:lsize]
#define Bariol_Thin(lsize) [UIFont fontWithName:@"Bariol-Thin" size:lsize]

#define OpenSans_Regular(lsize) [UIFont fontWithName:@"OpenSans" size:lsize] //[UIFont fontWithName:@"OpenSans-Regular" size:lsize]
//refer: http://stackoverflow.com/questions/18021945/ios-ttf-fonts-only-partially-work
#define OpenSans_Bold(lsize) [UIFont fontWithName:@"OpenSans-Bold" size:lsize]
#define OpenSans_Light(lsize) [UIFont fontWithName:@"OpenSans-Light" size:lsize]
#define OpenSans_Italic(lsize) [UIFont fontWithName:@"OpenSans-Italic" size:lsize]

#define mShowLogs @"TRUE"
#define USERNAME @"UserName"
#define AUTH_TOKEN @"AuthToken"
#define SESSION_TOKEN @"Token"
#define EXTERNALUSERID @"ExternalUserID"
#define USERTYPE @"Type"
#define COACHID @"CoachID"
#define USERID @"UserId"
#define DEVICE_ID @"deviceID"
#define DEVICE_TOKEN @"DeviceToken"
#define DTGDevSession_Token @"DTGDevSession"
//for automatic tracking
#define Step_Tracking @"StepTracking"
#define NUMBER_OF_STEPS @"NumberOfSteps"
#define TRACK_DATE @"TrackeDate"

#pragma mark WEBSERVICE_METHODS
//DietToGo urls
//dev url
#define WEBSERVICEURL @"http://dtgapi.wellnesslayers.com/api/"
#define LOGINURL @"http://dtgapi.wellnesslayers.com/user/xlogin" //@"http://dtgapi.wellnesslayers.com/user/mlogin"
//stagging urls
//#define WEBSERVICEURL @"http://wlistgapi.diettogo.com/api/"
//#define LOGINURL @"https://staging.diettogo.com/wl-app-login"
//@"https://diettogo.com/log-in"

#define GETSTARTEDURL @"http://diettogo.com/meal-plans/low-fat-traditional"
#define RESETPASSWORDURL @"https://staging.diettogo.com/wl-app-login?p=register"
#define REGISTRATIONURL @"https://staging.diettogo.com/wl-app-login?p=register"

//Account Mangement
#define AccountManagerURL @"https://staging.diettogo.com/wl-app-account"
#define MenuManagerURL @"https://staging.diettogo.com/wl-app-menu-manager"
#define PlanHoldsURL @"https://staging.diettogo.com/wl-app-hold-request"
#define SupportRequestURL @"http://staging.diettogo.com/wl-app-support-request"

//Camera over lays
//Meal Planner
#define CAMERALAYER @"isCameraLayer"
//BMI
#define BMICAMERALAYER @"BMICameraLayer"
#define BMITOPCAMERALAYER @"BMITopCameraLayer"
#define BMIBOTTOMCAMERALAYER @"BMIBottomCameraLayer"

#define WEIGHTCAMERALAYER @"WeightCameraLayer"
#define WEIGHTTOPCAMERALAYER @"WeightTopCameraLayer"
#define WEIGHTBOTTOMCAMERALAYER @"WeightBottomCameraLayer"

#define STEPCAMERALAYER @"StepCameraLayer"
#define STEPTOPCAMERALAYER @"StepTopCameraLayer"
#define STEPBOTTOMCAMERALAYER @"StepBottomCameraLayer"

#define EXERCISECAMERALAYER @"ExerciseCameraLayer"
#define EXERCISETOPCAMERALAYER @"ExerciseTopCameraLayer"
#define EXERCISEBOTTOMCAMERALAYER @"ExerciseBottomCameraLayer"

#define MEASUREMENTCAMERALAYER @"MeasurementCameraLayer"
#define MEASUREMENTTOPCAMERALAYER @"MeasurementTopCameraLayer"
#define MEASUREMENTBOTTOMCAMERALAYER @"MeasurementBottomCameraLayer"

#define BLOODCAMERALAYER @"BloodCameraLayer"
#define BLOODTOPCAMERALAYER @"BloodTopCameraLayer"
#define BLOODBOTTOMCAMERALAYER @"BloodBottomCameraLayer"

#define CHOLESTREOLCAMERALAYER @"CholestroelCameraLayer"
#define CHOLESTREOLTOPCAMERALAYER @"CholestroelTopCameraLayer"
#define CHOLESTREOLBOTTOMCAMERALAYER @"CholestroelBottomCameraLayer"

#define UNDERWEIGHT @"Underweight (<18.5)"
#define NORMALWEIGHT @"Normal Weight (18.5 to 24.9)"
#define OVERWEIGHT @"Overweight (25.0 to 29.9)"
#define OBESE @"Obese (≥ 30)"

#define MEALPLANTEXT @"Mealplan"
#define SWAPTEXT @"Swap"
#define LOGINTEXT @"Login"
#define FOODTEXT @"Food" //removed 's'
#define LOGOUT @"Logout"
#define SETTINGS @"Settings"
#define PERSONAL @"Personal"
#define CALORIESTXT @"Calories"
#define GETMEALPLAN @"GetMealPlan"
#define CHANGEREPORTSTATUS @"ChangeReportStatus"
#define EDITLOGFOOD @"EditFood"
#define DELETELOGFOOD @"DeleteFood"
#define ADDGFOOD @"AddFood"
#define ADDPHOTOFOOD @"AddPhotoFood"
#define SEARCHGFOOD @"SearchFood"
#define FOODINFO @"FoodInfo"
#define GETPRIVATEFOODS @"GetPrivateFoods"
#define GETDTGMEALS @"GetDTGMeals"
#define SAVEPRIVATEFOOD @"SavePrivateFood"
#define GETFAVORITEFOODS @"GetFavoriteFoods"
#define GETRECENTFOODS @"GetRecentFoods"
#define GETFOODUNITS @"GetFoodUnits"
#define ADDFOODTOFAVORITEFOODS @"AddToFavoriteFoods"
#define REMOVEFOODFROMFAVORITEFOODS @"RemoveFromFavoriteFoods"
#define GETMEALS @"GetMeals"
#define SWAPMEAL @"SwapMeal"

#define GETTOKENS @"GETToken"
#define GETPERSONALSETTINGS @"GetPersonalSettings"
#define UPDATEPERSONALSETTINGS @"UpdatePersonalSettings"
#define CHECKPERSONALSETTINGS @"CheckSettings"
#define CHECKMEALPLANSETTINGS @"CheckMealPlanSettings"
#define GETCALORIELEVEL @"GetCalorieLevel"
#define GETMEALPLANS @"GetMealPlans"
#define SAVEMEALPLANS @"SaveMealPlans"
#define GETMEALPREFERENCES @"GetMealPreferences"
#define SAVEMEALPREFERENCES @"SaveMealPreferences"
//lookups
#define GENDER @"Gender"
#define ACTIVITYLEVEL @"ActivityLevel"
#define MEALGOAL @"MealGoal"
#define CALORIELEVEL @"CalorieLevel"
#define JOURNALCATEGORY @"JournalCategory"
//weight tracker
#define TrackersTXT @"Trackers"
#define WeightTxt @"Weight"
#define GetDayWeight @"GetDayWeight"
#define GetWeightLogs @"GetWeight"
#define AddWeightLog @"AddWeight"
#define GetWeightChartData @"WeightChart"
#define DeleteWeightLog @"DeleteWeight"
#define EditWeight @"EditWeight"
//water tracker
#define WaterTxt @"Water"
#define GetWaterLogs @"GetWater"
//Measurement tracker
#define MeasurementTXT @"Measurement"
#define GetDayMeasurement @"GetDayMeasurement"
#define GetMeasurementLogs @"GetMeasurement"
#define AddMeasurementLog @"AddMeasurement"
#define GetMeasurementChartData @"MeasurementChart"
#define DeleteMeasurementLog @"DeleteMeasurement"
#define EditMeasurement @"EditMeasurement"
//exercise tracker
#define ExerciseTXT @"Exercise"
#define GetDayExercise @"GetDayExercise"
#define GetExerciseLogs @"GetExercise"
#define AddExerciseLog @"AddExercise"
#define GetExerciseChartData @"ExerciseChart"
#define DeleteExerciseLog @"DeleteExercise"
#define GetCurrentWeight @"GetUserWeight"
#define GetActivities @"GetActivities"
//glucose tracker
#define GlucoseTXT @"Glucose"
#define GetDayGlucose @"GetDayGlucose"
#define GetGlucoseLogs @"GetGlucose"
#define AddGlucoseLog @"AddGlucose"
#define GetGlucoseChartData @"GlucoseChart"
#define DeleteGlucoseLog @"DeleteGlucose"
//journal tracker
#define JournalTXT @"Journal"
#define GetJournalLogs @"GetJournal"
#define AddJournalLog @"AddJournal"
#define DeleteJournalLog @"DeleteJournal"
//cholesterol tracker
#define CholesterolTXT @"Cholesterol"
#define GetCholesterolLogs @"GetCholesterol"
#define AddCholesterolLog @"AddCholesterol"
#define DeleteCholesterolLog @"DeleteCholesterol"
#define GetCholesterolChartData @"CholesterolChart"
//BMI tracker
#define BMITXT @"BMI"
#define GetBMILogs @"GetBMI"
#define AddBMILog @"AddBMI"
#define DeleteBMILog @"DeleteBMI"
#define GetBMIChartData @"BMIChart"
#define GetDayBMI @"GetDayBMI"
//Goal Tracker
#define GoalTxt @"Goals"
#define GetDashboardGoals @"GetDashGoals"
#define GetGoalSteps @"GetGoalSteps"
#define GetGoalChartData @"GoalChart"
#define GetGoalLogs @"GetGoals"
#define AddGoal @"AddGoal"
#define DeleteGoal @"DeleteGoal"
#define GetTrackerGoals @"TrackerGoals"
#define GetStepProgress @"StepProgress"
//step Tracker
#define StepsTxt @"Steps"
#define GetStepLogs @"GetStep"
#define GetStepChartData @"StepChart"
#define GetDaySteps @"GetDayStep"
#define AddStepLog @"AddStep"
#define DeleteStepLog @"DeleteStep"
//push notifications
#define GetNotifications @"GetNotifications"
#define SaveNotifications @"SaveNotifications"
//messages
#define MessagesTXT @"Messages"
#define GetMessagesList @"GetMessagesList"
#define GetMessage @"GetMessage"
#define ArchiveMessage @"ArchiveMessage"
#define DeleteMessage @"DeleteMessage"
#define ReplyMessage @"ReplyToMessage"
#define CheckRecipent @"CheckRecipent"
#define SendNewMessage @"SendMessage"

//Demo Meal Plan
#define GETDEMOPLAN @"DemoMealPlan"
#define DEMOPLANTXT @"DemoPlan"

//FitBit
#define FitBitBannerTag 888

//Discussion Forums
#define BOARDSTXT @"boards"
#define GETCATEGORYDATA @"GetCategory"
#define GETFORUMSINCATEGORY @"GetForumsincategory"
#define GETTHREADSINFORUM @"GetThreadsInForum"
#define GETPOSTSINTHREADS @"GetPostsInForums"
#define ADDNEWTHREAD @"AddNewThread"
#define ADDPOSTTOTHREAD @"AddPostToThread"

#pragma marrk - Keys of Discussion Forums

#define CategoryNameKey @"CategoryName"
#define CategoryIDKey @"CategoryID"

#define forumidKey @"forumid"
#define forumNameKey @"forumName"
#define NumOfThreadsKey @"NumOfThreads"

#define threadidKey @"threadid"
#define ThreadTitleKey @"ThreadTitle"

#define usernameKey @"username"
#define PhotoIDKey @"PhotoID"
#define PostDateKey @"PostDate"
#define PostTimeKey @"PostTime"
#define titleKey @"title"
#define bodyKey @"body"

#pragma marrk - Keys of Meal Planner
#define CaloriesBudgetKey @"CaloriesBudget"
#define CalorieBudgetKey @"CalorieBudget"
#define CaloriesConsumedKey @"CaloriesConsumed"
#define ConsumedPercentageKey @"ConsumedPercentage"
#define ExerciseCaloriesBurnedKey @"ExerciseCaloriesBurned"
#define DailyCaloriesLeftKey @"DailyCaloriesLeft"

#define MealsKey @"Meals"
#define NameKey @"Name"
#define ListFoodsKey @"ListFoods"
#define CaloriesTotalKey @"CaloriesTotal"
#define PhotoFileNameKey @"PhotoFileName"
#define ImageUrlKey @"ImageUrl"

#define MealIDKey @"MealID"
#define FoodIDKey @"FoodID"
#define FoodLogIDKey @"FoodLogID"
#define FoodLogDailyIDKey @"FoodLogDailyID"

#ifdef __IPHONE_6_0
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
#else
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
#endif

#ifdef __IPHONE_6_0
# define TEXT_ALIGN_LEFT NSTextAlignmentLeft
#else
# define TEXT_ALIGN_LEFT UITextAlignmentLeft
#endif

#ifdef __IPHONE_6_0
# define TEXT_ALIGN_RIGHT NSTextAlignmentRight
#else
# define TEXT_ALIGN_RIGHT UITextAlignmentRight
#endif

#if __IPHONE_6_0
# define TEXT_ALIGN_CENTER NSTextAlignmentCenter
#else
# define TEXT_ALIGN_CENTER UITextAlignmentCenter
#endif

#endif
