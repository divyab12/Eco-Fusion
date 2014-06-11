//
//  AddBMIViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 26/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"
#import "DatePickerController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;


@interface AddBMIViewController : GAITrackedViewController<PickerViewControllerDelegate,DatePickerControllerDelegate, UITextFieldDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
  
    
}
@property (nonatomic, retain) NSIndexPath *mSelectedIndex;
@property (weak, nonatomic) IBOutlet UILabel *mValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *mHealthyWtLbl;
@property (nonatomic, retain) NSMutableArray *mRowValuesArray;
@property (retain ,nonatomic) NSMutableArray *mRowValueintheComponent;

@property (weak, nonatomic) IBOutlet UILabel *mDatetxtLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mBGImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLbl;
@property (weak, nonatomic) IBOutlet UITextView *mCommentsTxtView;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *mBtmView;
@property(nonatomic,retain) NSMutableDictionary  *mWeightValDict_;

- (IBAction)dateAction:(id)sender;
/*
 * Method used to display the date picker
 */
- (void)displayDatePicker;
/*
 * Method used to display the PickerView
 */
- (void)displayPickerview;
/*
 * Method used to remove the PickerView and date picker if already present
 */
- (void)removeViews;
/*
 * Method used to clauclate the BMI of the user
 */
- (float)caluclateBMI;
/*
 * Method used to determine the weight type i.e underweight, normal weight, overweight, obese based on the BMI
 * @param mValue for the BMI value
 */
- (NSString*)returnTheweightType:(float)mValue;
@end
