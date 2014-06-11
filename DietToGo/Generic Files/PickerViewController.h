//
//  PickerViewController.h
//  EHEandme
//
//  Created by EHEandme on 9/20/12.
//  Copyright (c) 2012 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class PickerViewController;
@class AppDelegate;
@protocol PickerViewControllerDelegate

/**
 * Method used to pick date from datepickercontroller when done is presses
 @param controller refers to DatePickerController instance
 @param date refers to date of DatePickerController
 @param isDone refers to BOOL value weather done is pressed or not
 */
- (void)pickerViewController:(PickerViewController *)controller 
                 didPickComp:(NSMutableArray *)value 
                       isDone:(BOOL)isDone;

@optional
- (void)didChangeTheRowIncomponet:(PickerViewController *)controller picker:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end




@interface PickerViewController : UIView <UIPickerViewDataSource,UIPickerViewDelegate>{
    
    /**
     * AppDelegate object creating
     */
    AppDelegate *mAppDelegate;
    
    /**
     * UIDatePicker object creating
     */
	UIPickerView *mViewPicker_;
    
    /**
     * DatePickerControllerDelegate object creating
     */
    NSObject <PickerViewControllerDelegate> *mPickerViewDelegate_;
    
    /**
     * CGRect variable  declaration
     */
    CGRect mFrame_;
    
    /**
     * UITextField  parameter declaration
     */
    UITextField *mSelectedTextField_;
    @public
    /**
     *integer to refer the number of components
     */
    int mNoofComponents;
    /**
     * nsmutable Array hold the value that has to be displayed in the picker
     */
    NSMutableArray *mRowValueintheComponent;
    
    /**
     *  Picker view  heading label .. Which was added to the toolbar on top of the picker.
     */
    UILabel *mTextDisplayedlb;
}

@property (nonatomic,strong,) UIPickerView *mViewPicker_;
@property (nonatomic, strong) NSObject <PickerViewControllerDelegate> *mPickerViewDelegate_;
@property (nonatomic, strong) UITextField *mSelectedTextField_;
@property (strong ,nonatomic) NSMutableArray *mRowValueintheComponent;
@property (strong, nonatomic) UILabel *mTextDisplayedlb;
@end