//
//  ThreadsViewController.h
//  DietToGo
//
//  Created by Suresh on 4/14/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewThread.h"

@class AppDelegate;

@interface ThreadsViewController : UIViewController<UITextViewDelegate> {
    AppDelegate *mAppDelegate;
}
@property BOOL isLoadMoreDone;
@property (strong, nonatomic) NSString *mCurrentPage;
@property (strong, nonatomic) AddNewThread *mAddNewThread;
@property (strong, nonatomic) IBOutlet UILabel *mNewThreadLbl;

@property (strong, nonatomic) IBOutlet UIView *mBottomView;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)addNewthreadAction:(id)sender;

@end
