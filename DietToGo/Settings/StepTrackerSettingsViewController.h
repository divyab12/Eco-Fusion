//
//  StepTrackerSettingsViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 06/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface StepTrackerSettingsViewController : GAITrackedViewController{
    AppDelegate *mAppDelegate;
    
}

@property (weak, nonatomic) IBOutlet UILabel *mLbl;
@property (weak, nonatomic) IBOutlet UILabel *mLb11;
@property (weak, nonatomic) IBOutlet UISwitch *mSwitch;

@end
