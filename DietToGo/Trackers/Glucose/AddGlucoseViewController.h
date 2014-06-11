//
//  AddGlucoseViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 18/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;
@interface AddGlucoseViewController : GAITrackedViewController<DatePickerControllerDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
      
    
    
}
@property (nonatomic, assign)int mSelectedTag;

@property (weak, nonatomic) IBOutlet UITextField *mGlucoseTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *mGlucoseBtn;
@property (weak, nonatomic) IBOutlet UILabel *mDatetxtLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UILabel *mLbsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mBGImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *mTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *mTimeTxtLbl;
@property (weak, nonatomic) IBOutlet UITextView *mCommentsTxtView;
@property(nonatomic,retain) NSMutableDictionary  *mWeightValDict_;
- (IBAction)GlucoseAction:(id)sender;
- (IBAction)dateAction:(id)sender;
- (IBAction)minusAction:(id)sender;
- (IBAction)plusAction:(id)sender;
- (IBAction)timeAction:(id)sender;

/**
 * Method used to display the datepicker
 */
- (void)displayDatePicker;


/*
 * Method used to remove the PickerView and date picker if already present
 */
- (void)removeViews;


@end
