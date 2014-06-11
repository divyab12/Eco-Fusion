//
//  DailyGoalsSettingViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 12/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface DailyGoalsSettingViewController : GAITrackedViewController<PickerViewControllerDelegate, UITextFieldDelegate>{
    AppDelegate *mAppDelegate;
    
    //to check whether the look up is from save or table did select
    BOOL isFromSave;
    
}
@property (nonatomic, retain) id mParentClass;

@property (nonatomic, assign) int mSelectedRow;
@property(nonatomic,retain) UITextField *mActiveTxtFld;

@property (nonatomic,retain) NSString *methodName, *mCalCode, *mMealPlanID;
@property (nonatomic,retain) NSMutableArray *mTitlesArray;
@property (nonatomic,retain) NSMutableArray *mValuesArray, *mRowValuesArray;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@property (weak, nonatomic) IBOutlet UILabel *mNutrnLbl;
@property (weak, nonatomic) IBOutlet UITableView *mNutritionTableView;
@property (weak, nonatomic) IBOutlet UILabel *mFitnessLbl;
@property (weak, nonatomic) IBOutlet UITableView *mFitnessTblView;

/*
 * Method used to display the PickerView
 */
- (void)displayPickerview;
/*
 * Method used to remove the PickerView and date picker if already present
 */
- (void)removeViews;
/*
 * Method used to load the APi response in the screen
 */
- (void)loadData;
@end
