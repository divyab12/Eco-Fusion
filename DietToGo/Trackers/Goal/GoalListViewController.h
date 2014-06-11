//
//  GoalListViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 28/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "LoadGraph.h"
#import "PickerViewController.h"
#import "GAITrackedViewController.h"

@class AppDelegate;

@interface GoalListViewController : GAITrackedViewController<PickerViewControllerDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
    IBOutlet CPTGraphHostingView *_graphHostingView;
    LoadGraph *mLoadgraph;
    
}
@property (retain, nonatomic) NSMutableDictionary *mGoalsDict;

@property (weak, nonatomic) IBOutlet UILabel *mTypeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mTopGrayImgView;
@property (weak, nonatomic) IBOutlet UILabel *mLbsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mWeightimgView;
@property (weak, nonatomic) IBOutlet UILabel *mWeightlbl;
@property (nonatomic, retain) NSString *mRange;
@property (nonatomic, retain) NSString *mStepID;
@property (nonatomic, retain) NSString *mUserStepID;

@property (weak, nonatomic) IBOutlet UIView *mTopView;
@property (weak, nonatomic) IBOutlet UILabel *mLastLogLbl;
@property (nonatomic, retain) NSIndexPath *mSelectdIndex;
@property (weak, nonatomic) IBOutlet UILabel *mMsgLbl;

@property (weak, nonatomic) IBOutlet UILabel *mLogLbl;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollview;
@property (weak, nonatomic) IBOutlet UIImageView *mLineImgView;
@property (weak, nonatomic) IBOutlet UIButton *mWeekBtn;
@property (weak, nonatomic) IBOutlet UIButton *mMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *m3MonthsBtn;
- (IBAction)MonthsAction:(UIButton *)sender;
- (IBAction)monthAction:(id)sender;
- (IBAction)weekAction:(id)sender;
- (IBAction)typeAction:(id)sender;
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
- (void)postRequestForGaolGraph;
/*
 * Method used to display the PickerView
 */
- (void)displayPickerview;

/*
 * Method used to divide/categorize the goals based on the dates into a dictionary
 */
- (void)categorizeGoalsByDate;
/*
 * Method used to caluclate the total table height
 */
- (CGFloat)caluclateTableHeight;
/*
 * Method used to sort the goals in date wise
 */
- (NSMutableArray*)compareTheDatesandSortTheresponse;

@end
