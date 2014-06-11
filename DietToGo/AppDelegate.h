//
//  AppDelegate.h
//  EHEandme
//
//  Created by Divya Reddy on 23/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

#import "LogMealsViewController.h"
#import "GenericDataBase.h"
#import "CustomPopUpView.h"
#import "FitBitViewController.h"
//for tracking
#import "GAI.h"
@class LoadingView;
//Helper files
@class RequestMethods;
@class ResponseMethods;
@class ParserMethods;
@class DataGetter;
@class TrackerDataGetter;
@class MessagesDataGetter;
@class CommunityDataGetter;
@class WebEngine;
//login classes
@class LoginViewController;
@class ECSlidingViewController;
@class LandingViewController;
@class MenuViewController;
@class AddFoodViewController;
@class MealPlannerSettingsViewController;
@class SettingsViewController;
//trackers
@class WeightListViewController;
@class WaterListViewController;
@class MeasurementListViewController;
@class ExerciseListViewController;
@class GlucoseListViewController;
@class MyJournalListViewController;
@class CholesterolListViewController;
@class BMIListViewController;
@class StepListViewController;
@class GoalListViewController;
@class DailyGoalsSettingViewController;
@class MessagesListViewController;
@class NewMessageViewController;
@class EditServingViewController;
@class AddNewPrivateFoodController;
@class AddEditFoodDetailController;

//Discussion Forum
@class CategotyViewController;
@class ForumsViewController;
@class ThreadsViewController;
@class PostsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    /**
     * Loadingview object creating
     */
	LoadingView *mLoadingView_;
    
    /**
     * Variables to track the accelaration values with respect to x,y,z
     */
    float px;
    float py;
    float pz;
    
    int numSteps;
    BOOL isChange;
    BOOL isSleeping;
    
    CMMotionManager *motionManager;
    
    NSTimer *mPopupTimer;


}
@property (readonly) CMMotionManager *motionManager;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *mNavigationController;
@property (nonatomic, retain) NSString *mPushAlert;
/*
 * genericdatabase objext
 */
@property(nonatomic,retain) GenericDataBase *mGenericDataBase_;


//API Classes
@property(nonatomic,retain)    WebEngine *mWebEngine_;
@property(nonatomic,retain)    ParserMethods *mParserMethods_;
@property(nonatomic,retain)    RequestMethods *mRequestMethods_;
@property(nonatomic,retain)    ResponseMethods *mResponseMethods_;
@property(nonatomic,retain)    DataGetter *mDataGetter_;
@property(nonatomic,retain)    TrackerDataGetter *mTrackerDataGetter_;
@property(nonatomic,retain)    MessagesDataGetter *mMessagesDataGetter_;
@property(nonatomic,retain)    CommunityDataGetter *mCommunityDataGetter;


@property (strong, nonatomic) LoginViewController *mLoginViewController;
@property (strong, nonatomic) ECSlidingViewController *mSlidingViewController;
@property (strong, nonatomic) MenuViewController *mMenuViewController;
@property (strong, nonatomic) LandingViewController *mLandingViewController;
@property (strong, nonatomic) LogMealsViewController *mLogMealsViewController;
@property (strong, nonatomic) AddFoodViewController *mAddFoodViewController;
@property (nonatomic, retain) MealPlannerSettingsViewController *mMealPlannerSettingsViewController;
@property (strong, nonatomic) WeightListViewController *mWeightListViewController;
@property (strong, nonatomic) WaterListViewController *mWaterListViewController;
@property (nonatomic,retain) MeasurementListViewController *mMeasurementListViewController;
@property (nonatomic,retain) ExerciseListViewController *mExerciseListViewController;
@property (nonatomic,retain) GlucoseListViewController *mGlucoseListViewController;
@property (nonatomic, retain) MyJournalListViewController *mMyJournalListViewController;
@property (nonatomic, retain) CholesterolListViewController *mCholesterolListViewController;
@property (nonatomic, retain) BMIListViewController *mBMIListViewController;
@property (nonatomic, retain) StepListViewController *mStepListViewController;
@property (nonatomic, retain) GoalListViewController *mGoalListViewController;
@property (nonatomic, retain) MessagesListViewController *mMessagesListViewController;
@property (nonatomic,retain) SettingsViewController *mSettingsViewController;
@property (nonatomic, retain) DailyGoalsSettingViewController *mDailyGoalsSettingViewController;
@property (nonatomic, retain) EditServingViewController *mEditServingViewController;
@property (nonatomic, retain) NewMessageViewController *mNewMessageViewController;
@property (nonatomic, retain) AddNewPrivateFoodController *mAddNewPrivateFoodController;
@property (nonatomic, retain) AddEditFoodDetailController *mAddEditFoodDetailController;

//Discussion Forums
@property (nonatomic, retain) CategotyViewController *mCategotyViewController;
@property (nonatomic, retain) ForumsViewController *mForumsViewController;
@property (nonatomic, retain) ThreadsViewController *mThreadsViewController;
@property (nonatomic, retain) PostsViewController *mPostsViewController;

@property (nonatomic, retain) CustomPopUpView *mCustomPopUpView;
@property (nonatomic) BOOL mTrackPages;
@property(nonatomic, retain) id<GAITracker> tracker;
/**
 *AppDelegateInstance Declaration
 **/
+ (AppDelegate*) appDelegateInstance;
/**
 * Method used to present load view
 */
- (void)createLoadView;
- (void)addTransparentView:(UIViewController*)viewController;

/**
 * Method used to remove load view
 */
- (void)removeLoadView;
-(void)removeTransparentView:(UIViewController*)viewController;

/**
 * Method used to add/remove black transperant layer to/from window
 */
- (void)addTransparentViewToWindow;
- (void)addTransparentViewToWindowForDisuccionForum;
-(void)removeTransparentViewFromWindow;

/**
 * Method used to present load view
 */
- (void)displaySplashScreen;
/**
 * Method used to display login view
 */
-(void)displayLoginView;
/**
 * Method used to display main view
 */
-(void)displayMainView;
/**
 * Method used to clear camera guide data
 */
-(void)clearCameraGuideData;
/**
 * Method to track steps
 */
-(void)automaticTrackSteps;

/*
 * Method used to check the step tracking date is equal to current date or not
 */
- (void)checkTrackDate;
/*
 * Method used to post the step tracker request
 */
- (void)postRequestToAddAutomaticStepLog;
/**
 *hideEmptySeparators method to clear the background of a tableview
 @param tableView for which the backgroung should be removed
 **/
- (void)hideEmptySeparators:(UITableView*)tableView;
/*
 * Method used to show the left side slider from a viewcontroller
 * @param mParentclass refers to the viewcontroller instance from where the method is called
 */
- (void)showLeftSideMenu:(UIViewController*)mParentClass;
/**
 *setNavControllerTitle Declaration used to set the title of a navigation bar
 @param title to hold the title of a navigation bar
 @param image for the navigation bar image
 @param viewController for instance of a viewcontroller
 **/
- (void)setNavControllerTitle:(NSString*)title
                        imageName:(NSString*)mImage
				forController:(UIViewController*)viewController;
/*
 * Method used to handle push notifications click action
 */
- (void)handlePushNotifications;
/**
 * Method used to present push notifications alert when clicked from springboard
 @ param dictionary with push notification details
 */
- (void)processRemoteNotification:(NSDictionary *)userInfo;
/**
 * Method used to show the custom alert
 @ param mAlert for the alert title
 * @param mMsg for the alert message
 */
- (void)showCustomAlert:(NSString*)mAlert
                Message:(NSString*)mMsg;

/**
 * Method used to check the session expiry time .i.e 20 min
 */
- (BOOL)sessionExpired;
- (NSTimeInterval)getLastLoggedInTimestamp;
- (void)setLastLoggedInTimestamp:(NSTimeInterval)timestamp;

#pragma mark - Check FitBit Status
-(BOOL)isShowFitBitBanner;
-(void)pushToFitBitViewController;
#pragma mark - Flurry
-(void)trackFlurryLogEvent:(NSString*)pageName;
-(void)trackFlurryLogEventForBanners:(NSString*)pageName;
@end
