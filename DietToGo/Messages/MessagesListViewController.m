//
//  MessagesListViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 06/01/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import "MessagesListViewController.h"
#import "MessageDetailViewController.h"
#import "NewMessageViewController.h"

@interface MessagesListViewController ()

@end

@implementation MessagesListViewController
@synthesize mSelectdIndex,mFolderType, mSwipeGes;
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
    //swipe
    UISwipeGestureRecognizer *sgrLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedLeft:)];
    [sgrLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    self.mSwipeGes = sgrLeft;
    
    [self.mTableView addGestureRecognizer:sgrLeft];
    [mAppDelegate_ hideEmptySeparators:self.mTableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    self.mFolderType = @"Inbox";
    if ([[GenricUI instance] isiPhone5]) {
        self.mInboxBtn.frame = CGRectMake(self.mInboxBtn.frame.origin.x, 504 - self.mInboxBtn.frame.size.height, self.mInboxBtn.frame.size.width, self.mInboxBtn.frame.size.height);
        self.marchiveBtn.frame = CGRectMake(self.marchiveBtn.frame.origin.x, 504 - self.marchiveBtn.frame.size.height, self.marchiveBtn.frame.size.width, self.marchiveBtn.frame.size.height);
         self.mSentBtn.frame = CGRectMake(self.mSentBtn.frame.origin.x, 504 - self.mSentBtn.frame.size.height, self.mSentBtn.frame.size.width, self.mSentBtn.frame.size.height);
         self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mTableView.frame.origin.y, self.mTableView.frame.size.width, self.marchiveBtn.frame.origin.y);
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"Messages Main View";
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
    NSString *mNavTitle = [NSString stringWithFormat:@"Messages (%d)", [self returnUnreadMessages]];
    [mAppDelegate_ setNavControllerTitle:mNavTitle imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];
    
    int coachID = [mAppDelegate_.mResponseMethods_.coachID intValue];
    if (coachID > 0) {
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"messagesedit.png"] title:nil target:self action:@selector(addAction:) forController:self rightOrLeft:1];
    }
}
- (void)menuAction:(id)sender {
    [mAppDelegate_ showLeftSideMenu:self];
}
- (void)addAction:(id)sender {
    NewMessageViewController *lVc = [[NewMessageViewController alloc]initWithNibName:@"NewMessageViewController" bundle:nil];
    mAppDelegate_.mNewMessageViewController = lVc;
    [self.navigationController pushViewController:lVc animated:TRUE];
}
- (int)returnUnreadMessages{
    int iCount = 0;
    for (int i = 0 ; i < [[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] count]; i++) {
        if ([[[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:i] objectForKey:@"Status"] intValue] == 2) {
            iCount ++;
        }
    }
    return iCount;
}
#pragma mark TABLE VIEW DELEGATE METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] count] == 0) {
        return 50;
    }else{
        return 110;
    }
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] count] == 0) {
        return 1;
    }
    return [[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.clearsContextBeforeDrawing=TRUE;
        if ([[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] count] == 0) {
            //Sender name lbl
            UILabel *lLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 290, 30)];
            lLabel1.font = Bariol_Regular(18);
            lLabel1.textColor = BLACK_COLOR;
            lLabel1.backgroundColor = CLEAR_COLOR;
            lLabel1.lineBreakMode = UILineBreakModeTailTruncation;
            lLabel1.tag = 1;
            [cell.contentView addSubview:lLabel1];
            
        }else{
            //Sender name lbl
            UILabel *lLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 175, 20)];
            lLabel1.font = Bariol_Bold(17);
            lLabel1.textColor = BLACK_COLOR;
            lLabel1.backgroundColor = CLEAR_COLOR;
            lLabel1.lineBreakMode = UILineBreakModeTailTruncation;
            lLabel1.tag = 1;
            [cell.contentView addSubview:lLabel1];
            
            //time image
            UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(183.5+15, 15+((20 -11.5)/2), 11.5, 11.5)];
            lImgView.image = [UIImage imageNamed:@"calendar.png"];
            lImgView.tag = 2;
            [cell.contentView addSubview:lImgView];
            
            //date label
            UILabel *lDateLbl = [[UILabel alloc]initWithFrame:CGRectMake(215, 15, 95, 20)];
            lDateLbl.textAlignment = UITextAlignmentLeft;
            lDateLbl.font = Bariol_Regular(17);
            lDateLbl.textColor = RGB_A(136, 136, 136, 1);
            lDateLbl.backgroundColor = CLEAR_COLOR;
            lDateLbl.tag = 3;
            [cell.contentView addSubview:lDateLbl];
            
            //subject label
            UILabel *lSubLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 290, 20)];
            lSubLbl.font = Bariol_Regular(17);
            lSubLbl.textColor = BLACK_COLOR;
            lSubLbl.textAlignment = UITextAlignmentLeft;
            lSubLbl.tag = 4;
            lSubLbl.backgroundColor = CLEAR_COLOR;
            [cell.contentView addSubview:lSubLbl];
            
            //UNREAD BTN
            UIImageView *lImgview1 = [[UIImageView alloc]initWithFrame:CGRectMake(288, 35+((20-17)/2), 17, 17)];
            lImgview1.image = [UIImage imageNamed:@"unread.png"];
            lImgview1.tag = 5;
            [cell.contentView addSubview:lImgview1];
            
            //msg labl
            UILabel *mMsgLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 55, 290, 40)];
            mMsgLbl.font = Bariol_Regular(17);
            mMsgLbl.textColor = RGB_A(136, 136, 136, 1);
            mMsgLbl.lineBreakMode = UILineBreakModeTailTruncation;
            mMsgLbl.numberOfLines = 2;
            mMsgLbl.tag = 6;
            [cell.contentView addSubview:mMsgLbl];
        }
        

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] count] == 0) {
        //getting instances
        UILabel *lNameLbl = (UILabel*)[cell.contentView viewWithTag:1];
        lNameLbl.text = @"There are no messages.";
    }else{
        //getting instances
        UILabel *lNameLbl = (UILabel*)[cell.contentView viewWithTag:1];
        //coach
        if ([[[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:indexPath.row] objectForKey:@"Type"] intValue] == 1) {
            lNameLbl.text = @"Coach";
        }else{
            lNameLbl.text = [[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:indexPath.row] objectForKey:@"SenderName"];
            if ([self.mFolderType isEqualToString:@"Sent"]) {
                lNameLbl.text = [[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:indexPath.row] objectForKey:@"RecipientName"];
                
            }
        }
        
        UILabel *lDateLbl = (UILabel*)[cell.contentView viewWithTag:3];
        NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
        [GenricUI setLocaleZoneForDateFormatter:lFormatter];
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *lDate = [lFormatter dateFromString:[[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:indexPath.row] objectForKey:@"PostedOn"]];
        if (lDate == nil) {
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            lDate = [lFormatter dateFromString:[[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:indexPath.row] objectForKey:@"PostedOn"]];
        }
        [lFormatter setDateFormat:@"MM/dd/yyyy"];
        lDateLbl.text = [lFormatter stringFromDate:lDate];
        
        //subject label
        UILabel *lSubLbl = (UILabel*)[cell.contentView viewWithTag:4];
        lSubLbl.text = [[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:indexPath.row] objectForKey:@"Subject"];
        
        //imgview
        UIImageView *lImgView = (UIImageView*)[cell.contentView viewWithTag:5];
        lImgView.hidden = TRUE;
        if ([[[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:indexPath.row] objectForKey:@"Status"] intValue] == 2) {
            lImgView.hidden = FALSE;
        }
        
        //msg labl
        UILabel *lMsgLbl = (UILabel*)[cell.contentView viewWithTag:6];
        //lMsgLbl.text = @"Hey, What's up? I was looking for you the other day. What can you do about the new fruit day?";
        lMsgLbl.text = [[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:indexPath.row] objectForKey:@"Body"];

    }
       return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] count] != 0) {
        self.mSelectdIndex = indexPath;
        [self.mTableView reloadData];
        //post request to get message thread
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToGetMessageThread:[[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:indexPath.row] objectForKey:@"MessageID"]
                                                                AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                             SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance] displayNetworkMonitorAlert];
        }

    }
    
}
-(void)cellSwipedLeft:(UIGestureRecognizer *)gestureRecognizer {
    [self.mTableView reloadData];
    if ([[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] count] == 0) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // [self.mTableView removeGestureRecognizer:self.mSwipeGes];
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.mTableView];
        NSIndexPath *swipedIndexPath = [self.mTableView indexPathForRowAtPoint:swipeLocation];
        self.mSelectdIndex = swipedIndexPath;
        UITableViewCell* swipedCell = [self.mTableView cellForRowAtIndexPath:swipedIndexPath];
        //to move the row contents to left
        UITableViewCell *cell = (UITableViewCell *)swipedCell;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        for (int i =1; i< 7; i++) {
            UIView *lView = (UIView*)[cell.contentView viewWithTag:i];
            CGRect frame = lView.frame;
            frame.origin.x -= 100;
            lView.frame = frame;
        }
        [UIView commitAnimations];
        
        //for view
        UIView* rightPatch = [[UIView alloc]init];
        rightPatch.frame = CGRectMake(320-100, 0, 100, cell.frame.size.height);
        [rightPatch setBackgroundColor:DTG_MAROON_COLOR];
        [cell addSubview:rightPatch];
        
        //archive button
        UIButton *archiveBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        archiveBtn.frame = CGRectMake(0, 0, 50, cell.frame.size.height);
        [archiveBtn setImage:[UIImage imageNamed:@"archiveWhite.png"] forState:UIControlStateNormal];
        archiveBtn.tag = swipedIndexPath.row;
        [archiveBtn addTarget:self action:@selector(archiveAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightPatch addSubview:archiveBtn];
        
        //delete Button
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(50, 0, 50, cell.frame.size.height);
        [deleteBtn setImage:[UIImage imageNamed:@"crossicon.png"] forState:UIControlStateNormal];
        [deleteBtn setTag:swipedIndexPath.row];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightPatch addSubview:deleteBtn];
        
    }
}
-(void)deleteBtnAction:(UIButton*)deleteBtn {
    [GenricUI showAlertWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"DELETE_Message", nil) cancelButton:@"No" delegates:self button1Titles:@"Yes" button2Titles:nil tag:400];
}
-(void)archiveAction:(UIButton*)Btn {
    //to delete the message
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestToArchiveMessage:[[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:Btn.tag] objectForKey:@"MessageID"]
                                                         AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                      SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 400) {
        if (buttonIndex == 1) {
            //to delete the message
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                mAppDelegate_.mRequestMethods_.mViewRefrence = self;
                [mAppDelegate_.mRequestMethods_ postRequestToDeleteMessage:[[[mAppDelegate_.mMessagesDataGetter_.mMessagesListDict_ objectForKey:@"Messages"] objectAtIndex:self.mSelectdIndex.row] objectForKey:@"MessageID"]
                                                                 AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                              SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
            
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inboxAction:(id)sender {
    if ([sender isSelected]) {
        return;
    }
    [self.mTableView addGestureRecognizer:self.mSwipeGes];
    self.mFolderType = @"Inbox";
    self.mInboxBtn.selected = TRUE;
    self.marchiveBtn.selected = FALSE;
    self.mSentBtn.selected = FALSE;
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestToGetMessagesList:@"Inbox"
                                                               Page:@"1"
                                                         UnreadOnly:@"false"
                                                          AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                       SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }

    
}

- (IBAction)mArchiveAction:(id)sender {
    if ([sender isSelected]) {
        return;
    }
    [self.mTableView addGestureRecognizer:self.mSwipeGes];
    self.mFolderType = @"Archive";
    self.mInboxBtn.selected = FALSE;
    self.marchiveBtn.selected = TRUE;
    self.mSentBtn.selected = FALSE;
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestToGetMessagesList:@"Archive"
                                                                Page:@"1"
                                                          UnreadOnly:@"false"
                                                           AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                        SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }

}
- (IBAction)sentAction:(id)sender {
    if ([sender isSelected]) {
        return;
    }
    [self.mTableView removeGestureRecognizer:self.mSwipeGes];
    self.mFolderType = @"Sent";
    self.mInboxBtn.selected = FALSE;
    self.marchiveBtn.selected = FALSE;
    self.mSentBtn.selected = TRUE;
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestToGetMessagesList:@"Sent"
                                                                Page:@"1"
                                                          UnreadOnly:@"false"
                                                           AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                        SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
    
}
- (void)reloadContentsOftableView
{
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    NSString *mNavTitle = [NSString stringWithFormat:@"Messages (%d)", [self returnUnreadMessages]];
    [mAppDelegate_ setNavControllerTitle:mNavTitle imageName:imgName forController:self];
    self.mTableView.contentOffset = CGPointMake(0, 0);
    [self.mTableView reloadData];
    

}
- (void)PushToDetailView{
    MessageDetailViewController *lVc = [[MessageDetailViewController alloc]initWithNibName:@"MessageDetailViewController" bundle:nil];
    [self.navigationController pushViewController:lVc animated:TRUE];
}


@end
