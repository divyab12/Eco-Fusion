//
//  LogMealsViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 28/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnsuccessProtocol.h"
#import "SwapMealViewController.h"
#import "GAITrackedViewController.h"
#import "IconDownloader.h"
#import "AppRecord.h"
@class CameraView;
@class CameraGuide;
@class AppDelegate;
@class FoodDetailsViewController;

@interface LogMealsViewController : GAITrackedViewController<OnsuccessProtocol,UIImagePickerControllerDelegate,UIActionSheetDelegate,IconDownloaderDelegate>{
    /**
     * AppDelegate instance variable creation
     */
    AppDelegate *mAppDelegate_;
    /*
     * bool variable to store weather the get categories is from add or selected meal type
     */
    BOOL isFromAddFood;
    //FOR imagepicker
    BOOL newMedia;
    //Camera view
    CameraView *camera;
    CameraGuide *mCameraGuide;
    //FOR imagepicker
    BOOL isCameraOpen;

}
@property (strong, nonatomic) NSMutableDictionary *imageDownloadsInProgress;

@property (nonatomic,retain) FoodDetailsViewController *mFoodDetailsViewController;
@property (nonatomic,retain) SwapMealViewController *mSwapMealViewController;

@property (weak, nonatomic) IBOutlet UIButton *mPrevBtn;
@property (weak, nonatomic) IBOutlet UIButton *mNextBtn;
@property (weak, nonatomic) IBOutlet UILabel *mCal1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *mCal2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *mCal3Lbl;
@property (weak, nonatomic) IBOutlet UILabel *mCal4Lbl;
@property (weak, nonatomic) IBOutlet UIButton *mNext2Btn;
@property (weak, nonatomic) IBOutlet UIButton *mPrev2Btn;

@property(nonatomic,retain)NSIndexPath *mSelectedIndex;
@property (nonatomic,retain) NSString *mMealLUT;
@property (nonatomic,retain) NSString *mFoodLogId;
@property (nonatomic,retain) NSString *mFoodID;
@property (nonatomic,retain) NSString *mFoodLogDailyId;
@property (retain, nonatomic) NSDateFormatter *mFormatter_;
@property (retain, nonatomic) NSDate *mDisplayedDate_;
@property (retain, nonatomic) NSString *mCurrentDate_;
@property(nonatomic,retain) NSMutableDictionary *mLogMealsDictionary_;

@property (weak, nonatomic) IBOutlet UILabel *mTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *mGoalLbl;
@property (weak, nonatomic) IBOutlet UILabel *mGoalTxtLbl;
@property (weak, nonatomic) IBOutlet UILabel *mConsumedLbl;
@property (weak, nonatomic) IBOutlet UILabel *mConsumedTxtLbl;
@property (weak, nonatomic) IBOutlet UILabel *mRemainingLbl;
@property (weak, nonatomic) IBOutlet UILabel *mRemainTxtLbl;
@property (weak, nonatomic) IBOutlet UILabel *mBurnLbl;
@property (weak, nonatomic) IBOutlet UILabel *mBurnTxtLbl;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UILabel *mConsumedPerLbl;

// Camera layouts
@property (strong, nonatomic) IBOutlet UIView *mButtomCameraView;
@property (strong, nonatomic) IBOutlet UIView *mTakePhotoView;
@property (retain, nonatomic)  UIImagePickerController *imagePicker;

//to store the quantity and unit id of the selected food item
@property (nonatomic, assign) float mQuantity_;
@property(nonatomic, retain) NSString *mUnitID;

- (IBAction)prevaction:(id)sender;
- (IBAction)nextAction:(id)sender;
/*
 * method to display the top view with date
 */
- (void)displayTitleView;
/*
 * method to post request for a particular day meal
 @param mDate for date of meal planner to get
 */
- (void)postRequestForMealPlan:(NSString*)mDate;
/*
 * method used to populate the view
 */
- (void)populateTheView;
/*
 * method to retrive meal type(name) based on the lut value from the response
 * @param mSelectedType for the melaType value
 */
- (NSString*)getTheMeaalTypeName:(int)mSelectedType;
/*
 * method used to store the food details from response into a dictionary based on the meal type
 */
- (void)storeResponseAsMealCategories;
/*
 * method used to reload contents of tableview
 */
- (void)reloadContentsOfTableView;
/*
 * method to push to detail page
 */
- (void)pushToDetailPage;
/*
 * method to push to swap meal page
 */
- (void)pushToSwapPage;
/*
 * method to Refresh meal page
 */
-(void)refreshThePage;
//Camera Actions
- (IBAction)cameraBtnAction:(id)sender;
//- (IBAction)cameraGuideCloseAction:(id)sender;
/*
- (IBAction)takeNewPhotoAction:(id)sender;
- (IBAction)uploadFromLibraryAction:(id)sender;
- (IBAction)cancelPhotoViewAction:(id)sender;
 */

@end
