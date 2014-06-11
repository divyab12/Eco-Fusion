//
//  ReplyMessageViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 08/01/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface ReplyMessageViewController : GAITrackedViewController{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
}
@property (strong, nonatomic) IBOutlet UIImageView *mImgView1;
@property (strong, nonatomic) IBOutlet UILabel *mMsgToLbl;
@property (strong, nonatomic) IBOutlet UILabel *mNameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *mImgView2;
@property (strong, nonatomic) IBOutlet UILabel *mSubLbl;
@property (strong, nonatomic) IBOutlet UITextField *mSubjectTxtFld;
@property (strong, nonatomic) IBOutlet UITextView *mBodyTxtView;
@property (nonatomic, retain) NSString *mID, *mType, *mUserName, *mSubject;

@end
