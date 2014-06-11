//
//  WeightListViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 01/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "LoadGraph.h"
#import "GAITrackedViewController.h"
#import "CustomPageControl.h"

@class AppDelegate;

@interface WeightListViewController : GAITrackedViewController<UIScrollViewDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
    IBOutlet CPTGraphHostingView *_graphHostingView;
    LoadGraph *mLoadgraph;
    TrackerCameraGuide *mCameraGuide;
    CGFloat fitBitYpos;
}
//Add Page Control to Banner View
@property (retain, nonatomic) CustomPageControl *pagging;

@property (weak, nonatomic) IBOutlet UILabel *mLbsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mWeightimgView;
@property (weak, nonatomic) IBOutlet UILabel *mWeightlbl;
@property (nonatomic, retain) NSString *mRange;
@property (weak, nonatomic) IBOutlet UIView *mTopView;
@property (weak, nonatomic) IBOutlet UILabel *mLastLogLbl;
@property (nonatomic, retain) NSIndexPath *mSelectdIndex;
@property (weak, nonatomic) IBOutlet UILabel *mMsgLbl;
@property (nonatomic,retain) UISwipeGestureRecognizer *mSwipeGes;
@property (weak, nonatomic) IBOutlet UILabel *mLogLbl;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrolView;
@property (weak, nonatomic) IBOutlet UIImageView *mLineImgView;
@property (weak, nonatomic) IBOutlet UIButton *mWeekBtn;
@property (weak, nonatomic) IBOutlet UIButton *mMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *m3MonthsBtn;
- (IBAction)MonthsAction:(UIButton *)sender;
- (IBAction)monthAction:(id)sender;
- (IBAction)weekAction:(id)sender;
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
- (void)postRequestForWeightGraph;
/*
 * Method used to caluclate the total table height
 */
- (CGFloat)caluclateTableHeight;
@end
