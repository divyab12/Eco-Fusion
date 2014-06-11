//
//  LandingViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 23/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "LandingViewController.h"
#import "ECSlidingViewController.h"
#import "EditLandingViewController.h"
#import "LoginViewController.h"
#import "JSON.h"
#import "GenericDataBase.h"
#import "HomePageButton.h"
#import "MealPlannerHelpView.h"

#define SecondsInAWeek  60 * 60 * 24
#define DateFormatServer @"MM/dd/yyyy hh:mm:ss a"
#define DateFormatApp @"EEE, MMM dd yyyy"
#define DateFormatForRequest @"yyyy-MM-dd"
#define KToday @"Today"
#define WeightTracker @"Weight"
#define MealTracker @"Meal"
#define ExerciseTracker @"Exercise"
#define StepTracker @"Step"
#define WaterTracker @"Water"
#define GoalWeight @"GoalWeight"
#define GoalWater @"GoalWater"
#define GoalSteps @"GoalSteps"
#define GoalExercise @"GoalExercise"
#define GoalCalories @"GoalCalories"

#import "StepperView.h"
#import "Timeview.h"
#import "MoonView.h"
#import "GlassView.h"
#import "DashboradGoalView.h"
@interface LandingViewController ()

@end

@implementation LandingViewController
@synthesize mCurrentDate_,mDisplayedDate_,mFormatter_, methodName, mTrackerValuesDict, mTrackerCount, mTrackerOrder, mTrackersShown, mGoalsArray, isFromAddWater, mGoalOrder, mGoalsShown, mGlassesLbl, mMainGoalsArray, mBannerTxtArray;
@synthesize mScrollGesture,mBannerContentView;
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
    mAppDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    // for setting the view below 20px in iOS7.0.
    mAppDelegate.mLoginViewController.mIndicatorView_.hidden = TRUE;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    mCurrentDate_=@"";
    mFormatter_=[[NSDateFormatter alloc]init];
    
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [self.mFormatter_ setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    self.mFormatter_.locale = enLocale;
    
    [mFormatter_ setDateFormat:DateFormatForRequest];
    self.mCurrentDate_=[mFormatter_ stringFromDate:[NSDate date]];
    self.mDisplayedDate_=[NSDate date];
    self.mTitleLbl1_.font = OpenSans_Light(30); //Bariol_Bold(30);
    self.mTitleLbl1_.textColor = DTG_MAROON_COLOR;//RGB_A(51, 51, 51, 1);
  
    mTrackerValuesDict = [[NSMutableDictionary alloc]init];
    if ([mAppDelegate.mResponseMethods_.userType intValue] == 4) {
        mGoalsArray = [[NSMutableArray alloc]init];
        mMainGoalsArray = [[NSMutableArray alloc] init];
    }else{
        mBannerTxtArray = [[NSMutableArray alloc]initWithObjects:@"The first step to activating your EHE benefit is scheduling your physical exam.",@"We're here to support you during your physical exam and beyond.",@"Begin the path to a healthy life by partnering with a personal health coach.", nil];
    }
    
    self.mAddGlassCountLbl.font = Bariol_Regular(30);
    self.mAddGlassCountLbl.textColor = BLACK_COLOR;
    self.mGlassesLbl.font = Bariol_Regular(18);
    self.mGlassesLbl.textColor = BLACK_COLOR;
    self.mBannerLbl.font = Bariol_Regular(18);
    self.mBannerLbl.textColor = BLACK_COLOR;
    self.mScrollview.contentOffset = CGPointMake(0, 0);

   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate.mTrackPages) {
        //self.trackedViewName=@"Landing page";
        [mAppDelegate trackFlurryLogEvent:@"Landing page"];
    }
    //end
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"whitebar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"whitebar1.png";
    }
    [mAppDelegate setNavControllerTitle:@"" imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"edit.png"] title:nil target:self action:@selector(editAction:) forController:self rightOrLeft:1];
    [self.slidingViewController setAnchorLeftRevealAmount:250.0f];
    [self.slidingViewController setAnchorRightRevealAmount:250.0f];
    [self displayTitleView];
   
    //for iphone5
    if ([[GenricUI instance]isiPhone5]) {
        self.mScrollview.frame = CGRectMake(self.mScrollview.frame.origin.x, 70, 320, 360);
        self.mPageControl.frame = CGRectMake(self.mPageControl.frame.origin.x, 504-36, self.mPageControl.frame.size.width, self.mPageControl.frame.size.height);
        self.mBannerView.frame = CGRectMake(self.mBannerView.frame.origin.x, 504-58, self.mBannerView.frame.size.width, self.mBannerView.frame.size.height);
    }
    
    //to insert and retrieve the tracker order from the db
    if (![mAppDelegate.mGenericDataBase_ checkTrackerOrderForDate]) {
        
        //inserting into db
        NSString *sequence = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", WeightTracker, MealTracker, ExerciseTracker, StepTracker, WaterTracker];
        [mAppDelegate.mGenericDataBase_ insertTrackerOrder:sequence];
        //retriving from DB
        NSMutableDictionary *mDict = [mAppDelegate.mGenericDataBase_ getTrackerOrderForDate];
        self.mTrackerOrder = [mDict objectForKey:@"Sequence"];
        self.mTrackersShown = [mDict objectForKey:@"VisibleTrackers"];
    }else{
        NSMutableDictionary *mDict = [mAppDelegate.mGenericDataBase_ getTrackerOrderForDate];
        self.mTrackerOrder = [mDict objectForKey:@"Sequence"];
        self.mTrackersShown = [mDict objectForKey:@"VisibleTrackers"];

    }
    
    self.mBannerView.hidden = TRUE;
    //Hide this buttom banner as we dont have in DTG.
    /*
    //for the banner view showing and after 10 visit for 1, 2 and 3 user types and hide for incoaching user type
    if ([mAppDelegate.mResponseMethods_.userType intValue] == 2) {
        self.mBannerView.hidden = TRUE;

    }else{
        NSUserDefaults *mUserDeafults = [NSUserDefaults standardUserDefaults];
        if ([mUserDeafults objectForKey:@"BannerVisitNum"] == nil) {
            self.mBannerView.hidden = FALSE;
        }else{
            int mNum = [[mUserDeafults objectForKey:@"BannerVisitNum"] intValue];
            if (mNum==9) {
                self.mBannerView.hidden = FALSE;
                [mUserDeafults setValue:nil forKey:@"BannerVisitNum"];
                [mUserDeafults synchronize];
                
            }else{
                self.mBannerView.hidden = TRUE;
                mNum++;
                [mUserDeafults setValue:[NSString stringWithFormat:@"%d",mNum] forKey:@"BannerVisitNum"];
                [mUserDeafults synchronize];
                
            }
        }
    }
     */
    //to remove banner view
    if (self.mBannerContentView!=nil) {
        [self.mBannerContentView removeFromSuperview];
        [self setMBannerContentView:nil];
    }
    /* //Change-2
    if ([mAppDelegate.mResponseMethods_.userType intValue] != 4) {
        //post request per day
        [self postRequestToGetTrackersPerDay];
    }else{
        self.isFromAddWater = FALSE;
        [self postRequestToGetGoals];
    }*/
    [self postRequestToGetTrackersPerDay];
    self.mAddWaterView.hidden = TRUE;

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
    
    self.mTitleLbl1_.text=lDateStr;
    
    self.mNextBtn.hidden = FALSE;
    self.mNextBtn1.hidden = FALSE;
    self.mPrevBtn.hidden  = FALSE;
    self.mPrevBtn1.hidden = FALSE;
    if ([lDateStr isEqualToString:KToday]) {
      //  self.mNextBtn.hidden = TRUE;
      //  self.mNextBtn1.hidden = TRUE;
    }
    [self adjustArrows];

}
-(void)adjustArrows {

    CGSize size =  [self.mTitleLbl1_.text sizeWithFont:self.mTitleLbl1_.font constrainedToSize:CGSizeMake(320, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mTitleLbl1_.frame = CGRectMake((320-size.width)/2, self.mTitleLbl1_.frame.origin.y, size.width, self.mTitleLbl1_.frame.size.height);
    
    self.mPrevBtn.frame = CGRectMake(self.mTitleLbl1_.frame.origin.x - self.mPrevBtn.frame.size.width , self.mPrevBtn.frame.origin.y, self.mPrevBtn.frame.size.width, self.mPrevBtn.frame.size.height);
    self.mPrevBtn1.frame = CGRectMake(self.mPrevBtn.frame.origin.x +10, self.mPrevBtn1.frame.origin.y, self.mPrevBtn1.frame.size.width, self.mPrevBtn1.frame.size.height);
    
   // [self.mPrevBtn setBackgroundColor:GREEN_COLOR];
    
    self.mNextBtn.frame = CGRectMake(self.mTitleLbl1_.frame.origin.x + self.mTitleLbl1_.frame.size.width + 10, self.mNextBtn.frame.origin.y, self.mNextBtn.frame.size.width, self.mNextBtn.frame.size.height);
    self.mNextBtn1.frame = CGRectMake(self.mNextBtn.frame.origin.x, self.mNextBtn1.frame.origin.y, self.mNextBtn1.frame.size.width, self.mNextBtn1.frame.size.height);
  //  [self.mNextBtn setBackgroundColor:GREEN_COLOR];
}
- (void)LoadViewsToScrollView:(NSString*)mUserType
{
    self.mScrollview.hidden = FALSE;
    //to remove gesture if has
    if (self.mScrollGesture != nil) {
        [self.mScrollview removeGestureRecognizer:self.mScrollGesture];
        self.mScrollGesture = nil;
    }
    //to remove banner view
    if (self.mBannerContentView!=nil) {
        [self.mBannerContentView removeFromSuperview];
        [self setMBannerContentView:nil];
    }
    for (UIView *lview in self.mScrollview.subviews) {
        [lview removeFromSuperview];
    }
    NSLog(@"mTrackerValuesDict %@ %d",mTrackerValuesDict, [mUserType intValue]);
    
    [self displayTitleView];
    self.mScrollview.contentOffset = CGPointMake(0, 0);
    if ([[GenricUI instance]isiPhone5]) {
        UIView *lView = [self returnTheTrackersView];
        [self.mScrollview addSubview:lView];
    } else {
        //This issue with iPhone 4S only when banner present
        UIView *lView = [self returnTheTrackersView];
        UIScrollView *temp = [[UIScrollView alloc] initWithFrame:CGRectMake(lView.frame.origin.x, lView.frame.origin.y, lView.frame.size.width, lView.frame.size.height)];
        [temp addSubview:lView];
        [temp setContentSize:CGSizeMake(lView.frame.size.width, lView.frame.size.height)];
        temp.tag = 108;
        temp.contentSize = CGSizeMake(320, temp.frame.size.height+20);
        [temp setBackgroundColor:CLEAR_COLOR];
        [self.mScrollview addSubview:temp];
    }
    //[self.mScrollview setBackgroundColor:RED_COLOR];
    self.mScrollview.contentSize = CGSizeMake(320, self.mScrollview.frame.size.height);
    
   // mUserType = @"2";
    if ([mUserType intValue]== 1) {
        
        //for type-1 Prospector, Add pagination
        self.mPageControl.numberOfPages = 2; // Which indicates no of portions in landing page. ie. Tracker list and addBannerView
        self.mPageControl.hidden = FALSE;
        self.mPageControl.currentPage = 0;
        self.mScrollview.scrollEnabled = NO;
        self.mScrollview.pagingEnabled = FALSE;
        
        //for swipe gesture
        UISwipeGestureRecognizer *sgrLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showBannerView)];
        self.mScrollGesture = sgrLeft;
        [sgrLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        //Change-3
        [self.mScrollview addGestureRecognizer:sgrLeft];
 
    }else{
       //for type-2 Customer, remove pagination
        self.mPageControl.numberOfPages = 0;
        self.mPageControl.currentPage = 0;
        self.mPageControl.hidden = TRUE;//FALSE;
        self.mScrollview.clipsToBounds = YES;
        self.mScrollview.scrollEnabled = YES;
        self.mScrollview.pagingEnabled = YES;
    }
}
- (void)showBannerView{
    self.mAddWaterView.hidden = TRUE;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    [self.mScrollview.layer addAnimation:transition forKey:nil];
    [self.mScrollview.layer addAnimation:transition forKey:nil];
    self.mScrollview.hidden = TRUE;
    [self.mBannerView.layer addAnimation:transition forKey:nil];
    [self.mBannerView.layer addAnimation:transition forKey:nil];
    self.mPageControl.currentPage = 1;

    self.mBannerView.hidden = TRUE;
    UIView *lbannerView = [self returnTheBannerView];
    lbannerView.backgroundColor = WHITE_COLOR;
    [self setMBannerContentView:lbannerView];
    [self.view addSubview:lbannerView];
    [self.view bringSubviewToFront:self.mBannerContentView];
    [self.mBannerContentView.layer addAnimation:transition forKey:nil];
    [self.mBannerContentView.layer addAnimation:transition forKey:nil];
    self.navigationItem.rightBarButtonItem=nil;
    
}
- (UIView*)returnTheBannerView{
    UIView *lBannerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 416-36)];
    lBannerView.userInteractionEnabled = TRUE;
    if ([[GenricUI instance] isiPhone5]) {
        lBannerView.frame = CGRectMake(0, 0, 320, 504-36);
    }
    UIScrollView *lScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, lBannerView.frame.size.height)];
    CGFloat xPos = 20;
    UILabel *lTitle = [[UILabel alloc]initWithFrame:CGRectMake(xPos, 10, 280, 40)];
    lTitle.textColor = DTG_MAROON_COLOR;
    lTitle.font = OpenSans_Light(30);
    lTitle.text = @"Diet-to-Go is easy!";
    lTitle.backgroundColor = CLEAR_COLOR;
    [lScrollview addSubview:lTitle];
    
    UILabel *lTitleSub = [[UILabel alloc]initWithFrame:CGRectMake(xPos, 50, 280, 80)];
    lTitleSub.textColor = RGB_A(58, 58, 58, 1); //3a3a3a
    lTitleSub.font = OpenSans_Light(25);
    lTitleSub.numberOfLines = 2;
    lTitleSub.text = @"It's like having your own personal chef.";
    lTitleSub.backgroundColor = CLEAR_COLOR;
    [lScrollview addSubview:lTitleSub];
    
    UILabel *lMealMenu = [[UILabel alloc]initWithFrame:CGRectMake(xPos, 140, 280, 30)];
    lMealMenu.textColor = RGB_A(100, 150, 41, 1); //649629
    lMealMenu.font = OpenSans_Regular(18);
    lMealMenu.text = @"Choose from 3 Delicious Menus";
    lMealMenu.backgroundColor = CLEAR_COLOR;
    [lScrollview addSubview:lMealMenu];
    CGFloat loopYpos = 180;
    NSMutableArray *mealArr = [[NSMutableArray alloc] initWithObjects:@"Traditional",@"Low-Carb",@"Vegetarian", nil];
    for (int loop=0; loop < 3; loop++) {
        UIView *lView = [[UIView alloc] initWithFrame:CGRectMake(xPos, loopYpos, 280, 50)];
        lView.backgroundColor = RGB_A(232, 232,232, 1);//e8e8e8
        [lScrollview addSubview:lView];
        
        UIImage *lImage = [UIImage imageNamed:[NSString stringWithFormat:@"bannerMeal%d.png",loop+1]];
        UIImageView *lImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 95, 50)];
        lImgeView.image = lImage;
        [lView addSubview:lImgeView];
        
        UILabel *lMealName = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 100, 50)];
        lMealName.textColor = DTG_MAROON_COLOR;
        lMealName.font = OpenSans_Light(20);
        lMealName.text = [mealArr objectAtIndex:loop];
        lMealName.backgroundColor = CLEAR_COLOR;
        [lView addSubview:lMealName];
        
        loopYpos = loopYpos + 55;
    }
    
    UIImage *lImage = [UIImage imageNamed:@"getstartednowbtn.png"];
    UIImageView *lImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos+10, loopYpos+30, 270, 50)];
    lImgeView.image = lImage;
    [lScrollview addSubview:lImgeView];
    UILabel *getStartedLbl = [[UILabel alloc]initWithFrame:CGRectMake(xPos+50, loopYpos+30, 200, 45)];
    getStartedLbl.textColor = RGB_A(255, 255, 255, 1);
    getStartedLbl.font = OpenSans_Light(25);
    getStartedLbl.text = @"Get Started Now";
    getStartedLbl.backgroundColor = CLEAR_COLOR;
    [lScrollview addSubview:getStartedLbl];
    
    UIButton *getStartedBtn = [[UIButton alloc] initWithFrame:lImgeView.frame];
    [getStartedBtn setBackgroundColor:CLEAR_COLOR];
    [getStartedBtn addTarget:self action:@selector(getStartedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [lScrollview addSubview:getStartedBtn];

    lScrollview.contentSize = CGSizeMake(320, loopYpos+80);
    lScrollview.userInteractionEnabled = TRUE;
    [lBannerView addSubview:lScrollview];
    //for swipe gesture
    UISwipeGestureRecognizer *sgrLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeBannerView)];
    [sgrLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    [lBannerView addGestureRecognizer:sgrLeft];

    return lBannerView;
}
-(void)getStartedBtnAction:(UIButton*)btn {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GETSTARTEDURL]];
}
- (void)removeBannerView{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    [self.mBannerContentView.layer addAnimation:transition forKey:nil];
    [self.mBannerContentView.layer addAnimation:transition forKey:nil];

    [self.mScrollview.layer addAnimation:transition forKey:nil];
    [self.mScrollview.layer addAnimation:transition forKey:nil];
    self.mPageControl.currentPage = 0;
    //to remove banner view
    if (self.mBannerContentView!=nil) {
        self.mBannerContentView.hidden = TRUE;
        [self performSelector:@selector(setbannerViewNil) withObject:nil afterDelay:0.3];
    }
    self.mScrollview.hidden = FALSE;

    /*
     //we dont have buttom banner in DTG.
    //for the banner view showing and after 10 visit for 1, 2 and 3 user types and hide for incoaching user type
    if ([mAppDelegate.mResponseMethods_.userType intValue] == 2) {
        self.mBannerView.hidden = TRUE;
        
    }else{
        NSUserDefaults *mUserDeafults = [NSUserDefaults standardUserDefaults];
        if ([mUserDeafults objectForKey:@"BannerVisitNum"] == nil) {
            self.mBannerView.hidden = FALSE;
        }else{
            self.mBannerView.hidden = TRUE;
        }
    }
     */
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"edit.png"] title:nil target:self action:@selector(editAction:) forController:self rightOrLeft:1];


}
- (void)setbannerViewNil{
   [self.mBannerContentView removeFromSuperview];
    [self setMBannerContentView:nil];

}
- (void)readMoreAction:(UIButton*)lBtn{
    
    for(UIView *lView in self.view.subviews) {
        if([lView isKindOfClass:[UIView class]] && lView.tag == 101) {
            [lView removeFromSuperview];
        }
    }
    
    UIView* trns = [[UIView alloc]initWithFrame:mAppDelegate.window.frame];
    trns.tag = 101;
    [trns setBackgroundColor:[UIColor blackColor]];
    trns.alpha = 0.7f;
    [mAppDelegate.window addSubview:trns];
    
    for (UIView *lView  in mAppDelegate.window.subviews) {
        if ([lView isKindOfClass:[MealPlannerHelpView class]]) {
            [lView removeFromSuperview];
        }
    }
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"MealPlannerHelpView" owner:self options:nil];
    
    MealPlannerHelpView *lMealPlannerHelpView = [array objectAtIndex:0];
    lMealPlannerHelpView.frame = CGRectMake(0, 0, 320, mAppDelegate.window.frame.size.height);
    
    lMealPlannerHelpView.mHelptitlelbl.font = Bariol_Regular(22);
    lMealPlannerHelpView.mHelptitlelbl.textColor = RGB_A(136, 136, 136, 1);
    lMealPlannerHelpView.mTextView.font = Bariol_Regular(16);
    lMealPlannerHelpView.mTextView.textColor = BLACK_COLOR;
    lMealPlannerHelpView.mTextView.editable = FALSE;
    if (lBtn.tag == 0) {
        lMealPlannerHelpView.mHelptitlelbl.text = @"Activate your ehe benefit";
        lMealPlannerHelpView.mTextView.text = @"The first step to activating your EHE benefit is scheduling your physical exam. EHE’s comprehensive examination provides a unique experience unlike any other.\n\nYour individual program begins with a health assessment. You will meet with a board certified physician specialist who will perform a thorough assessment of your current health and discuss practical preventive health measures to help ensure your future good health. Shortly after the exam, you will receive a detailed written report of exam findings and recommendations that is available to you in electronic form, if you choose, as well as on paper.\n\nYour EHE benefit gives you exclusive access to year-round professional guidance from an expert team of nurses, professional health coaches, and referral coordinators that manage and coordinate your ongoing preventive care and wellness needs. The nurses help you manage any significant health findings from your exam, provide health education, and answer health questions. The Personal Health Coaches help you address health risks and develop wellness plans to achieve the health goals that are important to you. Referral Coordinators help you find specialists and schedule specialty appointments for services not provided by EHE that are recommended by your physician following your exam.\n\nActivate your exclusive benefit today.";
    }else if (lBtn.tag == 1){
        lMealPlannerHelpView.mHelptitlelbl.text = @"Beyond the exam";
        lMealPlannerHelpView.mTextView.text = @"EHE International is well–known for a patient–centered approach to preventive care management. In addition to the physician’s assessment, each personalized program includes clinical team management of health findings, appointment coordination with other physician/healthcare specialists, personal coaching, and a patient–accessible electronic medical record.\n\nOur preventive care experts use tested methodologies to ensure that your program includes much more than the exam and is personal to you. Your program includes:\n\n-  Comprehensive History\n-  Physical Assessment\n-  Lab Testing and Results \n-  Physician to patient written report of exam findings, health risks, and recommendations \n-  Physician referrals for appointments with specialists, primary care physicians, and transfer of records \n-  Clinical intervention to manage significant findings and offer counseling and education\n-  Personal health coaching guided by physician recommendations and lab values\n-  Periodic preventive health newsletters\n-  Web–based Personal Health Record Management\n\nWe’re here to support you during your physical exam and beyond, in one of the most important steps you will ever take.\n\nEHE. Your Partner for a Healthy Life.";

    }else{
        lMealPlannerHelpView.mHelptitlelbl.text = @"EHE personal health coaching";
        lMealPlannerHelpView.mTextView.text = @"After completing your exam, begin the path to a healthier life by partnering with a Personal Health Coach. The Personal Health Coaching Program has helped thousands of EHE patients change their health behaviors and reduce their risks of disease. The program provides a valued, friendly professional counselor to help you change lifestyle behaviors that may be keeping you from achieving optimal health.\n\nTogether, you and your Personal Health Coach will design a plan based on the results of your EHE physical examination and on your personal objectives in the areas of physical activity, nutrition, stress management, and smoking cessation. Your Personal Health Coach stays with you throughout the year or until you have reached your goals and are ready to go it alone. Even then, should you wish to re-engage with your Personal Health Coach, you may do so at any time.\n\nWant to learn more about this extraordinary component of your EHE benefit? Give us a call at 866.657.5697.";

    }
    //Actions
    [lMealPlannerHelpView.mDoneBtn addTarget:self action:@selector(helpDoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [mAppDelegate.window addSubview:lMealPlannerHelpView];
    
    
}
- (void)helpDoneAction:(id)sender {
    for(UIView *lView in mAppDelegate.window.subviews) {
        if([lView isKindOfClass:[UIView class]] && lView.tag == 101) {
            [lView removeFromSuperview];
        }
    }
    for (UIView *lView  in mAppDelegate.window.subviews) {
        if ([lView isKindOfClass:[MealPlannerHelpView class]]) {
            [lView removeFromSuperview];
        }
    }
}

- (UIScrollView*)returnTheGoalsView{
    UIScrollView *lScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.mScrollview.frame.size.height)];

    CGFloat yPos = 0;
    for (int iGoals = 0 ; iGoals < self.mGoalsArray.count; iGoals++) {
        //main view
        UIView *lView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, 320, 85)];
        lView.backgroundColor = CLEAR_COLOR;
        lView.tag = iGoals;
        [lScrollview addSubview:lView];
        
        //goal image
        UIImage *lGoalImage = [UIImage imageNamed:@"goal@2x.png"];
        DLog(@"%f width = %f", lGoalImage.size.height, lGoalImage.size.width);
       //UIImage *lGoalImage = [UIImage imageNamed:[NSString stringWithFormat:@"GoalIconLog_%d.png", [[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"GoalStep"] intValue]]];

        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (85/2) - (lGoalImage.size.height/4), lGoalImage.size.width/2, lGoalImage.size.height/2)];
        lImgView.image = lGoalImage;
        [lView addSubview:lImgView];
        
        //line imageview
        UIImageView *lImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(lImgView.frame.origin.x+lImgView.frame.size.width+15, (85-61)/2, 1, 61)];
        lImgView2.backgroundColor = CLEAR_COLOR;
        lImgView2.image = [UIImage imageNamed:@"verticalline_small.png"];
        [lView addSubview:lImgView2];
        
        //goal label
        UILabel *lGoalLbl = [[UILabel alloc]initWithFrame:CGRectMake(lImgView2.frame.origin.x+lImgView2.frame.size.width+5, lImgView2.frame.origin.y, 305 - (lImgView2.frame.origin.x+lImgView2.frame.size.width+5), 50)];
        lGoalLbl.font = Bariol_Regular(17);
        lGoalLbl.textColor = BLACK_COLOR;
        lGoalLbl.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lGoalLbl.numberOfLines = 0;
        lGoalLbl.textAlignment = UITextAlignmentLeft;
        lGoalLbl.backgroundColor = CLEAR_COLOR;
        //lGoalLbl.text = [[[[self.mGoalsArray objectAtIndex:1] objectForKey:@"Steps"] objectAtIndex:0] objectForKey:@"Label"];
        
        lGoalLbl.text = [[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Label"];
        CGSize size =  [lGoalLbl.text sizeWithFont:lGoalLbl.font constrainedToSize:CGSizeMake(lGoalLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lGoalLbl.frame = CGRectMake(lGoalLbl.frame.origin.x, lGoalLbl.frame.origin.y, lGoalLbl.frame.size.width, size.height);

        /*if (size.height > 20) {
            
        }else{
            lGoalLbl.frame = CGRectMake(lGoalLbl.frame.origin.x, lGoalLbl.frame.origin.y+10, lGoalLbl.frame.size.width, size.height);
            
        }*/
        [lView addSubview:lGoalLbl];
        
        //Progress img view
        UIColor *lBarColor;
        NSString *lText= @"";
        float percentage = 0;
        BOOL isFreeForm = FALSE, isFreeGoalDone = FALSE;
        
        //negative goals
        if ([[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Category"] intValue] < 0) {
            float goalValue = [[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Achievement"] intValue]* [[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Goal"] floatValue];
            goalValue = goalValue/100.0f;

            //under limit
            if (goalValue < [[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Goal"] intValue]) {
                lBarColor = RGB_A(175, 225, 95, 1);
                lText = @"Under limit";
                percentage = 100;
            }
            //at limit
            else if (goalValue == [[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Goal"] intValue]) {
                lBarColor = RGB_A(255, 225, 105, 1);
                lText = @"At limit";
                percentage = 100;

            }//Over limit
            else if (goalValue > [[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Goal"] intValue]) {
                lBarColor = RGB_A(225, 138, 138, 1);
                lText = @"Over limit";
                percentage = 100;

            }
        }
        //positive goals
        else if ([[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Category"] intValue] >0){
            lBarColor = RGB_A(255, 225, 105, 1);
            lText = [NSString stringWithFormat:@"%d",[[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Achievement"] intValue]];
            lText = [lText stringByAppendingString:@"%"];
            percentage = [[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Achievement"] intValue];
            if (percentage >= 100) {
                lBarColor = RGB_A(175, 225, 95, 1);
                percentage = 100;
            }
            
        }
        //free form goals
        else if ([[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Category"] intValue] == 0){
            isFreeForm = TRUE;
            if ([[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Achievement"] intValue]>=[[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Goal"] intValue]) {
                isFreeGoalDone = TRUE;

            }else if ([[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Achievement"] intValue]<[[[self.mGoalsArray objectAtIndex:iGoals] objectForKey:@"Goal"] intValue]){
                isFreeGoalDone = FALSE;

            }
            if (isFreeGoalDone) {
                //need to change later
                lBarColor = RGB_A(175, 225, 95, 1);

            }else{
                //need to change later
                lBarColor = RGB_A(225, 138, 138, 1);
            }
           
            lText = @"";
            percentage = 100;
        }
        DashboradGoalView *lProgressImgView = [[DashboradGoalView alloc]initWithFrame:CGRectMake(lGoalLbl.frame.origin.x, lGoalLbl.frame.origin.y+lGoalLbl.frame.size.height+5, 216, 27)
                                                                           percentage:percentage
                                                                                color:lBarColor
                                                                                 Text:lText
                                                                           isFreeGoal:isFreeForm
                                                                             GoalDone:isFreeGoalDone];
        [lView addSubview:lProgressImgView];

        //add goal button
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(320-30, lProgressImgView.frame.origin.y+2.5, 15, 15)];
        [lBtn setImage:[UIImage imageNamed:@"plusicon.png"] forState:UIControlStateNormal];
        lBtn.tag = iGoals;
        lBtn.userInteractionEnabled = TRUE;
        //[lBtn addTarget:self action:@selector(addGoal:) forControlEvents:UIControlEventTouchUpInside];
        [lView addSubview:lBtn];
        
        //for increasing the touch sensitivity adding one more transparent btn
        UIButton *lBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(lBtn.frame.origin.x-7.5, lBtn.frame.origin.y-7.5, 30, 30)];
        lBtn1.tag = iGoals;
        lBtn1.backgroundColor = CLEAR_COLOR;
        [lBtn1 addTarget:self action:@selector(addGoal:) forControlEvents:UIControlEventTouchUpInside];
        [lView addSubview:lBtn1];

        if (lProgressImgView.frame.size.height+lProgressImgView.frame.origin.y+10 >85) {
            lView.frame = CGRectMake(lView.frame.origin.x, lView.frame.origin.y, lView.frame.size.width, lProgressImgView.frame.size.height+lProgressImgView.frame.origin.y+10);
            
        }

        yPos+=lView.frame.size.height;
        
    }
    lScrollview.contentSize = CGSizeMake(320, yPos+20);
    return lScrollview;
}
- (void)addGoal:(UIButton*)lBtn{
    //to get the main scrol class
    UIScrollView *lParentScrol;
    
    for (UIView *lView in self.mScrollview.subviews) {
        if ([lView isKindOfClass:[UIScrollView class]]) {
            lParentScrol = (UIScrollView*)lView;
        }
    }
    // to remove if already added
     for (UIView *lSubView in lParentScrol.subviews) {
         if (lSubView.tag == 101) {
             [lSubView removeFromSuperview];
         }
     }
    
    CGFloat yPos = 0, addViewHeight = 0;
    UIView *lSuperView = (UIView*)[lBtn superview];
    yPos = lSuperView.frame.size.height+lSuperView.frame.origin.y;
    
    if (lBtn.tag == self.mGoalsArray.count -1) {
        addViewHeight = 85;
    }else{
        for (UIView *lView in lParentScrol.subviews) {
            if ([lView isKindOfClass:[UIView class]] && lView.tag == lBtn.tag+1) {
                addViewHeight = lView.frame.size.height;
            }
        }
    }

    //to set the content size if its less than the required
    //DLog(@"%f", lParentScrol.contentSize.height);
    if (lParentScrol.contentSize.height < yPos+addViewHeight) {
        lParentScrol.contentSize = CGSizeMake(320, yPos+20+addViewHeight);
    }
    //to add the goal view
    UIView *lAddView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, 320, addViewHeight)];
    lAddView.backgroundColor = WHITE_COLOR;
    lAddView.tag = 101;
    // top line
    UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    lImgView.image = [UIImage imageNamed:@"horizontalline1.png"];
    [lAddView addSubview:lImgView];
    //bottom line
    UIImageView *lImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, lAddView.frame.size.height-1, 320, 1)];
    lImgView2.image = [UIImage imageNamed:@"horizontalline1.png"];
    [lAddView addSubview:lImgView2];
    //back button
    UIButton *lCloseBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, (lAddView.frame.size.height/2)- (18/2), 8, 18)];
    [lCloseBtn setImage:[UIImage imageNamed:@"prev(orange).png"] forState:UIControlStateNormal];
    //[lCloseBtn addTarget:self action:@selector(closeAddGoal:) forControlEvents:UIControlEventTouchUpInside];
    [lAddView addSubview:lCloseBtn];
    
     //for increasing the touch sensitivity adding one more transparent btn on close btn
    UIButton *lCloseBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(lCloseBtn.frame.origin.x-11, lCloseBtn.frame.origin.y-6, 30, 30)];
    lCloseBtn1.backgroundColor = CLEAR_COLOR;
    [lCloseBtn1 addTarget:self action:@selector(closeAddGoal:) forControlEvents:UIControlEventTouchUpInside];
    [lAddView addSubview:lCloseBtn1];

    
    //for scrollview
    UIScrollView *lScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(50, 0, 320-50, lAddView.frame.size.height)];
    lScrollView.backgroundColor = CLEAR_COLOR;
    //to add buttons to the scrollview
    CGFloat xPos = 0;
    for (int i =0; i < 6; i++) {
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(xPos, (lAddView.frame.size.height-30)/2, 30, 30)];
        [lBtn setImage:[UIImage imageNamed:@"deleteactiv.png"] forState:UIControlStateSelected];
        [lBtn setImage:[UIImage imageNamed:@"deleteinactive.png"] forState:UIControlStateNormal];
        lBtn.backgroundColor = CLEAR_COLOR;
        lBtn.selected = TRUE;
        [lBtn addTarget:self action:@selector(addservings:) forControlEvents:UIControlEventTouchUpInside];
        //[lScrollView addSubview:lBtn];
        xPos+=30+15;

    }
    //to add done button
    UIButton *lDoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0+(170/2), (lAddView.frame.size.height/2)-15, 100, 30)];
    [lDoneBtn setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    [lDoneBtn setImage:[UIImage imageNamed:@"doneactive.png"] forState:UIControlStateHighlighted];
    lDoneBtn.tag = lBtn.tag;
    [lDoneBtn addTarget:self action:@selector(addGoalDoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [lScrollView addSubview:lDoneBtn];
    
    lScrollView.pagingEnabled = TRUE;
    lScrollView.showsHorizontalScrollIndicator = FALSE;
    [lScrollView setContentSize:CGSizeMake(270, lScrollView.frame.size.height)];//as one page width = 270
    [lAddView addSubview:lScrollView];

    [lParentScrol addSubview:lAddView];
    [lParentScrol bringSubviewToFront:lAddView];
    //for animation
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    [lAddView.layer addAnimation:transition forKey:nil];
    [lAddView.layer addAnimation:transition forKey:nil];
    
    [lParentScrol scrollRectToVisible:lAddView.frame animated:TRUE];
    
}
- (void)closeAddGoal:(UIButton*)lBtn{
    UIView *lView = (UIView*)[lBtn superview];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    [lView.layer addAnimation:transition forKey:nil];
    [lView.layer addAnimation:transition forKey:nil];
    lView.hidden = TRUE;
}
- (void)addservings:(UIButton*)lBtn{
    
}
- (void)addGoalDoneAction:(UIButton*)lBtn{
    NSDate *lDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [GenricUI setLocaleZoneForDateFormatter:dateFormat];
    //[dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    int mValue = 1;
    
    //post request to add goal
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate createLoadView];
        mAppDelegate.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate.mRequestMethods_ postRequestToAddGoal:[dateFormat stringFromDate:lDate]
                                                     StepID:[[self.mGoalsArray objectAtIndex:lBtn.tag] objectForKey:@"GoalStep"]
                                                 UserStepID:[[self.mGoalsArray objectAtIndex:lBtn.tag] objectForKey:@"UserStepID"]
                                                      Value:[NSString stringWithFormat:@"%d",mValue]
                                                      Notes:@""
                                                  AuthToken:mAppDelegate.mResponseMethods_.authToken
                                               SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
}
- (void)onSuccessAddGoal{
    //to get the main scrol class
    UIScrollView *lParentScrol;
    
    for (UIView *lView in self.mScrollview.subviews) {
        if ([lView isKindOfClass:[UIScrollView class]]) {
            lParentScrol = (UIScrollView*)lView;
        }
    }
    // to remove if already added
    for (UIView *lSubView in lParentScrol.subviews) {
        if (lSubView.tag == 101) {
            [lSubView removeFromSuperview];
        }
    }
    [self postRequestToGetGoals];
}
- (UIView*)returnTheTrackersView
{
    UIView *lTrackerView =[[UIView alloc]init];
    if ([[GenricUI instance]isiPhone5]) {
        lTrackerView.frame = CGRectMake(0, 0, 320, self.mScrollview.frame.size.height);
    }else {
        lTrackerView.frame = CGRectMake(0, 0, 320, 340);
    }
   
    //to get the trackers shown count
    if (self.mTrackerOrder == nil) {
       self.mTrackerOrder = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", WeightTracker, MealTracker, ExerciseTracker, StepTracker, WaterTracker];
    }
    if (self.mTrackersShown == nil) {
        self.mTrackersShown = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", WeightTracker, MealTracker, ExerciseTracker, StepTracker, WaterTracker];
    }
    
    NSMutableArray *mArray = [[NSMutableArray alloc]  initWithArray:[self.mTrackerOrder componentsSeparatedByString:@","]];
    NSArray *mShownArray = [self.mTrackersShown componentsSeparatedByString:@","];
    //to remove the hidden trackers from the list
    for (int i = mArray.count-1; i >= 0 ; i--) {
        NSString *mTracker = [mArray objectAtIndex:i];
        BOOL flag = FALSE;
        for (int j = 0; j < mShownArray.count; j++) {
            NSString *mVisTracker = [mShownArray objectAtIndex:j];
            if ([mVisTracker isEqualToString:mTracker] && !flag) {
                flag = TRUE;
            }
        }
        if (!flag) {
            [mArray removeObjectAtIndex:i];
        }
        
    }
    int mTrackersCount = [mArray count];
    switch (mTrackersCount) {
        case 1:
        {
            UIView *lview = [[UIView alloc]initWithFrame:CGRectMake(0, 80, 320, lTrackerView.frame.size.height/2)];
            lview = [self addSubControlsToTrackerView:lview
                                          TrackerType:[mArray objectAtIndex:0]];
            [lTrackerView addSubview:lview];
        }
            break;
        case 2:
        {
            //first view
            UIView *lFirstview = [[UIView alloc]initWithFrame:CGRectMake(0, 80, 160, lTrackerView.frame.size.height/2)];
            lFirstview = [self addSubControlsToTrackerView:lFirstview
                                               TrackerType:[mArray objectAtIndex:0]];
            [lTrackerView addSubview:lFirstview];
            //for vertical line
            UIImage *lVLine = [UIImage imageNamed:@"verticalline2@2x.png"];
            UIImageView *lLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake((lTrackerView.frame.size.width/2)-(lVLine.size.width/2), (lTrackerView.frame.size.height/2)-(lVLine.size.height/2)+60, lVLine.size.width/2, lVLine.size.height/2)];
            lLineImgView.image = lVLine;
            [lLineImgView setImage:lVLine];
            [lTrackerView addSubview:lLineImgView];

            //second view
            UIView *lSecondview = [[UIView alloc]initWithFrame:CGRectMake(160, 80, 160, lTrackerView.frame.size.height/2)];
            lSecondview = [self addSubControlsToTrackerView:lSecondview
                                                TrackerType:[mArray objectAtIndex:1]];
            [lTrackerView addSubview:lSecondview];
            
        }
            break;
        case 3:
        {
            //first view
            UIView *lFirstview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, lTrackerView.frame.size.height/2)];
            lFirstview = [self addSubControlsToTrackerView:lFirstview
                                               TrackerType:[mArray objectAtIndex:0]];
            [lTrackerView addSubview:lFirstview];
            //for vertical line
            UIImage *lVLine = [UIImage imageNamed:@"verticalline2@2x.png"];
            UIImageView *lLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake((lTrackerView.frame.size.width/2)-(lVLine.size.width/2), ((lTrackerView.frame.size.height/2)-(lVLine.size.height/2))/2, lVLine.size.width/2, lVLine.size.height/2)];
            lLineImgView.image = lVLine;
            [lTrackerView addSubview:lLineImgView];
            //second view
            UIView *lSecondview = [[UIView alloc]initWithFrame:CGRectMake(160, 0, 160, lTrackerView.frame.size.height/2)];
            lSecondview = [self addSubControlsToTrackerView:lSecondview
                                                TrackerType:[mArray objectAtIndex:1]];
            [lTrackerView addSubview:lSecondview];
            
            //for vertical line
            UIImage *lHLine = [UIImage imageNamed:@"horizontalline@2x.png"];
            UIImageView *lHorizontalLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (lTrackerView.frame.size.height/2)-(1/2), 290, 1)];
            lHorizontalLineImgView.image = lHLine;
            [lTrackerView addSubview:lHorizontalLineImgView];
            
            //third view
            UIView *lThirdview = [[UIView alloc]initWithFrame:CGRectMake(0, lTrackerView.frame.size.height/2, 320, lTrackerView.frame.size.height/2)];
            lThirdview = [self addSubControlsToTrackerView:lThirdview
                                               TrackerType:[mArray objectAtIndex:2]];
            [lTrackerView addSubview:lThirdview];
            
        }
            break;
        case 4:
        {
            //first view
            UIView *lFirstview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, lTrackerView.frame.size.height/2)];
            lFirstview = [self addSubControlsToTrackerView:lFirstview
                                               TrackerType:[mArray objectAtIndex:0]];
            lFirstview.userInteractionEnabled = TRUE;
            [lTrackerView addSubview:lFirstview];
            //for vertical line
            UIImage *lVLine = [UIImage imageNamed:@"verticalline2@2x.png"];
            UIImageView *lLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake((lTrackerView.frame.size.width/2)-(lVLine.size.width/2), ((lTrackerView.frame.size.height/2)-(lVLine.size.height/2))/2, lVLine.size.width/2, lVLine.size.height/2)];
            lLineImgView.image = lVLine;
            [lTrackerView addSubview:lLineImgView];
            
            //second view
            UIView *lSecondview = [[UIView alloc]initWithFrame:CGRectMake(160, 0, 160, lTrackerView.frame.size.height/2)];
            lSecondview = [self addSubControlsToTrackerView:lSecondview
                                                TrackerType:[mArray objectAtIndex:1]];
            [lTrackerView addSubview:lSecondview];
            
            //for vertical line
            UIImage *lHLine = [UIImage imageNamed:@"horizontalline@2x.png"];
            UIImageView *lHorizontalLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (lTrackerView.frame.size.height/2)-(1/2), 290, 1)];
            lHorizontalLineImgView.image = lHLine;
            [lTrackerView addSubview:lHorizontalLineImgView];
            
            //third view
            UIView *lThirdview = [[UIView alloc]initWithFrame:CGRectMake(0, lTrackerView.frame.size.height/2, 320/2, lTrackerView.frame.size.height/2)];
            lThirdview = [self addSubControlsToTrackerView:lThirdview
                                               TrackerType:[mArray objectAtIndex:2]];
            [lTrackerView addSubview:lThirdview];
            
            UIImage *lVLine2 = [UIImage imageNamed:@"verticalline1@2x.png"];
            //for vertical line
            UIImageView *lLineImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake((lTrackerView.frame.size.width/2)-(lVLine2.size.width/2), (((lTrackerView.frame.size.height/2)-(lVLine2.size.height/2))/2) + (lTrackerView.frame.size.height/2), lVLine2.size.width/2, lVLine2.size.height/2)];
            
            //for for iphone3.5 the line is not aligned hence increasing the y frame by 2
            if (![[GenricUI instance] isiPhone5]) {
                lLineImgView2.frame = CGRectMake((lTrackerView.frame.size.width/2)-(lVLine2.size.width/2), (((lTrackerView.frame.size.height/2)-(lVLine2.size.height/2))/2) + (lTrackerView.frame.size.height/2)+5, lVLine2.size.width/2, lVLine2.size.height/2);
            }
            lLineImgView2.image = lVLine2;
            [lTrackerView addSubview:lLineImgView2];
            
            
            //fourth view
            UIView *lFourthview = [[UIView alloc]initWithFrame:CGRectMake(0+lThirdview.frame.size.width, lTrackerView.frame.size.height/2, 320/2, lTrackerView.frame.size.height/2)];
            lFourthview = [self addSubControlsToTrackerView:lFourthview
                                                TrackerType:[mArray objectAtIndex:3]];
            [lTrackerView addSubview:lFourthview];
            
        }
            break;
        case 5:
        {
            //first view
            UIView *lFirstview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, lTrackerView.frame.size.height/2)];
            lFirstview = [self addSubControlsToTrackerView:lFirstview
                                               TrackerType:[mArray objectAtIndex:0]];
            [lTrackerView addSubview:lFirstview];
            
            //for vertical line
            UIImage *lVLine = [UIImage imageNamed:@"verticalline2@2x.png"];
            UIImageView *lLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake((lTrackerView.frame.size.width/2)-(lVLine.size.width/2), ((lTrackerView.frame.size.height/2)-(lVLine.size.height/2))/2, lVLine.size.width/2, lVLine.size.height/2)];
            lLineImgView.image = lVLine;
            [lTrackerView addSubview:lLineImgView];
            
            //second view
            UIView *lSecondview = [[UIView alloc]initWithFrame:CGRectMake(160, 0, 160, lTrackerView.frame.size.height/2)];
            lSecondview = [self addSubControlsToTrackerView:lSecondview
                                                TrackerType:[mArray objectAtIndex:1]];
            [lTrackerView addSubview:lSecondview];
            
            //for horizontal line
            UIImage *lHLine = [UIImage imageNamed:@"horizontalline@2x.png"];
            UIImageView *lHorizontalLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (lTrackerView.frame.size.height/2)-(1/2), 290, 1)];
            lHorizontalLineImgView.image = lHLine;
            [lTrackerView addSubview:lHorizontalLineImgView];
            
            
            //third view
            UIView *lThirdview = [[UIView alloc]initWithFrame:CGRectMake(0, lTrackerView.frame.size.height/2, 102.4, lTrackerView.frame.size.height/2)];
            lThirdview = [self addSubControlsToTrackerView:lThirdview
                                               TrackerType:[mArray objectAtIndex:2]];
            [lTrackerView addSubview:lThirdview];
            
            UIImage *lVLine2 = [UIImage imageNamed:@"verticalline1@2x.png"];
            
            //for vertical line
            UIImageView *lLineImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(102.4 +1, (((lTrackerView.frame.size.height/2)-(lVLine2.size.height/2))/2) + (lTrackerView.frame.size.height/2)+5, lVLine2.size.width/2, lVLine2.size.height/2)];
            //for for iphone3.5 the line is not aligned hence increasing the y frame by 2
            if (![[GenricUI instance] isiPhone5]) {
                lLineImgView2.frame = CGRectMake(102.4 +1, (((lTrackerView.frame.size.height/2)-(lVLine2.size.height/2))/2) + (lTrackerView.frame.size.height/2)+5, lVLine2.size.width/2, lVLine2.size.height/2);
            }
            lLineImgView2.image = lVLine2;
            [lTrackerView addSubview:lLineImgView2];
            

            
            //fourth view
            UIView *lFourthview = [[UIView alloc]initWithFrame:CGRectMake(0+lThirdview.frame.size.width, lTrackerView.frame.size.height/2, 115.2, lTrackerView.frame.size.height/2)];
            lFourthview = [self addSubControlsToTrackerView:lFourthview
                                                TrackerType:[mArray objectAtIndex:3]];
            [lTrackerView addSubview:lFourthview];
            
            //for vertical line
            UIImageView *lLineImgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(102.4+115.2+1, (((lTrackerView.frame.size.height/2)-(lVLine2.size.height/2))/2) + (lTrackerView.frame.size.height/2), lVLine2.size.width/2, lVLine2.size.height/2)];
            //for for iphone3.5 the line is not aligned hence increasing the y frame by 2
            if (![[GenricUI instance] isiPhone5]) {
                lLineImgView3.frame = CGRectMake(102.4+115.2+1, (((lTrackerView.frame.size.height/2)-(lVLine2.size.height/2))/2) + (lTrackerView.frame.size.height/2)+5, lVLine2.size.width/2, lVLine2.size.height/2);
            }
            lLineImgView3.image = lVLine2;
            [lTrackerView addSubview:lLineImgView3];

            //fifth view
            UIView *lFifthview = [[UIView alloc]initWithFrame:CGRectMake(lFourthview.frame.origin.x+lFourthview.frame.size.width, lTrackerView.frame.size.height/2, 102.4,lTrackerView.frame.size.height/2)];
            lFifthview = [self addSubControlsToTrackerView:lFifthview
                                               TrackerType:[mArray objectAtIndex:4]];
            [lTrackerView addSubview:lFifthview];
            [lTrackerView bringSubviewToFront:lLineImgView3];
            
        }
            break;
        default:
            break;
    }
    return lTrackerView;
}
- (UIView*)addSubControlsToTrackerView:(UIView*)lTrackerMainView
                           TrackerType:(NSString*)mType
{
    //to add tracker imageview
    UIImageView *lTrackerImgView = [[UIImageView alloc]initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(38/2), 15, 38, 38)];//adjust based on image frame.
    lTrackerImgView.backgroundColor = CLEAR_COLOR;
    lTrackerImgView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *lImage,*lProgressImage;
    if ([mType isEqualToString:WeightTracker]) {
        lImage = [UIImage imageNamed:@"weighingmachine@2x.png"];
        lProgressImage = [UIImage imageNamed:@"moon@2x.png"];
        //lProgressImage = [UIImage imageNamed:@"calories@2x.png"]; //EHEandme
    }else if ([mType isEqualToString:MealTracker]) {
        lImage = [UIImage imageNamed:@"plateicon@2x.png"];
        lProgressImage = [UIImage imageNamed:@"moon@2x.png"];
        //lProgressImage = [UIImage imageNamed:@"calories@2x.png"]; //EHEandme

    }else if ([mType isEqualToString:ExerciseTracker]) {
        lImage = [UIImage imageNamed:@"manicon@2x.png"];
        lProgressImage = [UIImage imageNamed:@"clock@2x.png"];
        //lProgressImage = [UIImage imageNamed:@"exercise@2x.png"]; -EHEandme

    }else if ([mType isEqualToString:StepTracker]) {
        lImage = [UIImage imageNamed:@"stepsicon@2x.png"];
        lProgressImage = [UIImage imageNamed:@"steps@2x.png"];
    }else if ([mType isEqualToString:WaterTracker]) {
      //  lImage = [UIImage imageNamed:@"glass@2x.png"];
        lProgressImage = [UIImage imageNamed:@"glass@2x.png"];

//        lImage = [UIImage imageNamed:@"glasswithplusicon@2x.png"];
  //      lProgressImage = [UIImage imageNamed:@"glasswithplusicon@2x.png"];

    }
    lTrackerImgView.frame = CGRectMake((lTrackerMainView.frame.size.width/2)-(lImage.size.width/4), lTrackerImgView.frame.origin.y, lImage.size.width/2, lImage.size.height/2);
    lTrackerImgView.image = lImage;
    //lTrackerImgView.backgroundColor = RED_COLOR;
    [lTrackerMainView addSubview:lTrackerImgView];
    
    //for progress image view
    UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height+10, lProgressImage.size.width/2, lProgressImage.size.height/2)];
    if ([mType isEqualToString:ExerciseTracker]) {
        lImgView.frame = CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height+5, lProgressImage.size.width/2, lProgressImage.size.height/2);
    }
    lImgView.backgroundColor = CLEAR_COLOR;
    lImgView.contentMode = UIViewContentModeScaleAspectFit;
    lImgView.image = lProgressImage;
    //[lTrackerMainView addSubview:lImgView];
    
    //EHEandme
    if ([mType isEqualToString:WeightTracker]) {
        if ([[self.mTrackerValuesDict objectForKey:GoalWeight] intValue] == 0) {
            // Moon Shape View
            MoonView *moonView = [[MoonView alloc] initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height+10, lProgressImage.size.width/2, lProgressImage.size.height/2) percentage:0];
            [lTrackerMainView addSubview:moonView];

        }else{
            // Moon Shape View
            MoonView *moonView = [[MoonView alloc] initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height+10, lProgressImage.size.width/2, lProgressImage.size.height/2) percentage:[self caluclatePercentage:[[self.mTrackerValuesDict objectForKey:WeightTracker] floatValue] Goal:[[self.mTrackerValuesDict objectForKey:GoalWeight] floatValue] TrackerType:mType]];
            [lTrackerMainView addSubview:moonView];

        }
        
    }else if ([mType isEqualToString:MealTracker]) {
        if ([[self.mTrackerValuesDict objectForKey:GoalCalories] intValue] ==0) {
            // Moon Shape View
            MoonView *moonView = [[MoonView alloc] initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height+10, lProgressImage.size.width/2, lProgressImage.size.height/2) percentage:0];
            [lTrackerMainView addSubview:moonView];
        }else{
            // Moon Shape View
            MoonView *moonView = [[MoonView alloc] initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height+10, lProgressImage.size.width/2, lProgressImage.size.height/2) percentage:[self caluclatePercentage:[[self.mTrackerValuesDict objectForKey:MealTracker] floatValue] Goal:[[self.mTrackerValuesDict objectForKey:GoalCalories] floatValue] TrackerType:mType]];
            [lTrackerMainView addSubview:moonView];

        }
        
    }else if ([mType isEqualToString:ExerciseTracker]) {
        
        if ([[self.mTrackerValuesDict objectForKey:GoalExercise] intValue] == 0) {
            //Time shape View
            Timeview *timeView = [[Timeview alloc] initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height+5, lProgressImage.size.width/2, lProgressImage.size.height/2) percentage:0];
            [lTrackerMainView addSubview:timeView];
        }else{
            //Time shape View
            Timeview *timeView = [[Timeview alloc] initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height+5, lProgressImage.size.width/2, lProgressImage.size.height/2) percentage:[self caluclatePercentage:[[self.mTrackerValuesDict objectForKey:ExerciseTracker] floatValue] Goal:[[self.mTrackerValuesDict objectForKey:GoalExercise] floatValue] TrackerType:mType]];
            [lTrackerMainView addSubview:timeView];

        }
        
    }else if ([mType isEqualToString:StepTracker]) {
        //to set the percentage if goal is set by user else set as 0
        if ([[self.mTrackerValuesDict objectForKey:GoalSteps] intValue] == 0) {
            //Stepper shape View
            StepperView *stepView = [[StepperView alloc] initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height+10, lProgressImage.size.width/2, lProgressImage.size.height/2) percentage:0];
            [lTrackerMainView addSubview:stepView];
            
        }else{
            //Stepper shape View
            int percentage = 0;
              if ( [self.mTitleLbl1_.text isEqualToString:KToday]) {
                  percentage = [self returnTheStepsForToday];
              }else{
                  percentage = [[self.mTrackerValuesDict objectForKey:StepTracker] floatValue];

              }
            StepperView *stepView = [[StepperView alloc] initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height+10, lProgressImage.size.width/2, lProgressImage.size.height/2) percentage:[self caluclatePercentage:percentage Goal:[[self.mTrackerValuesDict objectForKey:GoalSteps] floatValue] TrackerType:mType]];
            [lTrackerMainView addSubview:stepView];
        }
    }else if ([mType isEqualToString:WaterTracker]) {
        //to set the percentage if goal is set by user else set as 0
        if ([[self.mTrackerValuesDict objectForKey:GoalWater] intValue] == 0) {
            //Glass shape View
            GlassView *glassView = [[GlassView alloc] initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height-10, lProgressImage.size.width/2, lProgressImage.size.height/2) percentage:[self caluclatePercentage:[[self.mTrackerValuesDict objectForKey:WaterTracker] floatValue] Goal:[[self.mTrackerValuesDict objectForKey:GoalWater] floatValue] TrackerType:mType]];
            [lTrackerMainView addSubview:glassView];
            
        }else{
            //Glass shape View
            GlassView *glassView = [[GlassView alloc] initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height-10, lProgressImage.size.width/2, lProgressImage.size.height/2) percentage:[self caluclatePercentage:[[self.mTrackerValuesDict objectForKey:WaterTracker] floatValue] Goal:[[self.mTrackerValuesDict objectForKey:GoalWater] floatValue] TrackerType:mType]];
            [lTrackerMainView addSubview:glassView];
        }

        
    }
    
    //for dynamic value label
    UILabel *lTextLabel = [[UILabel alloc]initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(100/2), lImgView.frame.origin.y+lImgView.frame.size.height, 100, 30)];
    if ([mType isEqualToString:StepTracker]) {
        lTextLabel.frame = CGRectMake((lTrackerMainView.frame.size.width/2)-(100/2), lImgView.frame.origin.y+51.5-5, 100, 30);
    }
    lTextLabel.textAlignment = UITextAlignmentCenter;
    lTextLabel.font = Bariol_Regular(30);
    lTextLabel.textColor = BLACK_COLOR;
    lTextLabel.backgroundColor = CLEAR_COLOR;
    [lTrackerMainView addSubview:lTextLabel];
    
    //for static text
    UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(50/2), lTextLabel.frame.origin.y+lTextLabel.frame.size.height, 200, 25)];
    lLabel.textAlignment = UITextAlignmentCenter;
    lLabel.textColor = BLACK_COLOR;
    lLabel.backgroundColor = CLEAR_COLOR;
    lLabel.font = Bariol_Regular(18);
    [lTrackerMainView addSubview:lLabel];
    
    //for arrow image view
    UIImageView *lImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(lLabel.frame.origin.x+lLabel.frame.size.width, (lLabel.frame.size.height/2)+lLabel.frame.origin.y - (27/4), 10, 10)];
    lImgView1.backgroundColor = CLEAR_COLOR;
    lImgView1.image = [UIImage imageNamed:@"doublearrow@2x.png"];
    [lTrackerMainView addSubview:lImgView1];
    
    //to set the text based on the type of tracker
    if ([mType isEqualToString:WeightTracker]) {
        lTextLabel.text = [NSString stringWithFormat:@"%d",[[self.mTrackerValuesDict objectForKey:WeightTracker] intValue]];
        lLabel.text = @"lbs";
        if ([[self.mTrackerValuesDict objectForKey:GoalWeight] intValue] == 0) {
            lTextLabel.hidden = TRUE;
            lLabel.text = @"Set Weight";
            lLabel.textColor = RGB_A(229, 96, 65, 1);
            
        }

    }else if ([mType isEqualToString:MealTracker]){
        //Convert nav to pos..
        lTextLabel.text = [NSString stringWithFormat:@"%d",abs([[self.mTrackerValuesDict objectForKey:MealTracker] intValue])];
        lLabel.text = @"cal.";
        if ([[self.mTrackerValuesDict objectForKey:GoalCalories] intValue] == 0) {
            lTextLabel.hidden = TRUE;
            lLabel.text = @"Set Meal";
            lLabel.textColor = RGB_A(229, 96, 65, 1);
            
        }

    }else if ([mType isEqualToString:ExerciseTracker]){
        lTextLabel.text = [NSString stringWithFormat:@"%dmin.", [[self.mTrackerValuesDict objectForKey:ExerciseTracker] intValue]];
        lLabel.text = [NSString stringWithFormat:@"%d cal.", [[self.mTrackerValuesDict objectForKey:@"ExCalories"] intValue]];
        
        if ([[self.mTrackerValuesDict objectForKey:GoalExercise] intValue] == 0) {
            lTextLabel.hidden = TRUE;
            lLabel.text = @"Set Exercise";
            lLabel.textColor = RGB_A(229, 96, 65, 1);
            
        }
        
    }else if ([mType isEqualToString:StepTracker]){
        if ( [self.mTitleLbl1_.text isEqualToString:KToday]) {
            lTextLabel.text = [NSString stringWithFormat:@"%d",[self returnTheStepsForToday]];

        }else{
            lTextLabel.text = [NSString stringWithFormat:@"%d",[[self.mTrackerValuesDict objectForKey:StepTracker] intValue]];
        }
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[lTextLabel.text intValue]]];
        lTextLabel.text = formatted;

        lLabel.text = @"steps";
        
        if ([[self.mTrackerValuesDict objectForKey:GoalSteps] intValue] == 0) {
            lTextLabel.hidden = TRUE;
            lLabel.text = @"Set Step Goal";
            lLabel.textColor = RGB_A(229, 96, 65, 1);

        }
        
    }else if ([mType isEqualToString:WaterTracker]){
        lTextLabel.text = [NSString stringWithFormat:@"%d",[[self.mTrackerValuesDict objectForKey:WaterTracker] intValue]];
        if ([[self.mTrackerValuesDict objectForKey:WaterTracker] intValue] == 1 || [[self.mTrackerValuesDict objectForKey:WaterTracker] intValue] == 0) {
            lLabel.text = @"glass";

        }else{
            lLabel.text = @"glasses";
 
        }
        lImgView.hidden = TRUE;
        lTrackerImgView.frame = CGRectMake((lTrackerMainView.frame.size.width/2)-(lImage.size.width/4)+10, lTrackerImgView.frame.origin.y, lImage.size.width/2, lImage.size.height/2);
        lTextLabel.frame = CGRectMake((lTrackerMainView.frame.size.width/2)-(100/2), 114-5, 100, 30);
        lLabel.frame = CGRectMake((lTrackerMainView.frame.size.width/2)-(50/2), lTextLabel.frame.origin.y+lTextLabel.frame.size.height, 100, 30);
        
        //to add the add weight log button
        UIButton *mButton = [[UIButton alloc]initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(lProgressImage.size.width/4), lTrackerImgView.frame.origin.y+lTrackerImgView.frame.size.height-10, lProgressImage.size.width/2, lProgressImage.size.height/2)];
        [mButton setBackgroundColor:CLEAR_COLOR];
        [mButton addTarget:self action:@selector(addWaterAction) forControlEvents:UIControlEventTouchUpInside];
        [lTrackerMainView addSubview:mButton];
        if ([[self.mTrackerValuesDict objectForKey:GoalWater] intValue] == 0) {
             lTextLabel.hidden = TRUE;
             lLabel.text = @"Set Water";
             lLabel.textColor = RGB_A(229, 96, 65, 1);
         }
        
    }

    CGSize size =  [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    CGRect mFrame = lTrackerMainView.frame;
    if (mFrame.size.width < 115)//for 32 %
    {
        lLabel.frame = CGRectMake((lTrackerMainView.frame.size.width/2)-(size.width/2)-(18.5/2), lLabel.frame.origin.y, size.width, size.height);

    }else{
        lLabel.frame = CGRectMake((lTrackerMainView.frame.size.width/2)-(size.width/2), lLabel.frame.origin.y, size.width, size.height);

    }

    lImgView1.frame = CGRectMake(lLabel.frame.origin.x+lLabel.frame.size.width+3, (lLabel.frame.size.height+lLabel.frame.origin.y)- (21/2)-5, 10, 10);
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
         lImgView1.frame = CGRectMake(lLabel.frame.origin.x+lLabel.frame.size.width+3, (lLabel.frame.size.height+lLabel.frame.origin.y)- (21/2)-5 +2, 10, 10);

     }
           //for button to click action
        //HomePageButton *lCustomBtn = [[HomePageButton alloc]initWithFrame:CGRectMake(lImgView1.frame.origin.x-5, lImgView1.frame.origin.y-5, lImgView1.frame.size.width+10, lImgView1.frame.size.height+10)];
        HomePageButton *lCustomBtn = [[HomePageButton alloc]initWithFrame:CGRectMake(0, 0, lTrackerMainView.frame.size.width, lTrackerMainView.frame.size.height)];

        lCustomBtn.backgroundColor = CLEAR_COLOR;
        lCustomBtn.TrackerType = mType;
        [lCustomBtn addTarget:self action:@selector(showTrackerList:) forControlEvents:UIControlEventTouchUpInside];
        [lTrackerMainView addSubview:lCustomBtn];

    
    //TO hide the arrow button when goal is not set by user
    int mGoal = 0;
    if ([mType isEqualToString:WeightTracker]) {
        mGoal = [[self.mTrackerValuesDict objectForKey:GoalWeight] intValue];
    }else if ([mType isEqualToString:MealTracker]) {
        mGoal = [[self.mTrackerValuesDict objectForKey:GoalCalories] intValue];
    }else if ([mType isEqualToString:ExerciseTracker]) {
        mGoal = [[self.mTrackerValuesDict objectForKey:GoalExercise] intValue];
    }else if ([mType isEqualToString:StepTracker]) {
        mGoal = [[self.mTrackerValuesDict objectForKey:GoalSteps] intValue];
    }else if ([mType isEqualToString:WaterTracker]) {
        mGoal = [[self.mTrackerValuesDict objectForKey:GoalWater] intValue];
    }
    if (mGoal == 0) {
        lLabel.frame = CGRectMake((lTrackerMainView.frame.size.width/2)-(size.width/2), lLabel.frame.origin.y, size.width, size.height);

        lImgView1.hidden = TRUE;
        //lCustomBtn.hidden = TRUE;
        
        UIButton *mSetGoalBtn = [[UIButton alloc]initWithFrame:CGRectMake((lTrackerMainView.frame.size.width/2)-(30/2), lLabel.frame.origin.y-30-5, 30, 30)];
        [mSetGoalBtn setImage:[UIImage imageNamed:@"addicon.png"] forState:UIControlStateNormal];
        [mSetGoalBtn addTarget:self action:@selector(setGoalAction) forControlEvents:UIControlEventTouchUpInside];
        [lTrackerMainView addSubview:mSetGoalBtn];
        
        
    }
    return lTrackerMainView;
    

}
- (void)showTrackerList:(HomePageButton*)lBtn{
    //UIView *lview = (UIView*)[lBtn superview];
    //lview.backgroundColor = RGB_A(249, 248, 242, 1);
 
    if ([lBtn.TrackerType isEqualToString:WeightTracker]) {
        //to get the weight log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = mAppDelegate.mMenuViewController;
            [mAppDelegate.mRequestMethods_ postRequestToGetWeightChartData:@"Week"
                                                                 AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                              SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

    }else if ([lBtn.TrackerType isEqualToString:ExerciseTracker]){
        //to get the exercise log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = mAppDelegate.mMenuViewController;
            [mAppDelegate.mRequestMethods_ postRequestToGetExerciseChartData:@"Week"
                                                                   AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                                SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

    }else if ([lBtn.TrackerType isEqualToString:StepTracker]){
        //to get the step log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = mAppDelegate.mMenuViewController;;
            [mAppDelegate.mRequestMethods_ postRequestToGetStepChartData:@"Week"
                                                               AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

    }else if ([lBtn.TrackerType isEqualToString:MealTracker]){
        LogMealsViewController *lVC = [[LogMealsViewController alloc]initWithNibName:@"LogMealsViewController" bundle:nil];
        mAppDelegate.mLogMealsViewController = lVC;
        UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:mAppDelegate.mLogMealsViewController];
        mAppDelegate.mSlidingViewController.topViewController = NVGController;
        [mAppDelegate.mSlidingViewController resetTopView];
        /*
         //Commenting - April 16
        //to check if has meal plan settings or not
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToCheckUserMealPlanSettings:mAppDelegate.mResponseMethods_.authToken
                                                                     SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
         */

    }else if ([lBtn.TrackerType isEqualToString:WaterTracker]){
        [self addWaterAction];
    }
    
}
- (void)addWaterAction{
    if (!self.mAddWaterView.hidden) {
        return;
    }
    if ([[GenricUI instance] isiPhone5]) {
        self.mAddWaterView.frame = CGRectMake(0, 180+60, 320, 180);
        self.mAddWaterBackBtn.frame = CGRectMake(self.mAddWaterBackBtn.frame.origin.x, (self.mAddWaterView.frame.size.height/2)- (self.mAddWaterBackBtn.frame.size.height/2), self.mAddWaterBackBtn.frame.size.width, self.mAddWaterBackBtn.frame.size.height);
         self.mAddWaterBackBtn1.frame = CGRectMake(self.mAddWaterBackBtn.frame.origin.x-11, self.mAddWaterBackBtn.frame.origin.y-6, self.mAddWaterBackBtn1.frame.size.width, self.mAddWaterBackBtn1.frame.size.height);
        self.mAddGlassesView.frame = CGRectMake(self.mAddGlassesView.frame.origin.x, (self.mAddWaterView.frame.size.height/2)- (self.mAddGlassesView.frame.size.height/2), self.mAddGlassesView.frame.size.width, self.mAddGlassesView.frame.size.height);
        self.mWaterLastLineImgVieqw.frame = CGRectMake(self.mWaterLastLineImgVieqw.frame.origin.x, 179, self.mWaterLastLineImgVieqw.frame.size.width, self.mWaterLastLineImgVieqw.frame.size.height);
        
    }
    self.mAddWaterView.hidden = FALSE;
    mCurrentGlass_ = 0;
    [self loadGlassesView];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    [self.mAddWaterView.layer addAnimation:transition forKey:nil];
    [self.mAddWaterView.layer addAnimation:transition forKey:nil];
}
- (void)loadGlassesView{
    self.mAddGlassCountLbl.text = [NSString stringWithFormat:@"%d", [[self.mTrackerValuesDict objectForKey:WaterTracker] intValue]];
    if ([[self.mTrackerValuesDict objectForKey:WaterTracker] intValue] <= 1) {
        self.mGlassesLbl.text = @"glass";
    }else{
        self.mGlassesLbl.text = @"glasses";

    }
    // This is implemented as suggested by client on may 15
    int waterCount = [[self.mTrackerValuesDict objectForKey:WaterTracker] intValue];
    int mWaterGoal = 0;
    NSString* mExternalUserID = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALUSERID];
    NSMutableDictionary *dict = [mAppDelegate.mGenericDataBase_ getWaterGoalFormUser:mExternalUserID];
    if ([dict count] > 0) {
        mWaterGoal = [[dict objectForKey:@"GoalWater"] intValue];
    }
    waterCount = abs(waterCount);
    mWaterGoal = abs(mWaterGoal);
  //  NSLog(@"waterCount, mWaterGoal %d %d",waterCount, mWaterGoal);
    if (waterCount >= mWaterGoal) {
        self.mAddGlassImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Waterstage13.png"]];
 
    } else {
        self.mAddGlassImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Waterstage%d.png",[[self.mTrackerValuesDict objectForKey:WaterTracker] intValue]+1]];

    }
    //end
    //self.mAddGlassImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Waterstage%d.png",[[self.mTrackerValuesDict objectForKey:WaterTracker] intValue]+1]];
    int mWaterConsumed_ = [[self.mTrackerValuesDict objectForKey:WaterTracker] intValue];
    for (UIView *lView in self.mAddGlassesView.subviews) {
        [lView removeFromSuperview];
    }
    int xPos=0;
    int yPos=0;
    
    for(int i=0;i<12;i++){
        if (i==4 || i == 8) {
            xPos = 0;
            yPos +=30+10; //height+gap
        }
        // adding check box  with label commment
        UIImage *reportedImg = [UIImage imageNamed:@"glassfull.png"];
        UIImage *unReportedImg=[UIImage imageNamed:@"glassempty.png"];
        UIButton *waterGlassButton=[[UIButton alloc]init];
        [waterGlassButton setFrame:CGRectMake(xPos,yPos,30,30)];
        [waterGlassButton setBackgroundImage:unReportedImg forState:UIControlStateNormal];
        [waterGlassButton setBackgroundImage:reportedImg forState:UIControlStateSelected];
        [waterGlassButton addTarget:self action:@selector(waterGlassButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [waterGlassButton setTag:i+1];
        if(i<mWaterConsumed_){
            [waterGlassButton setSelected:YES];
            mCurrentGlass_ = i+1;
        }else{
            [waterGlassButton setSelected:NO];

        }
        xPos+=30+10;//width+gap
        [self.mAddGlassesView addSubview:waterGlassButton];


     }
    
}
- (void)waterGlassButtonAction:(id)sender {
    UIButton *waterGlass=(UIButton*)sender;
    if ([waterGlass isSelected]) {
        mCurrentGlass_--;
    }else{
        mCurrentGlass_++;

    }
    
    DLog(@"%d count", mCurrentGlass_);
    // The below Request is used to set the water glass
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        NSString *mRequestStr=[NSString stringWithFormat:@"%@%@/%@/%@?GlassCount=%@",WEBSERVICEURL, TrackersTXT, WaterTxt, mCurrentDate_,[NSString stringWithFormat:@"%d", mCurrentGlass_]];
        [mAppDelegate createLoadView];
        [NSThread detachNewThreadSelector:@selector(AddWaterClick:) toTarget:self withObject: mRequestStr];
        
    }else {
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
        return;
    }

}
#pragma mark - Get the Setting data and push to Daily goal page.
- (void)setGoalAction{
    //This same as Setting page
    [self postRequestToGetLookupCalorieLevel];
}
- (void)postRequestToGetLookupCalorieLevel {
    if ([mAppDelegate.mDataGetter_.mCalLevelList_ count] > 0) {
        [self postRequestToDetRecommendedCalories];
    }else {
        NSString *mRequestStr = WEBSERVICEURL;
        mRequestStr = [mRequestStr stringByAppendingFormat:@"Info/Lookup/%@",CALORIELEVEL];
        NSURL *url1 = [NSURL URLWithString:mRequestStr];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:60.0];
        //[theRequest valueForHTTPHeaderField:body];
        [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
        [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
        [theRequest setHTTPMethod:@"GET"];
        
        NSData *response = [NSURLConnection
                            sendSynchronousRequest:theRequest
                            returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc]
                                 initWithData:response encoding:NSUTF8StringEncoding];
        DLog(@"json_string: CALORIELEVEL level %@", json_string);
        mAppDelegate.mDataGetter_.mCalLevelList_ = [json_string JSONValue];
        [self postRequestToDetRecommendedCalories];
    }
}
- (void)postRequestToDetRecommendedCalories {
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"%@/%@",SETTINGS, CALORIESTXT];
    NSLog(@"mRequestStr %@",mRequestStr);
    mRequestStr = [mRequestStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestStr = [mRequestStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:mRequestStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    //[theRequest valueForHTTPHeaderField:body];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"GET"];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    DLog(@"json_string: RecommendedCalories %@", json_string);
    mAppDelegate.mTrackerDataGetter_.mRecommendedCalorie = json_string;
    [self pushToGoalsPage];
    
}
- (void)pushToGoalsPage{
    DailyGoalsSettingViewController *lVc = [[DailyGoalsSettingViewController alloc]initWithNibName:@"DailyGoalsSettingViewController" bundle:nil];
    mAppDelegate.mDailyGoalsSettingViewController = lVc;
    lVc.mParentClass = self;
    [self.navigationController pushViewController:lVc animated:TRUE];
}
// *********** Send the request by using multithreading ************** //

-(void) AddWaterClick: (NSObject *) myObject {
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:(NSString *)myObject]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [request setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:request
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    NSMutableArray *mArray = [json_string JSONValue];
   // [self.mTrackerValuesDict setValue:@"0" forKey:WaterTracker];
    
    for (int i =0 ; i < mArray.count; i++) {
        NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
        [GenricUI setLocaleZoneForDateFormatter:lFormatter];
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *lDate = [lFormatter dateFromString:[[mArray objectAtIndex:i] objectForKey:@"Date"]];
        [lFormatter setDateFormat:DateFormatForRequest];
        if ([[lFormatter stringFromDate:lDate] isEqualToString:self.mCurrentDate_]) {
            [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%d", [[[mArray objectAtIndex:i] objectForKey:@"Glass"] intValue]] forKey:WaterTracker];
        }

    }
    [self loadGlassesView];
    self.isFromAddWater = TRUE;
    [self postRequestToGetTrackersPerDay];
    

    
}
- (void)removeLoadView {
    
    [mAppDelegate removeLoadView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)slideAction:(UIButton*)btn{
    [mAppDelegate showLeftSideMenu:self];

}
- (void)menuAction:(id)sender {
    [mAppDelegate showLeftSideMenu:self];

}

- (IBAction)prevAction:(id)sender {
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
    self.mTitleLbl1_.text=lDateStr;
    [self adjustArrows];
    [self.mTrackerValuesDict removeAllObjects];
    
    //to insert and retrieve the tracker order from the db
    if (![mAppDelegate.mGenericDataBase_ checkTrackerOrderForDate]) {
        
        //inserting into db
        NSString *sequence = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", WeightTracker, MealTracker, ExerciseTracker, StepTracker, WaterTracker];
        [mAppDelegate.mGenericDataBase_ insertTrackerOrder:sequence];
        //retriving from DB
        NSMutableDictionary *mDict = [mAppDelegate.mGenericDataBase_ getTrackerOrderForDate];
        self.mTrackerOrder = [mDict objectForKey:@"Sequence"];
        self.mTrackersShown = [mDict objectForKey:@"VisibleTrackers"];

    }else{
        NSMutableDictionary *mDict = [mAppDelegate.mGenericDataBase_ getTrackerOrderForDate];
        self.mTrackerOrder = [mDict objectForKey:@"Sequence"];
        self.mTrackersShown = [mDict objectForKey:@"VisibleTrackers"];

        
    }
    /*//Change4
    if ([mAppDelegate.mResponseMethods_.userType intValue] != 4) {
        //post request per day
        [self postRequestToGetTrackersPerDay];
    }else{
        self.isFromAddWater = FALSE;
        //[self postRequestToGetGoals];
        [self postRequestToGetTrackersPerDay];

    }*/
    [self postRequestToGetTrackersPerDay];
    self.mAddWaterView.hidden = TRUE;

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
    self.mTitleLbl1_.text=lDateStr;
    [self adjustArrows];
    
    [self.mTrackerValuesDict removeAllObjects];
    
    //to insert and retrieve the tracker order from the db
    if (![mAppDelegate.mGenericDataBase_ checkTrackerOrderForDate]) {
        
        //inserting into db
        NSString *sequence = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", WeightTracker, MealTracker, ExerciseTracker, StepTracker, WaterTracker];
        [mAppDelegate.mGenericDataBase_ insertTrackerOrder:sequence];
        //retriving from DB
        NSMutableDictionary *mDict = [mAppDelegate.mGenericDataBase_ getTrackerOrderForDate];
        self.mTrackerOrder = [mDict objectForKey:@"Sequence"];
        self.mTrackersShown = [mDict objectForKey:@"VisibleTrackers"];

    }else{
        NSMutableDictionary *mDict = [mAppDelegate.mGenericDataBase_ getTrackerOrderForDate];
        self.mTrackerOrder = [mDict objectForKey:@"Sequence"];
        self.mTrackersShown = [mDict objectForKey:@"VisibleTrackers"];

        
    }
    /*
    if ([mAppDelegate.mResponseMethods_.userType intValue] != 4) {
        //post request per day
        [self postRequestToGetTrackersPerDay];
    }else{
        self.isFromAddWater = FALSE;
        //[self postRequestToGetGoals];
        [self postRequestToGetTrackersPerDay];

    }
     */
    [self postRequestToGetTrackersPerDay];
    
    self.mAddWaterView.hidden = TRUE;


}
#pragma mark scroll view delegate methods
// Delegate method removed on May -6.
- (void)viewDidUnload {
    [self setMBannerView:nil];
    [self setMBannerLbl:nil];
    [self setMAddWaterView:nil];
    [self setMBannerTxtArray:nil];
    [self setMTrackerValuesDict:nil];
    [self setMGoalsArray:nil];
    [self setMMainGoalsArray:nil];
    [super viewDidUnload];
}
- (IBAction)bannerCloseAction:(id)sender {
    if (!self.mBannerView.hidden) {
        for (UIView *lview in self.mScrollview.subviews) {
            if ([lview isKindOfClass:[UIScrollView class]]) {
                UIScrollView* temp = (UIScrollView*)lview;
                if (temp.tag == 108) {
                    CGRect frame = temp.frame;
                    frame.size.height +=25;
                    temp.frame = frame;
                }
            }
        }
    }
    self.mBannerView.hidden = TRUE;
    int mBannerViewNum = 0;
    NSUserDefaults *mUserDeafults = [NSUserDefaults standardUserDefaults];
    [mUserDeafults setValue:[NSString stringWithFormat:@"%d",mBannerViewNum] forKey:@"BannerVisitNum"];
    [mUserDeafults synchronize];
    
}

- (IBAction)bannerViewAction:(id)sender {
    if ([mAppDelegate.mResponseMethods_.userType integerValue]!=4) {
        [self showBannerView];
    }
}
- (IBAction)addWiaterCloseAction:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    [self.mAddWaterView.layer addAnimation:transition forKey:nil];
    [self.mAddWaterView.layer addAnimation:transition forKey:nil];
    self.mAddWaterView.hidden = TRUE;

}

- (void)editAction:(id)sender {
    EditLandingViewController *lVC = [[EditLandingViewController alloc]initWithNibName:@"EditLandingViewController" bundle:nil];
    [self.navigationController pushViewController:lVC animated:TRUE];
    
}
- (int)caluclatePercentage:(float)mValue
                      Goal:(float)mGoal
               TrackerType:(NSString*)mType{
    int percentage = 0;
    if ([mType isEqualToString:WeightTracker]) {
        
        //if goal = 0 and both goal and current values are 0 show an epty graph
        if ((mGoal == 0) ||( mGoal == 0 && mValue == 0)) {
            return percentage;
        }
        //if both goal and current values are equal and if goal is greater then show full graph
        else if((mValue == mGoal) || mValue < mGoal){
            percentage = 100;
            return percentage;
        }
        //if current > goal
        else if (mValue > mGoal){
            double per = ((mValue-mGoal)/mGoal);
            per = per*100.0f;
            //if percentage greater tahn 100 show an empty graph else show the percentage area as empty
            if (per > 100) {
                percentage = 0;
                return percentage;
            }else{
                percentage = 100 - per;
                return percentage;
                
            }
        }

    }else{
         mValue = abs(mValue); // convert nagative value to positive.
        //goal is equal to the current value
        if (mGoal == mValue) {
            percentage = 100;
        }else if (mValue > mGoal){
            percentage = 100;
            
        }else if (mValue < mGoal){
            float per = mValue/mGoal;
            per = per*100.0f;
            percentage = per;
            
        }

    }
     return percentage;

}
- (int)returnTheStepsForToday{
    int steps = 0;
    steps = [[self.mTrackerValuesDict objectForKey:StepTracker] intValue];
    //to check whether automatic tracking is enabled or not
    //for automatic tracking image
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    /*if ([lUserDefaults boolForKey:Step_Tracking]) {
        
        steps+=[[lUserDefaults valueForKey:NUMBER_OF_STEPS]integerValue];//change later based on the step count
    }*/
    if ([lUserDefaults valueForKey:NUMBER_OF_STEPS] != nil) {
        steps+=[[lUserDefaults valueForKey:NUMBER_OF_STEPS]integerValue];
    }
    return steps;
}

#pragma mark requests
- (void)postRequestToGetTrackersPerDay{
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"Dashboard/%@", self.mCurrentDate_];
    //[mRequestStr stringByAppendingFormat:@"%@/%@/%@", GoalTxt, TrackersTXT, self.mCurrentDate_]
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        
        [mAppDelegate createLoadView];
        [NSThread detachNewThreadSelector:@selector(GetResponseData:) toTarget:self withObject: mRequestStr];
        
    }else {
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
        return;
    }

}
- (void)GetResponseData:(NSObject *) myObject  {
    
    NSURL *url1 = [NSURL URLWithString:(NSString *)myObject];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    //[theRequest valueForHTTPHeaderField:body];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"GET"];
    
    NSURLResponse *response1;
    NSHTTPURLResponse *httpResponse;
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:&response1 error:nil];
    httpResponse = (NSHTTPURLResponse *)response1;
    DLog(@"Trackers HTTP Status code: %d", [httpResponse statusCode]);
    if ([httpResponse statusCode] == 500) {
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Oops! There seem to be an issue, please try again later."];

    }
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    NSMutableDictionary *mDict = [json_string JSONValue];
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"Weight"] floatValue])] forKey:WeightTracker];
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"Calories"]  floatValue])] forKey:MealTracker];
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"ExerciseDuration"] floatValue])] forKey:ExerciseTracker];
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"ExerciseCalories"] floatValue])] forKey:@"ExCalories"];
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"Steps"] floatValue])] forKey:StepTracker];
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"Water"] floatValue])] forKey:WaterTracker];
    //to set goal values
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"GoalWeight"] floatValue])] forKey:GoalWeight];
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"CaloriesGoal"] floatValue])] forKey:GoalCalories];
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"ExerciseGoal"] floatValue])] forKey:GoalExercise];
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"StepsGoal"] floatValue])] forKey:GoalSteps];
    
    float mWaterGoal = 0;
    NSString* mExternalUserID = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALUSERID];
    NSMutableDictionary *dict = [mAppDelegate.mGenericDataBase_ getWaterGoalFormUser:mExternalUserID];
    if ([dict count] > 0) {
        mWaterGoal = [[dict objectForKey:@"GoalWater"] floatValue];
    }
    NSLog(@"GoalWater %f",mWaterGoal);
    [self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf(mWaterGoal)] forKey:GoalWater];
    //[self.mTrackerValuesDict setValue:[NSString stringWithFormat:@"%.0f", ceilf([[mDict objectForKey:@"WaterGoal"] floatValue])] forKey:GoalWater];

    
    [mAppDelegate removeLoadView];
    [self LoadViewsToScrollView:mAppDelegate.mResponseMethods_.userType];
    [self loadGlassesView];

   
}
- (void)postRequestToGetGoals{
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"%@/Dashboard", GoalTxt];
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        
        [mAppDelegate createLoadView];
        [NSThread detachNewThreadSelector:@selector(GetGoalsResponseData:) toTarget:self withObject: mRequestStr];
        
    }else {
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
        return;
    }

}
- (void)GetGoalsResponseData:(NSObject *) myObject  {
    NSURL *url1 = [NSURL URLWithString:(NSString *)myObject];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    //[theRequest valueForHTTPHeaderField:body];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"GET"];
    
    NSURLResponse *response1;
    NSHTTPURLResponse *httpResponse;
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:&response1 error:nil];
    httpResponse = (NSHTTPURLResponse *)response1;
    DLog(@"HTTP Status code: %d", [httpResponse statusCode]);
    if ([httpResponse statusCode] == 500) {
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Oops! There seem to be an issue, please try again later."];
        
    }
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    [self.mGoalsArray removeAllObjects];
    [self.mMainGoalsArray removeAllObjects];
   
    //error handling
    if ([[json_string JSONValue] isKindOfClass:[NSMutableArray class]]) {
    }
    else
    {
        NSMutableDictionary *mDict = [json_string JSONValue];
        if ([mDict objectForKey:@"Message"]!=nil ) {
            [mAppDelegate removeLoadView];
            [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :[mDict objectForKey:@"Message"]];
            return;
        }
    }
    NSMutableArray *lArray = [json_string JSONValue];
    //to add steps to array
    for (int iCount = 0; iCount < lArray.count; iCount++) {
        int stepCount = [[[lArray objectAtIndex:iCount] objectForKey:@"Steps"] count];
        if (stepCount>0) {
            for (int j = 0; j <stepCount; j++) {
                [self.mGoalsArray addObject:[[[lArray objectAtIndex:iCount] objectForKey:@"Steps"] objectAtIndex:j]];
                [self.mMainGoalsArray addObject:[[[lArray objectAtIndex:iCount] objectForKey:@"Steps"] objectAtIndex:j]];
            }
        }
    }
    //to insert and retrieve the tracker order from the db
    if (![mAppDelegate.mGenericDataBase_ checkGoalOrder]) {
        NSString *sequence = @"";
        for (int i =0; i<self.mGoalsArray.count; i++) {
            sequence = [sequence stringByAppendingString:[NSString stringWithFormat:@"%d,", [[[self.mGoalsArray objectAtIndex:i] objectForKey:@"GoalStep"] intValue]]];
        }
        sequence = [sequence stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
       
        //inserting into db
        [mAppDelegate.mGenericDataBase_ insertGoalOrder:sequence];
        //retriving from DB
        NSMutableDictionary *mDict = [mAppDelegate.mGenericDataBase_ getGoalOrderForDate];
        self.mGoalOrder = [mDict objectForKey:@"Sequence"];
        self.mGoalsShown = [mDict objectForKey:@"VisibleGoals"];
    }else{
        NSMutableDictionary *mDict = [mAppDelegate.mGenericDataBase_ getGoalOrderForDate];
        self.mGoalOrder = [mDict objectForKey:@"Sequence"];
        self.mGoalsShown = [mDict objectForKey:@"VisibleGoals"];
        
    }
    //to change the sequence of the goals
    NSArray *mSeqGolsArray = [self.mGoalOrder componentsSeparatedByString:@","];
    for (int iCount = 0; iCount < mSeqGolsArray.count; iCount++) {
        NSString *mMainstep = [NSString stringWithFormat:@"%d", [[mSeqGolsArray objectAtIndex:iCount]  intValue]];
        
        for (int iGoalCount = 0; iGoalCount < self.mGoalsArray.count; iGoalCount++) {
            NSString *mSubStep = [NSString stringWithFormat:@"%d", [[[self.mGoalsArray objectAtIndex:iGoalCount] objectForKey:@"GoalStep"]  intValue]];
            if ([mSubStep intValue] == [mMainstep intValue]) {
                //[self.mGoalsArray replaceObjectAtIndex:iCount withObject:[self.mGoalsArray objectAtIndex:iGoalCount]];
                [self.mGoalsArray exchangeObjectAtIndex:iCount withObjectAtIndex:iGoalCount];
            }
            
        }
    }
    // to remove the hidden goals
    for (int i =self.mGoalsArray.count-1; i>=0; i--) {
         NSString *mGoalStep = [NSString stringWithFormat:@"%d", [[[self.mGoalsArray objectAtIndex:i] objectForKey:@"GoalStep"] intValue]];
         NSArray *mVisibleGoals = [self.mGoalsShown componentsSeparatedByString:@","];
        BOOL flag = FALSE;
         for (int j = 0; j < mVisibleGoals.count; j++) {
             NSString *mshownStep = [NSString stringWithFormat:@"%d", [[mVisibleGoals objectAtIndex:j]  intValue]];
             if ([mGoalStep intValue] == [mshownStep intValue] && !flag) {
                 flag = TRUE;
             }
         }
        //the step id is not hidden
        if (flag) {
        }else{
            [self.mGoalsArray removeObjectAtIndex:i];
            
        }

     }

    [self postRequestToGetTrackersPerDay];
}
@end
