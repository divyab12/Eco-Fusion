//
//  FitBitViewController.h
//  DietToGo
//
//  Created by Suresh on 4/28/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterFitBitPIN.h"
@class AppDelegate;

@interface FitBitViewController : UIViewController<UITextFieldDelegate>  {
    AppDelegate *mAppDelegate;
}
@property (strong, nonatomic) EnterFitBitPIN *mEnterFitBitPIN;
@property (strong, nonatomic) IBOutlet UIScrollView *mScollView;
@property (strong, nonatomic) IBOutlet UILabel *mTitle;
@property (strong, nonatomic) IBOutlet UILabel *mSubTitle;
@property (strong, nonatomic) IBOutlet UIButton *mConnectBtn;
@property (strong, nonatomic) IBOutlet UIButton *hadPINBtn;

@property (strong, nonatomic) IBOutlet UIButton *mSyncBtn;
@property (strong, nonatomic) IBOutlet UIButton *mDisConnectBtn;

@property (strong, nonatomic) IBOutlet UIWebView *mWebView;

- (IBAction)fitBitConnectAction:(id)sender;
- (IBAction)syncAction:(id)sender;
- (IBAction)disConnectAction:(id)sender;
- (IBAction)hadPINAction:(id)sender;

@end
