//
//  ThreadsViewController.m
//  DietToGo
//
//  Created by Suresh on 4/14/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import "ThreadsViewController.h"
#import "JSON.h"

@interface ThreadsViewController ()

@end

@implementation ThreadsViewController
@synthesize isLoadMoreDone,mCurrentPage;
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
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    
    mAppDelegate = [AppDelegate appDelegateInstance];
    [mAppDelegate hideEmptySeparators:self.mTableView];
    
    if ( CURRENTDEVICEVERSION >= IOS7VERSION) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    CGFloat bottomYpos = 416 - self.mBottomView.frame.size.height;
    if ([[GenricUI instance] isiPhone5]) {
        bottomYpos = 504 - self.mBottomView.frame.size.height;
    }
    //set Bottom View frame
    CGRect lFrame = self.mBottomView.frame;
    lFrame.origin.y = bottomYpos;
    self.mBottomView.frame = lFrame;
    NSLog(@"frm %f %f",self.view.frame.size.height,lFrame.origin.y);
    self.mNewThreadLbl.font = OpenSans_Regular(17);
    //add Footer to provide click action for last row.
    UIView *footerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    footerView_.backgroundColor = [UIColor clearColor];
    [self.mTableView setTableFooterView:footerView_];
    
    // for load more
    self.mCurrentPage = @"1";
    self.isLoadMoreDone = TRUE;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //for tracking
    if (mAppDelegate.mTrackPages) {
        //self.trackedViewName = @"";
        [mAppDelegate trackFlurryLogEvent:@"Discussion Forum - Threads View"];
    }
    //end
    
    NSString *imgName;
    if (CURRENTDEVICEVERSION >= IOS7VERSION ) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    NSString* selectedForumName = [mAppDelegate.mCommunityDataGetter.mSelectedForumDict valueForKey:forumNameKey];
    [mAppDelegate setNavControllerTitle:selectedForumName imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
}
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mAppDelegate.mCommunityDataGetter.mThreadsArray count];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier] ;
        
        UIView *lSelectedView_ = [[UIView alloc] init];
        lSelectedView_.backgroundColor =SELECTED_CELL_COLOR;
        cell.selectedBackgroundView = lSelectedView_;
        
        //TITLE LABEL
        UILabel *lLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 250, 60)];
        lLbl.textAlignment = UITextAlignmentLeft;
        lLbl.font = OpenSans_Regular(17);
        lLbl.textColor = DTG_CELLTITLE_COLOR;
        lLbl.backgroundColor = CLEAR_COLOR;
        lLbl.tag = 1;
        [cell.contentView addSubview:lLbl];
        
        //arrow image
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(295, 23, 10.5, 18)];
        lImgView.backgroundColor = CLEAR_COLOR;
        lImgView.image = [UIImage imageNamed:@"arrowright.png"];
        lImgView.tag = 2;
        [cell.contentView addSubview:lImgView];
    }
    
    //to get the instances
    UILabel *lLblIns = (UILabel*)[cell.contentView viewWithTag:1];
    lLblIns.numberOfLines = 2;
    lLblIns.text = [[mAppDelegate.mCommunityDataGetter.mThreadsArray objectAtIndex:indexPath.row ]valueForKey:ThreadTitleKey] ;
    
    
    //for load more..
    NSUInteger row = [indexPath row]+1;
    NSUInteger count = [mAppDelegate.mCommunityDataGetter.mThreadsArray count];
    
    if (row == count) {
        int totalRecord = [[mAppDelegate.mCommunityDataGetter.mSelectedForumDict valueForKey:NumOfThreadsKey] integerValue];
        if (count < totalRecord && self.isLoadMoreDone) {
            self.isLoadMoreDone = FALSE;
            int currentPag = [self.mCurrentPage integerValue];
            currentPag++;
            self.mCurrentPage = [NSString stringWithFormat:@"%d",currentPag];
            [self performSelector:@selector(loadMoreItems:) withObject:indexPath afterDelay:0.1];
            
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate createLoadView];
        mAppDelegate.mRequestMethods_.mViewRefrence = self;
        
        mAppDelegate.mCommunityDataGetter.mSelectedThreadDict = [mAppDelegate.mCommunityDataGetter.mThreadsArray objectAtIndex:indexPath.row ];
        
        NSString *threadId = [[mAppDelegate.mCommunityDataGetter.mThreadsArray objectAtIndex:indexPath.row ]valueForKey:threadidKey];
        
        NSString* selectedCatogeryId = [mAppDelegate.mCommunityDataGetter.mSelectedCategoryDict valueForKey:CategoryIDKey];
        NSString* selectedForumId = [mAppDelegate.mCommunityDataGetter.mSelectedForumDict valueForKey:forumidKey];
        
        [mAppDelegate.mRequestMethods_ postRequestForPosts:selectedCatogeryId forum:selectedForumId thread:threadId page:@"1" AuthToken:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];        
        
    }else {
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
    
}

-(void)loadMoreItems:(NSIndexPath*)index {
    NSString *mRequestURL=WEBSERVICEURL;
    
    NSString* selectedCatogeryId = [mAppDelegate.mCommunityDataGetter.mSelectedCategoryDict valueForKey:CategoryIDKey];
    
    NSString* selectedForumId = [mAppDelegate.mCommunityDataGetter.mSelectedForumDict valueForKey:forumidKey];
    
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@?page=%@", BOARDSTXT,selectedCatogeryId,selectedForumId,self.mCurrentPage];
    

    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        [NSThread detachNewThreadSelector:@selector(loadMoreRequest:) toTarget:self withObject: mRequestURL];
    }else {
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
}
- (void)loadMoreRequest: (NSObject *) myObject {
    
    NSURL *url1 = [NSURL URLWithString:(NSString *)myObject];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    //[theRequest valueForHTTPHeaderField:body];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"GET"];
    
    NSURLResponse *response1;
    NSHTTPURLResponse *httpResponse;
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:&response1 error:nil];
    httpResponse = (NSHTTPURLResponse *)response1;
    DLog(@"Trackers HTTP Status code: %d", [httpResponse statusCode]);
    if ([httpResponse statusCode] == 500) {
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Oops! There seem to be an issue, please try again later."];
        return;
        
    }
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    
    NSMutableArray *tempShopArr = [json_string JSONValue];
    for (int i = 0; i < [tempShopArr count]; i++)
    {
        [mAppDelegate.mCommunityDataGetter.mThreadsArray addObject:[tempShopArr objectAtIndex:i]];
    }
    
    [self performSelectorOnMainThread:@selector(onSuccessLoadMore) withObject:nil waitUntilDone:NO];
}
- (void)onSuccessLoadMore {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [mAppDelegate removeLoadView];
    [self.mTableView reloadData];
    self.isLoadMoreDone = TRUE;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewthreadAction:(id)sender {
    [mAppDelegate addTransparentViewToWindowForDisuccionForum];
    
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"AddNewThread" owner:self options:nil];
    self.mAddNewThread = [array objectAtIndex:0];
    
    self.mAddNewThread.mTitleTextFld_.text = @"";
    self.mAddNewThread.mTitleTextFld_.placeholder = NSLocalizedString(@"INSERT_TITLE", nil);
    self.mAddNewThread.mBodyTxtView_.text = @"";
    self.mAddNewThread.mBodyTxtView_.delegate = self;
    // code for place holder in body text view
    self.mAddNewThread.mTitleTextFld_.font = OpenSans_Italic(18);
    self.mAddNewThread.mTitleTextFld_.textColor = BLACK_COLOR;
    [self.mAddNewThread.mTitleTextFld_ setValue:[UIFont fontWithName:@"OpenSans-Italic" size:18] forKeyPath:@"_placeholderLabel.font"];
    self.mAddNewThread.mBodyTxtView_.font = OpenSans_Italic(18);
    self.mAddNewThread.mBodyTxtView_.textColor = BLACK_COLOR;
    
    [Utilities addInputViewForKeyBoard:self.mAddNewThread.mBodyTxtView_
                                 Class:self];
    UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mAddNewThread.mBodyTxtView_.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:NSLocalizedString(@"WHATS_ON_MIND", nil)];
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:OpenSans_Italic(18)];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];

    [self.mAddNewThread.mBodyTxtView_ addSubview:placeholderLabel];

    
    [self.mAddNewThread.mClosebtn addTarget:self action:@selector(addThreadCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mAddNewThread.mSavebtn addTarget:self action:@selector(addThreadSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mAddNewThread.mTitleTextFld_ becomeFirstResponder];
    
    CGRect lFrame = self.mAddNewThread.frame;
    lFrame.origin.y = 10;
    self.mAddNewThread.frame = lFrame;
    
    if (CURRENTDEVICEVERSION <= IOS7VERSION) {
        CGRect lFrame = self.mAddNewThread.mClosebtn.frame;
        lFrame.origin.x = 0;
        self.mAddNewThread.mClosebtn.frame = lFrame;
    }
    
    [mAppDelegate.window addSubview:self.mAddNewThread];
}
- (void)addThreadCancelAction:(id)sender {
    [self.mAddNewThread.mTitleTextFld_ resignFirstResponder];
    [self.mAddNewThread.mBodyTxtView_ resignFirstResponder];
    [self.mAddNewThread removeFromSuperview];
    [mAppDelegate removeTransparentViewFromWindow];
}
- (void)addThreadSaveAction:(id)sender {
    if ( [self.mAddNewThread.mTitleTextFld_.text isEqualToString:@""]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"INSERT_TITLE_VALIDATION_TEXT", nil)];
        return;
    }
    if ( [self.mAddNewThread.mBodyTxtView_.text isEqualToString:@""]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"WHATS_ON_MIND_VALIDATION_TEXT", nil)];
        return;
    }
    [self.mAddNewThread.mTitleTextFld_ resignFirstResponder];
    [self.mAddNewThread.mBodyTxtView_ resignFirstResponder];
    [self.mAddNewThread removeFromSuperview];
    [mAppDelegate removeTransparentViewFromWindow];
    
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate createLoadView];
        NSString* selectedCatogeryId = [mAppDelegate.mCommunityDataGetter.mSelectedCategoryDict valueForKey:CategoryIDKey];
        NSString* selectedForumId = [mAppDelegate.mCommunityDataGetter.mSelectedForumDict valueForKey:forumidKey];

        [mAppDelegate.mRequestMethods_ postRequestForAddNewThread:selectedCatogeryId forum:selectedForumId Title:self.mAddNewThread.mTitleTextFld_.text Body:self.mAddNewThread.mBodyTxtView_.text AuthToken:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
       // [mAppDelegate.mRequestMethods_ postRequestForAddNewThread:mAppDelegate.mCategoriesViewController.categoryId forum:mAppDelegate.mForumsViewController.forumId user:mAppDelegate.mResponseMethods_.UserID Title:self.mAddThreadTitleTextFld_.text Body:self.mAddThreadBodyTxtView_.text];
        
    }else {
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
}
#pragma mark - Text View Actions
- (void)textViewDidChange:(UITextView*)textView
{
    if(self.mAddNewThread.mBodyTxtView_.text.length == 0){
        //self.mTextView_.textColor = [UIColor lightGrayColor];
        //self.mTextView_.text = @"comment";
        //[self.mTextView_ resignFirstResponder];
        for (UIView *lview in textView.subviews) {
            if ([lview isKindOfClass:[UILabel class]]) {
                [lview removeFromSuperview];
            }
        }
        UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mAddNewThread.mBodyTxtView_.frame.size.width - 20.0, 34.0)];
        [placeholderLabel setText:NSLocalizedString(@"WHATS_ON_MIND", nil)];
        [placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [placeholderLabel setFont:OpenSans_Italic(18)];
        [placeholderLabel setTextColor:[UIColor lightGrayColor]];
        [self.mAddNewThread.mBodyTxtView_ addSubview:placeholderLabel];
        
    }else {
        for (UIView *lview in textView.subviews) {
            if ([lview isKindOfClass:[UILabel class]]) {
                [lview removeFromSuperview];
            }
        }
        
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length == 0){
        for (UIView *lview in textView.subviews) {
            if ([lview isKindOfClass:[UILabel class]]) {
                [lview removeFromSuperview];
            }
        }
        UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mAddNewThread.mBodyTxtView_.frame.size.width - 20.0, 34.0)];
        [placeholderLabel setText:NSLocalizedString(@"WHATS_ON_MIND", nil)];
        [placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [placeholderLabel setFont:OpenSans_Italic(18)];
        [placeholderLabel setTextColor:[UIColor lightGrayColor]];
        [self.mAddNewThread.mBodyTxtView_ addSubview:placeholderLabel];
    }else {
        for (UIView *lview in textView.subviews) {
            if ([lview isKindOfClass:[UILabel class]]) {
                [lview removeFromSuperview];
            }
        }
        
    }
}
- (void)cancel_Event
{
    self.mAddNewThread.mBodyTxtView_.text = @"";
    for (UIView *lview in self.mAddNewThread.mBodyTxtView_.subviews) {
        if ([lview isKindOfClass:[UILabel class]]) {
            [lview removeFromSuperview];
        }
    }
    UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mAddNewThread.mBodyTxtView_.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:NSLocalizedString(@"WHATS_ON_MIND", nil)];
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:OpenSans_Italic(18)];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    [self.mAddNewThread.mBodyTxtView_ addSubview:placeholderLabel];
}
// done action
- (void)done_Event
{
    [self.mAddNewThread.mBodyTxtView_ resignFirstResponder];
    
}

@end
