//
//  DatePickerController.h
//  GSPSurveyor
//
//  Created by EHEandme on 6/14/11.
//  Copyright 2013 EHEandme Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class DatePickerController;
@class AppDelegate;
@protocol DatePickerControllerDelegate

/**
 * Method used to pick date from datepickercontroller when done is presses
 @param controller refers to DatePickerController instance
 @param date refers to date of DatePickerController
 @param isDone refers to BOOL value weather done is pressed or not
 */
- (void) datePickerController:(DatePickerController *)controller 
                  didPickDate:(NSDate *)date 
                       isDone:(BOOL)isDone;
@end


@interface DatePickerController : UIView {
    
    /**
     * UIDatePicker object creating
     */
	UIDatePicker *mDatePicker_;
    
    /**
     * DatePickerControllerDelegate object creating
     */
    NSObject <DatePickerControllerDelegate> *mDatePickerDelegate_;
    
    /**
     * CGRect variable  declaration
     */
    CGRect mFrame_;
    
    /**
     * UITextField  parameter declaration
     */
    UITextField *mSelectedTextField_;
    
    /**
     * Date Picker  heading label .. Which was added to the toolbar on top of the picker.
     */
    UILabel *mTextDisplayedlb;
    
    UIToolbar *mToolBar_;
 
    
    UIView *mPickerView_;
    
    AppDelegate *mAppDelegate;
}

@property (nonatomic,strong,) UIDatePicker *mDatePicker_;
@property (nonatomic,strong)     UILabel *mTextDisplayedlb;
@property (nonatomic, strong) NSObject <DatePickerControllerDelegate> *mDatePickerDelegate_;
@property (nonatomic, strong) UITextField *mSelectedTextField_;
@property (nonatomic, strong) UIToolbar *mToolBar_;
@property (nonatomic,strong)UIView *mPickerView_;
- (void)showAnimation;
@end
