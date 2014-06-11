//
//  AddJournalViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 19/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"
#import "DatePickerController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;
@interface AddJournalViewController : GAITrackedViewController<PickerViewControllerDelegate,DatePickerControllerDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
    
}
@property (nonatomic, assign)int mSelectedTag;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextView *mCommentTxtView;
@property (weak, nonatomic) IBOutlet UILabel *mCatLbl;
@property (weak, nonatomic) IBOutlet UILabel *mCatTxtLbl;
- (IBAction)categoryAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *mTopImgView;
@property (weak, nonatomic) IBOutlet UIImageView *mBtmImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *mDateTXTLBL;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLbl;

- (IBAction)dateAction:(UIButton *)sender;
- (IBAction)timeAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *mTimeTxtLbl;

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


@end
