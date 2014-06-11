//
//  StepListViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 27/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadGraph.h"
#import "UnderLineButton.h"
#import "GAITrackedViewController.h"
#import "CustomPageControl.h"

@class AppDelegate;

@interface StepListViewController : GAITrackedViewController<UIScrollViewDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
    IBOutlet CPTGraphHostingView *_graphHostingView;
    LoadGraph *mLoadgraph;
    TrackerCameraGuide *mCameraGuide;
    //Add Page Control to Banner View
    CGFloat fitBitYpos;
}
//Add Page Control to Banner View
@property (retain, nonatomic) CustomPageControl *pagging;

@property (weak, nonatomic) IBOutlet UIButton *mPedoMeterBtn;
@property (weak, nonatomic) IBOutlet UILabel *mSetUpGoalLbl;
@property (weak, nonatomic) IBOutlet UnderLineButton *mClickHereBtn;
@property (weak, nonatomic) IBOutlet UILabel *mLbsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mWeightimgView;
@property (strong, nonatomic) IBOutlet UILabel *mWeightlbl;
@property (nonatomic, retain) NSString *mRange;
@property (weak, nonatomic) IBOutlet UIView *mTopView;
@property (weak, nonatomic) IBOutlet UILabel *mLastLogLbl;
@property (nonatomic, retain) NSIndexPath *mSelectdIndex;
@property (weak, nonatomic) IBOutlet UILabel *mMsgLbl;
@property (weak, nonatomic) IBOutlet UILabel *mLogLbl;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrolView;
@property (weak, nonatomic) IBOutlet UIImageView *mLineImgView;
@property (weak, nonatomic) IBOutlet UIButton *mWeekBtn;
@property (weak, nonatomic) IBOutlet UIButton *mMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *m3MonthsBtn;
@property (weak, nonatomic) IBOutlet UIButton *mTodayBtn;
@property (weak, nonatomic) IBOutlet UILabel *mGoalStepsLabel;
- (IBAction)MonthsAction:(UIButton *)sender;
- (IBAction)monthAction:(id)sender;
- (IBAction)weekAction:(id)sender;
- (IBAction)TodayAction:(id)sender;
- (IBAction)pedometerAction:(UIButton *)sender;

/**
 * Method to reload table data
 */
- (void)reloadContentsOftableView;
/**
 * Method to load graph data
 */
- (void)loadGraphData;
/**
 * Method used to post request for weight graph
 */
- (void)postRequestForStepGraph;
/*
 * Method used to caluclate the total table height
 */
- (CGFloat)caluclateTableHeight;
/*
 * Method used to load the today view text
 */
- (void)loadTodayView;
- (void)refreshTodayView;
/*
 * Method used to calculate the steps for today
 */
- (int)returnTheStepsForToday;
/*
 * Method used to return the percentage of progress in trackers
 * @param mValue for the actual value
 * @param mGoal for the goal value
 */
- (int)caluclatePercentage:(float)mValue
                      Goal:(float)mGoal;
- (IBAction)clickHereAction:(id)sender;

@end
