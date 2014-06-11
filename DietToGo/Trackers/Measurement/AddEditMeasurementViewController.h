//
//  AddEditMeasurementViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 06/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"
#import "DatePickerController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;
@interface AddEditMeasurementViewController : GAITrackedViewController<PickerViewControllerDelegate, DatePickerControllerDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;

}
@property (nonatomic,assign) int mSelectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *mBodyImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDatetxtLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mBGImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLbl;
@property (weak, nonatomic) IBOutlet UITextView *mCommentsTxtView;
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
- (IBAction)armAction:(UIButton *)sender;
- (IBAction)chestAction:(UIButton *)sender;
- (IBAction)thighsAction:(UIButton *)sender;
- (IBAction)hipsAction:(UIButton *)sender;
- (IBAction)waistAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *mArmsLbl;
@property (weak, nonatomic) IBOutlet UILabel *mWaistLbl;
@property (weak, nonatomic) IBOutlet UILabel *mChestLbl;
@property (weak, nonatomic) IBOutlet UILabel *mThighsLbl;
@property (weak, nonatomic) IBOutlet UILabel *mHipsLbl;
/*
 * Method used to post multi threading request to get personal settings for male/female image
 */
- (void)postRequestToGetPerSonalSettings;

@end
