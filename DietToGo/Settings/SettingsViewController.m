//
//  SettingsViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 07/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "SettingsViewController.h"
#import "PersonalSettingsViewController.h"
#import "DailyGoalsSettingViewController.h"
#import "StepTrackerSettingsViewController.h"
#import "MealPlannerSettingsViewController.h"
#import "JSON.h"

#define PERSONALSETTINGSTXT @"Personal Settings"
#define MEALPLANSETTINGTXT @"Meal Plan Settings"
#define DAILYGOALTXT @"Daily Goals"
#define ALERTSANDNOTITXT @"Alerts and Notifications"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize mTitlesArray;

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
    mAppDelegate = [AppDelegate appDelegateInstance];
    [mAppDelegate hideEmptySeparators:self.mTableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }

    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    
   int userType = [[loginUserDefaults objectForKey:USERTYPE] intValue];
    NSLog(@"userType %d",userType);
    if ( userType == 2) {
        mTitlesArray = [[NSMutableArray alloc]initWithObjects:PERSONALSETTINGSTXT,DAILYGOALTXT, nil];

    }else {
        mTitlesArray = [[NSMutableArray alloc]initWithObjects:PERSONALSETTINGSTXT,MEALPLANSETTINGTXT,DAILYGOALTXT, nil];
    }
    
    //@"Alerts and Notifications",
    //[[NSMutableArray alloc]initWithObjects:@"Personal Settings",@"Meal Plan Settings",@"Step Tracker Settings",@"Daily Goals", nil];//@"Alerts and Notifications",
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate.mTrackPages) {
       //self.trackedViewName=@"Settings page";
        [mAppDelegate trackFlurryLogEvent:@"Settings page"];
        
    }
    //end
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    [mAppDelegate setNavControllerTitle:NSLocalizedString(@"SETTINGS", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];
}
#pragma mark TableView Datasource and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.mTitlesArray.count;
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
        
        //TITLE LABEL
        UILabel *lLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 60)];
        lLbl.textAlignment = UITextAlignmentLeft;
        lLbl.font = Bariol_Bold(20);
        lLbl.textColor = BLACK_COLOR;
        lLbl.backgroundColor = CLEAR_COLOR;
        lLbl.tag = 1;
        [cell.contentView addSubview:lLbl];
        
        //arrow image
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(305-8.5, 30-(13/2), 8.5, 13)];
        lImgView.backgroundColor = CLEAR_COLOR;
        lImgView.image = [UIImage imageNamed:@"arrowright.png"];
        lImgView.tag = 2;
        [cell.contentView addSubview:lImgView];
    }
    
    //to get the instances
    UILabel *lLblIns = (UILabel*)[cell.contentView viewWithTag:1];
    lLblIns.text = [self.mTitlesArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString* seleccteRow = [self.mTitlesArray objectAtIndex:indexPath.row];
    
    if ([seleccteRow isEqualToString:PERSONALSETTINGSTXT]) {
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            [mAppDelegate.mRequestMethods_ postRequestToGetUserPersonalSettings:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance] displayNetworkMonitorAlert];
        }
    }else if ([seleccteRow isEqualToString:MEALPLANSETTINGTXT]){

        //This only for prospector..
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
                [mAppDelegate createLoadView];
                mAppDelegate.mRequestMethods_.mViewRefrence = self;
                [mAppDelegate.mRequestMethods_ postRequestTogetDemoMealPlan:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance] displayNetworkMonitorAlert];
            }
    } /*else if (indexPath.row == 2){
        StepTrackerSettingsViewController *lVc = [[StepTrackerSettingsViewController alloc]initWithNibName:@"StepTrackerSettingsViewController" bundle:nil];
        [self.navigationController pushViewController:lVc animated:TRUE];
    }*/
    else if ([seleccteRow isEqualToString:DAILYGOALTXT]){ //3 to 2
        [self postRequestToGetLookupCalorieLevel];
        
    } /*else if (indexPath.row == 4){
        //to retrieve the notifications
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            mAppDelegate.mRequestMethods_.mViewRefrence = self;
            NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
            NSString *mId = [mUserDefaults objectForKey:DEVICE_ID];
            //mId = @"-1";

            [mAppDelegate.mRequestMethods_ postRequestToGetNotifications:mId
                                                               AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }
    }*/
}
- (void)pushToSettingsPage
{
    PersonalSettingsViewController *lVC = [[PersonalSettingsViewController alloc]initWithNibName:@"PersonalSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:lVC animated:TRUE];

}
- (void)pushToGoalsPage{
    DailyGoalsSettingViewController *lVc = [[DailyGoalsSettingViewController alloc]initWithNibName:@"DailyGoalsSettingViewController" bundle:nil];
    mAppDelegate.mDailyGoalsSettingViewController = lVc;
    lVc.mParentClass = self;
    [self.navigationController pushViewController:lVc animated:TRUE];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMTableView:nil];
    [super viewDidUnload];
}
- (void)menuAction:(id)sender {
    [mAppDelegate showLeftSideMenu:self];
}

- (void)postRequestToGetLookupCalorieLevel {
    if ([mAppDelegate.mDataGetter_.mCalLevelList_ count] > 0) {
        [self postRequestToDailyGolasData];
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
    [self postRequestToDailyGolasData];
    }
}
- (void)postRequestToDailyGolasData {
    /* // Now No need for hitting personal setting API, as API for get calorie changed.-May 6,2014.
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"%@/%@", SETTINGS, PERSONAL];//[mRequestStr stringByAppendingFormat:@"%@/%@",SETTINGS, GoalTxt];
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
    
    [mAppDelegate.mTrackerDataGetter_.mDayStepDict_ removeAllObjects];
    mAppDelegate.mTrackerDataGetter_.mDayStepDict_ = [json_string JSONValue];
     NSLog(@"mAppDelegate.mTrackerDataGetter_.mDayStepDict_ %@",mAppDelegate.mTrackerDataGetter_.mDayStepDict_);
    */
    [self postRequestToDetRecommendedCalories];
}
- (void)postRequestToDetRecommendedCalories {
       /*
    NSString *mSelcetedGender = [mAppDelegate.mTrackerDataGetter_.mDayStepDict_ valueForKey:@"Gender"];
    NSString *mSelctedActivity = [mAppDelegate.mTrackerDataGetter_.mDayStepDict_ valueForKey:@"ActivityLevel"];
    NSString *mHeightFt = [mAppDelegate.mTrackerDataGetter_.mDayStepDict_ valueForKey:@"HeightFt"];
    NSString *mHeightInch = [mAppDelegate.mTrackerDataGetter_.mDayStepDict_ valueForKey:@"HeightInch"];
    NSString *mCurrentWeight = [mAppDelegate.mTrackerDataGetter_.mDayStepDict_ valueForKey:@"CurrentWeight"];
    NSString *mBirthDate = [mAppDelegate.mTrackerDataGetter_.mDayStepDict_ valueForKey:@"BirthDate"];
    
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"%@/%@/%@?gender=%@&heightFt=%@&heightIn=%@&weight=%@&birthDate=%@",SETTINGS, CALORIESTXT,mSelctedActivity,mSelcetedGender,mHeightFt,mHeightInch,mCurrentWeight,mBirthDate];
    */
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
@end
