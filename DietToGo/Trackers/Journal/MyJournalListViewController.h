//
//  MyJournalListViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 19/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface MyJournalListViewController : GAITrackedViewController{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
}
@property (nonatomic, retain) NSIndexPath *mSelectdIndex;
@property (weak, nonatomic) IBOutlet UIImageView *mImgView;
@property (weak, nonatomic) IBOutlet UIImageView *mLineImgView;
@property (weak, nonatomic) IBOutlet UITableView *mTableview;
@property (weak, nonatomic) IBOutlet UILabel *mMsgLbl;
/**
 * Method to reload table data
 */
- (void)reloadContentsOftableView;
@end
