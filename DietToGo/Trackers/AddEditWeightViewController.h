//
//  AddEditWeightViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 04/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface AddEditWeightViewController : GAITrackedViewController<PickerViewControllerDelegate,DatePickerControllerDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
    /**
     * dictionary to store picker values of the table
     */
    NSMutableDictionary *mLogWeightValuesDict_;
    


}
@property (nonatomic,assign) BOOL isFromEdit;
@property (weak, nonatomic) IBOutlet UILabel *mDatetxtLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UILabel *mLbsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mBGImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLbl;
@property (weak, nonatomic) IBOutlet UITextView *mCommentsTxtView;
@property (weak, nonatomic) IBOutlet UITextField *mWeightTxtFld;
- (IBAction)dateAction:(id)sender;
- (IBAction)minusAction:(UIButton *)sender;
- (IBAction)plusAction:(UIButton *)sender;

/**
 * Method used to display the datepicker
 */
- (void)displayDatePicker;

/*
 * Method used to remove the PickerView and date picker if already present
 */
- (void)removeViews;
@end
