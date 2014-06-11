//
//  PersonalSettingsViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 07/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"
#import "DatePickerController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface PersonalSettingsViewController : GAITrackedViewController<UITextFieldDelegate,PickerViewControllerDelegate,DatePickerControllerDelegate>{
    AppDelegate *mAppDelegate;
    /**
     * Currently Displayed String in the toolbar parameter
     */
    NSString *mTextInToolBar;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic,retain) NSMutableArray *mTitlesArray;
@property (nonatomic,retain) NSMutableArray *mTxtFldsArray;
@property (nonatomic, retain) NSMutableDictionary *mDetailsDict;
@property (retain, nonatomic) UITextField *mActiveTxtFld_;
@property (retain ,nonatomic) NSMutableArray *mRowValueintheComponent;


- (void)loadDetails;
/**
 * Method used to display the PickerView
 */
- (void)displayPickerview;
/**
 * Method used to display the datepicker
 */
- (void)displayDatePicker;

@end
