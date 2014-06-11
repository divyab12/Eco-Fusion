//
//  AddExerciseViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 18/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;
@interface AddExerciseViewController : GAITrackedViewController<DatePickerControllerDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
    int selectedBtn;
    
}
@property (nonatomic, retain) NSString *mMETval;
@property (nonatomic, retain) NSString *mActivityLUT;

@property (nonatomic,retain) NSMutableArray *mRowsArray;
@property (nonatomic,retain) NSMutableArray *mRowsValueArray;
@property (nonatomic,retain) NSMutableArray *mSubExerciseArray;

@property (weak, nonatomic) IBOutlet UILabel *mDatetxtLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIButton *mMinBtn;
@property (weak, nonatomic) IBOutlet UILabel *mMinLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mBGImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLbl;
@property (weak, nonatomic) IBOutlet UITextView *mCommentsTxtView;
@property (weak, nonatomic) IBOutlet UILabel *mCalBurnedLbl;
- (IBAction)dateAction:(id)sender;
- (IBAction)minuteAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *mCalLbl;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *mBtmView;
- (IBAction)minusAction:(id)sender;
- (IBAction)plusAction:(id)sender;

/*
 * Method used to display the date picker
 */
- (void)displayDatePicker;

/*
 * Method used to relod the exercise table
 */
- (void)loadTableData;
@end
