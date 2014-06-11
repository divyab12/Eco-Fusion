//
//  LoginViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 23/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "LoginViewController.h"
#define gender @"Male,Female"
#define Height @"0,1,2,3,4,5,6,7,8,9,10,11"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize mIndicatorView_;
@synthesize mTitlesArray;
@synthesize mDetailsDict;
@synthesize mActiveTxtFld_,mRowValueintheComponent,mTxtFldsArray;

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
    mAppDelegate_ = [AppDelegate appDelegateInstance];
    
    // for setting the view below 20px in iOS7.0.
    [mAppDelegate_ hideEmptySeparators:self.mTableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    mTitlesArray = [[NSMutableArray alloc]initWithObjects:@"Start Weight",@"Height",@"Gender",@"Goal Weight", @"Date of Birth",@"Activity Level",@"Select a Goal", nil];
    mDetailsDict = [[NSMutableDictionary alloc]init];
    mTxtFldsArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *lArr=[[NSMutableArray alloc] init];
    self.mRowValueintheComponent=lArr;
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    self.mWelcumLbl.font = Bariol_Regular(20);
    self.mWelcumLbl.textColor = RGB_A(86, 93, 93, 1);
    self.mAssistLbl.font = Bariol_Regular(18);
    self.mAssistLbl.textColor = RGB_A(86, 93, 93, 1);
    self.mEmailLbl.font = Bariol_Regular(18);
    self.mEmailLbl.textColor = RGB_A(5, 137, 193, 1);
    self.mPhNumLbl.font = Bariol_Regular(18);
    self.mPhNumLbl.textColor = RGB_A(86, 93, 93, 1);
    self.mTextLbl.font = Bariol_Regular(17);
    self.mTitleLbl.font = Bariol_Regular(22);
    self.mTitleLbl.textColor = RGB_A(114, 105, 89, 1);
    
    //Set Controls for Login Web page View
    NSString *imgName =@"";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
         imgName = @"topbar.png";
        if ([[GenricUI instance] isiPhone5]) {
            self.mLoginWebPageView.frame = CGRectMake(0, 0, 320, 568);
        }else {
            self.mLoginWebPageView.frame = CGRectMake(0, 0, 320, 480);
        }
    }else {
         imgName = @"topbar1.png";
        if ([[GenricUI instance] isiPhone5]) {
            self.mLoginWebPageView.frame = CGRectMake(0, 0, 320, 548);
        }else {
            self.mLoginWebPageView.frame = CGRectMake(0, 0, 320, 460);
            
        }
    }
    self.mLoginWebPageBGImg.image = [UIImage imageNamed:imgName];
    self.mLoginWebPageBGImg.frame = CGRectMake(0, 0, 320, [UIImage imageNamed:imgName].size.height);
    
    self.mWebView.frame = CGRectMake(0, self.mLoginWebPageBGImg.frame.size.height, 320, (self.mLoginWebPageView.frame.size.height - self.mLoginWebPageBGImg.frame.size.height));
    
    self.mLoginwebPagTitle.frame = CGRectMake(0, 0, 320, self.mLoginwebPagTitle.frame.size.height);
    self.mLoginWebPageBackBtn.frame = CGRectMake(self.mLoginWebPageBackBtn.frame.origin.x, (self.mLoginWebPageBGImg.frame.size.height-self.mLoginWebPageBackBtn.frame.size.height)/2, self.mLoginWebPageBackBtn.frame.size.width, self.mLoginWebPageBackBtn.frame.size.height);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        self.mLoginwebPagTitle.frame = CGRectMake(0, 20, 320, self.mLoginwebPagTitle.frame.size.height);
        self.mLoginWebPageBackBtn.frame = CGRectMake(self.mLoginWebPageBackBtn.frame.origin.x, (self.mLoginWebPageBGImg.frame.size.height-self.mLoginWebPageBackBtn.frame.size.height)/2 +10, self.mLoginWebPageBackBtn.frame.size.width, self.mLoginWebPageBackBtn.frame.size.height);
    }
    self.mLoginwebPagTitle.font = OpenSans_Bold(22);
    self.mLoginwebPagTitle.textColor = DTG_MAROON_COLOR;
    self.mLoginwebPagTitle.textAlignment = TEXT_ALIGN_CENTER;
  
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:TRUE];
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Welcome Landing page";
        [mAppDelegate_ trackFlurryLogEvent:@"Welcome Landing page"];
    }
    //end
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark web view delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([request.URL.absoluteString rangeOfString:@"register"].location != NSNotFound ) {
            self.mLoginwebPagTitle.text = @"Register";
        } else if([request.URL.absoluteString rangeOfString:@"reset"].location != NSNotFound ){
            self.mLoginwebPagTitle.text = @"Password Assistance";
        }
        isRemoveCookie = YES;
        NavigationTypeLinkClicked = YES;
        if ([request.URL.absoluteString rangeOfString:@"account"].location != NSNotFound ) {
            NavigationTypeLinkClicked = NO;
        }
        mCounter = 0;
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *each in cookieStorage.cookies) {
            [cookieStorage deleteCookie:each];
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    self.mIndicatorView_.hidden = FALSE;
    [self.mIndicatorView_ startAnimating];
    [self.view bringSubviewToFront:self.mIndicatorView_];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"absoluteString %@",webView.request.URL.absoluteString);
    if (!NavigationTypeLinkClicked) {
    NSMutableArray *cookies = [NSMutableArray array];
    
    if (isRemoveCookie) {
        //staging
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *each in cookieStorage.cookies) {
            [cookieStorage deleteCookie:each];
        }
        isRemoveCookie = FALSE;
    }
    /*
    if ([webView.request.URL.absoluteString isEqualToString:@"https://staging.diettogo.com/wl-app-login?p=register"]) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *each in cookieStorage.cookies) {
            [cookieStorage deleteCookie:each];
        }
    }*/
    NSString *cookieKey = loginCookieKey;
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableDictionary *mCookiesDict = [[NSMutableDictionary alloc]init];
    for (cookie in [cookieJar cookies]) {
       // if ([[cookie domain] isEqualToString:self.domain])
        {
            if ([[cookie name] isEqualToString:cookieKey]) {
                [cookies addObject:cookie];
                [mCookiesDict setValue:[cookie value] forKey:[cookie name]];
            }
        }
    }
    if ([mCookiesDict count] >0) {
        DLog(@"successful message %@",mCookiesDict);
        self.mLoginWebPageView.hidden = TRUE;
        self.mIndicatorView_.hidden = TRUE;
        [self.mIndicatorView_ stopAnimating];
        
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            NSString *sessionKey = [mCookiesDict objectForKey:cookieKey];
            NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
            [loginUserDefaults setValue:sessionKey forKey:DTGDevSession_Token];
            [loginUserDefaults synchronize];
                
            [mAppDelegate_.mRequestMethods_ postRequestToValidateCookies:sessionKey
                                                                      SV:@""
                                                                      CD:@""];
        }else{
            [[NetworkMonitor instance] displayNetworkMonitorAlert];
        }
        return;
    }else if(mCounter > 0 && [mCookiesDict count] == 0){
        DLog(@"error occured");
        [UtilitiesLibrary showAlertViewWithTitle:@"Sign In Failed" :@"Please check your User ID and password."];
        self.mLoginWebPageView.hidden = TRUE;
        self.mIndicatorView_.hidden = TRUE;
        [self.mIndicatorView_ stopAnimating];
        return;
        
    }
    self.mLoginWebPageView.hidden = FALSE;
    self.mIndicatorView_.hidden = TRUE;
    [self.mIndicatorView_ stopAnimating];
    mCounter++;
    }
    self.mLoginWebPageView.hidden = FALSE;
    self.mIndicatorView_.hidden = TRUE;
    [self.mIndicatorView_ stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (![[NetworkMonitor instance] isNetworkAvailable]) {
        [[NetworkMonitor instance] displayNetworkMonitorAlert];

    }
    self.mIndicatorView_.hidden = TRUE;
    [self.mIndicatorView_ stopAnimating];

}

#pragma mark --

- (IBAction)loginAction:(id)sender {
//   
//    if ([[NetworkMonitor instance]isNetworkAvailable]) {
//        [mAppDelegate_ createLoadView];
//        [mAppDelegate_.mRequestMethods_ postRequestForLoginWithUserID:@"100004"
//                                                             UserName:@""
//                                                              CoachID:@""];
//        }else{
//            [[NetworkMonitor instance] displayNetworkMonitorAlert];
//    }
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    mCounter = 0;
    NavigationTypeLinkClicked = FALSE;
    if ( [LOGINURL isEqualToString:@"https://diettogo.com/log-in"] || [LOGINURL isEqualToString:@"https://staging.diettogo.com/wl-app-login"] ) {
    //if ([LOGINURL isEqualToString:@"https://staging.diettogo.com/wl-app-login"]) {
        isRemoveCookie = YES;
        loginCookieKey = @"PHPSESSID";
    } else {
        isRemoveCookie = NO;
        loginCookieKey = @"DTGDevSession";
    }
    [self.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:LOGINURL]]];
    self.mLoginwebPagTitle.text = @"Login";
}
- (IBAction)newUserAction:(id)sender {
    NavigationTypeLinkClicked = YES;
    self.mLoginwebPagTitle.text = @"Register";
    [self.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:REGISTRATIONURL]]];
}
- (IBAction)continueAction:(id)sender {
    if (self.mActiveTxtFld_!=nil) {
        [self.mActiveTxtFld_ resignFirstResponder];
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
    DLog(@"%@",self.mDetailsDict);
    //for validations
    if ([[[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:0]] stringByReplacingOccurrencesOfString:@" lbs" withString:@""] isEqualToString:@"0.0"]) {
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please enter your start weight."];
        return;
    }else if ([[[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:1]] stringByReplacingOccurrencesOfString:@" ft" withString:@""] isEqualToString:@"0.0"]){
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please enter your height."];
        return;
    }else if ([[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:2]] intValue]<1){
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please select your gender."];
        return;
    }else if ([[[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:3]] stringByReplacingOccurrencesOfString:@" lbs" withString:@""] isEqualToString:@"0.0"]){
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please enter your goal weight."];
        return;
    }else if ([self.mDetailsDict objectForKey:@"Activity Level"] == nil || [[self.mDetailsDict objectForKey:@"Activity Level"] isEqualToString:@""]){
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please select your activity level."];
        return;
    }/* //Change-1
    else if ([self.mDetailsDict objectForKey:@"Select a Goal"] == nil || [[self.mDetailsDict objectForKey:@"Select a Goal"] isEqualToString:@""]){
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please select your goal type."];
        return;
    }*/
    //end
    
    NSString *mHeight = [self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:1]];
    mHeight = [mHeight stringByReplacingOccurrencesOfString:@" ft" withString:@""];
    NSArray *mArray = [mHeight componentsSeparatedByString:@"."];
    
    NSString *mDOB = [self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:4]];
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [lFormatter setDateFormat:@"MMM. dd, yyyy"];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    NSDate *lDate =[lFormatter dateFromString:mDOB];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    mDOB = [lFormatter stringFromDate:lDate];
    
    NSString *mActivity=@"7";
    for (int iLevelCnt =0 ; iLevelCnt < mAppDelegate_.mDataGetter_.mActivityLevelList_.count; iLevelCnt++) {
        if ([[[mAppDelegate_.mDataGetter_.mActivityLevelList_ objectAtIndex:iLevelCnt] objectForKey:@"Value"] isEqualToString: [self.mDetailsDict objectForKey:@"Activity Level"]] ) {
            mActivity = [[mAppDelegate_.mDataGetter_.mActivityLevelList_ objectAtIndex:iLevelCnt] objectForKey:@"Code"];
        }
    }
    NSString *mCurrentWeight = [mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"CurrentWeight"];
    /* //Change-2
    NSString *mGoal = [self.mDetailsDict objectForKey:@"Select a Goal"];
    for (int iLevelCnt =0 ; iLevelCnt < mAppDelegate_.mDataGetter_.mMealGoalList_.count; iLevelCnt++) {
        if ([[[mAppDelegate_.mDataGetter_.mMealGoalList_ objectAtIndex:iLevelCnt] objectForKey:@"Value"] isEqualToString:[self.mDetailsDict objectForKey:@"Select a Goal"]] ) {
            mGoal = [[mAppDelegate_.mDataGetter_.mMealGoalList_ objectAtIndex:iLevelCnt] objectForKey:@"Code"];
        }
    }*/
    
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestToUpdateUserPersonalSettings:mAppDelegate_.mResponseMethods_.authToken
                                                                  SessionToken:mAppDelegate_.mResponseMethods_.sessionToken
                                                                   StartWeight:[[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:0]] stringByReplacingOccurrencesOfString:@" lbs" withString:@""]
                                                                    GoalWeight:[[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:3]] stringByReplacingOccurrencesOfString:@" lbs" withString:@""]
                                                                  HeightInches:[mArray objectAtIndex:1]
                                                                   HeightFeets:[mArray objectAtIndex:0]
                                                                        Gender:[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:2]]
                                                                 ActivityLevel:mActivity
                                                                          Goal:mCurrentWeight
                                                                           DOB:mDOB];
        //Change-3: mGoal to mCurrentWeight
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
}
- (IBAction)backSettingAction:(id)sender{
    [mAppDelegate_ displayLoginView];
}
- (void)displayPersonalSettingsView{
    self.mLoginWebPageView.hidden = TRUE;
    self.mIndicatorView_.hidden = TRUE;
    self.mLoginLandingView.hidden = TRUE;
    
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"topbar.png";
         if ([[GenricUI instance] isiPhone5]) {
             self.mUserInfoView.frame = CGRectMake(0, 0, 320, 568);
         }else{
              self.mUserInfoView.frame = CGRectMake(0, 0, 320, 480);
         }
    }else{
        imgName = @"topbar1.png";
        if ([[GenricUI instance] isiPhone5]) {
            self.mUserInfoView.frame = CGRectMake(0, 0, 320, 548);
        }else{
            self.mUserInfoView.frame = CGRectMake(0, 0, 320, 460);
        }
    }

    self.mUserInfoView.hidden = FALSE;
    self.mUserInfoView.backgroundColor = CLEAR_COLOR;
    [self.view bringSubviewToFront:self.mUserInfoView];
    self.mImgView.image = [UIImage imageNamed:imgName];
    self.mImgView.frame = CGRectMake(0, 0, 320, [UIImage imageNamed:imgName].size.height);
    
    self.mTitleLbl.frame = CGRectMake(0, 0, 320, self.mTitleLbl.frame.size.height);
    self.mContinueBtn.frame = CGRectMake(self.mContinueBtn.frame.origin.x, (self.mImgView.frame.size.height-self.mContinueBtn.frame.size.height)/2, self.mContinueBtn.frame.size.width, self.mContinueBtn.frame.size.height);
    self.mBackSettingBtn.frame = CGRectMake(self.mBackSettingBtn.frame.origin.x, (self.mImgView.frame.size.height-self.mBackSettingBtn.frame.size.height)/2, self.mBackSettingBtn.frame.size.width, self.mBackSettingBtn.frame.size.height);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        // self.mTitleLbl.backgroundColor = RED_COLOR;
        self.mTitleLbl.frame = CGRectMake(0, 20, 320, self.mTitleLbl.frame.size.height);
        self.mContinueBtn.frame = CGRectMake(self.mContinueBtn.frame.origin.x, (self.mImgView.frame.size.height-self.mContinueBtn.frame.size.height)/2 +10, self.mContinueBtn.frame.size.width, self.mContinueBtn.frame.size.height);
        self.mBackSettingBtn.frame = CGRectMake(self.mBackSettingBtn.frame.origin.x, (self.mImgView.frame.size.height-self.mBackSettingBtn.frame.size.height)/2 +10, self.mBackSettingBtn.frame.size.width, self.mBackSettingBtn.frame.size.height);
    }

    self.mScrollView.frame = CGRectMake(0, self.mImgView.frame.origin.y+self.mImgView.frame.size.height+20, 320, self.view.frame.size.height-(self.mImgView.frame.origin.y+self.mImgView.frame.size.height+20));
    self.mScrollView.contentSize = CGSizeMake(320, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+20);
    [self loadDetails];
    [self.mTableView reloadData];

    
}
- (void)loadDetails
{
    [self.mDetailsDict removeAllObjects];
    [self.mTxtFldsArray removeAllObjects];
    //start weight
    [mDetailsDict setValue:[NSString stringWithFormat:@"%.1f lbs",[[mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"StartWeight"] floatValue]] forKey:[mTitlesArray objectAtIndex:0]];
    
    //Height
    [mDetailsDict setValue:[NSString stringWithFormat:@"%d.%d ft", [[mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"HeightFt"] intValue], [[mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"HeightInch"] intValue]] forKey:[mTitlesArray objectAtIndex:1]];
    //Gender
    [mDetailsDict setValue:[NSString stringWithFormat:@"%d",[[mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"Gender"] intValue]] forKey:[mTitlesArray objectAtIndex:2]];
    //goal weight
    [mDetailsDict setValue:[NSString stringWithFormat:@"%.1f lbs",[[mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"GoalWeight"] floatValue]] forKey:[mTitlesArray objectAtIndex:3]];
    //date of birth
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    
    NSDate *lDate = [lFormatter dateFromString:@"2000-01-01T00:00:00"];
    //[lFormatter dateFromString:[mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"BirthDate"]];//DateOfBirth
    [lFormatter setDateFormat:@"MMM. dd, yyyy"];
    [mDetailsDict setValue:[lFormatter stringFromDate:lDate] forKey:[mTitlesArray objectAtIndex:4]];
    
    //ActivityLevel
    NSString *mStr;
    
    for (int iLevelCnt =0 ; iLevelCnt < mAppDelegate_.mDataGetter_.mActivityLevelList_.count; iLevelCnt++) {
        if ([[[mAppDelegate_.mDataGetter_.mActivityLevelList_ objectAtIndex:iLevelCnt] objectForKey:@"Code"] intValue] == [[mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"ActivityLevel"] intValue]) {
            mStr = [[mAppDelegate_.mDataGetter_.mActivityLevelList_ objectAtIndex:iLevelCnt] objectForKey:@"Value"];
            
        }
    }
    [mDetailsDict setValue:mStr forKey:[mTitlesArray objectAtIndex:5]];
    
    //goal
    mStr = @"";
    for (int iLevelCnt =0 ; iLevelCnt < mAppDelegate_.mDataGetter_.mMealGoalList_.count; iLevelCnt++) {
        if ([[[mAppDelegate_.mDataGetter_.mMealGoalList_ objectAtIndex:iLevelCnt] objectForKey:@"Code"] intValue] == [[mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"MealGoal"] intValue]) {
            mStr = [[mAppDelegate_.mDataGetter_.mMealGoalList_ objectAtIndex:iLevelCnt] objectForKey:@"Value"];
            
        }
    }
    [mDetailsDict setValue:mStr forKey:[mTitlesArray objectAtIndex:6]];
    
    
}
#pragma mark TableView Datasource and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.mTitlesArray.count-1; //Change-4
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
        //cell.selectedBackgroundView = lSelectedView_;
        lSelectedView_=nil;
        
        //TITLE LABEL
        UILabel *lLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 120, 50)];
        lLbl.textAlignment = UITextAlignmentLeft;
        lLbl.font = Bariol_Regular(17);
        lLbl.textColor = RGB_A(136, 136, 136, 1);
        lLbl.backgroundColor = CLEAR_COLOR;
        lLbl.tag = 1;
        [cell.contentView addSubview:lLbl];
        
        
        if (indexPath.row!=2) {
            UITextField *lTxtFld = [[UITextField alloc]initWithFrame:CGRectMake(285-120, 16, 120, 28)];
            lTxtFld.textAlignment = UITextAlignmentRight;
            lTxtFld.font = Bariol_Regular(17);
            lTxtFld.textColor = BLACK_COLOR;
            lTxtFld.tag = indexPath.row + 3;
            lTxtFld.backgroundColor = CLEAR_COLOR;
            lTxtFld.delegate = self;
            if (indexPath.row == 0 ||indexPath.row == 3) {
                lTxtFld.keyboardType = UIKeyboardTypeDecimalPad;
                [Utilities addInputViewForKeyBoardForTextFld:lTxtFld Class:self];
            }
            [cell.contentView addSubview:lTxtFld];
            
        }else{
            //lFemale btn
            UIButton *lBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(132, 10, 30, 30)];
            [lBtn1 addTarget:self action:@selector(femaleAction:) forControlEvents:UIControlEventTouchUpInside];
            lBtn1.backgroundColor = CLEAR_COLOR;
            
            if ([[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:indexPath.row]] intValue] == 2) {
                lBtn1.selected = TRUE;
                [lBtn1 setImage:[UIImage imageNamed:@"radiobtnactive.png"] forState:UIControlStateNormal];
                
            }else{
                lBtn1.selected = FALSE;
                [lBtn1 setImage:[UIImage imageNamed:@"in.png"] forState:UIControlStateNormal];
                
            }
            [cell.contentView addSubview:lBtn1];
            
            //label
            UILabel *lfLbl = [[UILabel alloc]initWithFrame:CGRectMake(lBtn1.frame.origin.x+lBtn1.frame.size.width+10, 15, 60, 20)];
            lfLbl.text = @"Female";
            lfLbl.textAlignment = UITextAlignmentLeft;
            lfLbl.font = Bariol_Regular(15);
            lfLbl.textColor = BLACK_COLOR;
            lfLbl.backgroundColor = CLEAR_COLOR;
            [cell.contentView addSubview:lfLbl];
            
            //male btn
            UIButton *lBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(lfLbl.frame.origin.x+lfLbl.frame.size.width+5, 10, 30, 30)];
            [lBtn2 addTarget:self action:@selector(maleAction:) forControlEvents:UIControlEventTouchUpInside];
            lBtn2.backgroundColor = CLEAR_COLOR;
            
            if ([[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:indexPath.row]] intValue] == 1) {
                lBtn2.selected = TRUE;
                [lBtn2 setImage:[UIImage imageNamed:@"radiobtnactive.png"] forState:UIControlStateNormal];
            }else{
                lBtn2.selected = FALSE;
                [lBtn2 setImage:[UIImage imageNamed:@"in.png"] forState:UIControlStateNormal];
            }
            [cell.contentView addSubview:lBtn2];
            
            //label
            UILabel *lmLbl = [[UILabel alloc]initWithFrame:CGRectMake(lBtn2.frame.origin.x+lBtn2.frame.size.width+10, 15, 40, 20)];
            lmLbl.text = @"Male";
            lmLbl.textAlignment = UITextAlignmentLeft;
            lmLbl.font = Bariol_Regular(15);
            lmLbl.textColor = BLACK_COLOR;
            lmLbl.backgroundColor = CLEAR_COLOR;
            [cell.contentView addSubview:lmLbl];
            
        }
        
        //arrow image
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(305-8.5, 25-(13/2), 8.5, 13)];
        lImgView.backgroundColor = CLEAR_COLOR;
        lImgView.image = [UIImage imageNamed:@"arrowright.png"];
        lImgView.tag = 2;
        
        if (indexPath.row == 2) {
            lImgView.hidden = TRUE;
        }
        [cell.contentView addSubview:lImgView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //to get the instances
    UILabel *lLblIns = (UILabel*)[cell.contentView viewWithTag:1];
    lLblIns.text = [self.mTitlesArray objectAtIndex:indexPath.row];
    
    if (indexPath.row!=2) {
        //text label
        UITextField *lValFldIns = (UITextField*)[cell.contentView viewWithTag:3+indexPath.row];
        lValFldIns.text = [self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.mTxtFldsArray addObject:lValFldIns];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row!=2) {
    
        UITableViewCell* selectedCell = [self.mTableView cellForRowAtIndexPath:indexPath];
        UITextField *lLbl2 = (UITextField*)[selectedCell.contentView viewWithTag:indexPath.row+3];
        [lLbl2 becomeFirstResponder];
    }
    
   
    
}
- (void)maleAction:(UIButton*)lbtn{
    if (lbtn.selected) {
        [mDetailsDict setValue:@"2" forKey:[mTitlesArray objectAtIndex:2]];
    }else{
        [mDetailsDict setValue:@"1" forKey:[mTitlesArray objectAtIndex:2]];
        
    }
    [self.mTableView reloadData];
}
- (void)femaleAction:(UIButton*)lbtn{
    if (lbtn.selected) {
        [mDetailsDict setValue:@"1" forKey:[mTitlesArray objectAtIndex:2]];
    }else{
        [mDetailsDict setValue:@"2" forKey:[mTitlesArray objectAtIndex:2]];
        
    }
    [self.mTableView reloadData];
}

# pragma mark ***** TextFieldDelegatemethods *****
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag-3 == 0 || textField.tag-3 ==3) {
        UIEdgeInsets contentInsets;
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217+55 , 0.0);
        
        self.mScrollView.contentInset = contentInsets;
        self.mScrollView.scrollIndicatorInsets = contentInsets;
        CGRect lFrame;
        lFrame=[self.mScrollView convertRect:textField.bounds fromView:textField];
        [self.mScrollView scrollRectToVisible:lFrame animated:NO];
        

        return YES;
    }else{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.mScrollView.contentInset = contentInsets;
        self.mScrollView.scrollIndicatorInsets = contentInsets;

        if (self.mActiveTxtFld_!=nil) {
            [self.mActiveTxtFld_ resignFirstResponder];
        }
        self.mActiveTxtFld_ = textField;
        if (textField.tag-3 == 1) {
            mTextInToolBar=@"Select Height";
            NSArray *lRowValueArr=[Height componentsSeparatedByString:@","];
            [self.mRowValueintheComponent removeAllObjects];
            [self.mRowValueintheComponent addObject:lRowValueArr];
            [self.mRowValueintheComponent addObject:lRowValueArr];
            [self displayPickerview];
        }else if(textField.tag -3 == 5){
            mTextInToolBar=@"Select how active";
            NSMutableArray *mArray = [[NSMutableArray alloc]init];
            for (int i=0; i<mAppDelegate_.mDataGetter_.mActivityLevelList_.count; i++) {
                [mArray addObject:[[mAppDelegate_.mDataGetter_.mActivityLevelList_ objectAtIndex:i] objectForKey:@"Value"]];
            }
            [self.mRowValueintheComponent removeAllObjects];
            [self.mRowValueintheComponent addObject:mArray];
            [self displayPickerview];
            
            
        }else if(textField.tag -3 == 6){
            mTextInToolBar=@"Select a Goal";
            NSMutableArray *mArray = [[NSMutableArray alloc]init];
            for (int i=0; i<mAppDelegate_.mDataGetter_.mMealGoalList_.count; i++) {
                [mArray addObject:[[mAppDelegate_.mDataGetter_.mMealGoalList_ objectAtIndex:i] objectForKey:@"Value"]];
            }
            [self.mRowValueintheComponent removeAllObjects];
            [self.mRowValueintheComponent addObject:mArray];
            [self displayPickerview];
            
            
        }else if(textField.tag-3 == 4){
            [self displayDatePicker];
        }
    }
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" lbs" withString:@""];
    self.mActiveTxtFld_ = textField;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength;
    newLength = [textField.text length] + [string length] - range.length;
    
    if(newLength > 5){
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length != 0) {
        textField.text = [NSString stringWithFormat:@"%.1f lbs", [textField.text floatValue]];
        
    }else{
        if (textField.tag == 3) {
            //start weight
            self.mActiveTxtFld_.text = [NSString stringWithFormat:@"%.1f lbs", [[mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"StartWeight"] floatValue]];
        }
        if (textField.tag == 6) {
            
            //goal weight
            self.mActiveTxtFld_.text = [NSString stringWithFormat:@"%.1f lbs", [[mAppDelegate_.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"GoalWeight"] floatValue]];
        }
    }
    [mDetailsDict setValue:[NSString stringWithFormat:@"%.1f lbs", [self.mActiveTxtFld_.text floatValue]] forKey:[mTitlesArray objectAtIndex:self.mActiveTxtFld_.tag-3]];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
}

// clear action
- (void)cancelTxtFld_Event
{
    self.mActiveTxtFld_.text = @"";
    
    
}
// done action
- (void)doneTxtFld_Event
{
    [self.mActiveTxtFld_ resignFirstResponder];
    self.mActiveTxtFld_ = nil;
    
}

- (void)displayPickerview {
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217+55 , 0.0);
    
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    CGRect lFrame;
    lFrame=[self.mScrollView convertRect:self.mActiveTxtFld_.bounds fromView:self.mActiveTxtFld_];
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
    
    

    PickerViewController *screen = [[PickerViewController alloc] init];
    screen.mRowValueintheComponent=self.mRowValueintheComponent;
    screen->mNoofComponents=[self.mRowValueintheComponent count];
    screen.mTextDisplayedlb.text=mTextInToolBar;
    
    // *********** ************* reloading the components to the value in the particular label *************** **************
    if (self.mActiveTxtFld_.tag -3 == 1) {
        NSString *mHeight = self.mActiveTxtFld_.text;
        mHeight = [mHeight stringByReplacingOccurrencesOfString:@" ft" withString:@""];
        NSArray *lArray = [mHeight componentsSeparatedByString:@"."];
        
        [screen.mViewPicker_ selectRow:[[lArray objectAtIndex:0] intValue] inComponent:0 animated:YES];
        [screen.mViewPicker_ reloadComponent:0];
        [screen.mViewPicker_ selectRow:[[lArray objectAtIndex:1] intValue] inComponent:1 animated:YES];
        [screen.mViewPicker_ reloadComponent:1];
    }else if(self.mActiveTxtFld_.tag -3 == 5 || self.mActiveTxtFld_.tag -3 == 6){
        for (int i =0; i<[[self.mRowValueintheComponent objectAtIndex:0]count]; i++) {
            if ([[[self.mRowValueintheComponent objectAtIndex:0] objectAtIndex:i] isEqualToString:self.mActiveTxtFld_.text]) {
                [screen.mViewPicker_ selectRow:i inComponent:0 animated:YES];
                [screen.mViewPicker_ reloadComponent:0];
            }
        }
    }
    [screen setMPickerViewDelegate_:self];
    [screen setMSelectedTextField_:mActiveTxtFld_];
    [mAppDelegate_.window addSubview:screen];
    
}
- (void)pickerViewController:(PickerViewController *)controller
                 didPickComp:(NSMutableArray *)valueArr
                      isDone:(BOOL)isDone{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;

    if(isDone==YES)
    {
        
        NSString *mData_=@"";
        for(int i=0;i<[valueArr count];i++){
            if(i==1){
                mData_ = [mData_ stringByAppendingString:@"."];
            }
            mData_=[mData_ stringByAppendingString:[valueArr objectAtIndex:i]];
        }
        if ([controller mSelectedTextField_].tag -3 == 1) {
            [controller mSelectedTextField_].text = [NSString stringWithFormat:@"%@ ft",mData_];
            [mDetailsDict setValue:[NSString stringWithFormat:@"%@ ft", mData_] forKey:[mTitlesArray objectAtIndex:1]];
            
            
        }
        else{
            [controller mSelectedTextField_].text = mData_;
            [mDetailsDict setValue:mData_ forKey:[mTitlesArray objectAtIndex:controller.mSelectedTextField_.tag-3]];
        }
        if([controller superview]){
			[controller removeFromSuperview];
		}
    }
    else
    {
        if([controller superview]){
            [controller removeFromSuperview];
        }
    }
}
- (void)displayDatePicker{
    
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217+55 , 0.0);
    
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    CGRect lFrame;
    lFrame=[self.mScrollView convertRect:self.mActiveTxtFld_.bounds fromView:self.mActiveTxtFld_];
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
    

    DatePickerController *screen = [[DatePickerController alloc] init];
    
    NSString *tempString=@"";
    tempString = self.mActiveTxtFld_.text;
    NSDate *getDate=(NSDate *)tempString;
    
    //set the minimum date
    [[screen mDatePicker_] setMaximumDate:[NSDate date]];
    if (getDate == nil)
    {
        getDate = [NSDate date];
        
    }else {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
        [df setTimeZone:gmtZone];
        NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
        df.locale = enLocale;
        [df setDateFormat:@"MMM. dd, yyyy"];
        screen.mTextDisplayedlb.text=NSLocalizedString(@"SELECT_DATE",nil);
        getDate = [df dateFromString:tempString];
    }
    
    // Set the date current in the textField
    if ([tempString isEqualToString:@""])
    {
        [[screen mDatePicker_]setDate:[NSDate date] animated:YES];
        
    }
    else {
        [[screen mDatePicker_]setDate:getDate animated:YES];
    }
    
    [screen setMDatePickerDelegate_:self];
    [screen setMSelectedTextField_:self.mActiveTxtFld_];
    [mAppDelegate_.window addSubview:screen];
    
}
- (void)datePickerController:(DatePickerController *)controller
                 didPickDate:(NSDate *)date
                      isDone:(BOOL)isDone {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;

    if(isDone==YES)
    {
		NSDateFormatter *lDateFormat_ = [[NSDateFormatter alloc] init];
        NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
        [lDateFormat_ setTimeZone:gmtZone];
        NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
        lDateFormat_.locale = enLocale;
        [lDateFormat_ setDateFormat:@"MMM. dd, yyyy"];
        controller.mSelectedTextField_.text = [NSString stringWithFormat:@"%@", [lDateFormat_ stringFromDate:date]];
        [mDetailsDict setValue:[NSString stringWithFormat:@"%@", [lDateFormat_ stringFromDate:date]] forKey:[mTitlesArray objectAtIndex:controller.mSelectedTextField_.tag-3]];
        
		if([controller superview]){
			[controller removeFromSuperview];
		}
    }
    else
    {
        if([controller superview]){
            [controller removeFromSuperview];
        }
    }
}

- (void)viewDidUnload {
    [self setMLoginBtn:nil];
    [super viewDidUnload];
}
@end
