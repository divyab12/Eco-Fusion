//
//  MenuViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 23/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "LogMealsViewController.h"
#import "WeightListViewController.h"
#import "MeasurementListViewController.h"
#import "LandingViewController.h"
#import "JSON.h"
#import "FitBitViewController.h"
#import "AccountManegerViewController.h"

#define HOME @"Home"
#define MENUMANAGEMT @"Menu Manager"
#define TRACKERS @"Trackers"
#define MEALTRACKER @"Meal Tracker"
#define WEIGHTTRACKER @"Weight Tracker"
#define STEPTRACKER @"Step Tracker"
#define EXERCISETRACKER @"Exercise Tracker"
#define MEASUREMENTTRACKER @"Measurement Tracker"
#define ACCOUNTMANAGEMENT @"Account Management"
#define PLANHOLDS @"Plan Holds"
#define SUPPORTREQUEST @"Support Request"
#define DEVICEMANAGER @"Device Manager"
#define DISCUSSIONFORUM @"Discussion Forum"
#define MENUSETTINGS @"Settings"
#define MENULOGOUT @"Logout"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize headerTitleArr;
@synthesize imagearray;
@synthesize selecteModule;

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
    // for setting the view below 20px in iOS7.0.
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    // Do any additional setup after loading the view from its nib.
    mAppDelegate = [AppDelegate appDelegateInstance];
    [mAppDelegate hideEmptySeparators:self.mTableview];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) {
        self.mBgImgView.frame = CGRectMake(0, 0, 320, 480);
        self.mTableview.frame = CGRectMake(0, 0, 320, 460);
        if ([[GenricUI instance] isiPhone5]) {
            self.mBgImgView.frame = CGRectMake(0, 0, 320, 548);
            self.mTableview.frame = CGRectMake(0, 0, 320, 548);
            self.mBgImgView.image = [UIImage imageNamed:@"menubg-568h@2x.png"];
        }
    }else{
        self.mBgImgView.frame = CGRectMake(0, 0, 320, 480);
        self.mTableview.frame = CGRectMake(0, 20, 320, 460);

        if ([[GenricUI instance] isiPhone5]) {
            self.mBgImgView.frame = CGRectMake(0, 0, 320, 568);
            self.mTableview.frame = CGRectMake(0, 20, 320, 548);
            self.mBgImgView.image = [UIImage imageNamed:@"menubg-568h@2x.png"];
        }
    }

    self.headerTitleArr = [[NSMutableArray alloc]initWithObjects:HOME,ACCOUNTMANAGEMENT,MENUMANAGEMT,PLANHOLDS,SUPPORTREQUEST, TRACKERS, MEALTRACKER, WEIGHTTRACKER, STEPTRACKER, EXERCISETRACKER, MEASUREMENTTRACKER, DEVICEMANAGER, DISCUSSIONFORUM, MENUSETTINGS, MENULOGOUT, nil];
    self.imagearray = [[NSMutableArray alloc]initWithObjects:@"DGT_home.png",@"DTG_accountmgmt.png",@"DGT_menumgmt.png",@"DTG_planholds.png",@"STG_supportrequest.png", @"DGT_trackers.png", @"DGT_mealplan.png", @"DGT_weighttracker.png", @"DGT_steptracker.png", @"DGT_exercisetracker.png", @"DGT_measurementtracker.png", @"DGT_devicemgr.png", @"DGT_discussionforum.png", @"DGT_settings.png", @"DGT_logout@2x.png", nil];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //for tracking
    if (mAppDelegate.mTrackPages) {
        //self.trackedViewName=@"Main Menu";
        [mAppDelegate trackFlurryLogEvent:@"Main Menu"];
        
    }
}
#pragma mark TABLE VIEW DELEGATE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       
    return  50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.headerTitleArr count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.clearsContextBeforeDrawing=TRUE;
        
        //image view
        UIImageView *limage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
        limage.tag = 1;
        limage.backgroundColor = CLEAR_COLOR;
        [cell.contentView addSubview:limage];
        //Label
        UILabel *headerTitle=[[UILabel alloc]initWithFrame:CGRectMake(55, 15, 175, 30)];
        [headerTitle setBackgroundColor:[UIColor clearColor]];
        [headerTitle setFont:Bariol_Regular(18)];
        //headerTitle.numberOfLines = 0;
        //headerTitle.lineBreakMode = LINE_BREAK_WORD_WRAP;
        headerTitle.tag =2;
        [headerTitle setTextColor:[UIColor whiteColor]];
        
        [cell.contentView addSubview:headerTitle];
        
        if (indexPath.row == 2 ||indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10) {
            
            CGRect lFrame = limage.frame;
            lFrame.origin.x +=20;
            limage.frame = lFrame;
            
            lFrame = headerTitle.frame;
            lFrame.origin.x +=20;
            headerTitle.frame = lFrame;
        }
        
        //line image
        UIImageView *lImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, cell.frame.origin.y, 210+5, 1)];
        lImage1.tag = 3;
        if (indexPath.row != 0) {
            [cell.contentView addSubview:lImage1];
        }
        
    }
    cell.backgroundColor = CLEAR_COLOR;
    
    UIImageView *limage1 = (UIImageView*)[cell.contentView viewWithTag:1];
    UILabel *lTextLabel= (UILabel*)[cell.contentView viewWithTag:2];
    UIImageView *lLineImg = (UIImageView*)[cell.contentView viewWithTag:3];
    lLineImg.image = [UIImage imageNamed:@"divider.png"];
    
    [limage1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.imagearray objectAtIndex:indexPath.row]]]];
    [lTextLabel setText:[NSString stringWithFormat:@"%@",[self.headerTitleArr objectAtIndex:indexPath.row]]];
    
    
    UIView *lSelectedView_ = [[UIView alloc] initWithFrame:cell.frame];
    lSelectedView_.backgroundColor = DTG_MAROON_COLOR;
    cell.selectedBackgroundView = lSelectedView_;
    
    if (indexPath.row == [self.headerTitleArr count] - 1) {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"EHEandME://"]];
    //return;
    
    selecteModule = @"";
    if (indexPath.row == [self.headerTitleArr count]-1) {
        //post request for logout
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
           //Wrote this method for now, as we dont have logout API.
           // [self logoutAction];
            
             [mAppDelegate createLoadView];
            [mAppDelegate.mRequestMethods_ postRequestToLogout:mAppDelegate.mResponseMethods_.authToken 
                                                  SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
            
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }else if ([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:HOME]){
        //to move user to settings page
        LandingViewController *lVC = [[LandingViewController alloc]initWithNibName:@"LandingViewController" bundle:nil];
        UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
        mAppDelegate.mLandingViewController = lVC;
        mAppDelegate.mSlidingViewController.topViewController = NVGController;
        [mAppDelegate.mSlidingViewController resetTopView];
        return;

    }
    //Messages
    else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:@"Messages"]){
        //to check if has meal plan settings or not
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetMessagesList:@"Inbox"
                                                                   Page:@"1"
                                                             UnreadOnly:@"false"
                                                              AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                           SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        return;
    }
    else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:MEALTRACKER]|| [[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:TRACKERS]){
       
        LogMealsViewController *lVC = [[LogMealsViewController alloc]initWithNibName:@"LogMealsViewController" bundle:nil];
        mAppDelegate.mLogMealsViewController = lVC;
        UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:mAppDelegate.mLogMealsViewController];
        mAppDelegate.mSlidingViewController.topViewController = NVGController;
        [mAppDelegate.mSlidingViewController resetTopView];
        
        //Commenting - April 16
        /*//to check if has meal plan settings or not
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToCheckUserMealPlanSettings:mAppDelegate.mResponseMethods_.authToken
                                                                     SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }*/
        return;
        
        

    }//My Goals
    else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:@"My Goals"]){
        
        //to retrieve goal steps
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetGoalSteps:mAppDelegate.mResponseMethods_.authToken
                                                        SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        
    }
    else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:WEIGHTTRACKER]){
       
        selecteModule = WEIGHTTRACKER;
        [self postRequestToDailyGolasData];
        return;
        
    }else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:MEASUREMENTTRACKER]){
        selecteModule = MEASUREMENTTRACKER;
        [self postRequestToDailyGolasData];
        return;
    }else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:@"Water Tracker"]){
        //to get the water log
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetWaterLogs:mAppDelegate.mResponseMethods_.authToken
                                                        SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

        
    }else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:EXERCISETRACKER]){
        selecteModule =  EXERCISETRACKER;
        [self postRequestToDailyGolasData];
        return;
    }else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:@"Blood Glucose Tracker"]){
        //to get the glucose log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetGlucoseChartData:@"Week"
                                                                   AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                                SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        return;
    }else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:@"My Journal"]){
        //to get the exercise day log
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
                        
            [mAppDelegate.mRequestMethods_ postRequestToGetJournalLogs:mAppDelegate.mResponseMethods_.authToken
                                                         SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        return;
    }else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:@"Cholesterol Tracker"]){
        //to get the measurement log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetCholesterolChartData:@"Week"
                                                                   AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                                SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

    }
    else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:@"BMI Tracker"]){
        //to get the BMI log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetBMIChartData:@"Week"
                                                              AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                           SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        
    } else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:STEPTRACKER]){
        selecteModule = STEPTRACKER;
        [self postRequestToDailyGolasData];
        return;
    } else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:MENUSETTINGS]){
        
        //to move user to settings page
        SettingsViewController *lVC = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
        UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:lVC];
        mAppDelegate.mSettingsViewController = lVC;
        mAppDelegate.mSlidingViewController.topViewController = NVGController;
        [mAppDelegate.mSlidingViewController resetTopView];
        return;
    }
    else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:DEVICEMANAGER]){
        [mAppDelegate pushToFitBitViewController];
    }
    else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:DISCUSSIONFORUM]){
        //to get Catogory data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestForcategory:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];

        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        
    }
    //Account Manger
    else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:ACCOUNTMANAGEMENT]){
        [self pushToAccountManeger:1];
    }else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:MENUMANAGEMT]){
        [self pushToAccountManeger:2];
    }else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:PLANHOLDS]){
        [self pushToAccountManeger:3];
    }else if([[self.headerTitleArr objectAtIndex:indexPath.row] isEqualToString:SUPPORTREQUEST]){
        [self pushToAccountManeger:4];
    }
    

}
-(void)pushToAccountManeger:(int)index {
    AccountManegerViewController *maneger = [[AccountManegerViewController alloc] initWithNibName:@"AccountManegerViewController" WithIndex:index];
    UINavigationController *NVGController = [[UINavigationController alloc] initWithRootViewController:maneger];
    mAppDelegate.mSlidingViewController.topViewController = NVGController;
    [mAppDelegate.mSlidingViewController resetTopView];
}
-(void)logoutAction {

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
        [loginUserDefaults setValue:nil forKey:DTGDevSession_Token];
        [loginUserDefaults synchronize];
        
        mAppDelegate.mResponseMethods_.userName = nil;
        mAppDelegate.mResponseMethods_.authToken = nil;
        mAppDelegate.mResponseMethods_.sessionToken = nil;
        mAppDelegate.mResponseMethods_.userType =nil;
        [mAppDelegate.mGenericDataBase_ clearGoalOrder];
        [mAppDelegate.mGenericDataBase_ clearTrackerOrder];
        [mAppDelegate displayLoginView];

}
- (void)postRequestToDailyGolasData {
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"%@/%@",SETTINGS, GoalTxt];
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
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
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    
    [mAppDelegate.mTrackerDataGetter_.mDayStepDict_ removeAllObjects];
    mAppDelegate.mTrackerDataGetter_.mDayStepDict_ = [json_string JSONValue];

    [self performSelectorOnMainThread:@selector(parseGetPersonalSettings:) withObject:nil waitUntilDone:NO];
    
    
}
- (void)parseGetPersonalSettings:(NSObject *) isSucces {
    //[mAppDelegate removeLoadView];
    NSLog(@"mAppDelegate.mTrackerDataGetter_.mDayStepDict_ %@",mAppDelegate.mTrackerDataGetter_.mDayStepDict_);
    if ([selecteModule isEqualToString:WEIGHTTRACKER]) {
        //to get the weight log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetWeightChartData:@"Week"
                                                                 AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                              SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        
    } else if ([selecteModule isEqualToString:STEPTRACKER]) {
        //to get the step log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetStepChartData:@"Week"
                                                               AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        
    } else if ([selecteModule isEqualToString:EXERCISETRACKER]) {
        //to get the exercise log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetExerciseChartData:@"Week"
                                                                   AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                                SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
        
    } else if ([selecteModule isEqualToString:MEASUREMENTTRACKER]) {
        //to get the weight log chart data
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetMeasurementChartData:@"Week"
                                                                      AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                                   SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMBgImgView:nil];
    [super viewDidUnload];
}
@end
