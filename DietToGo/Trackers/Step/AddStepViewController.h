//
//  AddStepViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 27/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerController.h"
#import "GAITrackedViewController.h"

@interface AddStepViewController : GAITrackedViewController<DatePickerControllerDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
}
@property (weak, nonatomic) IBOutlet UILabel *mDatetxtLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UILabel *mStepsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mBGImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLbl;
@property (weak, nonatomic) IBOutlet UITextView *mCommentsTxtView;
@property (weak, nonatomic) IBOutlet UITextField *mTxtFld;
@property(nonatomic,retain) NSMutableDictionary  *mWeightValDict_;
- (IBAction)dateAction:(id)sender;
- (IBAction)minusAction:(id)sender;
- (IBAction)plusAction:(id)sender;

/**
 * Method used to display the datepicker
 */
- (void)displayDatePicker;

/*
 * Method used to remove the PickerView and date picker if already present
 */
- (void)removeViews;

@end
