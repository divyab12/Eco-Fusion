//
//  PostsViewController.h
//  DietToGo
//
//  Created by Suresh on 4/15/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

#import "AppRecord.h"
#import "IconDownloader.h"
#import "AddNewPost.h"

@interface PostsViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,IconDownloaderDelegate> {
    AppDelegate *mAppDelegate;
}
@property BOOL isLoadMoreDone;
@property (strong, nonatomic) NSMutableDictionary *imageDownloadsInProgress;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) NSString *mCurrentPage;
@property (strong, nonatomic) IBOutlet UIView *mBottomView;
@property (strong, nonatomic) IBOutlet UILabel *mReplyThreadLbl;

@property (strong, nonatomic) AddNewPost *mAddNewPost;
-(void)LoadDetails;
//Add New Post
- (IBAction)addNewPostAction:(id)sender;

@end
