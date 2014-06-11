//
//  NewMessageViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 10/01/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import "NewMessageViewController.h"

@interface NewMessageViewController ()

@end

@implementation NewMessageViewController

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
    self.mTypeLbl.font = Bariol_Bold(20);
    self.mTypeLbl.textColor = BLACK_COLOR;
    self.mScreenNameLbl.font = Bariol_Regular(17);
    self.mScreenNameLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mSubLbl.font = Bariol_Regular(17);
    self.mSubLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mSubTxtFld.font = Bariol_Bold(20);
    self.mSubTxtFld.textColor = BLACK_COLOR;
    self.mUserNameTxtFld.font = Bariol_Bold(20);
    self.mUserNameTxtFld.textColor = BLACK_COLOR;
    self.mBodyTxtView.font = Bariol_Regular(17);
    self.mBodyTxtView.textColor = BLACK_COLOR;
    [Utilities addInputViewForKeyBoard:self.mBodyTxtView
                                 Class:self];
    //for the user type 4 coach should be defualt else community member
    if ([mAppDelegate_.mResponseMethods_.userType intValue] == 4) {
        self.mTypeLbl.text = @"Coach";
        self.mPickerBtn.hidden = TRUE;
        self.mArrowImgview.hidden = TRUE;

        //to hide the screen name field
        self.mScreenNameLbl.hidden = TRUE;
        self.mUserNameTxtFld.hidden = TRUE;
        self.mImgView2.hidden = TRUE;
        self.mImgView3.frame = CGRectMake(0, 100, 320, 1);
        self.mSubLbl.frame = CGRectMake(self.mSubLbl.frame.origin.x, 65, self.mSubLbl.frame.size.width, self.mSubLbl.frame.size.height);
        self.mSubTxtFld.frame = CGRectMake(self.mSubTxtFld.frame.origin.x, 65, self.mSubTxtFld.frame.size.width, self.mSubTxtFld.frame.size.height);
    }else{
        self.mTypeLbl.text = @"Community member";
        self.mPickerBtn.hidden = TRUE;
        self.mArrowImgview.hidden = TRUE;
        
        //to show the screen name fld
        self.mScreenNameLbl.hidden = FALSE;
        self.mUserNameTxtFld.hidden = FALSE;
        self.mImgView2.hidden = FALSE;
        self.mImgView2.frame = CGRectMake(0, 100, 320, 1);
        self.mScreenNameLbl.frame = CGRectMake(self.mScreenNameLbl.frame.origin.x, 65, self.mScreenNameLbl.frame.size.width, self.mScreenNameLbl.frame.size.height);
        self.mUserNameTxtFld.frame = CGRectMake(self.mUserNameTxtFld.frame.origin.x, 65, self.mUserNameTxtFld.frame.size.width, self.mUserNameTxtFld.frame.size.height);
        
        self.mImgView3.frame = CGRectMake(0, 150, 320, 1);
        self.mSubLbl.frame = CGRectMake(self.mSubLbl.frame.origin.x, 115, self.mSubLbl.frame.size.width, self.mSubLbl.frame.size.height);
        self.mSubTxtFld.frame = CGRectMake(self.mSubTxtFld.frame.origin.x, 115, self.mSubTxtFld.frame.size.width, self.mSubTxtFld.frame.size.height);
    }
    self.mBodyTxtView.frame = CGRectMake(self.mBodyTxtView.frame.origin.x, self.mImgView3.frame.origin.y+10, self.mBodyTxtView.frame.size.width, self.mBodyTxtView.frame.size.height);

    if ([[GenricUI instance] isiPhone5]) {
        self.mBodyTxtView.frame = CGRectMake(self.mBodyTxtView.frame.origin.x, self.mBodyTxtView.frame.origin.y, self.mBodyTxtView.frame.size.width, 504-10-self.mBodyTxtView.frame.origin.y);
    }else{
        self.mBodyTxtView.frame = CGRectMake(self.mBodyTxtView.frame.origin.x, self.mBodyTxtView.frame.origin.y, self.mBodyTxtView.frame.size.width, 416-10-self.mBodyTxtView.frame.origin.y);

    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"New Message";
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
    [mAppDelegate_ setNavControllerTitle:@"New Message" imageName:imgName forController:self];
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"cancelbtn.png"] title:nil target:self action:@selector(CancelAction:) forController:self rightOrLeft:0];
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
    
}
- (void)CancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)sendAction:(id)sender{
    BOOL flag = FALSE;
    if ([self.mTypeLbl.text isEqualToString:@"Coach"]) {
        if (self.mSubTxtFld.text.length > 0 && self.mBodyTxtView.text.length > 0) {
            flag = TRUE;
        }
    }else{
        if (self.mSubTxtFld.text.length > 0 && self.mBodyTxtView.text.length > 0 && self.mUserNameTxtFld.text.length > 0) {
            flag = TRUE;
        }
    }
    if (flag) {
        [self.mBodyTxtView resignFirstResponder];
        [self.mSubTxtFld resignFirstResponder];
        [self.mUserNameTxtFld resignFirstResponder];
        NSString *mUsername;
        if ([self.mTypeLbl.text isEqualToString:@"Coach"]) {
            mUsername = self.mTypeLbl.text;
        }else{
            mUsername = self.mUserNameTxtFld.text;
        }
        
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToCheckRecipent:mUsername
                                                             AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance] displayNetworkMonitorAlert];
        }
    }
}
- (void)postSendMessageRequest:(int)mId{
    NSString *mType;
    if ([self.mTypeLbl.text isEqualToString:@"Coach"]) {
        mType = @"1";
    }else{
        mType = @"2";
    }
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToSendNewMessage:[NSString stringWithFormat:@"%d", mId]
                                                               Type:mType
                                                            Subject:self.mSubTxtFld.text
                                                               Body:self.mBodyTxtView.text
                                                          AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                       SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength;
    newLength = [textField.text length] + [string length] - range.length;
    
    
    if ([self.mTypeLbl.text isEqualToString:@"Coach"]) {
        if (newLength > 0 && self.mBodyTxtView.text.length > 0) {
            [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtnactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
        }else{
            [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
            
        }
    }else{
        NSString *mOtherString = @"";

        if (textField == self.mSubTxtFld) {
            mOtherString = self.mUserNameTxtFld.text;
        }else{
            mOtherString = self.mSubTxtFld.text;
            
        }
        if (newLength > 0 && self.mBodyTxtView.text.length > 0 && mOtherString.length > 0) {
            [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtnactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
        }else{
            [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
            
        }
    }
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger newLength;
    newLength = [textView.text length] + [text length] - range.length;
    
    if ([self.mTypeLbl.text isEqualToString:@"Coach"]) {
        if (newLength > 0 && self.mSubTxtFld.text.length > 0) {
            [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtnactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
        }else{
            [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
            
        }
    }else{
        if (newLength > 0 && self.mSubTxtFld.text.length > 0 && self.mUserNameTxtFld.text.length > 0 ) {
            [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtnactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
        }else{
            [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];
            
        }
    }
    
    return YES;
    
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickerAction:(id)sender {
    [self.mSubTxtFld resignFirstResponder];
    [self.mUserNameTxtFld resignFirstResponder];
    [self.mBodyTxtView resignFirstResponder];
    [self displayPickerview];
}
- (void)displayPickerview {
    NSArray *mArray = [[NSArray alloc]initWithObjects:@"Coach",@"Community member", nil];
    NSMutableArray *mPickerValues = [[NSMutableArray alloc]init ];
    [mPickerValues addObject:mArray];
    PickerViewController *screen = [[PickerViewController alloc] init];
    screen.mRowValueintheComponent=mPickerValues;
    screen->mNoofComponents=[mPickerValues count];
    screen.mTextDisplayedlb.text=@"Select type";
    
    // *********** ************* reloading the components to the value in the particular label *************** **************
    if (self.mTypeLbl.text.length > 0) {
        for (int i =0; i<[[screen.mRowValueintheComponent objectAtIndex:0]count]; i++) {
            if ([[[screen.mRowValueintheComponent objectAtIndex:0] objectAtIndex:i] isEqualToString:self.mTypeLbl.text]) {
                [screen.mViewPicker_ selectRow:i inComponent:0 animated:YES];
                [screen.mViewPicker_ reloadComponent:0];
            }
        }
    }
    [screen setMPickerViewDelegate_:self];
    [mAppDelegate_.window addSubview:screen];
    
}
- (void)pickerViewController:(PickerViewController *)controller
                 didPickComp:(NSMutableArray *)valueArr
                      isDone:(BOOL)isDone{
    
    if(isDone==YES)
    {
        
        NSString *mData_=@"";
        for(int i=0;i<[valueArr count];i++){
            if(i==1){
                mData_ = [mData_ stringByAppendingString:@"."];
            }
            mData_=[mData_ stringByAppendingString:[valueArr objectAtIndex:i]];
        }
        self.mTypeLbl.text = mData_;
        if ([self.mTypeLbl.text isEqualToString:@"Coach"]) {
            //to hide the screen name field
            self.mScreenNameLbl.hidden = TRUE;
            self.mUserNameTxtFld.hidden = TRUE;
            self.mImgView2.hidden = TRUE;
            self.mImgView3.frame = CGRectMake(0, 100, 320, 1);
            self.mSubLbl.frame = CGRectMake(self.mSubLbl.frame.origin.x, 65, self.mSubLbl.frame.size.width, self.mSubLbl.frame.size.height);
            self.mSubTxtFld.frame = CGRectMake(self.mSubTxtFld.frame.origin.x, 65, self.mSubTxtFld.frame.size.width, self.mSubTxtFld.frame.size.height);

        }else{
            //to show the screen name fld
            self.mScreenNameLbl.hidden = FALSE;
            self.mUserNameTxtFld.hidden = FALSE;
            self.mImgView2.hidden = FALSE;
            self.mImgView2.frame = CGRectMake(0, 100, 320, 1);
            self.mScreenNameLbl.frame = CGRectMake(self.mScreenNameLbl.frame.origin.x, 65, self.mScreenNameLbl.frame.size.width, self.mScreenNameLbl.frame.size.height);
            self.mUserNameTxtFld.frame = CGRectMake(self.mUserNameTxtFld.frame.origin.x, 65, self.mUserNameTxtFld.frame.size.width, self.mUserNameTxtFld.frame.size.height);
            self.mUserNameTxtFld.text = @"";
            self.mImgView3.frame = CGRectMake(0, 150, 320, 1);
            self.mSubLbl.frame = CGRectMake(self.mSubLbl.frame.origin.x, 115, self.mSubLbl.frame.size.width, self.mSubLbl.frame.size.height);
            self.mSubTxtFld.frame = CGRectMake(self.mSubTxtFld.frame.origin.x, 115, self.mSubTxtFld.frame.size.width, self.mSubTxtFld.frame.size.height);

        }
        self.mBodyTxtView.frame = CGRectMake(self.mBodyTxtView.frame.origin.x, self.mImgView3.frame.origin.y+10, self.mBodyTxtView.frame.size.width, self.mBodyTxtView.frame.size.height);
        
        if ([[GenricUI instance] isiPhone5]) {
            self.mBodyTxtView.frame = CGRectMake(self.mBodyTxtView.frame.origin.x, self.mBodyTxtView.frame.origin.y, self.mBodyTxtView.frame.size.width, 504-10-self.mBodyTxtView.frame.origin.y);
        }else{
            self.mBodyTxtView.frame = CGRectMake(self.mBodyTxtView.frame.origin.x, self.mBodyTxtView.frame.origin.y, self.mBodyTxtView.frame.size.width, 416-10-self.mBodyTxtView.frame.origin.y);
            
        }
        // to set the image for send button
        BOOL flag = FALSE;
        if ([self.mTypeLbl.text isEqualToString:@"Coach"]) {
            if (self.mSubTxtFld.text.length > 0 && self.mBodyTxtView.text.length > 0) {
                flag = TRUE;
            }
        }else{
            if (self.mSubTxtFld.text.length > 0 && self.mBodyTxtView.text.length > 0 && self.mUserNameTxtFld.text.length > 0) {
                flag = TRUE;
            }
        }
        if (flag) {
            [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtnactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];

        }else{
            [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"sendbtninactive.png"] title:nil target:self action:@selector(sendAction:) forController:self rightOrLeft:1];

        }
        if([controller superview]){
			[controller removeFromSuperview];
		}
    }
    else
    {
        if([controller superview]){
            [controller removeFromSuperview];
        }
    }
}

@end
