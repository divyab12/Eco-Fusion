//
//  MessageDetailViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 07/01/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "ReplyMessageViewController.h"
#import "MessagesListViewController.h"
@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

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
    
    self.mSenderNameLbl.font = Bariol_Regular(27);
    self.mSenderNameLbl.textColor = BLACK_COLOR;
    self.mDateLbl.font = Bariol_Regular(14);
    self.mDateLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mTypeLbl.font = Bariol_Regular(21);
    self.mTypeLbl.textColor = BLACK_COLOR;
    self.mTextView.font = Bariol_Regular(17);
    self.mTextView.textColor = RGB_A(136, 136, 136, 1);
    self.mTextView.editable = FALSE;
    self.mSenderNameLbl.text = [mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"Subject"];
   
    CGSize size =  [self.mSenderNameLbl.text sizeWithFont:self.mSenderNameLbl.font constrainedToSize:CGSizeMake(self.mSenderNameLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (size.height > 25)
    {
        self.mSenderNameLbl.frame = CGRectMake(self.mSenderNameLbl.frame.origin.x, self.mSenderNameLbl.frame.origin.y, self.mSenderNameLbl.frame.size.width, size.height);

    }
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *lDate = [lFormatter dateFromString:[mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_   objectForKey:@"PostedOn"]];
    if (lDate == nil) {
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        lDate = [lFormatter dateFromString:[mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_   objectForKey:@"PostedOn"]];
    }
    [lFormatter setDateFormat:@"MMM. dd, yyyy hh:mm a"];
    self.mDateLbl.text = [lFormatter stringFromDate:lDate];
    self.mDateLbl.frame = CGRectMake(self.mDateLbl.frame.origin.x, self.mSenderNameLbl.frame.origin.y+self.mSenderNameLbl.frame.size.height, self.mDateLbl.frame.size.width, self.mDateLbl.frame.size.height);
    
    if ([[mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"Type"] intValue] == 1) {
        self.mTypeLbl.text = @"Coach";
    }else{
        self.mTypeLbl.text = [mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"SenderName"];
        if ([mAppDelegate_.mMessagesListViewController.mFolderType isEqualToString:@"Sent"]) {
            self.mTypeLbl.text = [mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"RecipientName"];
        }
    }
    self.mTypeLbl.frame = CGRectMake(self.mTypeLbl.frame.origin.x, self.mDateLbl.frame.origin.y+self.mDateLbl.frame.size.height+5, self.mTypeLbl.frame.size.width, self.mTypeLbl.frame.size.height);
    self.mSeparator.frame = CGRectMake(self.mSeparator.frame.origin.x, self.mTypeLbl.frame.origin.y+self.mTypeLbl.frame.size.height+20, self.mSeparator.frame.size.width, self.mSeparator.frame.size.height);
    self.mTextView.frame = CGRectMake(self.mTextView.frame.origin.x, self.mSeparator.frame.origin.y+self.mSeparator.frame.size.height+20, self.mTextView.frame.size.width, self.mTextView.frame.size.height);
    self.mTextView.text = [mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_   objectForKey:@"Body"];
    
    //to hide the archive and delete button for sent messages
    if ([mAppDelegate_.mMessagesListViewController.mFolderType isEqualToString:@"Sent"]) {
        self.mSeparatorImgView.hidden = TRUE;
        self.mArchiveBtn.hidden = TRUE;
        self.mDeleteBtn.hidden = TRUE;
    }else{
        self.mSeparatorImgView.hidden = FALSE;
        self.mArchiveBtn.hidden = FALSE;
        self.mDeleteBtn.hidden = FALSE;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"Messages Detail page";
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
    [mAppDelegate_ setNavControllerTitle:@"Message" imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"reply.png"] title:nil target:self action:@selector(replyAction:) forController:self rightOrLeft:1];
    
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollView.frame = CGRectMake(0, 0, 320, 504);
        self.mTextView.frame = CGRectMake(self.mTextView.frame.origin.x, self.mTextView.frame.origin.y, self.mTextView.frame.size.width, self.mScrollView.frame.size.height - self.mTextView.frame.origin.y-10);
    }
    self.mScrollView.contentSize = CGSizeMake(320, self.mScrollView.frame.size.height);
}
- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)replyAction:(id)sender{
    ReplyMessageViewController *lVc = [[ReplyMessageViewController alloc]initWithNibName:@"ReplyMessageViewController" bundle:Nil];
    lVc.mUserName = [mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"SenderName"];
    lVc.mID = [NSString stringWithFormat:@"%d",[[mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"SenderID"] intValue]];
    if ([mAppDelegate_.mMessagesListViewController.mFolderType isEqualToString:@"Sent"]) {
        lVc.mUserName = [mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"RecipientName"];
        lVc.mID = [NSString stringWithFormat:@"%d",[[mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"RecipientID"] intValue]];
    }
    lVc.mSubject = [mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"Subject"];
    lVc.mType = [NSString stringWithFormat:@"%d",[[mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"Type"] intValue]];
    [self.navigationController pushViewController:lVc animated:TRUE];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteAction:(id)sender {
      [GenricUI showAlertWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"DELETE_Message", nil) cancelButton:@"No" delegates:self button1Titles:@"Yes" button2Titles:nil tag:400];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 400) {
        if (buttonIndex == 1) {
            if ([[NetworkMonitor instance] isNetworkAvailable]) {
                [self.navigationController popViewControllerAnimated:TRUE];
                [mAppDelegate_ createLoadView];
                mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mMessagesListViewController;
                [mAppDelegate_.mRequestMethods_ postRequestToDeleteMessage:[mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"MessageID"]
                                                                 AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                              SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance] displayNetworkMonitorAlert];
            }
            
        }
    }
}


- (IBAction)archiveAction:(id)sender {
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [self.navigationController popViewControllerAnimated:TRUE];
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mMessagesListViewController;
        [mAppDelegate_.mRequestMethods_ postRequestToArchiveMessage:[mAppDelegate_.mMessagesDataGetter_.mMessagesDetailDict_ objectForKey:@"MessageID"]
                                                         AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                      SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }

}
@end
