//
//  WaterListViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 14/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterAddEditViewController.h"
@class AppDelegate;
@interface WaterListViewController : UIViewController{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
    
}
@property (nonatomic,retain) WaterAddEditViewController *mWaterAddEditViewController;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UILabel *mLogLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mLineImgView;

/**
 * Method to reload table data
 */
- (void)reloadContentsOftableView;
@end
