//
//  MessagesListViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 06/01/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@class AppDelegate;
@interface MessagesListViewController : GAITrackedViewController{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
}
@property (nonatomic, retain) NSIndexPath *mSelectdIndex;
@property (nonatomic, retain) NSString *mFolderType;
@property (nonatomic,retain) UISwipeGestureRecognizer *mSwipeGes;
@property (strong, nonatomic) IBOutlet UIButton *mInboxBtn;
@property (strong, nonatomic) IBOutlet UIButton *marchiveBtn;
@property (strong, nonatomic) IBOutlet UIButton *mSentBtn;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)inboxAction:(id)sender;
- (IBAction)mArchiveAction:(id)sender;
- (IBAction)sentAction:(id)sender;
/*
 * Method used to return the unread messages count
 */
- (int)returnUnreadMessages;
/**
 * Method used to reload table data
 */
- (void)reloadContentsOftableView;
/**
 * Method used to push to detail page
 */
- (void)PushToDetailView;

@end
