//
//  WaterAddEditViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 14/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface WaterAddEditViewController : UIViewController{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
@public
    /**
     * NSMutableDictionary which contains the Log water detail
     */
    NSMutableArray *mLogWaterDataList_;
    /**
     * waterconsumed parameter
     */
    NSInteger mWaterConsumed_;
    
    /**
     * total water glasses parameter
     */
    NSInteger mTotalwaterGlasses_;
    /**
     * Currently selected glass parameter
     */
    NSInteger mCurrentGlass_;
    
    /**
     *Current Day which we are displaying
     */
    NSInteger mCurrentDay;
    
    /**
     *Current Date
     */
    NSString *mCurrentDate_;
    
    /**
     * Bool variable whether it is from edit or Add
     */
    BOOL isFromEdit;
    
    /**
     *Dispalyed NsDate parameter
     */
    NSDate *mDisplayedDate_;
    /**
     * Dateformatter parameter
     */
    NSDateFormatter *mFormatter_;
}
@property (retain, nonatomic) IBOutlet UILabel *mTitleLbl_;
@property (retain, nonatomic) IBOutlet UIButton *mPrevBtn_;
@property (retain, nonatomic) IBOutlet UIButton *mNextBtn_;
@property (retain, nonatomic) IBOutlet UIScrollView *mWaterGlassesScrollVie_;
@property (retain, nonatomic) NSString *mCurrentDate_;
@property (retain, nonatomic) NSDate *mDisplayedDate_;
@property (retain, nonatomic) NSDateFormatter *mFormatter_;
@property (retain, atomic) NSMutableArray *mLogWaterDataList_;
- (IBAction)prevDayBtnAction:(id)sender;
- (IBAction)nextDayBtnAction:(id)sender;
/**
 * Display the water glasses that are consumed
 */
- (void)dispalyTheWaterGlasses;

/**
 * Display Date in the Top Header
 */
- (void)displayDateFortheHeader;

/**
 * Search wheater the particular date in the previous list or not
 */
- (BOOL) searchPreviousList:(NSDate *)searchDate;

/**
 * Logic for the Add new water log in which it calls the search
 */
- (void)addNewWaterLog;


@end
