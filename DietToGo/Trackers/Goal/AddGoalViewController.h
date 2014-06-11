//
//  AddGoalViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 28/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerController.h"
#import "PickerViewController.h"
#import "GAITrackedViewController.h"

@class AppDelegate;

@interface AddGoalViewController : GAITrackedViewController<DatePickerControllerDelegate, PickerViewControllerDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
}
@property (nonatomic, retain) NSString *mStepID;
@property (nonatomic, retain) NSString *mUserStepID;
@property (nonatomic, retain) NSMutableDictionary *mGolaStepProgress_;
@property (weak, nonatomic) IBOutlet UIImageView *mTopGrayImgView;
@property (weak, nonatomic) IBOutlet UIImageView *mStepImgView;
@property (weak, nonatomic) IBOutlet UILabel *mStepLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mArrowImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDatetxtLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UILabel *mServingsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mBGImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLbl;
@property (weak, nonatomic) IBOutlet UIButton *mGoalBtn;
@property (weak, nonatomic) IBOutlet UITextView *mCommentsTxtView;

@property (strong, nonatomic) IBOutlet UIButton *mMinusBtn;
@property (strong, nonatomic) IBOutlet UIButton *mPlusBtn;

- (IBAction)dateAction:(id)sender;
/**
 * Method used to display the datepicker
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
 * Method used to post request for goal step progress for day
 */
- (void)postRequestToGoalStepProgress;
- (IBAction)minusAction:(id)sender;
- (IBAction)plusAction:(id)sender;

- (IBAction)stepAction:(UIButton *)sender;
@end
