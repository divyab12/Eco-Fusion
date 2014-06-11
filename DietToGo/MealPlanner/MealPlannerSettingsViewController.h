//
//  MealPlannerSettingsViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 30/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"
#import "MealPlannerHelpView.h"
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface MealPlannerSettingsViewController : GAITrackedViewController<PickerViewControllerDelegate>{
    /**
     * AppDelegate instance variable creation
     */
    AppDelegate *mAppDelegate_;
}
@property (nonatomic, retain) MealPlannerHelpView *mHelpView;
@property (assign, nonatomic) BOOL isFromSlider;
@property (nonatomic,retain) NSMutableArray *mPlansListArray;
@property (nonatomic,retain) NSMutableArray *mSeclectedPlansListArray;
@property (nonatomic,retain) NSMutableArray *mCaloryLevelChoices;

@property (weak, nonatomic) IBOutlet UILabel *mCalLevelLbl;
@property (weak, nonatomic) IBOutlet UILabel *mTextlbl;
@property (weak, nonatomic) IBOutlet UILabel *mCalRangeLbl;
@property (weak, nonatomic) IBOutlet UILabel *mSelectPlanLbl;
@property (weak, nonatomic) IBOutlet UILabel *mCalSetngsLbl;
@property (weak, nonatomic) IBOutlet UILabel *mCalValueLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mCalImgView;
@property (weak, nonatomic) IBOutlet UILabel *mCalPerDayLbl;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollview;
@property (weak, nonatomic) IBOutlet UIImageView *mTblLastImgView;
//help view
- (void)helpDoneAction:(id)sender;

- (IBAction)rangeAction:(id)sender;
/*
 * Method used to display the PickerView
 */
- (void)displayPickerview;
@end
