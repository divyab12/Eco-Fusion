//
//  AddCholesterolViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 26/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface AddCholesterolViewController : GAITrackedViewController<DatePickerControllerDelegate, UITextFieldDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
    
}
@property(nonatomic,retain) UITextField *mActiveTxtFld;
@property (nonatomic, retain) NSMutableArray *mRowValuesArray;
@property (weak, nonatomic) IBOutlet UILabel *mDatetxtLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mBGImgView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLbl;
@property (weak, nonatomic) IBOutlet UITextView *mCommentsTxtView;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *mBtmView;

- (IBAction)dateAction:(id)sender;

/*
 * Method used to display the date picker
 */
- (void)displayDatePicker;
@end
