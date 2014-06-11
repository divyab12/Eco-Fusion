//
//  LogMealsViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 28/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "LogMealsViewController.h"
#import "GenricUI.h"
#import "CustomButton.h"
#import "AddFoodViewController.h"
#import "SwapMealViewController.h"
#import "FoodDetailsViewController.h"
#import "AddEditFoodDetailController.h"
#import "CameraView.h"
#import "CameraGuide.h"
#import "AsyncImageView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface LogMealsViewController ()

@end

@implementation LogMealsViewController
@synthesize mFormatter_,mCurrentDate_,mDisplayedDate_;
@synthesize mLogMealsDictionary_;
@synthesize mSelectedIndex,mMealLUT,mFoodLogId;
@synthesize mFoodDetailsViewController, mSwapMealViewController;
@synthesize mUnitID, mQuantity_;
@synthesize imagePicker;
@synthesize imageDownloadsInProgress;

#define SecondsInAWeek  60 * 60 * 24
#define DateFormatServer @"MM/dd/yyyy hh:mm:ss a"
#define DateFormatApp @"EEE, MMM dd yyyy"
#define DateFormatForRequest @"yyyy-MM-dd"
#define KToday @"Today"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // for setting the view below 20px in iOS7.0.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    mAppDelegate_=[AppDelegate appDelegateInstance];
    mLogMealsDictionary_=[[NSMutableDictionary alloc]init];
    mCurrentDate_=@"";
    mFormatter_=[[NSDateFormatter alloc]init];
    self.mTitleLbl.font = OpenSans_Light(30);
    self.mTitleLbl.textColor = DTG_MAROON_COLOR;
    
    self.mGoalLbl.font = OpenSans_Light(14);
    self.mGoalLbl.textColor = DTG_GRAYLIGHT_COLOR;
    self.mConsumedLbl.font = OpenSans_Light(14);
    self.mConsumedLbl.textColor = DTG_GRAYLIGHT_COLOR;
    self.mRemainingLbl.font = OpenSans_Light(14);
    self.mRemainingLbl.textColor = DTG_GRAYLIGHT_COLOR;
    self.mBurnLbl.font = OpenSans_Light(14);
    self.mBurnLbl.textColor = DTG_GRAYLIGHT_COLOR;
    
    self.mGoalTxtLbl.font = OpenSans_Regular(23);
    self.mGoalTxtLbl.textColor = DTG_GRAYTHIK_COLOR;
    self.mConsumedTxtLbl.font = OpenSans_Regular(23);
    self.mConsumedTxtLbl.textColor = DTG_GRAYTHIK_COLOR;
    self.mRemainTxtLbl.font = OpenSans_Bold(24);
    self.mRemainTxtLbl.textColor = DTG_GRAYTHIK_COLOR;
    self.mBurnTxtLbl.font = OpenSans_Regular(23);
    self.mBurnTxtLbl.textColor = DTG_GRAYTHIK_COLOR;
    
    self.mCal1Lbl.font = OpenSans_Light(13);
    self.mCal1Lbl.textColor = DTG_GRAYTHIK_COLOR;
    self.mCal2Lbl.font = OpenSans_Light(13);
    self.mCal2Lbl.textColor = DTG_GRAYTHIK_COLOR;
    self.mCal3Lbl.font = OpenSans_Light(13);
    self.mCal3Lbl.textColor = DTG_GRAYTHIK_COLOR;
    self.mCal4Lbl.font = OpenSans_Light(13);
    self.mCal4Lbl.textColor = DTG_GRAYTHIK_COLOR;
    
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [self.mFormatter_ setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    self.mFormatter_.locale = enLocale;
    
    [mFormatter_ setDateFormat:DateFormatForRequest];
    self.mCurrentDate_=[mFormatter_ stringFromDate:[NSDate date]];
    self.mDisplayedDate_=[NSDate date];
    //swipe
    UISwipeGestureRecognizer *sgrLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedLeft:)];
    [sgrLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.mTableView addGestureRecognizer:sgrLeft];
    
    imageDownloadsInProgress = [[NSMutableDictionary alloc]init];
    //isCameraOpen
    isCameraOpen = FALSE;
    //For iPhone 5
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3)
    {
        CGRect frame = self.mButtomCameraView.frame;
        frame.origin.y += 88;
        self.mButtomCameraView.frame = frame;
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    //[mAppDelegate_ hideEmptySeparators:self.mTableView];
    self.mButtomCameraView.hidden = FALSE;
    UIView *emptyView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    emptyView_.backgroundColor = [UIColor clearColor];
    [self.mTableView setTableFooterView:emptyView_];
       
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Meal Plan - Main View";
        [mAppDelegate_ trackFlurryLogEvent:@"Meal Plan - Main View"];
    }
    //end
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    self.navigationController.navigationBarHidden = FALSE;
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"MEAL_PLANNER", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];
    
    
    [self displayTitleView];
    
    // [mFormatter_ setDateFormat:DateFormatForRequest];
    // self.mCurrentDate_=[mFormatter_ stringFromDate:[NSDate date]];
    if (!isCameraOpen) {
        [self postRequestForMealPlan:self.mCurrentDate_];
        
    }
    
}
-(void)refreshThePage {
    [self postRequestForMealPlan:self.mCurrentDate_];
}
/*
 -(void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 //isCameraOpen
 isCameraOpen = FALSE;
 }
 */
- (void)menuAction:(id)sender {
    [mAppDelegate_ showLeftSideMenu:self];
}

- (void)displayTitleView
{
    
    NSDate *lDate=nil ;
    NSString *lDateStr=nil;
    [mFormatter_ setDateFormat:DateFormatForRequest];
    lDateStr=self.mCurrentDate_;
    
    if(lDateStr!=nil){
        lDate=[mFormatter_ dateFromString:lDateStr];
        self.mDisplayedDate_=lDate;
    }
    [mFormatter_ setDateFormat:DateFormatForRequest];
    if(lDate!=nil){
        if([lDateStr isEqualToString:[mFormatter_ stringFromDate:[NSDate date]]]){
            lDateStr=KToday;
        } else{
            [mFormatter_ setDateFormat:DateFormatApp];
            lDateStr=[mFormatter_ stringFromDate:lDate];
        }
    }
    [mFormatter_ setDateFormat:DateFormatForRequest];
    if(lDate!=nil){
        self.mCurrentDate_=[mFormatter_ stringFromDate:lDate];
    }
    
    self.mTitleLbl.text = lDateStr;
    [self AdjustArrows];
}
-(void)AdjustArrows{
    
    CGSize size =  [self.mTitleLbl.text sizeWithFont:self.mTitleLbl.font constrainedToSize:CGSizeMake(320, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mTitleLbl.frame = CGRectMake((320-size.width)/2, self.mTitleLbl.frame.origin.y, size.width, self.mTitleLbl.frame.size.height);
    
    self.mNextBtn.hidden = NO;
    self.mNext2Btn.hidden = NO;
    if ([self.mTitleLbl.text isEqualToString:KToday]) {
        self.mNextBtn.hidden = YES;
        self.mNext2Btn.hidden = YES;
    }
    self.mPrevBtn.frame = CGRectMake(self.mTitleLbl.frame.origin.x - self.mPrevBtn.frame.size.width - 15, self.mPrevBtn.frame.origin.y, self.mPrevBtn.frame.size.width, self.mPrevBtn.frame.size.height);
    self.mPrev2Btn.frame = CGRectMake(self.mPrevBtn.frame.origin.x - 4, self.mPrev2Btn.frame.origin.y, self.mPrev2Btn.frame.size.width, self.mPrev2Btn.frame.size.height);
    
    self.mNextBtn.frame = CGRectMake(self.mTitleLbl.frame.origin.x + self.mTitleLbl.frame.size.width + 15, self.mNextBtn.frame.origin.y, self.mNextBtn.frame.size.width, self.mNextBtn.frame.size.height);
    self.mNext2Btn.frame = CGRectMake(self.mNextBtn.frame.origin.x - 4, self.mNext2Btn.frame.origin.y, self.mNext2Btn.frame.size.width, self.mNext2Btn.frame.size.height);

}
- (void)populateTheView
{
   int isMealPlanSetUP = [[[mAppDelegate_.mDataGetter_.mMealPlanDict_ objectForKey:@"Plan"] objectForKey:@"DTGMealPlanTypeLUT"] intValue];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    int userType = [[loginUserDefaults objectForKey:USERTYPE] intValue];
    NSLog(@"userType %d",userType);

    //1 - Set up
    //0 - No Meal Plans
    //For Customer we never get 0.
    if (isMealPlanSetUP == 0 && userType == 1) {
            //This only for prospector..userType: 1
            if ([[NetworkMonitor instance] isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                mAppDelegate_.mRequestMethods_.mViewRefrence = self;
                [mAppDelegate_.mRequestMethods_ postRequestTogetDemoMealPlan:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance] displayNetworkMonitorAlert];
            }
        
    } else {
        
        self.mGoalTxtLbl.text = [NSString stringWithFormat:@"%d",[[[mAppDelegate_.mDataGetter_.mMealPlanDict_ objectForKey:CaloriesBudgetKey] objectForKey:CalorieBudgetKey] intValue]];
        //convert nav to pos..
        self.mConsumedTxtLbl.text = [NSString stringWithFormat:@"%d",[[[mAppDelegate_.mDataGetter_.mMealPlanDict_ objectForKey:CaloriesBudgetKey] objectForKey:CaloriesConsumedKey] intValue]];
        self.mConsumedPerLbl.text = [NSString stringWithFormat:@"%d",[[[mAppDelegate_.mDataGetter_.mMealPlanDict_ objectForKey:CaloriesBudgetKey] objectForKey:ConsumedPercentageKey] intValue]];
        self.mConsumedPerLbl.text = [ self.mConsumedPerLbl.text stringByAppendingString:@"%"];
        self.mBurnTxtLbl.text = [NSString stringWithFormat:@"%d",[[[mAppDelegate_.mDataGetter_.mMealPlanDict_ objectForKey:CaloriesBudgetKey] objectForKey:ExerciseCaloriesBurnedKey]intValue]];
        self.mRemainTxtLbl.text = [NSString stringWithFormat:@"%d",[[[mAppDelegate_.mDataGetter_.mMealPlanDict_ objectForKey:CaloriesBudgetKey] objectForKey:DailyCaloriesLeftKey] intValue]];
        [self reloadContentsOfTableView];
       

    }
}
- (void)storeResponseAsMealCategories
{
    [self.mLogMealsDictionary_ removeAllObjects];
    
    for (int i=0; i<5; i++)
    {
        NSMutableArray *tempArray=[[NSMutableArray alloc]init];
        
        [tempArray removeAllObjects];
        
        NSString *mKeyVal=[self getTheMeaalTypeName:i];
        
        NSMutableArray *mArray = [[mAppDelegate_.mDataGetter_.mMealPlanDict_ objectForKey:MealsKey] objectForKey:MealsKey];
        for (int i=0; i< mArray.count; i++) {
            if ([[[mArray objectAtIndex:i] objectForKey:NameKey] isEqualToString:mKeyVal]) {
                tempArray = [[mArray objectAtIndex:i] objectForKey:ListFoodsKey];
                [self.mLogMealsDictionary_ setValue:tempArray forKey:mKeyVal];
                
            }
        }
    }
}

- (void)postRequestForMealPlan:(NSString*)mDate
{
    if ([[NetworkMonitor instance]isNetworkAvailable])
    {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestForGetMealPlan:mDate
                                                        AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                     SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
    
}
- (NSString*)getTheMeaalTypeName:(int)mSelectedType
{
    NSString *keyValue=@"" ;
    switch (mSelectedType) {
        case 0:
            keyValue=NSLocalizedString(@"BREAKFAST", nil);
            break;
        case 1:
            keyValue=NSLocalizedString(@"LUNCH", nil);
            break;
        case 2:
            keyValue=NSLocalizedString(@"DINNER", nil);
            break;
        case 3:
            keyValue=NSLocalizedString(@"SNACKS", nil);
            break;
       // case 4:
       //     keyValue=NSLocalizedString(@"DESSERT", nil);
      //      break;
        default:
            break;
    }
    return keyValue;
}
- (void)reloadContentsOfTableView
{
    [self storeResponseAsMealCategories];
    //App Record
    [self stopLoadingImages];
    [self.imageDownloadsInProgress removeAllObjects];
    //We have 4 secions only.
    int i;
    for (i=0; i < 4; i++) {
        int mRowsCount=0;
        NSString *keyValue=[self getTheMeaalTypeName:i];
        mRowsCount=  [[self.mLogMealsDictionary_ objectForKey:keyValue] count];
        for (int j=0; j < mRowsCount; j++) {
            AppRecord *appRecord = [[AppRecord alloc] init];
            NSString* photoURl = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:j] objectForKey:PhotoFileNameKey];//@"http://diettogo.com/data/meal_images/t130/32B4%20&%20V32B4%20Granola_and_Yogurt%20017-1.jpg";//;
          //  NSLog(@"photoURl %@",photoURl);
            photoURl = [photoURl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            photoURl = [photoURl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (photoURl) {
                if (![photoURl isEqualToString:@""]) {
                    appRecord.imageURLString = photoURl;
                }
            }else {
                appRecord.imageURLString = @"";

            }
            appRecord.appIcon = nil;
            [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:j] setObject:appRecord forKey:@"AppRecord"];
        }
    }
    //App Record
    
    //self.mTableView.contentOffset = CGPointMake(0, 0);
    [self.mTableView reloadData];
    
    //Increase the tableview content size as we are showing camera layer - For type-4 user - Changed above.
    if (!self.mButtomCameraView.hidden) {
        // CGSize size = self.mTableView.contentSize;
        //  size.height += 50;
        //  self.mTableView.contentSize = size;
        
        // show camera guide very first time to user
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:CAMERALAYER];//FALSE;//
        if (!isCameraLayer) {
            
            /*
             UIView *whireTransLayer = [[UIView alloc] initWithFrame:[mAppDelegate_.window bounds]];
             whireTransLayer.tag = 1000;
             whireTransLayer.backgroundColor = BLACK_COLOR;
             whireTransLayer.alpha = 0.2f;
             [mAppDelegate_.window addSubview:whireTransLayer];*/
            [mAppDelegate_ addTransparentViewToWindow];
            
            
            //if there are food items show the share view
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"CameraGuide" owner:self options:nil];
            mCameraGuide = [array objectAtIndex:0];
            //Setting the frame to the share View
            mCameraGuide.guideTopLbl.font = Bariol_Regular(18);
            mCameraGuide.guideBottomLbl.font = Bariol_Regular(18);
            mCameraGuide.middleViewLbl.font = Bariol_Regular(18);
            mCameraGuide.slideViewLbl.font = Bariol_Regular(18);
            mCameraGuide.checkBoxViewLbl.font = Bariol_Regular(18);
            
            mCameraGuide.checkBoxView.hidden = YES;
            mCameraGuide.slideView.hidden = YES;
            
            mCameraGuide.middleView.hidden = NO;
            
            int userType = [[loginUserDefaults objectForKey:USERTYPE] intValue];
            if ( userType == 1) {
                //For Prospect user, hide swap icon and also alert.
                mCameraGuide.middleView.hidden = YES;
            }
            
            //Commenting this as we dint have availableMealPlan API - Apl 17
            /*
            //to hide the swap meal button no meal is selected
            BOOL flag = FALSE;
            if (mAppDelegate_.mDataGetter_.mPlansList_.count == 0) {
                flag = TRUE;
                
            }
            for(int i =0 ; i< mAppDelegate_.mDataGetter_.mPlansList_.count; i++){
                if ([[[mAppDelegate_.mDataGetter_.mPlansList_ objectAtIndex:i] objectForKey:@"MealPlanID"] intValue] == 0 && [[[mAppDelegate_.mDataGetter_.mPlansList_ objectAtIndex:i] objectForKey:@"MealPlanName"] isEqualToString:@"I wish not to have any Meal Plan, but will use the planner to track calories."] && [[[mAppDelegate_.mDataGetter_.mPlansList_ objectAtIndex:i] objectForKey:@"Selected"] boolValue]) {
                    flag = TRUE;
                }
            }
            if (!flag) {
                mCameraGuide.middleView.hidden = FALSE;
                
            }
            */
            
            UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraGuideTapFirstAction:)];
            [firstTap setNumberOfTapsRequired:1];
            [mCameraGuide addGestureRecognizer:firstTap];
            
            
            //For iPhone 5
            int valueDevice = [[UIDevice currentDevice] resolution];
            if (valueDevice == 3) {
                mCameraGuide.frame = CGRectMake(0, 0, 320, 568);
                CGRect frame = mCameraGuide.bottomView.frame;
                frame.origin.y += 85;
                mCameraGuide.bottomView.frame = frame;
                
            }else {
                mCameraGuide.frame = CGRectMake(0, 0, 320, 460);
            }
            [mAppDelegate_.window addSubview:mCameraGuide];
            mCameraGuide.backgroundColor = [UIColor clearColor];
        }
    }
    
    
}
-(void)cameraGuideTapFirstAction:(UITapGestureRecognizer*)tap {
    [mCameraGuide removeGestureRecognizer:tap];
    
    //If Breakfast doesnot have log, dont go to second overlay.
    int mRowsCount=0;
    NSString *keyValue=[self getTheMeaalTypeName:0];
    mRowsCount=  [[self.mLogMealsDictionary_ objectForKey:keyValue] count];
    
    if (mRowsCount ==  0) {
        [self removeOverLay];
    } else {
        mCameraGuide.checkBoxView.hidden = NO;
        mCameraGuide.slideView.hidden = NO;
        
        mCameraGuide.topView.hidden = YES;
        mCameraGuide.bottomView.hidden = YES;
        mCameraGuide.middleView.hidden = YES;
        
        UITapGestureRecognizer *secTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraGuideTapSecondAction:)];
        [secTap setNumberOfTapsRequired:1];
        [mCameraGuide addGestureRecognizer:secTap];
        
    }
    
}
-(void)removeOverLay {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    /*for(UIView *lView in mAppDelegate_.window.subviews) {
     if ([lView isKindOfClass:[UIView class]] && lView.tag == 1000) {
     [lView removeFromSuperview];
     }
     }*/
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:CAMERALAYER];
    [loginUserDefaults synchronize];
}
-(void)cameraGuideTapSecondAction:(UITapGestureRecognizer*)tap {
    [self removeOverLay];
}
-(void)CheckBoxAction:(id)sender {
    CustomButton *checkBox = (CustomButton *)sender;
    NSString *mIsRepoted=@"",*mFoodLogID=@"", *mFoodLogDailyID=@"";
    if ([checkBox isSelected]) {
        mIsRepoted=@"false";
    }else {
        mIsRepoted=@"true";
    }
    NSString *sectionTitle=[self getTheMeaalTypeName:[checkBox.mSelectedSection intValue]] ;
    
    mFoodLogID = [[[self.mLogMealsDictionary_ objectForKey:sectionTitle]objectAtIndex:[checkBox.mSelectedRow intValue]] objectForKey:FoodLogIDKey];
    mFoodLogDailyID = [[[self.mLogMealsDictionary_ objectForKey:sectionTitle]objectAtIndex:[checkBox.mSelectedRow intValue]] objectForKey:FoodLogDailyIDKey];
    /*
     * post request for report change status
     */
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToChangeReportStatus:self.mCurrentDate_ FoodLogDailyId:mFoodLogDailyID FoodLogID:mFoodLogID Reported:mIsRepoted AuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else {
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
    
}
#pragma mark TableView Datasource and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 4; //5;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    int mRowsCount=0;
    NSString *keyValue=[self getTheMeaalTypeName:section];
    mRowsCount=  [[self.mLogMealsDictionary_ objectForKey:keyValue] count];
    return mRowsCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 50.0f;
    NSString *keyValue=[self getTheMeaalTypeName:indexPath.section];
    NSString* photoURl = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:PhotoFileNameKey];
    if (photoURl) {
        if (![photoURl isEqualToString:@""]) {
            height = 60.0;
        }
    }
    if ([[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:@"IsFoodFromPhoto"] boolValue]) {
        height = 60.0;
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    NSString *sectionTitle=[self getTheMeaalTypeName:section] ;
    
    UILabel * lMealTimeLabel_ = [[UILabel alloc] init] ;
    [lMealTimeLabel_ setFrame:CGRectMake(15, 10+2, 100, 25) ];
    [lMealTimeLabel_ setNumberOfLines:0];
    [lMealTimeLabel_ setText:sectionTitle];
    [lMealTimeLabel_ setBackgroundColor:CLEAR_COLOR];
    [lMealTimeLabel_ setTextColor:DTG_MAROON_COLOR];
    [lMealTimeLabel_ setFont:OpenSans_Regular(22)];
    CGSize size =  [lMealTimeLabel_.text sizeWithFont:lMealTimeLabel_.font constrainedToSize:CGSizeMake(lMealTimeLabel_.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lMealTimeLabel_.frame = CGRectMake(15, 10, size.width, 25);
    //for small line
    UIImageView *lLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(lMealTimeLabel_.frame.size.width+lMealTimeLabel_.frame.origin.x+10, 10, 1, 22)];
    lLineImgView.image = [UIImage imageNamed:@"sideline.png"];
    
    //for calories label
    UILabel *lCalLabel = [[UILabel alloc]initWithFrame:CGRectMake(lLineImgView.frame.size.width+lLineImgView.frame.origin.x+10, 10, 100, 25) ];
    [lCalLabel setNumberOfLines:0];
    [lCalLabel setText:sectionTitle];
    [lCalLabel setBackgroundColor:CLEAR_COLOR];
    [lCalLabel setTextColor:DTG_GRAYTHIK_COLOR];
    [lCalLabel setFont:OpenSans_Light(17)];
    
    NSMutableArray *mArray = [[mAppDelegate_.mDataGetter_.mMealPlanDict_ objectForKey:MealsKey] objectForKey:MealsKey];
    NSString *Calories = @"";
    for (int i=0; i< mArray.count; i++) {
        if ([[[mArray objectAtIndex:i] objectForKey:NameKey] isEqualToString:sectionTitle]) {
            Calories = [[mArray objectAtIndex:i] objectForKey:CaloriesTotalKey];
        }
    }
    Calories = [NSString stringWithFormat:@"%d",[Calories intValue]];
    lCalLabel.text = Calories;
    size =  [lCalLabel.text sizeWithFont:lCalLabel.font constrainedToSize:CGSizeMake(lCalLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lCalLabel.frame = CGRectMake(lCalLabel.frame.origin.x, lCalLabel.frame.origin.y, size.width, lCalLabel.frame.size.height);
    
    //Claories text label
    UILabel *lCalTxtLabel = [[UILabel alloc]initWithFrame:CGRectMake(lCalLabel.frame.size.width+lCalLabel.frame.origin.x+3, 14, 100, 20) ];
    [lCalTxtLabel setNumberOfLines:0];
    [lCalTxtLabel setText:@"cal."];
    [lCalTxtLabel setBackgroundColor:CLEAR_COLOR];
    [lCalTxtLabel setTextColor:DTG_GRAYTHIK_COLOR];
    [lCalTxtLabel setFont:OpenSans_Light(13)];
    
    //swap button
    UIButton *lSwapButton_ = [[UIButton alloc]initWithFrame:CGRectMake(245, 10, 25, 25)];
    lSwapButton_.tag = section;
    lSwapButton_.backgroundColor = CLEAR_COLOR;
    [lSwapButton_ setImage:[UIImage imageNamed:@"refreshincircle.png"] forState:UIControlStateNormal];
    //[lSwapButton_ addTarget:self action:@selector(swapFoodAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *lSwapButtonBig_ = [[UIButton alloc]initWithFrame:CGRectMake(235, 0, 40, 45)];
    lSwapButtonBig_.tag = section;
    lSwapButtonBig_.backgroundColor = CLEAR_COLOR;
    [lSwapButtonBig_ addTarget:self action:@selector(swapFoodAction:) forControlEvents:UIControlEventTouchUpInside];
   
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    int userType = [[loginUserDefaults objectForKey:USERTYPE] intValue];
    if ( userType == 1) {
        //For Prospect user, hide swap icon
        lSwapButton_.hidden = YES;
        lSwapButtonBig_.hidden = YES;
    }
    
    UIButton *lAddFoodButton_ = [[UIButton alloc] init] ;
    [lAddFoodButton_ setFrame:CGRectMake(285, 10, 25, 25)];
    [lAddFoodButton_ setImage:[UIImage imageNamed:@"addlarge.png"] forState:UIControlStateNormal];
    lAddFoodButton_.tag=section;
    lAddFoodButton_.backgroundColor = CLEAR_COLOR;
   // [lAddFoodButton_ addTarget:self action:@selector(addFoodAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *lAddFoodButtonBig_ = [[UIButton alloc] init] ;
    [lAddFoodButtonBig_ setFrame:CGRectMake(280, 0, 40, 45)];
    lAddFoodButtonBig_.tag=section;
    lAddFoodButtonBig_.backgroundColor = CLEAR_COLOR;
    [lAddFoodButtonBig_ addTarget:self action:@selector(addFoodAction:) forControlEvents:UIControlEventTouchUpInside];
  
    UIImageView *lBackgroungImage = [[UIImageView alloc] init] ;
    [lBackgroungImage setFrame:CGRectMake(0, 0, 320, 45)];
    [lBackgroungImage setImage:[UIImage imageNamed:@"greybar.png"]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    
    [view setBackgroundColor:CLEAR_COLOR];
    [view addSubview:lBackgroungImage];
    [view addSubview:lLineImgView];
    [view addSubview:lMealTimeLabel_];
    [view addSubview:lCalLabel];
    [view addSubview:lCalTxtLabel];
    [view addSubview:lAddFoodButton_];
    [view addSubview:lAddFoodButtonBig_];
    [view addSubview:lSwapButton_];
    [view addSubview:lSwapButtonBig_];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
	
	if (nil==cell)
	{
		cell = [[UITableViewCell alloc]  initWithFrame:CGRectMake(0,0,0,0)] ;
		
        UIView *lSelectedView_ = [[UIView alloc] init];
        lSelectedView_.backgroundColor =SELECTED_CELL_COLOR;
        cell.selectedBackgroundView = lSelectedView_;
        lSelectedView_=nil;
        
        UIImageView *lSelectedImgiew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        // lSelectedImgiew.image = [UIImage imageNamed:@"selectedbar.png"];
        lSelectedImgiew.contentMode = UIViewContentModeScaleAspectFit;
        lSelectedImgiew.tag = 99;
        lSelectedImgiew.hidden = TRUE;
        [cell.contentView addSubview:lSelectedImgiew];
        
		//Configure cell format for the tableView,
 	    //Same format for all the three sections.
        CustomButton *lCheckBox_ = [[CustomButton alloc] init];
        [lCheckBox_ setFrame:CGRectMake(0, 0, 45, 44)];
        lCheckBox_.tag=3;
        lCheckBox_.backgroundColor = CLEAR_COLOR;
        [cell.contentView addSubview:lCheckBox_];
        
        UILabel *lFoodItemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 25+160, 20)];
        lFoodItemNameLabel = [GenricUI showLabelWithText:@"                      " Font:Bariol_Regular(17) labelInstance:lFoodItemNameLabel numberOfLines:2 labelTag:1 textColor:BLACK_COLOR];
        [cell.contentView addSubview:lFoodItemNameLabel];
        lFoodItemNameLabel.backgroundColor=CLEAR_COLOR;
        
        UILabel *lFoodCalorieValueLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 60, 25)];
        lFoodCalorieValueLabel_ = [GenricUI showLabelWithText:@"                 " Font:Bariol_Regular(17) labelInstance:lFoodCalorieValueLabel_ numberOfLines:2 labelTag:2 textColor:BLACK_COLOR];
        lFoodCalorieValueLabel_.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lFoodCalorieValueLabel_];
        
        //unit name label
        UILabel *lUnitnameLbl=[[UILabel alloc]initWithFrame:CGRectMake(45, 25, 120, 15)];
        lUnitnameLbl.textColor=RGB_A(102, 102, 102, 1);
        //        lLogWeightLbl.text=@"";
        lUnitnameLbl.font=Bariol_Regular(14);
        lUnitnameLbl.backgroundColor=CLEAR_COLOR;
        lUnitnameLbl.tag=4;
        [cell.contentView addSubview:lUnitnameLbl];
        
        
        //Claories text label
        UILabel *lCalTxtLabel = [[UILabel alloc]initWithFrame:CGRectMake(lFoodCalorieValueLabel_.frame.size.width+lFoodCalorieValueLabel_.frame.origin.x+3, 13, 100, 20) ];
        [lCalTxtLabel setNumberOfLines:0];
        [lCalTxtLabel setText:@"cal."];
        lCalTxtLabel.tag = 5;
        [lCalTxtLabel setBackgroundColor:CLEAR_COLOR];
        [lCalTxtLabel setTextColor:RGB_A(102, 102, 102, 1)];
        [lCalTxtLabel setFont:Bariol_Regular(14)];
        [cell.contentView addSubview:lCalTxtLabel];
        
        UIImageView *AsyncImgView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 5, 50, 50)];
        
        //AsyncImageView *AsyncImgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(45, 5, 50, 50)];
        AsyncImgView.tag = 6;
        AsyncImgView.hidden = TRUE;
        [cell.contentView addSubview:AsyncImgView];
        //Add activity on imageview
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidden = YES;
        activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        activityIndicator.tag = 120;
        activityIndicator.frame = CGRectMake((AsyncImgView.frame.size.width-20)/2,(AsyncImgView.frame.size.height-20)/2, 20, 20);
        [AsyncImgView addSubview:activityIndicator];
        
	}
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType=UITableViewCellAccessoryNone;
    //Back ground Color
    CGFloat height = 50.0f;
    NSString *keyValue=[self getTheMeaalTypeName:indexPath.section];
    NSString* photoURl = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:PhotoFileNameKey];
    if (photoURl) {
        if (![photoURl isEqualToString:@""]) {
            height = 60.0;
        }
    }
    UIImageView *lImgview = (UIImageView*)[cell.contentView viewWithTag:99];
    lImgview.backgroundColor = RGB_A(251, 242, 230, 1);
    CGRect lFrame = lImgview.frame;
    lFrame.size.height = height;
    lImgview.frame = lFrame;
    
    /*
     * check box instance
     */
    UIImage *lSelectedImage = [UIImage imageNamed:@"mealcheckmark.png"];
    UIImage *lUnSelectedImage = [UIImage imageNamed:@"checkboxunchecked.png"];
    
    CustomButton *lCheckBox=(CustomButton*)[cell.contentView viewWithTag:3];
    lCheckBox.mSelectedSection=[NSString stringWithFormat:@"%d",indexPath.section];
    lCheckBox.mSelectedRow=[NSString stringWithFormat:@"%d",indexPath.row];
    [lCheckBox setSelected:FALSE];
    [lCheckBox setImage:lSelectedImage forState:UIControlStateSelected];
    lCheckBox.backgroundColor = CLEAR_COLOR;
    [lCheckBox setImage:lUnSelectedImage forState:UIControlStateNormal];
    [lCheckBox addTarget:self action:@selector(CheckBoxAction:) forControlEvents:UIControlEventTouchUpInside];
    /*
     * food name instance
     */
    UILabel *lFoodItemNameLabel = (UILabel*)[cell.contentView viewWithTag:1];
    /*
     * calories burnt label instance
     */
    UILabel *lFoodCalorieValueLabel_ = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *lCalorieLabel_ = (UILabel *)[cell.contentView viewWithTag:5];
    
    //creating unit name instanse
    UILabel *lUnitnameLblint = (UILabel*)[cell.contentView viewWithTag:4];
    
    NSString *mFoodName=@"",*mCalValue=@"";
    
    mFoodName=[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:@"FoodName"];
    mCalValue=[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:@"Calories"];
    
    self.mFoodID = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:@"FoodID"];
    
    
    if ([[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:@"IsReported"] boolValue]) {
        [lCheckBox setSelected:TRUE];
        lImgview.hidden = FALSE;
        lFoodItemNameLabel.textColor = RGB_A(102, 102, 102, 1);
        lFoodCalorieValueLabel_.textColor = RGB_A(102, 102, 102, 1);
        lUnitnameLblint.textColor = RGB_A(102, 102, 102, 1);
        lCalorieLabel_.textColor = RGB_A(102, 102, 102, 1);
        
    }else {
        [lCheckBox setSelected:FALSE];
        lImgview.hidden = TRUE;
        lFoodItemNameLabel.textColor = BLACK_COLOR;
        lFoodCalorieValueLabel_.textColor = BLACK_COLOR;
        lUnitnameLblint.textColor = RGB_A(102, 102, 102, 1);
        lCalorieLabel_.textColor = RGB_A(102, 102, 102, 1);
        
    }
    [lFoodItemNameLabel setText:mFoodName];
    NSString *Quantitystr = [NSString stringWithFormat:@"%@",[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:@"Qty"]];
    float quantity =[Quantitystr floatValue] ;
    NSString *qty = [NSString stringWithFormat:@"%.1f", quantity];
    
    lUnitnameLblint.text = [NSString stringWithFormat:@"%@ %@",qty,[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:@"UnitName"]];
    
    // display calories value only when its not a generic meal
    if ([self.mFoodID intValue]<=0) {
        [lFoodCalorieValueLabel_ setText:@""];
    }else {
        [lFoodCalorieValueLabel_ setText:[NSString stringWithFormat:@"%d",[mCalValue intValue]]];
    }
    CGSize size =  [lFoodCalorieValueLabel_.text sizeWithFont:lFoodCalorieValueLabel_.font constrainedToSize:CGSizeMake(lFoodCalorieValueLabel_.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lFoodCalorieValueLabel_.frame = CGRectMake(lFoodCalorieValueLabel_.frame.origin.x, lFoodCalorieValueLabel_.frame.origin.y, size.width, lFoodCalorieValueLabel_.frame.size.height);
    lCalorieLabel_.frame = CGRectMake(lFoodCalorieValueLabel_.frame.origin.x+lFoodCalorieValueLabel_.frame.size.width+5, lCalorieLabel_.frame.origin.y, lCalorieLabel_.frame.size.width, lCalorieLabel_.frame.size.height);
    
    lFoodItemNameLabel.frame = CGRectMake(45, 5, 185, 20);
    lUnitnameLblint.frame = CGRectMake(45, 25, 120, 15);
    UIImageView *AsyncImgView = (UIImageView *)[cell viewWithTag:6];
    AsyncImgView.hidden = TRUE;
    UIActivityIndicatorView *activityIndicator=(UIActivityIndicatorView*)[cell.contentView viewWithTag:120];
    activityIndicator.hidden = TRUE;
    
    if (photoURl) {
        if (![photoURl isEqualToString:@""]) {
            AsyncImgView.hidden = FALSE;
            activityIndicator.hidden = FALSE;
            AsyncImgView.frame = CGRectMake(45, 5, 50, 50);
            lFoodItemNameLabel.frame = CGRectMake(100, 5, 185-60, 20);
            lUnitnameLblint.frame = CGRectMake(100, 25, 120, 15);
        }
    }
    if ([[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:@"IsFoodFromPhoto"] boolValue]) {
        
        AsyncImgView.hidden = FALSE;
        activityIndicator.hidden = FALSE;
        AsyncImgView.frame = CGRectMake(45, 5, 50, 50);
        lFoodItemNameLabel.frame = CGRectMake(100, 5, 185-60, 20);
        lUnitnameLblint.frame = CGRectMake(100, 25, 120, 15);
    }
    
    if (!AsyncImgView.hidden) {
        
        AppRecord *appRecord = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:indexPath.row] objectForKey:@"AppRecord"];
    IconDownloader *iCondownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if(iCondownloader != nil) {
        //AppRecord *appRecordInIconDownloader = iCondownloader.appRecord.appRecord;
        appRecord = iCondownloader.appRecord;
    }
    
    if (!appRecord.appIcon)
    {
        [self startIconDownload:appRecord forIndexPath:indexPath];
        [activityIndicator startAnimating];
        //this is add a dummy image initially..
        AsyncImgView.image = [self imageScaledToSize:CGSizeMake(50,50) :[UIImage imageNamed:@"Icon.png"]];
    } else{
        [activityIndicator stopAnimating];
        activityIndicator.hidden = YES;
        AsyncImgView.image = [self imageScaledToSize:CGSizeMake(50,50) :appRecord.appIcon];
    }
    if(appRecord.imageURLString != nil)
    {
        
    }
    else
    {
        [activityIndicator stopAnimating];
        activityIndicator.hidesWhenStopped = YES;
        UIImage *cellImage = [self imageScaledToSize:CGSizeMake(50,50) :[UIImage imageNamed:@"Icon.png"]];
        //this is to add default image if we dont get image from URL.
        AsyncImgView.image = cellImage;
    }
    //end appRecoder
    }
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.mTableView reloadData];
    isFromAddFood = FALSE;
    /* storing the sected index*/
    self.mSelectedIndex=indexPath;
    
    //get the key value based on the meal type selection
    NSString *keyValue=[self getTheMeaalTypeName:indexPath.section];
    
    if ([[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:@"IsFoodFromPhoto"] boolValue]) {
        [self pushToAddEditPhotoFoodPage];
    }else {
        
        self.mFoodLogId = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:FoodLogIDKey];
        self.mFoodLogDailyId = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:FoodLogDailyIDKey];
        self.mMealLUT=keyValue;
        self.mFoodID = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:@"FoodID"];
        self.mQuantity_ = [[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:@"Qty"] floatValue];
        self.mUnitID = [NSString stringWithFormat:@"%d",[[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:@"UnitID"]  intValue]];
        
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate_.mRequestMethods_ postRequestToGetFoodInfo:self.mFoodID
                                                           AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                        SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }
    
}
-(void)cellSwipedLeft:(UIGestureRecognizer *)gestureRecognizer {
    [self.mTableView reloadData];
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // [self.mTableView removeGestureRecognizer:self.mSwipeGes];
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.mTableView];
        NSIndexPath *swipedIndexPath = [self.mTableView indexPathForRowAtPoint:swipeLocation];
        self.mSelectedIndex = swipedIndexPath;
        UITableViewCell* swipedCell = [self.mTableView cellForRowAtIndexPath:swipedIndexPath];
        //to move the row contents to left
        UITableViewCell *cell = (UITableViewCell *)swipedCell;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        for (int i =1; i<6; i++) {
            UILabel *lLbl = (UILabel*)[cell.contentView viewWithTag:i];
            CGRect frame = lLbl.frame;
            frame.origin.x -= 100;
            lLbl.frame = frame;
        }
        AsyncImageView *AsyncImgView = (AsyncImageView *)[cell viewWithTag:6];
        CGRect frame = AsyncImgView.frame;
        frame.origin.x -= 100;
        AsyncImgView.frame = frame;
        
        [UIView commitAnimations];
        //for view
        UIView* rightPatch = [[UIView alloc]init];
        rightPatch.frame = CGRectMake(320-100, 0, 100, cell.frame.size.height);
        [rightPatch setBackgroundColor:DTG_MAROON_COLOR];
        [cell addSubview:rightPatch];
        
        UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(0, 0, 50, cell.frame.size.height);
        [editBtn setTag:swipedIndexPath.row];
        [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [editBtn.titleLabel setFont:Bariol_Regular(17)];
        [editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightPatch addSubview:editBtn];
        
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(50, 0, 50, cell.frame.size.height);
        [deleteBtn setImage:[UIImage imageNamed:@"crossicon.png"] forState:UIControlStateNormal];
        [deleteBtn setTag:swipedIndexPath.row];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightPatch addSubview:deleteBtn];
        
    }
}
- (void)editBtnAction:(UIButton*)editBtn{
    [self.mTableView reloadData];
    
    //get the key value based on the meal type selection
    NSString *keyValue=[self getTheMeaalTypeName:self.mSelectedIndex.section];
    
    if ([[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:@"IsFoodFromPhoto"] boolValue]) {
        
        [self pushToAddEditPhotoFoodPage];
    }else {
        isFromAddFood = FALSE;
        
        self.mFoodLogId = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:FoodLogIDKey];
        self.mFoodLogDailyId = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:FoodLogDailyIDKey];
        self.mFoodID = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:@"FoodID"];
        self.mMealLUT=keyValue;
    
        
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            mAppDelegate_.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate_.mRequestMethods_ postRequestToGetFoodInfo:self.mFoodID
                                                           AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                        SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }
    
}
-(void)deleteBtnAction:(UIButton*)deleteBtn {
    [GenricUI showAlertWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:@"Are you sure you wish to delete the selected food item?" cancelButton:@"No" delegates:self button1Titles:@"Yes" button2Titles:nil tag:400];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 400) {
        if (buttonIndex == 1) {
            //get the key value based on the meal type selection
            NSString *keyValue=[self getTheMeaalTypeName:self.mSelectedIndex.section];
            
            self.mFoodLogId = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:FoodLogIDKey];
            self.mFoodLogDailyId = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:FoodLogDailyIDKey];
            self.mFoodID = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:@"FoodID"];
            self.mMealLUT=keyValue;
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                mAppDelegate_.mRequestMethods_.mViewRefrence = self;
                
                [mAppDelegate_.mRequestMethods_ postRequestForDeleteLogFood:self.mCurrentDate_ FoodLogDailyId:self.mFoodLogDailyId FoodLogID:self.mFoodLogId AuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
                return;
                
            }
            
        }
    }
}

- (void)pushToDetailPage
{
    FoodDetailsViewController *lVc = [[FoodDetailsViewController alloc] initWithNibName:@"FoodDetailsViewController" bundle:nil];
    lVc.isReported = TRUE;
    self.mFoodDetailsViewController = lVc;
    //get the key value based on the meal type selection
    NSString *keyValue=[self getTheMeaalTypeName:self.mSelectedIndex.section];
    self.mFoodID = [[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:@"FoodID"];
    lVc.mSelectedId = self.mFoodID;
    [self.navigationController pushViewController:lVc animated:TRUE];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)prevaction:(id)sender {
    NSDate *lDate=nil;
    NSString *lDateStr=nil;
    
    lDate= [NSDate dateWithTimeInterval:-SecondsInAWeek sinceDate:self.mDisplayedDate_];
    self.mDisplayedDate_=lDate;
    [mFormatter_ setDateFormat:DateFormatApp];
    lDateStr=[mFormatter_ stringFromDate:lDate];
    if([lDateStr isEqualToString:[mFormatter_ stringFromDate:[NSDate date]]]){
        lDateStr=KToday;
    }
    [mFormatter_ setDateFormat:DateFormatForRequest];
    if(lDate!=nil){
        self.mCurrentDate_=[mFormatter_ stringFromDate:lDate];
    }
    self.mTitleLbl.text=lDateStr;
    [self AdjustArrows];
    [self postRequestForMealPlan:self.mCurrentDate_];
    
    
}

- (IBAction)nextAction:(id)sender {
    
    NSDate *lDate=nil;
    NSString *lDateStr=nil;
    
    lDate= [NSDate dateWithTimeInterval:SecondsInAWeek sinceDate:self.mDisplayedDate_];
    self.mDisplayedDate_=lDate;
    [mFormatter_ setDateFormat:DateFormatApp];
    lDateStr=[mFormatter_ stringFromDate:lDate];
    if([lDateStr isEqualToString:[mFormatter_ stringFromDate:[NSDate date]]]){
        lDateStr=KToday;
    }
    [mFormatter_ setDateFormat:DateFormatForRequest];
    if(lDate!=nil){
        self.mCurrentDate_=[mFormatter_ stringFromDate:lDate];
    }
    self.mTitleLbl.text=lDateStr;
    [self AdjustArrows];
    [self postRequestForMealPlan:self.mCurrentDate_];
}
-(void)addFoodAction:(UIButton*)sender {
    isCameraOpen = FALSE;
    self.mMealLUT=[self getTheMeaalTypeName:sender.tag];
    
    isFromAddFood = TRUE;
    AddFoodViewController *lVc = [[AddFoodViewController alloc]initWithNibName:@"AddFoodViewController" bundle:nil];
    mAppDelegate_.mAddFoodViewController = lVc;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:lVc];
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:nc animated:YES completion:nil];
    } else {
        [self presentModalViewController:nc animated:YES];
        
    }
    
}
- (void)swapFoodAction:(UIButton*)lBtn{
    isCameraOpen = FALSE;
    self.mMealLUT=[self getTheMeaalTypeName:lBtn.tag];
    //get meals req
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToGetMeals:self.mCurrentDate_
                                                         Meal:self.mMealLUT
                                                    AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                 SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
    
    
}
- (void)pushToSwapPage{
    SwapMealViewController *lVc = [[SwapMealViewController alloc]initWithNibName:@"SwapMealViewController" bundle:nil];
    self.mSwapMealViewController = lVc;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:lVc];
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:nc animated:YES completion:nil];
    } else {
        [self presentModalViewController:nc animated:YES];
        
    }
}
- (void)pushToAddEditPhotoFoodPage {
    
    isCameraOpen = FALSE;
    
    NSString *keyValue=[self getTheMeaalTypeName:self.mSelectedIndex.section];
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row] objectForKey:PhotoFileNameKey]]];
    result = [UIImage imageWithData:data];
    if (result == nil) {
     //   result = [UIImage imageNamed:@"Icon.png"];
    }
    /*
     __block NSData *storeImageData;
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, NULL);
     dispatch_async(queue, ^{
     //load url image into NSData
     storeImageData = [NSData dataWithContentsOfURL:storeImageURL];
     
     dispatch_sync(dispatch_get_main_queue(), ^{
     //convert data into image after completion
     UIImage *storeImage = [UIImage imageWithData:storeImageData];
     //do what you want to do with your image
     });
     
     });
     dispatch_release(queue);
     */
    
    AddEditFoodDetailController *foodDetails = [[AddEditFoodDetailController alloc] initWithNibName:@"AddEditFoodDetailController" bundle:nil];
    [mAppDelegate_ setMAddEditFoodDetailController:foodDetails];
    foodDetails.isEdit = YES;
    foodDetails.mPreview = result;
    foodDetails.mealType = keyValue;
    foodDetails.mEditDict = [[self.mLogMealsDictionary_ objectForKey:keyValue]objectAtIndex:self.mSelectedIndex.row];
    [self.navigationController pushViewController:foodDetails animated:YES];
}
//***** ******** On succes of the food Catagegories list ******* *****************
- (void)OnsuccessResponseForRequest {
    
    
}
#pragma mark - UIActionSheet Delegate method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    
    if ([buttonTitle isEqualToString:@"Take Photo"]) {
        isCameraOpen = YES;
        [self takeNewPhotoAction];
    }
    if ([buttonTitle isEqualToString:@"Choose Photo"]) {
        isCameraOpen = YES;
        [self uploadFromLibraryAction];
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
}
#pragma mark - Handle Camera Events
- (IBAction)cameraBtnAction:(id)sender {
    
    
    NSString *other1 = @"Take Photo";
    NSString *other2 = @"Choose Photo";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2,nil];
    
    [actionSheet showInView:self.view];
    return;
    
    //if there are food items show the share view
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"CameraView" owner:self options:nil];
    camera = [array objectAtIndex:0];
    //Setting the frame to the share View
    
    //For iPhone 5
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        camera.frame = CGRectMake(0, 0, 320, 568);
    }else {
        camera.frame = CGRectMake(0, 0, 320, 460);
    }
    [mAppDelegate_.window addSubview:camera];
    camera.backgroundColor = [UIColor clearColor];
    
    camera.mTransparentView.hidden = FALSE;
    camera.mTakePhotoView.hidden = FALSE;
    camera.mUsePhotoView.hidden = TRUE;
    
    [camera.mCancelBtn addTarget:self action:@selector(cancelPhotoViewAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [camera.mTakeBtn addTarget:self action:@selector(takeNewPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [camera.mUploadBtn addTarget:self action:@selector(uploadFromLibraryAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //self.mTakePhotoView.hidden = FALSE;
}
- (void)takeNewPhotoAction {
    //- (IBAction)takeNewPhotoAction:(id)sender
    [camera removeFromSuperview];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        if (imagePicker != nil) {
            imagePicker = nil;
        }
        imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
        
        imagePicker.allowsEditing = NO;
        
        newMedia = YES;
        [self presentModalViewController:imagePicker animated:YES];
        
    }else {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil):NSLocalizedString(@"NOCAMERA_TITLE", nil)];
    }
}

- (void)uploadFromLibraryAction{
    //- (IBAction)uploadFromLibraryAction:(id)sender
    [camera removeFromSuperview];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        
        if (imagePicker != nil) {
            imagePicker = nil;
        }
        
        imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
        
        imagePicker.allowsEditing = NO;
        newMedia = NO;
        [self presentModalViewController:imagePicker animated:YES];
        
    }else {
        //        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil):NSLocalizedString(@"NOCAMERA_TITLE", nil)];
    }
}
- (IBAction)cancelPhotoViewAction:(id)sender {
    [camera removeFromSuperview];
    //self.mTakePhotoView.hidden = TRUE;
}
- (void)UsePhotoAction:(id)sender {
    UIImage *preview = camera.mPreview.image;
    [camera removeFromSuperview];
    //self.mTakePhotoView.hidden = TRUE;
    AddEditFoodDetailController *foodDetails = [[AddEditFoodDetailController alloc] initWithNibName:@"AddEditFoodDetailController" bundle:nil];
    foodDetails.isEdit = FALSE;
    foodDetails.mPreview = preview;
    [self.navigationController pushViewController:foodDetails animated:YES];
}
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [picker dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        //CGSize size = CGSizeMake(120, 150);//CGSizeMake(240, 320);
        /*  if (image.size.width > image.size.height) {
         DLog(@"Landscape");
         size = CGSizeMake(320, 240);
         }
         */
        
        //  UIImage *scalledImg = [Utilities imageWithImage:image scaledToSize:size];
        
        
        //here if cause to avoid storing if u selete image for Libray ( removing dupilcates)
        if (newMedia) UIImageWriteToSavedPhotosAlbum(image,
                                                     self,
                                                     @selector(image:finishedSavingWithError:contextInfo:),
                                                     nil);
        
        AddEditFoodDetailController *foodDetails = [[AddEditFoodDetailController alloc] initWithNibName:@"AddEditFoodDetailController" bundle:nil];
        [mAppDelegate_ setMAddEditFoodDetailController:foodDetails];
        foodDetails.isEdit = FALSE;
        foodDetails.mPreview = image;
        [self.navigationController pushViewController:foodDetails animated:YES];
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
}
-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(resetCameraValue:) userInfo:nil repeats:NO];
}
-(void)resetCameraValue:(NSTimer*)timer {
    [timer invalidate];
    timer = nil;
    isCameraOpen = FALSE;
}
#pragma mark Image Scale Methods
- (UIImage*) imageScaledToSize: (CGSize) newSize :(UIImage*)largeImage {
    //DTM-1073 iPad3 Retina - The grid/thumbnail view thumbnails are too pixelated
    if ([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    //DTM-1062 Thumbnail/grid view should not stretch all images to fit into a square area
    CGRect rect = [self calculateSize:newSize:largeImage.size];
    [largeImage drawInRect:rect];
    //[largeImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
//-------------------------------------------------------------------------------
//Method-    Caluclating the frames of the controls
//-------------------------------------------------------------------------------
//DTM-1062 Thumbnail/grid view should not stretch all images to fit into a square area
-(CGRect)calculateSize :(CGSize) newSize :(CGSize)imageSize {
    
    double lScaleFactor = MIN((newSize.width)/imageSize.width, (newSize.height)/imageSize.height);
    
    if(lScaleFactor>1) {
        lScaleFactor = 1;
    }
    
    return CGRectMake(((newSize.width- lScaleFactor*imageSize.width)/2),((newSize.height-lScaleFactor*imageSize.height)/2), lScaleFactor*imageSize.width, lScaleFactor*imageSize.height);
}
#pragma mark AppRecord Methods
- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
		iconDownloader->_pHeightOfImage = 50;
		iconDownloader->_pWidthOfImage = 50;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        //  [iconDownloader release];
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
	[self.mTableView reloadData];
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appSingleImageDidLoad:(int)rowNumber
{
}

-(void)stopLoadingImages
{
    // if ([[tipsDirectoryDicty objectForKey:@"Table"] count] > 0)
    {
        NSArray *visiblePaths = [self.mTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
			//if(_pAppDelegate->currentResultsObtained != indexPath.row)
			{
				IconDownloader *iCondownloader = [imageDownloadsInProgress objectForKey:indexPath];
                if(iCondownloader != nil)
                {
                    if(iCondownloader.imageConnection != nil)
                    {
                        [iCondownloader cancelDownload];
                    }
                }
            }
        }
    }
}
- (void)viewDidUnload {
    [self setMConsumedPerLbl:nil];
    [super viewDidUnload];
}
@end
