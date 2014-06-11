//
//  NotificationsSettngsViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 23/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface NotificationsSettngsViewController : GAITrackedViewController{
    AppDelegate *mAppDelegate;
    
}
@property (weak, nonatomic) IBOutlet UILabel *mAchLbl;
@property (weak, nonatomic) IBOutlet UILabel *mReportsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mLastImgView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollview;
@property (weak, nonatomic) IBOutlet UILabel *mSendMelbl;

@property (weak, nonatomic) IBOutlet UILabel *mNewMsgLbl;
@property (weak, nonatomic) IBOutlet UILabel *mDailyGoalLbl;
@property (weak, nonatomic) IBOutlet UISwitch *mGoalSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mNewMsgSwitch;
@property (weak, nonatomic) IBOutlet UILabel *mDailyLbl;
@property (weak, nonatomic) IBOutlet UISwitch *mDailySwitch;
@property (weak, nonatomic) IBOutlet UILabel *mWewklyLbl;
@property (weak, nonatomic) IBOutlet UISwitch *mWeekSwtch;
@property (strong, nonatomic) IBOutlet UIImageView *mImgView1;
@property (strong, nonatomic) IBOutlet UIImageView *mImgView2;
@property (strong, nonatomic) IBOutlet UIImageView *mImgView3;
- (IBAction)switchAction:(UISwitch *)sender;

@end
