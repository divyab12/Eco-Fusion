//
//  NotificationsSettngsViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 23/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "NotificationsSettngsViewController.h"

@interface NotificationsSettngsViewController ()

@end

@implementation NotificationsSettngsViewController

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
    // Do any additional setup after loading the view from its nib.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    mAppDelegate = [AppDelegate appDelegateInstance];
    self.mAchLbl.font = Bariol_Regular(22);
    self.mAchLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mReportsLbl.font = Bariol_Regular(22);
    self.mReportsLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mSendMelbl.font = Bariol_Regular(17);
    self.mSendMelbl.textColor = RGB_A(136, 136, 136, 1);
    self.mNewMsgLbl.font = Bariol_Regular(17);
    self.mNewMsgLbl.textColor = BLACK_COLOR;
    self.mDailyGoalLbl.font = Bariol_Regular(17);
    self.mDailyGoalLbl.textColor = BLACK_COLOR;
    self.mDailyLbl.font = Bariol_Regular(17);
    self.mDailyLbl.textColor = BLACK_COLOR;
    self.mWewklyLbl.font = Bariol_Regular(17);
    self.mWewklyLbl.textColor = BLACK_COLOR;
    
    // to set the swithches on/off state based on the api response
    if ([[mAppDelegate.mDataGetter_.mNotificationsDict_ objectForKey:@"CoachMessages"] boolValue]) {
        self.mNewMsgSwitch.on = TRUE;
    }
    if ([[mAppDelegate.mDataGetter_.mNotificationsDict_ objectForKey:@"GoalReached"] boolValue]) {
        self.mGoalSwitch.on = TRUE;
    }
    if ([[mAppDelegate.mDataGetter_.mNotificationsDict_ objectForKey:@"DailyReminder"] boolValue]) {
        self.mDailySwitch.on = TRUE;
    }
    if ([[mAppDelegate.mDataGetter_.mNotificationsDict_ objectForKey:@"WeeklyReminder"] boolValue]) {
        self.mWeekSwtch.on = TRUE;
    }
    //to hide the new message switch for 1, 2 and 3 usertypes
    if ([mAppDelegate.mResponseMethods_.userType intValue]!=4) {
        self.mNewMsgLbl.hidden = TRUE;
        self.mNewMsgSwitch.hidden = TRUE;
        self.mDailyGoalLbl.frame = CGRectMake(self.mDailyGoalLbl.frame.origin.x, self.mNewMsgLbl.frame.origin.y, self.mDailyGoalLbl.frame.size.width, self.mDailyGoalLbl.frame.size.height);
        self.mGoalSwitch.frame = CGRectMake(self.mGoalSwitch.frame.origin.x, self.mNewMsgSwitch.frame.origin.y, self.mGoalSwitch.frame.size.width, self.mGoalSwitch.frame.size.height);
        self.mImgView1.frame = CGRectMake(self.mImgView1.frame.origin.x, self.mDailyGoalLbl.frame.origin.y+self.mDailyGoalLbl.frame.size.height+25, self.mImgView1.frame.size.width, self.mImgView1.frame.size.height);
        self.mReportsLbl.frame = CGRectMake(self.mReportsLbl.frame.origin.x, self.mImgView1.frame.origin.y+50, self.mReportsLbl.frame.size.width, self.mReportsLbl.frame.size.height);
        self.mImgView2.frame = CGRectMake(self.mImgView2.frame.origin.x, self.mReportsLbl.frame.origin.y+self.mReportsLbl.frame.size.height+5, self.mImgView2.frame.size.width, self.mImgView2.frame.size.height);
        self.mDailyLbl.frame = CGRectMake(self.mDailyLbl.frame.origin.x, self.mImgView2.frame.origin.y+self.mImgView2.frame.size.height+27, self.mDailyLbl.frame.size.width, self.mDailyLbl.frame.size.height);
        self.mDailySwitch.frame = CGRectMake(self.mDailySwitch.frame.origin.x, self.mImgView2.frame.origin.y+self.mImgView2.frame.size.height+22, self.mDailySwitch.frame.size.width, self.mDailySwitch.frame.size.height);
        self.mWewklyLbl.frame = CGRectMake(self.mWewklyLbl.frame.origin.x, self.mDailyLbl.frame.origin.y+self.mDailyLbl.frame.size.height+23, self.mWewklyLbl.frame.size.width, self.mWewklyLbl.frame.size.height);
        self.mWeekSwtch.frame = CGRectMake(self.mWeekSwtch.frame.origin.x, self.mDailyLbl.frame.origin.y+self.mDailyLbl.frame.size.height+18, self.mWeekSwtch.frame.size.width, self.mWeekSwtch.frame.size.height);
        self.mImgView3.frame = CGRectMake(self.mImgView3.frame.origin.x, self.mWewklyLbl.frame.origin.y+self.mWewklyLbl.frame.size.height+25, self.mImgView3.frame.size.width, self.mImgView3.frame.size.height);
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate.mTrackPages) {
        //self.trackedViewName=@"Alerts and Notifications Settings page";
        [mAppDelegate trackFlurryLogEvent:@"Alerts and Notifications Settings page"];
        
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
    [mAppDelegate setNavControllerTitle:NSLocalizedString(@"NOTIFICATION_SETTINGS", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(saveAction:) forController:self rightOrLeft:1];
   
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollview.frame = CGRectMake(0, 0, 320, 504);
    }
    self.mScrollview.contentSize = CGSizeMake(320, self.mLastImgView.frame.origin.y + self.mLastImgView.frame.size.height);

}
- (void)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)saveAction:(id)sender {
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate createLoadView];
        NSString *mMessage = @"false", *mGoal = @"false", *mDaily = @"false", *mWeekly = @"false";
        if (self.mNewMsgSwitch.on) {
            mMessage = @"true";
        }if (self.mGoalSwitch.on) {
            mGoal = @"true";
        }if (self.mDailySwitch.on) {
            mDaily = @"true";
        }if (self.mWeekSwtch.on) {
            mWeekly = @"true";
        }
        NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
        NSString *mId = [mUserDefaults objectForKey:DEVICE_ID];
        //mId = @"-1";
        [mAppDelegate.mRequestMethods_ postRequestToSaveNotifications:mId
                                                              Message:mMessage
                                                                 Goal:mGoal
                                                                Daily:mDaily
                                                               Weekly:mWeekly
                                                            AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                         SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchAction:(UISwitch *)sender {
}
@end
