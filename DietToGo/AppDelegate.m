//
//  AppDelegate.m
//  EHEandme
//
//  Created by Divya Reddy on 23/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AppDelegate.h"
#import "TIMERUIApplication.h"
#import "LoadingView.h"
#import "TransparentView.h"
//API classes
#import "WebEngine.h"
#import "RequestMethods.h"
#import "ResponseMethods.h"
#import "ParserMethods.h"
#import "LoginViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "LandingViewController.h"
#import "StepListViewController.h"
#import "TodayStepView.h"
#import "JSON.h"
#import "Flurry.h"

// TIME DURATION
#define MAX_INACTIVITY_DURATION 60 *  20  // 20 minutes
#define CAMERAGUIDETAG 1000

/******* Set your tracking ID here *******/
//static NSString *const kTrackingId = @"UA-47164109-1";
//client provided
//static NSString *const kTrackingId = @"UA-17099144-3";
//Flurry Key
static NSString *const kFlurryAppKey = @"DW47KWPXVGSK3283JPWZ";

@implementation AppDelegate
@synthesize mGenericDataBase_;
@synthesize mWebEngine_;
@synthesize mParserMethods_;
@synthesize mRequestMethods_;
@synthesize mResponseMethods_;
@synthesize mDataGetter_, mTrackerDataGetter_, mMessagesDataGetter_,mCommunityDataGetter;
@synthesize mNavigationController;
@synthesize mLoginViewController;
@synthesize mLandingViewController,mMenuViewController,mSlidingViewController,mLogMealsViewController,mWeightListViewController,mAddFoodViewController, mMealPlannerSettingsViewController, mSettingsViewController, mWaterListViewController, mMeasurementListViewController, mExerciseListViewController, mGlucoseListViewController, mMyJournalListViewController, mCholesterolListViewController, mBMIListViewController, mStepListViewController, mGoalListViewController, mDailyGoalsSettingViewController, mMessagesListViewController, mNewMessageViewController,mEditServingViewController,mAddNewPrivateFoodController,mAddEditFoodDetailController;

//Discussion Forums
@synthesize mCategotyViewController,mForumsViewController,mThreadsViewController,mPostsViewController;
@synthesize mCustomPopUpView;
@synthesize mTrackPages, tracker;
@synthesize mPushAlert;
@synthesize motionManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //to trcak google analytics
    mTrackPages = TRUE;
    /* //Commenting as we dont have Google Analytics
     // tradeoff between battery usage and timely dispatch.
        [GAI sharedInstance].debug = YES;
        [GAI sharedInstance].dispatchInterval = 120;
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
     */
    //end
    //Flurry Analytics code
     [Flurry startSession:kFlurryAppKey];
    //end

    //This is to check idle time of app
    //Commented code here to remove auto logout feature.
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: [NetworkMonitor instance] selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	[[NetworkMonitor instance]initNetworkInstance];
    
    //WEB API Classes..
    mWebEngine_ = [[WebEngine alloc]init];
    mParserMethods_=[[ParserMethods alloc]init];
    mRequestMethods_=[[RequestMethods alloc]init];
    mResponseMethods_=[[ResponseMethods alloc]init];
    mDataGetter_= [[DataGetter alloc]init];
    mTrackerDataGetter_ = [[TrackerDataGetter alloc]init];
    mMessagesDataGetter_ = [[MessagesDataGetter alloc]init];
    mCommunityDataGetter = [[CommunityDataGetter alloc]init];
    
    //for db
    mGenericDataBase_=[[GenericDataBase alloc] init];
    //generic database declaration
    [mGenericDataBase_ storeDataBaseIntoFile];
    [mGenericDataBase_ checkAndCreateDatabase];
    [mGenericDataBase_ createWaterGoalsTable];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //for automatic tracking steps
    [self automaticTrackSteps];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self displaySplashScreen];
    
    //to show alert explicitly when notification are present
    
    NSDictionary* userInfo =
    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [self processRemoteNotification:userInfo];
    }
    //for background step tracking
    UIApplication *app = [UIApplication sharedApplication];
    [app beginBackgroundTaskWithExpirationHandler:^{
        DLog(@"called in back ground");}];
    

    
    return YES;
}
- (void)displaySplashScreen
{
    mLoginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];

    mNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mLoginViewController];
    self.window.rootViewController = self.mNavigationController;
    [self.window makeKeyAndVisible];
    [self.mLoginViewController.mIndicatorView_ startAnimating];
    self.mLoginViewController.mIndicatorView_.hidden = FALSE;
    self.mLoginViewController.mSplashImgView_.hidden = FALSE;
    self.mLoginViewController.mLoginLandingView.hidden = TRUE;
    self.mLoginViewController.mLoginWebPageView.hidden = TRUE;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) {
        if ([[GenricUI instance] isiPhone5]) {
            self.mLoginViewController.mSplashImgView_.frame = CGRectMake(0, 0, 320, 548);
            self.mLoginViewController.mSplashImgView_.image = [UIImage imageNamed:@"splash-568h@2x.png"];
            self.mLoginViewController.mIndicatorView_.frame = CGRectMake(self.mLoginViewController.mIndicatorView_.frame.origin.x, 264, self.mLoginViewController.mIndicatorView_.frame.size.width, self.mLoginViewController.mIndicatorView_.frame.size.height);

        }else{
            self.mLoginViewController.mSplashImgView_.frame = CGRectMake(0, 0, 320, 460);
            self.mLoginViewController.mSplashImgView_.image = [UIImage imageNamed:@"splash@2x.png"];
        }
    }else{
        if ([[GenricUI instance] isiPhone5]) {
            self.mLoginViewController.mSplashImgView_.frame = CGRectMake(0, 0, 320, 568);
            self.mLoginViewController.mSplashImgView_.image = [UIImage imageNamed:@"splash1-568h@2x.png"];
            self.mLoginViewController.mIndicatorView_.frame = CGRectMake(self.mLoginViewController.mIndicatorView_.frame.origin.x, 264, self.mLoginViewController.mIndicatorView_.frame.size.width, self.mLoginViewController.mIndicatorView_.frame.size.height);
        }else{
            self.mLoginViewController.mSplashImgView_.frame = CGRectMake(0, 0, 320, 480);
            self.mLoginViewController.mSplashImgView_.image = [UIImage imageNamed:@"splash1@2x.png"];
        }
    }
    self.mLoginViewController.mSplashImgView_.hidden = FALSE;
    [self performSelector:@selector(showMainPage:) withObject:mLoginViewController afterDelay:2.0];

}
-(void)showMainPage : (NSObject *) isSucces{
    LoginViewController *lVc =(LoginViewController*)isSucces;
    [lVc.mIndicatorView_ stopAnimating];
    lVc.mIndicatorView_.hidden = TRUE;
    lVc.mSplashImgView_.hidden= TRUE;
    lVc.mUserInfoView.hidden = TRUE;
    
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* userName = [loginUserDefaults objectForKey:USERNAME];
    NSString* authToken = [loginUserDefaults objectForKey:AUTH_TOKEN];
    NSString* sessionToken = [loginUserDefaults objectForKey:SESSION_TOKEN];
    NSString* userType = [loginUserDefaults objectForKey:USERTYPE];
    NSString* coachId = [loginUserDefaults objectForKey:COACHID];
    
    //NSLog(@"userName %@/n %@/n %@/n %@/n %@/n",userName,authToken,sessionToken, userType, coachId);
    //if (authToken!=nil & sessionToken!=nil & userType!=nil & coachId!=nil)
    if (authToken!=nil & sessionToken!=nil)
    {
        self.mResponseMethods_.userName = userName;
        self.mResponseMethods_.authToken = authToken;
        self.mResponseMethods_.sessionToken = sessionToken;
        self.mResponseMethods_.userType = userType;
        self.mResponseMethods_.coachID = coachId;
        //[self displayMainView];
        [self checkTrackDate];
        //post request for checking personal settings
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [self createLoadView];
            [self.mRequestMethods_ postRequestToCheckUserPersonalSettings:self.mResponseMethods_.authToken
                                                                      SessionToken:self.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
       
    }else {
        lVc.mLoginLandingView.hidden = FALSE;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) {
            if ([[GenricUI instance] isiPhone5]) {
                lVc.mLoginLandingView.frame = CGRectMake(0, 0, 320, 548);
                lVc.mLoginBgImgView.frame = lVc.mLoginLandingView.frame;
                lVc.mLoginBgImgView.image = [UIImage imageNamed:@"welcomebg-568h@2x.png"];
                lVc.mLoginBtn.frame = CGRectMake(lVc.mLoginBtn.frame.origin.x, 150+50, lVc.mLoginBtn.frame.size.width, lVc.mLoginBtn.frame.size.height);
                lVc.mNewUserBtn.frame = CGRectMake(lVc.mNewUserBtn.frame.origin.x, 215 + 50, lVc.mNewUserBtn.frame.size.width, lVc.mNewUserBtn.frame.size.height);
                //lVc.mWebView.frame = CGRectMake(0, 0, 320, 548);


                
            }else{
                lVc.mLoginLandingView.frame = CGRectMake(0, 0, 320, 460);
                lVc.mLoginBgImgView.frame = lVc.mLoginLandingView.frame;
                lVc.mLoginBgImgView.image = [UIImage imageNamed:@"welcomebg@2x.png"];
               // lVc.mWebView.frame = CGRectMake(0, 0, 320, 460);

            }
        }else{
            if ([[GenricUI instance] isiPhone5]) {
                lVc.mLoginLandingView.frame = CGRectMake(0, 0, 320, 568);
                lVc.mLoginBgImgView.frame = lVc.mLoginLandingView.frame;
                lVc.mLoginBgImgView.image = [UIImage imageNamed:@"welcomebg1-568h@2x.png"];
                lVc.mLoginBtn.frame = CGRectMake(lVc.mLoginBtn.frame.origin.x, 150+50, lVc.mLoginBtn.frame.size.width, lVc.mLoginBtn.frame.size.height);
                 lVc.mNewUserBtn.frame = CGRectMake(lVc.mNewUserBtn.frame.origin.x, 215+50, lVc.mNewUserBtn.frame.size.width, lVc.mNewUserBtn.frame.size.height);
               // lVc.mWebView.frame = CGRectMake(0, 0, 320, 568);

            }else{
                lVc.mLoginLandingView.frame = CGRectMake(0, 0, 320, 480);
                lVc.mLoginBgImgView.frame = lVc.mLoginLandingView.frame;
                lVc.mLoginBgImgView.image = [UIImage imageNamed:@"welcomebg1@2x.png"];
              //  lVc.mWebView.frame = CGRectMake(0, 0, 320, 480);

            }
        }
        lVc.mPhNumLbl.frame = CGRectMake(lVc.mPhNumLbl.frame.origin.x, (lVc.mLoginLandingView.frame.origin.y+lVc.mLoginLandingView.frame.size.height)-10-20, lVc.mPhNumLbl.frame.size.width, 20);
        lVc.mEmailLbl.frame = CGRectMake(lVc.mEmailLbl.frame.origin.x, (lVc.mPhNumLbl.frame.origin.y-20), lVc.mEmailLbl.frame.size.width, 20);
        lVc.mAssistLbl.frame = CGRectMake(lVc.mAssistLbl.frame.origin.x, (lVc.mEmailLbl.frame.origin.y-20), lVc.mAssistLbl.frame.size.width, 20);


    }


}
-(void)displayLoginView {
    
 
    if (self.mLoginViewController == nil) {
        mLoginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];

    }
   

    UINavigationController *mNavLandingController= [[UINavigationController alloc] initWithRootViewController:self.mLoginViewController];
    
    [self.mLoginViewController.mIndicatorView_ stopAnimating];
    self.mLoginViewController.mIndicatorView_.hidden = TRUE;
    self.mLoginViewController.navigationController.navigationBarHidden = TRUE;
    self.mLoginViewController.mSplashImgView_.hidden = TRUE;
    self.mLoginViewController.mUserInfoView.hidden = TRUE;
    self.mLoginViewController.mLoginLandingView.hidden = FALSE;
    self.mLoginViewController.mLoginWebPageView.hidden = TRUE;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) {
        if ([[GenricUI instance] isiPhone5]) {
            self.mLoginViewController.mLoginLandingView.frame = CGRectMake(0, 0, 320, 548);
            self.mLoginViewController.mLoginBgImgView.frame = self.mLoginViewController.mLoginLandingView.frame;
            self.mLoginViewController.mLoginBgImgView.image = [UIImage imageNamed:@"welcomebg-568h@2x.png"];
            self.mLoginViewController.mLoginBtn.frame = CGRectMake(self.mLoginViewController.mLoginBtn.frame.origin.x, 150+50, self.mLoginViewController.mLoginBtn.frame.size.width, self.mLoginViewController.mLoginBtn.frame.size.height);
            self.mLoginViewController.mNewUserBtn.frame = CGRectMake(self.mLoginViewController.mNewUserBtn.frame.origin.x, 215 + 50, self.mLoginViewController.mNewUserBtn.frame.size.width, self.mLoginViewController.mNewUserBtn.frame.size.height);
            
            self.mLoginViewController.mLoginWebPageView.frame = CGRectMake(0, 0, 320, 548);
            
        }else{
            self.mLoginViewController.mLoginLandingView.frame = CGRectMake(0, 0, 320, 460);
            self.mLoginViewController.mLoginBgImgView.frame = self.mLoginViewController.mLoginLandingView.frame;
            self.mLoginViewController.mLoginBgImgView.image = [UIImage imageNamed:@"welcomebg@2x.png"];
            self.mLoginViewController.mLoginWebPageView.frame = CGRectMake(0, 0, 320, 460);

        }
    }else{
        if ([[GenricUI instance] isiPhone5]) {
            self.mLoginViewController.mLoginLandingView.frame = CGRectMake(0, 0, 320, 568);
            self.mLoginViewController.mLoginBgImgView.frame = self.mLoginViewController.mLoginLandingView.frame;
            self.mLoginViewController.mLoginBgImgView.image = [UIImage imageNamed:@"welcomebg1-568h@2x.png"];
            self.mLoginViewController.mLoginBtn.frame = CGRectMake(self.mLoginViewController.mLoginBtn.frame.origin.x, 150+50, self.mLoginViewController.mLoginBtn.frame.size.width, self.mLoginViewController.mLoginBtn.frame.size.height);
            self.mLoginViewController.mNewUserBtn.frame = CGRectMake(self.mLoginViewController.mNewUserBtn.frame.origin.x, 215 + 50, self.mLoginViewController.mNewUserBtn.frame.size.width, self.mLoginViewController.mNewUserBtn.frame.size.height);
            
            self.mLoginViewController.mLoginWebPageView.frame = CGRectMake(0, 0, 320, 568);

        }else{
            self.mLoginViewController.mLoginLandingView.frame = CGRectMake(0, 0, 320, 480);
            self.mLoginViewController.mLoginBgImgView.frame = self.mLoginViewController.mLoginLandingView.frame;
            self.mLoginViewController.mLoginBgImgView.image = [UIImage imageNamed:@"welcomebg1@2x.png"];
            self.mLoginViewController.mLoginWebPageView.frame = CGRectMake(0, 0, 320, 480);

        }
    }
    self.mLoginViewController.mPhNumLbl.frame = CGRectMake(self.mLoginViewController.mPhNumLbl.frame.origin.x, (self.mLoginViewController.mLoginLandingView.frame.origin.y+self.mLoginViewController.mLoginLandingView.frame.size.height)-10-20, self.mLoginViewController.mPhNumLbl.frame.size.width, 20);
    self.mLoginViewController.mEmailLbl.frame = CGRectMake(self.mLoginViewController.mEmailLbl.frame.origin.x, (self.mLoginViewController.mPhNumLbl.frame.origin.y-20), self.mLoginViewController.mEmailLbl.frame.size.width, 20);
    self.mLoginViewController.mAssistLbl.frame = CGRectMake(self.mLoginViewController.mAssistLbl.frame.origin.x, (self.mLoginViewController.mEmailLbl.frame.origin.y-20), self.mLoginViewController.mAssistLbl.frame.size.width, 20);

    self.window.rootViewController = mNavLandingController;
    [self.window makeKeyAndVisible];

    
}
-(void)displayMainView {
    
    mMenuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    mLandingViewController = [[LandingViewController alloc]initWithNibName:@"LandingViewController" bundle:nil];
    UINavigationController *mNavLandingController= [[UINavigationController alloc] initWithRootViewController:self.mLandingViewController];
    
    mSlidingViewController = [[ECSlidingViewController alloc] init];
    self.mSlidingViewController.topViewController = mNavLandingController;
    //we dont have right view
    self.mSlidingViewController.underRightViewController = nil;
    self.mSlidingViewController.underLeftViewController = self.mMenuViewController;
    [mSlidingViewController resetTopView];
    
    self.window.rootViewController = mSlidingViewController;
    [self.window makeKeyAndVisible];
    
}
#pragma mark push delegate methods
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    if (TARGET_IPHONE_SIMULATOR) {
        return;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	NSLog(@"My token is: %@", deviceToken);
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *post =[NSString stringWithFormat:@"Device=1&Token=%@", newToken];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Notifications/Subscription", WEBSERVICEURL]]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [request setValue:self.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [request setHTTPBody:postData];

    NSError *error;
    NSHTTPURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *json_string = [[NSString alloc]
                             initWithData:urlData encoding:NSUTF8StringEncoding];
    DLog(@"%@", json_string);
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
    mDict = (NSMutableDictionary*)[json_string JSONValue];
    
    //to store the device id in user deaults
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    [lUserDefaults setValue:[mDict objectForKey:@"id"] forKey:DEVICE_ID];
    [lUserDefaults setValue:newToken forKey:DEVICE_TOKEN];
    [lUserDefaults synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    NSDictionary *notification = [userInfo objectForKey:@"aps"];
   
    
    NSString *alert = [notification objectForKey:@"alert"];
    self.mPushAlert = alert;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:alert
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
    [alertView  show];
}
- (void)processRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    NSDictionary *notification = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [notification objectForKey:@"alert"];
    self.mPushAlert = alert;

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:alert
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
    [alertView  show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* authToken = [loginUserDefaults objectForKey:AUTH_TOKEN];
    NSString* sessionToken = [loginUserDefaults objectForKey:SESSION_TOKEN];
    NSString* userType = [loginUserDefaults objectForKey:USERTYPE];
    
    if (authToken!=nil & sessionToken!=nil & userType!=nil)
    {
        [self handlePushNotifications];
    }

}
- (void)handlePushNotifications{
    if (self.mResponseMethods_.authToken == nil || self.mResponseMethods_.sessionToken == nil) {
        [self performSelector:@selector(handlePushNotifications) withObject:nil afterDelay:0.3];
        return;
    }
    //new message from EHE coach alert
    if ([self.mPushAlert isEqualToString:@"New message from my EHE Coach!"]) {
         if ([self.mResponseMethods_.userType intValue] == 4) {
             //move to messages part
             if ([[NetworkMonitor instance]isNetworkAvailable]) {
                 [self createLoadView];
                 self.mRequestMethods_.mViewRefrence = self.mMenuViewController;
                 [self.mRequestMethods_ postRequestToGetMessagesList:@"Inbox"
                                                                Page:@"1"
                                                          UnreadOnly:@"false"
                                                           AuthToken:self.mResponseMethods_.authToken
                                                        SessionToken:self.mResponseMethods_.sessionToken];
             }else{
                 [[NetworkMonitor instance]displayNetworkMonitorAlert];
             }

         }
        return;
    }
    //Reaching a daily step goal
    else if ([self.mPushAlert isEqualToString:@"Congratulations! You have reached your steps goal for today!"]){
        //move to step landing page
        //to get the step log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [self createLoadView];
            self.mRequestMethods_.mViewRefrence = self.mMenuViewController;
            [self.mRequestMethods_ postRequestToGetStepChartData:@"Week"
                                                               AuthToken:self.mResponseMethods_.authToken
                                                            SessionToken:self.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

    }//Reminder daily report alert when a user has not logged any ‘goals’ for the day
    else if ([self.mPushAlert isEqualToString:@"Time to report your EHE goals for today!"]){
        //move to my goals landing page
        if ([self.mResponseMethods_.userType intValue] == 4) {
            //to retrieve goal steps
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [self createLoadView];
                self.mRequestMethods_.mViewRefrence = self.mMenuViewController;
                [self.mRequestMethods_ postRequestToGetGoalSteps:self.mResponseMethods_.authToken
                                                    SessionToken:self.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }

        }
        
    }//When a user has not logged ‘weight’ in past 2 weeks
    else if ([self.mPushAlert isEqualToString:@"It’s time to log your weight and check progress!"]){
        //move to weight tracker landing page
        //to get the weight log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [self createLoadView];
            self.mRequestMethods_.mViewRefrence = self.mMenuViewController;
            [self.mRequestMethods_ postRequestToGetWeightChartData:@"Week"
                                                                 AuthToken:self.mResponseMethods_.authToken
                                                              SessionToken:self.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

    }//When a user has not logged ‘weight’ in past 2 weeks
    else if ([self.mPushAlert isEqualToString:@"It’s time to log your meals to track calories intake"]){
        //move to meal planner landing page
        //to check if has meal plan settings or not
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [self createLoadView];
            self.mRequestMethods_.mViewRefrence = self.mMenuViewController;
            [self.mRequestMethods_ postRequestToCheckUserMealPlanSettings:self.mResponseMethods_.authToken
                                                                     SessionToken:self.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        return;

    }
}
-(void)automaticTrackSteps{
    
    NSUserDefaults *ldefaults;
    ldefaults = [NSUserDefaults standardUserDefaults];
    
    if ([ldefaults objectForKey:Step_Tracking] == nil) {
        [ldefaults setValue:nil forKey:NUMBER_OF_STEPS];
        // UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
        // accel.delegate = nil;
        [self.motionManager stopAccelerometerUpdates];
    }
    
    else if ([ldefaults boolForKey:Step_Tracking]) {
        // [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 /20.0];
        //UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
        //accel.delegate = self;
        [self startMyMotionDetect];
        if ([ldefaults objectForKey:NUMBER_OF_STEPS]==nil) {
            [ldefaults setValue:[NSString stringWithFormat:@"0"] forKey:NUMBER_OF_STEPS];
            
        }
        
    }
    else if (![ldefaults boolForKey:Step_Tracking]){
        // Enable listening to the accelerometer
        //UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
        //accel.delegate = nil;
        //[ldefaults setValue:nil forKey:NUMBER_OF_STEPS];
        [self.motionManager stopAccelerometerUpdates];
        
        
    }
    [ldefaults synchronize];
}
/*
// UIAccelerometerDelegate method, called when the device accelerates.
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    NSUserDefaults *ldefaults;
    ldefaults = [NSUserDefaults standardUserDefaults];
    
    if ([ldefaults objectForKey:NUMBER_OF_STEPS]!=nil) {
        numSteps =[[ldefaults objectForKey:NUMBER_OF_STEPS] integerValue];
    }
    
    const float violence = 1.0;
    static BOOL beenhere;
    BOOL shake = FALSE;
    if (beenhere) return;
    beenhere = TRUE;
    if (acceleration.x > violence || acceleration.x < (-1* violence))
        shake = TRUE;
    // NSLog(@"Violance true in first case.");
    
    if (acceleration.y > violence || acceleration.y < (-1* violence))
        shake = TRUE;
    // NSLog(@"Violance true in Second case.");
    
    if (acceleration.z > violence || acceleration.z < (-1* violence))
        shake = TRUE;
    //NSLog(@"Violance true in Third case.");
    
    float xx = acceleration.x;
    float yy = acceleration.y;
    float zz = acceleration.z;
    
    float dot = (px * xx) + (py * yy) + (pz * zz);
    float a = ABS(sqrt(px * px + py * py + pz * pz));
    float b = ABS(sqrt(xx * xx + yy * yy + zz * zz));
    
    dot /= (a * b);
    
    dot = dot + dot + dot + 0.001;
    NSLog(@"values are %f",dot);
    
    if (dot <=2.995 && (shake == TRUE)) {
        
        if (!isSleeping) {
            isSleeping = YES;
            [self performSelector:@selector(wakeUp) withObject:nil afterDelay:0.3];
            numSteps += 1;
            NSUserDefaults *ldefaults;
            ldefaults = [NSUserDefaults standardUserDefaults];
            [ldefaults setValue:[NSString stringWithFormat:@"%d",numSteps] forKey:NUMBER_OF_STEPS];
           
            [ldefaults synchronize];
            if (self.mStepListViewController!=nil) {
                if (self.mStepListViewController.mWeightlbl!= nil) {
                    self.mStepListViewController.mWeightlbl.text = [NSString stringWithFormat:@"%d", [self.mStepListViewController returnTheStepsForToday]];
                    CGSize size =  [self.mStepListViewController.mWeightlbl.text sizeWithFont:self.mStepListViewController.mWeightlbl.font constrainedToSize:CGSizeMake(150, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
                    self.mStepListViewController.mWeightlbl.frame = CGRectMake(self.mStepListViewController.mWeightlbl.frame.origin.x, self.mStepListViewController.mWeightlbl.frame.origin.y, size.width, self.mStepListViewController.mWeightlbl.frame.size.height);
                    
                    //to update the graph
                    int percentage = [self.mStepListViewController caluclatePercentage:[self.mStepListViewController returnTheStepsForToday] Goal:[[self.mDataGetter_.mDailyGoalsDict_ objectForKey:@"StepsGoal"] intValue]];
                    TodayStepView *mTodayView = nil;
                    
                    for (UIView *lView in self.mStepListViewController.mScrolView.subviews) {
                        if ([lView isKindOfClass:[TodayStepView class]] && mTodayView == nil) {
                            mTodayView = (TodayStepView*)lView;
                        }
                    }
                    if (mTodayView!=nil) {
                        [mTodayView changeViewPercentage:percentage];
                    }
                    

                }
            }
        }
    }
    beenhere = false;
    px = xx; py = yy; pz = zz;
}
*/
- (void)wakeUp {
    isSleeping = NO;
}
#pragma mark coremotion methods
- (CMMotionManager *)motionManager
{
    if (!motionManager) motionManager = [[CMMotionManager alloc] init];
    return motionManager;
}



- (void)startMyMotionDetect
{
    //__block float stepMoveFactor = 15;
    NSUserDefaults *ldefaults;
    ldefaults = [NSUserDefaults standardUserDefaults];
    
    if ([ldefaults objectForKey:NUMBER_OF_STEPS]!=nil) {
        numSteps =[[ldefaults objectForKey:NUMBER_OF_STEPS] integerValue];
    }
    
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                             withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            
                            CMAcceleration acceleration = data.acceleration;
                            
                            
                            const float violence = 1.0;
                            static BOOL beenhere;
                            BOOL shake = FALSE;
                            //if (beenhere) return;
                            beenhere = TRUE;
                            if (acceleration.x > violence || acceleration.x < (-1* violence))
                                shake = TRUE;
                            // NSLog(@"Violance true in first case.");
                            
                            if (acceleration.y > violence || acceleration.y < (-1* violence))
                                shake = TRUE;
                            // NSLog(@"Violance true in Second case.");
                            
                            if (acceleration.z > violence || acceleration.z < (-1* violence))
                                shake = TRUE;
                            //NSLog(@"Violance true in Third case.");
                            
                            float xx = acceleration.x;
                            float yy = acceleration.y;
                            float zz = acceleration.z;
                            
                            float dot = (px * xx) + (py * yy) + (pz * zz);
                            float a = ABS(sqrt(px * px + py * py + pz * pz));
                            float b = ABS(sqrt(xx * xx + yy * yy + zz * zz));
                            
                            dot /= (a * b);
                            
                            dot = dot + dot + dot + 0.001;
                            NSLog(@"values are %f",dot);
                            
                            if (dot <=2.995 && (shake == TRUE)) {
                                
                                if (!isSleeping) {
                                    isSleeping = YES;
                                    [self performSelector:@selector(wakeUp) withObject:nil afterDelay:0.3];
                                    numSteps += 1;
                                    NSUserDefaults *ldefaults;
                                    ldefaults = [NSUserDefaults standardUserDefaults];
                                    [ldefaults setValue:[NSString stringWithFormat:@"%d",numSteps] forKey:NUMBER_OF_STEPS];
                                    
                                    [ldefaults synchronize];
                                    if (self.mStepListViewController!=nil) {
                                        if (self.mStepListViewController.mWeightlbl!= nil) {
                                            int steps=[self.mStepListViewController returnTheStepsForToday];
                                            NSNumberFormatter *formatter = [NSNumberFormatter new];
                                            [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                                            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:steps]];
                                            self.mStepListViewController.mWeightlbl.text = [NSString stringWithFormat:@"%@", formatted];
                                            CGSize size =  [self.mStepListViewController.mWeightlbl.text sizeWithFont:self.mStepListViewController.mWeightlbl.font constrainedToSize:CGSizeMake(150, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
                                            self.mStepListViewController.mWeightlbl.frame = CGRectMake(self.mStepListViewController.mWeightlbl.frame.origin.x, self.mStepListViewController.mWeightlbl.frame.origin.y, size.width, self.mStepListViewController.mWeightlbl.frame.size.height);
                                            
                                            //to update the graph
                                            int percentage = [self.mStepListViewController caluclatePercentage:[self.mStepListViewController returnTheStepsForToday] Goal:[[self.mDataGetter_.mDailyGoalsDict_ objectForKey:@"GoalSteps"] intValue]];//StepsGoal
                                            TodayStepView *mTodayView = nil;
                                            
                                            for (UIView *lView in self.mStepListViewController.mScrolView.subviews) {
                                                if ([lView isKindOfClass:[TodayStepView class]] && mTodayView == nil) {
                                                    mTodayView = (TodayStepView*)lView;
                                                }
                                            }
                                            if (mTodayView!=nil) {
                                                [mTodayView changeViewPercentage:percentage];
                                            }
                                            
                                            
                                        }
                                    }
                                }
                            }
                            px = xx; py = yy; pz = zz;
                            
                            
                        });
     }
     ];
    
    
}


////
#pragma mark end
- (void)checkTrackDate{
    if (TARGET_IPHONE_SIMULATOR) {
        return;
    }
    NSUserDefaults *ldefaults;
    ldefaults = [NSUserDefaults standardUserDefaults];
    //if ([ldefaults boolForKey:Step_Tracking])
    {
        if ([ldefaults objectForKey:TRACK_DATE]!=nil) {
            NSDate *lDate = (NSDate*)[ldefaults objectForKey:TRACK_DATE];
            NSDate *lCurrectDate = [NSDate date];
            NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            unsigned int uintFlags = NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit;
            NSDateComponents* differenceComponents = [gregorian components:uintFlags fromDate:lDate toDate:lCurrectDate options:0];
            int days = differenceComponents.day;
            DLog(@"%d %@", days, [NSString stringWithFormat:@"%d", [[ldefaults objectForKey:NUMBER_OF_STEPS] intValue]]);
            if (days == 0) {
                //to check whether the dates are equal or not if no post request
                NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
                [lFormatter setDateFormat:@"yyyy-MM-dd"];
                [GenricUI setLocaleZoneForDateFormatter:lFormatter];
                if (![[lFormatter stringFromDate:lDate] isEqualToString:[lFormatter stringFromDate:lCurrectDate]]) {
                    //post request
                    [self postRequestToAddAutomaticStepLog];

                }
            }else if (days >0){
                //to post request
                [self postRequestToAddAutomaticStepLog];
                
            }
            
        }
    }
}
- (void)postRequestToAddAutomaticStepLog
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [GenricUI setLocaleZoneForDateFormatter:dateFormat];
    [dateFormat setDateFormat:@"EEE, MM/dd/yy"];
    
    NSUserDefaults *ldefaults;
    ldefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lDate = (NSDate*)[ldefaults objectForKey:TRACK_DATE];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *mSteps = [NSString stringWithFormat:@"%d", [[ldefaults objectForKey:NUMBER_OF_STEPS] intValue]];
    NSString *mNotes = @"Added automatically";
    NSString *mReqStr = [NSString stringWithFormat:@"%@%@/%@", WEBSERVICEURL, TrackersTXT, StepsTxt];
    NSString *mBody = [NSString stringWithFormat:@"Date=%@&Steps=%@&Notes=%@", [dateFormat stringFromDate:lDate], mSteps,mNotes];
    
    
    NSURL *url1 = [NSURL URLWithString:mReqStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    [theRequest setValue:self.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:self.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    
    NSData *bodyData = [mBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    [theRequest setHTTPMethod:@"PUT"];
    [theRequest setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:bodyData];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    if ([json_string isEqualToString:@""]) {
        [ldefaults setValue:[NSString stringWithFormat:@"0"] forKey:NUMBER_OF_STEPS];
        [ldefaults synchronize];
    }
}
- (void)hideEmptySeparators:(UITableView*)tableView
{
    UIView *emptyView_ = [[UIView alloc] initWithFrame:CGRectZero];
       
    emptyView_.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:emptyView_];
}
- (void)showLeftSideMenu:(UIViewController*)mParentClass
{
    [mParentClass.slidingViewController anchorTopViewTo:ECRight];
    
}
- (void)showCustomAlert:(NSString*)mAlert
                Message:(NSString*)mMsg{
    if (mPopupTimer != nil) {
        [mPopupTimer invalidate];
        mPopupTimer = nil;
    }
    for(UIView *lView in self.window.subviews) {
        if([lView isKindOfClass:[UIView class]] && lView.tag == 101) {
            [lView removeFromSuperview];
        }
    }
    
    UIView* trns = [[UIView alloc]initWithFrame:self.window.frame];
    trns.tag = 101;
    [trns setBackgroundColor:[UIColor blackColor]];
    trns.alpha = 0.7f;
    [self.window addSubview:trns];
    
    for (UIView *lView  in self.window.subviews) {
        if ([lView isKindOfClass:[CustomPopUpView class]]) {
            [lView removeFromSuperview];
        }
    }
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"CustomPopUpView" owner:self options:nil];
    
    CustomPopUpView *lCustomPopUpView = [array objectAtIndex:0];
    self.mCustomPopUpView = lCustomPopUpView;
    lCustomPopUpView.frame = CGRectMake(0, 0, 320, self.window.frame.size.height);
    
  
    lCustomPopUpView.mTitleLbl.font = Bariol_Bold(17);
    lCustomPopUpView.mMsgLbl.font = Bariol_Regular(17);
    lCustomPopUpView.mMsgLbl.text = mMsg;
    lCustomPopUpView.mTitleLbl.text = mAlert;
    CGSize size =  [lCustomPopUpView.mMsgLbl.text sizeWithFont:lCustomPopUpView.mMsgLbl.font constrainedToSize:CGSizeMake(lCustomPopUpView.mMsgLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lCustomPopUpView.mMsgLbl.frame = CGRectMake(lCustomPopUpView.mMsgLbl.frame.origin.x, lCustomPopUpView.mMsgLbl.frame.origin.y, lCustomPopUpView.mMsgLbl.frame.size.width, size.height);
    lCustomPopUpView.mImgView.frame = CGRectMake(lCustomPopUpView.mImgView.frame.origin.x, lCustomPopUpView.mImgView.frame.origin.y, lCustomPopUpView.mImgView.frame.size.width, lCustomPopUpView.mMsgLbl.frame.origin.y+lCustomPopUpView.mMsgLbl.frame.size.height+10);
   lCustomPopUpView.mImgView.layer.cornerRadius=8;
	lCustomPopUpView.mImgView.layer.borderColor = CLEAR_COLOR.CGColor;
	lCustomPopUpView.mImgView.layer.borderWidth = 2;
    
    lCustomPopUpView.mView.frame = CGRectMake(lCustomPopUpView.mView.frame.origin.x, (lCustomPopUpView.frame.size.height-lCustomPopUpView.mView.frame.size.height)/2, lCustomPopUpView.mView.frame.size.width, lCustomPopUpView.mImgView.frame.size.height);
    
   
    [self.window addSubview:lCustomPopUpView];
    [self.window bringSubviewToFront:lCustomPopUpView];
    mPopupTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(closePopUp) userInfo:Nil repeats:FALSE];

}
- (void)closePopUp{
    if (mPopupTimer != nil) {
        [mPopupTimer invalidate];
        mPopupTimer = nil;
    }
    for(UIView *lView in self.window.subviews) {
        if([lView isKindOfClass:[UIView class]] && lView.tag == 101) {
            [lView removeFromSuperview];
        }
    }
    for (UIView *lView  in self.window.subviews) {
        if ([lView isKindOfClass:[CustomPopUpView class]]) {
            [lView removeFromSuperview];
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //this is called app is going back ground
    if (self.mResponseMethods_.authToken!=nil && self.mResponseMethods_.sessionToken!=nil) {
        [self setLastLoggedInTimestamp:[[NSDate date] timeIntervalSince1970]];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *ldefaults = [NSUserDefaults standardUserDefaults];
    if ([ldefaults boolForKey:Step_Tracking]) {
        NSDate *lDate = [NSDate date];
        [ldefaults setValue:lDate forKey:TRACK_DATE];
        [ldefaults synchronize];
    }
   /* UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
        backgroundSupported = device.multitaskingSupported;
    
    
    if (backgroundSupported) {
        UIApplication*    app = [UIApplication sharedApplication];
        
     __block  UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }];
        
        // Start the long-running task and return immediately.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           // Do the work associated with the task.
                           //if ([application backgroundTimeRemaining] > 1.0 )
                           {
                               UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
                               accel.delegate = self;
                               accel.updateInterval = 1.0 /20.0;
                           }          
                       });
    }*/
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //Commented code here to remove auto logout feature.
    
    /*if ([self sessionExpired]) {
        NSLog(@"expired");
            [self showLoginAfterSessionExpiry];
    } else {
        NSLog(@"not expired.");
        if (self.mResponseMethods_.authToken!=nil && self.mResponseMethods_.sessionToken!=nil) {
            NSUserDefaults *ldefaults = [NSUserDefaults standardUserDefaults];
            if ([ldefaults boolForKey:Step_Tracking]) {
                [self checkTrackDate];
            }
        }
    }*/
    if (self.mResponseMethods_.authToken!=nil && self.mResponseMethods_.sessionToken!=nil) {
        NSUserDefaults *ldefaults = [NSUserDefaults standardUserDefaults];
        if ([ldefaults boolForKey:Step_Tracking]) {
            [self checkTrackDate];
        }
    }   
}
-(void)applicationDidTimeout:(NSNotification *) notif
{
    //revert to Activity A
    NSLog(@"applicationDidTimeout");
    if (self.mResponseMethods_.authToken!=nil && self.mResponseMethods_.sessionToken!=nil) {
        /*
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [self.mRequestMethods_ postRequestToLogout:self.mResponseMethods_.authToken
                                          SessionToken:self.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }*/
        [self showLoginAfterSessionExpiry];
    }
}
- (BOOL)sessionExpired
{
    NSTimeInterval rightNow = [[NSDate date] timeIntervalSince1970];
    NSLog(@"sessionExpired %f",(rightNow - [self getLastLoggedInTimestamp]));
    //[UtilitiesLibrary showAlertViewWithTitle:@"Time" :[NSString stringWithFormat:@"In Sec: %f",(rightNow - [self getLastLoggedInTimestamp])]];
    
    if ((rightNow - [self getLastLoggedInTimestamp]) > MAX_INACTIVITY_DURATION)
        return YES;
    
    if (rightNow < [self getLastLoggedInTimestamp])
        return YES;
    return NO;
}

- (NSTimeInterval)getLastLoggedInTimestamp
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoggedInTimestamp"] intValue];
}
- (void)setLastLoggedInTimestamp:(NSTimeInterval)timestamp
{
    //[self setLastLoggedInTimestamp:[[NSDate date] timeIntervalSince1970]];
    NSLog(@"time stored");

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:timestamp] forKey:@"lastLoggedInTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSUserDefaults *ldefaults = [NSUserDefaults standardUserDefaults];
    if ([ldefaults boolForKey:Step_Tracking]) {
        NSDate *lDate = [NSDate date];
        [ldefaults setValue:lDate forKey:TRACK_DATE];
        [ldefaults synchronize];
        [self setLastLoggedInTimestamp:[[NSDate date] timeIntervalSince1970]];
    }
}
#pragma mark AppDelegateInstance
+(AppDelegate*) appDelegateInstance {
    return((AppDelegate*) [[UIApplication sharedApplication] delegate]);
}
#pragma mark LoadingView
- (void)createLoadView
{
    
    for(UIView *lView in self.window.subviews) {
        if([lView isKindOfClass:[LoadingView class]]) {
            [self.window bringSubviewToFront:mLoadingView_];
            return;
        }
    }
    
	mLoadingView_ = [[LoadingView alloc]init];
	[mLoadingView_ loadingViewInView:self.window];
    [self.window bringSubviewToFront:mLoadingView_];
    
    
}
- (void)removeLoadView
{
    for(UIView *lView in self.window.subviews) {
        if([lView isKindOfClass:[LoadingView class]]) {
            UIView *aSuperview = [lView superview];
            [lView removeFromSuperview];
            
            // Set up the animation
            CATransition *animation = [CATransition animation];
            [animation setType:kCATransitionFade];
            [animation setDuration:0.0];
            [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
            
        }
    }
}
//Add black transperant layer for window
- (void)addTransparentViewToWindow {
    for(UIView *lView in self.window.subviews) {
        if([lView isKindOfClass:[TransparentView class]] && lView.tag == CAMERAGUIDETAG) {
            [self.window bringSubviewToFront:lView];
            return;
        }
    }
    TransparentView* trns = [[TransparentView alloc]initWithFrame:self.window.frame];
    trns.alpha = 0.2f;// 20% opacity
    trns.tag = CAMERAGUIDETAG;
    [self.window addSubview:trns];
    
}
- (void)addTransparentViewToWindowForDisuccionForum {
    for(UIView *lView in self.window.subviews) {
        if([lView isKindOfClass:[TransparentView class]] && lView.tag == CAMERAGUIDETAG) {
            [self.window bringSubviewToFront:lView];
            return;
        }
    }
    TransparentView* trns = [[TransparentView alloc]initWithFrame:self.window.frame];
    trns.alpha = 0.7f;// 70% opacity
    trns.tag = CAMERAGUIDETAG;
    [self.window addSubview:trns];
    
}
-(void)removeTransparentViewFromWindow {

    for(UIView *lView in self.window.subviews) {
        if([lView isKindOfClass:[TransparentView class]] && lView.tag == CAMERAGUIDETAG) {
            [lView removeFromSuperview];
        }
    }

}

- (void)addTransparentView:(UIViewController*)viewController {
    
    for(UIView *lView in viewController.view.subviews) {
        if([lView isKindOfClass:[TransparentView class]]) {
            [viewController.view bringSubviewToFront:lView];
            return;
        }
    }
    
    TransparentView* trns = [[TransparentView alloc]initWithFrame:self.window.frame];
    [viewController.view addSubview:trns];
    
}
-(void)removeTransparentView:(UIViewController*)viewController {
    for(UIView *lView in viewController.view.subviews) {
        if([lView isKindOfClass:[TransparentView class]]) {
            UIView *aSuperview = [lView superview];
            [lView removeFromSuperview];
            
            // Set up the animation
            CATransition *animation = [CATransition animation];
            [animation setType:kCATransitionFade];
            [animation setDuration:0.0];
            [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
            
        }
    }
}
-(void)clearCameraGuideData {
    //This is to reset the camera guide.
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:NO forKey:CAMERALAYER];
    //BMI
    [loginUserDefaults setBool:NO forKey:BMICAMERALAYER];
    [loginUserDefaults setBool:NO forKey:BMITOPCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:BMIBOTTOMCAMERALAYER];
    
    //Weight
    [loginUserDefaults setBool:NO forKey:WEIGHTCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:WEIGHTTOPCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:WEIGHTBOTTOMCAMERALAYER];
    
    //Step tracker
    [loginUserDefaults setBool:NO forKey:STEPCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:STEPTOPCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:STEPBOTTOMCAMERALAYER];
    
    //Exercise tracker
    [loginUserDefaults setBool:NO forKey:EXERCISECAMERALAYER];
    [loginUserDefaults setBool:NO forKey:EXERCISETOPCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:EXERCISEBOTTOMCAMERALAYER];
    
    //Measurement tracker
    [loginUserDefaults setBool:NO forKey:MEASUREMENTCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:MEASUREMENTTOPCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:MEASUREMENTBOTTOMCAMERALAYER];
    
    //Blood Glucore tracker
    [loginUserDefaults setBool:NO forKey:BLOODCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:BLOODTOPCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:BLOODBOTTOMCAMERALAYER];

    //Cholestreol tracker
    [loginUserDefaults setBool:NO forKey:CHOLESTREOLCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:CHOLESTREOLTOPCAMERALAYER];
    [loginUserDefaults setBool:NO forKey:CHOLESTREOLBOTTOMCAMERALAYER];

    [loginUserDefaults synchronize];

}
- (void)setNavControllerTitle:(NSString*)title
                        imageName:(NSString*)mImage
				forController:(UIViewController*)viewController{
    CGRect lblFrame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        lblFrame = CGRectMake(0, 0, 200, 30);
    }    
    UILabel *titleView=[[UILabel alloc]initWithFrame:lblFrame];
    [titleView setText:title];
   
    titleView.font = OpenSans_Light(22); //Bariol_Regular(22);
    titleView.textColor = RGB_A(179, 35, 23, 1); //RGB_A(114, 105, 89, 1);
    
    [titleView setTextAlignment:TEXT_ALIGN_CENTER];
    [titleView setBackgroundColor:[UIColor clearColor]];
    [viewController.navigationItem setTitleView:titleView];
    //[titleView setAdjustsFontSizeToFitWidth:YES];
    
    if ([viewController.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        
        [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:mImage] forBarMetrics:UIBarMetricsDefault];
    }
}
-(void)showLoginAfterSessionExpiry {
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];       
    [loginUserDefaults setValue:nil forKey:USERNAME];
    [loginUserDefaults setValue:nil forKey:AUTH_TOKEN];
    [loginUserDefaults setValue:nil forKey:SESSION_TOKEN];
    [loginUserDefaults setValue:nil forKey:USERTYPE];
    [loginUserDefaults setValue:nil forKey:EXTERNALUSERID];
    [loginUserDefaults setValue:nil forKey:@"BannerVisitNum"];
    [loginUserDefaults setValue:nil forKey:Step_Tracking];
    [loginUserDefaults setValue:nil forKey:NUMBER_OF_STEPS];
    [loginUserDefaults setValue:nil forKey:DEVICE_ID];
    [loginUserDefaults setValue:nil forKey:DEVICE_TOKEN];
    [loginUserDefaults synchronize];
    
    self.mResponseMethods_.userName = nil;
    self.mResponseMethods_.authToken = nil;
    self.mResponseMethods_.sessionToken = nil;
    self.mResponseMethods_.userType =nil;
    [self.mGenericDataBase_ clearGoalOrder];
    [self.mGenericDataBase_ clearTrackerOrder];
    [self displayLoginView];
}
#pragma mark - Check FitBit Status
-(BOOL)isShowFitBitBanner {

    [self createLoadView];
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"Fitbit/Status"];
    NSURL *url1 = [NSURL URLWithString:mRequestStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    //[theRequest valueForHTTPHeaderField:body];
    [theRequest setValue:self.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:self.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"GET"];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    DLog(@"Fit Bit Status %@", json_string);
    [self removeLoadView];
    BOOL isShow = YES;
    //0- Not Connected
    //1- Connected but not linked
    //2- Connected and linked
    if ([json_string intValue] ==2) {
        isShow = NO;// if connected, dont show FitBit Banner.
    }
    return isShow;
}
-(void)pushToFitBitViewController {
    FitBitViewController *fitBit = [[FitBitViewController alloc] initWithNibName:@"FitBitViewController" bundle:nil];
    UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:fitBit];
    self.mSlidingViewController.topViewController = NVGController;
    [self.mSlidingViewController resetTopView];

}
#pragma mark - Flurry
-(void)trackFlurryLogEvent:(NSString*)pageName {
    [Flurry logEvent:pageName];
    [Flurry logPageView];
}
-(void)trackFlurryLogEventForBanners:(NSString*)pageName {
    [Flurry logEvent:pageName];
}
@end
