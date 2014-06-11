//
//  ReplyMessageViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 08/01/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import "ReplyMessageViewController.h"

@interface ReplyMessageViewController ()

@end

@implementation ReplyMessageViewController
@synthesize mUserName,mType,mSubject,mID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mAppDelegate_ = [AppDelegate appDelegateInstance];
    // for setting the view below 20px in iOS7.0.
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    
    self.mMsgToLbl.font = Bariol_Regular(17);
    self.mMsgToLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mNameLbl.font = Bariol_Bold(20);
    self.mNameLbl.textColor = BLACK_COLOR;
    self.mSubLbl.font = Bariol_Regular(17);
    self.mSubLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mSubjectTxtFld.font = Bariol_Bold(20);
    self.mSubjectTxtFld.textColor = BLACK_COLOR;
    self.mBodyTxtView.font = Bariol_Regular(17);
    self.mBodyTxtView.textColor = BLACK_COLOR;
    [Utilities addInputViewForKeyBoard:self.mBodyTxtView
                                 Class:self];
    
    if ([self.mType intValue] == 1) {
         self.mNameLbl.text = @"Coach";
    }else{
        self.mNameLbl.text = self.mUserName;

    }
    self.mSubjectTxtFld.text = self.mSubject;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"Reply Message";
    }
    //end
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    [mAppDelegate_ setNavControllerTitle:self.mSubject imageName:imgName forController:self];
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"cancelbtn.png"] title:nil target:self action:@selector(CancelAction:) forController:self rightOrLeft:0];
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
    if ([[GenricUI instance] isiPhone5]) {
        self.mBodyTxtView.frame = CGRectMake(self.mBodyTxtView.frame.origin.x, self.mBodyTxtView.frame.origin.y, self.mBodyTxtView.frame.size.width, 504-10-self.mBodyTxtView.frame.origin.y);
    }
}
- (void)CancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)sendAction:(id)sender{
     if (self.mSubjectTxtFld.text.length > 0 && self.mBodyTxtView.text.length > 0 ) {
         [self.mSubjectTxtFld resignFirstResponder];
         [self.mBodyTxtView resignFirstResponder];
         if ([[NetworkMonitor instance]isNetworkAvailable]) {
             [self.navigationController popToRootViewControllerAnimated:TRUE];
             [mAppDelegate_ createLoadView];
             [mAppDelegate_.mRequestMethods_ postRequestToReplyToMessage:self.mID
                                                                    Type:self.mType
                                                                 Subject:self.mSubjectTxtFld.text
                                                                    Body:self.mBodyTxtView.text
                                                               AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
         }else{
             [[NetworkMonitor instance]displayNetworkMonitorAlert];
         }
     }else{
         return;
     }
}
// clear action
- (void)cancel_Event
{
    self.mBodyTxtView.text = @"";
}
// done action
- (void)done_Event
{
    [self.mBodyTxtView resignFirstResponder];
    if (self.mSubjectTxtFld.text.length > 0 && self.mBodyTxtView.text.length > 0 ) {
        [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtnactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];

    }else{
        [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];

    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.mSubjectTxtFld.text.length > 0 && self.mBodyTxtView.text.length > 0 ) {
        [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtnactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
        
    }else{
        [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];

    }
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength;
    newLength = [textField.text length] + [string length] - range.length;
    if (newLength > 0 && self.mBodyTxtView.text.length > 0) {
        [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtnactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
    }else{
        [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];

    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger newLength;
    newLength = [textView.text length] + [text length] - range.length;
    if (newLength > 0 && self.mSubjectTxtFld.text.length > 0) {
        [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtnactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
    }else{
        [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
        
    }
    return YES;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
