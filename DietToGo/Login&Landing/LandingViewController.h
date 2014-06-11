//
//  LandingViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 23/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPageControl.h"
#import "GAITrackedViewController.h"

@interface LandingViewController : GAITrackedViewController
{
     AppDelegate *mAppDelegate;
    NSInteger mCurrentGlass_;
}
@property (nonatomic, assign) BOOL isFromAddWater;
@property (nonatomic, retain) NSString *methodName;
@property (nonatomic, assign) int *mTrackerCount;
@property (nonatomic, retain) NSString *mTrackerOrder, *mTrackersShown, *mGoalOrder, *mGoalsShown;
@property (nonatomic, retain)  UIGestureRecognizer *mScrollGesture;
@property (nonatomic, retain)  UIView *mBannerContentView;

@property (nonatomic, retain) NSMutableDictionary *mTrackerValuesDict;
@property (nonatomic, retain) NSMutableArray *mGoalsArray, *mMainGoalsArray,*mBannerTxtArray;

@property (retain, nonatomic) NSDateFormatter *mFormatter_;
@property (retain, nonatomic) NSDate *mDisplayedDate_;
@property (retain, nonatomic) NSString *mCurrentDate_;
@property (weak, nonatomic) IBOutlet UIView *mBannerView;

@property (weak, nonatomic) IBOutlet CustomPageControl *mPageControl;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLbl1_;
@property (weak, nonatomic) IBOutlet UILabel *mBannerLbl;
@property (weak, nonatomic) IBOutlet UIView *mAddWaterView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollview;
@property (weak, nonatomic) IBOutlet UIImageView *mAddGlassImgView;
@property (weak, nonatomic) IBOutlet UILabel *mAddGlassCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *mGlassesLbl;
@property (weak, nonatomic) IBOutlet UIView *mAddGlassesView;
@property (weak, nonatomic) IBOutlet UIButton *mAddWaterBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *mAddWaterBackBtn1;
@property (weak, nonatomic) IBOutlet UIImageView *mWaterLastLineImgVieqw;
@property (strong, nonatomic) IBOutlet UIButton *mPrevBtn1;
@property (strong, nonatomic) IBOutlet UIButton *mPrevBtn;
@property (strong, nonatomic) IBOutlet UIButton *mNextBtn1;
@property (strong, nonatomic) IBOutlet UIButton *mNextBtn;

- (IBAction)prevAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)bannerCloseAction:(id)sender;
- (IBAction)bannerViewAction:(id)sender;
- (IBAction)addWiaterCloseAction:(id)sender;
/*
 * method to display the top view with title and date
 */
- (void)displayTitleView;
/*
 * method used to add view to the scrollview based on the userType
 * @param MuserType for the logged in user type
 */
- (void)LoadViewsToScrollView:(NSString*)mUserType;
/*
 * method used to add Trackers view to the scrollview
 */
- (UIView*)returnTheTrackersView;

/*
 * method used to add goals view to the scrollview
 */
- (UIScrollView*)returnTheGoalsView;
/*
 * method used to load banner view
 */
- (UIView*)returnTheBannerView;
/*
 * Method used to add subviews to the the Tracker view based on the tracker type
 * @param lTrackerMainView for the main view to which subviews to be added
 * @param mType for the tracker type i.e weight/exercise/meal/step/water
 */
- (UIView*)addSubControlsToTrackerView:(UIView*)lTrackerMainView
                           TrackerType:(NSString*)mType;
/*
 * Method used to show glasses based on the glasses per day 
 */
- (void)loadGlassesView;
/*
 * Methods used to load the Trcakers progress data per day
 */
- (void)postRequestToGetTrackersPerDay;

/*
 * Method used to retrieve the goals for dashboard if usertype =4
 */
- (void)postRequestToGetGoals;

/*
 * Method used to reload the page when the new goal is added
 */
- (void)onSuccessAddGoal;
/*
 * Method used to return the percentage of progress in trackers
 * @param mValue for the actual value
 * @param mGoal for the goal value
 */
- (int)caluclatePercentage:(float)mValue
                      Goal:(float)mGoal
               TrackerType:(NSString*)mType;
/*
 * Method used to calculate the steps for today
 */
- (int)returnTheStepsForToday;

@end
