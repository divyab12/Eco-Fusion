//
//  NewMessageViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 10/01/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface NewMessageViewController : GAITrackedViewController<PickerViewControllerDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
}
@property (strong, nonatomic) IBOutlet UIButton *mPickerBtn;
@property (strong, nonatomic) IBOutlet UIImageView *mImgView1;
@property (strong, nonatomic) IBOutlet UILabel *mMsgToLbl;
@property (strong, nonatomic) IBOutlet UILabel *mTypeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *mArrowImgview;
@property (strong, nonatomic) IBOutlet UIImageView *mImgView2;
@property (strong, nonatomic) IBOutlet UILabel *mScreenNameLbl;
@property (strong, nonatomic) IBOutlet UITextField *mUserNameTxtFld;
@property (strong, nonatomic) IBOutlet UIImageView *mImgView3;
@property (strong, nonatomic) IBOutlet UILabel *mSubLbl;
@property (strong, nonatomic) IBOutlet UITextField *mSubTxtFld;
@property (strong, nonatomic) IBOutlet UITextView *mBodyTxtView;
- (IBAction)pickerAction:(id)sender;
/**
 * Method used to display the PickerView
 */
- (void)displayPickerview;
/**
 * Method used to post send msg request
 * @param mId for the userId
 */
- (void)postSendMessageRequest:(int)mId;

@end
