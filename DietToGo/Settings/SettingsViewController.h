//
//  SettingsViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 07/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyGoalsSettingViewController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface SettingsViewController : GAITrackedViewController{
    AppDelegate *mAppDelegate;
    
}
@property (nonatomic,retain) NSMutableArray *mTitlesArray;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

/*
 * Method used to push to respective pages
 */
- (void)pushToSettingsPage;
- (void)pushToGoalsPage;
@end
