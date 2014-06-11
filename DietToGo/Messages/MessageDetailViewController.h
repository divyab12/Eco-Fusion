//
//  MessageDetailViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 07/01/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface MessageDetailViewController : GAITrackedViewController{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
}
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (strong, nonatomic) IBOutlet UILabel *mSenderNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *mDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *mTypeLbl;
@property (strong, nonatomic) IBOutlet UIButton *mDeleteBtn;
@property (strong, nonatomic) IBOutlet UIButton *mArchiveBtn;
@property (strong, nonatomic) IBOutlet UIImageView *mSeparator;
@property (strong, nonatomic) IBOutlet UITextView *mTextView;
@property (strong, nonatomic) IBOutlet UIImageView *mSeparatorImgView;

- (IBAction)deleteAction:(id)sender;
- (IBAction)archiveAction:(id)sender;

@end
