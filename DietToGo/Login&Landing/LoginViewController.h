//
//  LoginViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 23/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PickerViewController.h"
#import "DatePickerController.h"
#import "GAITrackedViewController.h"
@class AppDelegate;


@interface LoginViewController : GAITrackedViewController<PickerViewControllerDelegate,DatePickerControllerDelegate, UITextFieldDelegate>{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
    int mCounter;
    /**
     * Currently Displayed String in the toolbar parameter
     */
    NSString *mTextInToolBar;
    BOOL isRemoveCookie;
    BOOL NavigationTypeLinkClicked;
    NSString* loginCookieKey;

}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *mIndicatorView_;
@property (strong, nonatomic) IBOutlet UIImageView *mSplashImgView_;
@property (strong, nonatomic) IBOutlet UIView *mUserInfoView;
@property (strong, nonatomic) IBOutlet UILabel *mUserNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *mTextLbl;
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) IBOutlet UIButton *mContinueBtn;
@property (strong, nonatomic) IBOutlet UIButton *mBackSettingBtn;

@property (strong, nonatomic) IBOutlet UIButton *mLoginBtn;
@property (strong, nonatomic) IBOutlet UIButton *mNewUserBtn;

@property (strong, nonatomic) IBOutlet UIView *mLoginLandingView;
@property (strong, nonatomic) IBOutlet UIImageView *mLoginBgImgView;
@property (strong, nonatomic) IBOutlet UILabel *mWelcumLbl;
@property (strong, nonatomic) IBOutlet UILabel *mAssistLbl;
@property (strong, nonatomic) IBOutlet UILabel *mEmailLbl;
@property (strong, nonatomic) IBOutlet UILabel *mPhNumLbl;

@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
@property (strong, nonatomic) IBOutlet UIView *mLoginWebPageView;
@property (strong, nonatomic) IBOutlet UILabel *mLoginwebPagTitle;
@property (strong, nonatomic) IBOutlet UIImageView *mLoginWebPageBGImg;
@property (strong, nonatomic) IBOutlet UIButton *mLoginWebPageBackBtn;


@property (strong, nonatomic) IBOutlet UIImageView *mImgView;
@property (strong, nonatomic) IBOutlet UILabel *mTitleLbl;
@property (nonatomic,retain) NSMutableArray *mTitlesArray;
@property (nonatomic,retain) NSMutableArray *mTxtFldsArray;
@property (nonatomic, retain) NSMutableDictionary *mDetailsDict;
@property (retain, nonatomic) UITextField *mActiveTxtFld_;
@property (retain ,nonatomic) NSMutableArray *mRowValueintheComponent;
- (IBAction)loginAction:(id)sender;
- (IBAction)continueAction:(id)sender;
- (IBAction)backSettingAction:(id)sender;
- (IBAction)newUserAction:(id)sender;

/*
 * Method used to show the personal settings view
 */
- (void)displayPersonalSettingsView;
/*
 * Method used to load personal settings details
 */
- (void)loadDetails;
/**
 * Method used to display the PickerView
 */
- (void)displayPickerview;
/**
 * Method used to display the datepicker
 */
- (void)displayDatePicker;
@end
