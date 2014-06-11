//
//  PostsViewController.m
//  DietToGo
//
//  Created by Suresh on 4/15/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import "PostsViewController.h"

@interface PostsViewController ()

@end

@implementation PostsViewController
@synthesize imageDownloadsInProgress,isLoadMoreDone,mCurrentPage;
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
    self.mReplyThreadLbl.font = OpenSans_Regular(17);
    
    // for load more
    self.mCurrentPage = @"1";
    self.isLoadMoreDone = TRUE;
    imageDownloadsInProgress = [[NSMutableDictionary alloc]init];
    
    //add Footer to provide click action for last row.
    UIView *footerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    footerView_.backgroundColor = [UIColor clearColor];
    [self.mTableView setTableFooterView:footerView_];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //for tracking
    if (mAppDelegate.mTrackPages) {
        //self.trackedViewName = @"";
        [mAppDelegate trackFlurryLogEvent:@"Discussion Forum - Posts View"];
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
    NSString* selectedForumName = [mAppDelegate.mCommunityDataGetter.mSelectedThreadDict valueForKey:ThreadTitleKey];
    [mAppDelegate setNavControllerTitle:selectedForumName imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    [self LoadDetails];
}
-(void)LoadDetails{
    [self stopLoadingImages];
    [self.imageDownloadsInProgress removeAllObjects];
    int i;
    for (i=0; i<[mAppDelegate.mCommunityDataGetter.mPostsArray count]; i++) {
        
        AppRecord *appRecord = [[AppRecord alloc] init];
        // add width paramenter to image link.()
        NSString *tmpImageLink = [[mAppDelegate.mCommunityDataGetter.mPostsArray objectAtIndex:i]objectForKey:@"AvatarURL"];
        //@"http://diettogo.com/data/meal_images/t130/32B4%20&%20V32B4%20Granola_and_Yogurt%20017-1.jpg";//;
        tmpImageLink = [tmpImageLink stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        tmpImageLink = [tmpImageLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        appRecord.imageURLString = tmpImageLink;
        appRecord.appIcon = nil;
        [[mAppDelegate.mCommunityDataGetter.mPostsArray objectAtIndex:i] setObject:appRecord forKey:@"AppRecord"];
    }
    
    [self.mTableView reloadData];
}

#pragma mark table view delegate and datasource Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = 150;
    UILabel *lTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 50, 175, 100)];
    lTitleLabel.textColor=BLACK_COLOR;
    lTitleLabel.numberOfLines=0;
    [lTitleLabel setContentMode: UIViewContentModeTop];
    lTitleLabel.lineBreakMode=UILineBreakModeTailTruncation;
    lTitleLabel.font = OpenSans_Light(14);
    lTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
    lTitleLabel.text =[[mAppDelegate.mCommunityDataGetter.mPostsArray objectAtIndex:indexPath.row ]
                       valueForKey:@"body"];
    CGSize  size =  [lTitleLabel.text sizeWithFont:lTitleLabel.font constrainedToSize:CGSizeMake(lTitleLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    
    if (size.height+100>150) {
        rowHeight = size.height+110;
    }
    else{
        rowHeight = 150;
    }
    
    
    return ceilf(rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mAppDelegate.mCommunityDataGetter.mPostsArray count];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier] ;
        
        //UIView *lSelectedView_ = [[UIView alloc] init];
        //lSelectedView_.backgroundColor =SELECTED_CELL_COLOR;
        //cell.selectedBackgroundView = lSelectedView_;
        
        UILabel *lTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 50, 175, 100)];
        lTitleLabel.textColor = RGB_A(68, 68, 68, 1);
        lTitleLabel.numberOfLines=0;
        [lTitleLabel setContentMode: UIViewContentModeTop];
        lTitleLabel.lineBreakMode=UILineBreakModeTailTruncation;
        lTitleLabel.font = OpenSans_Regular(14);
        lTitleLabel.tag=2;
        lTitleLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lTitleLabel];
        
        // label to display author name
        UILabel *lAuthorLabel=[[UILabel alloc]initWithFrame:CGRectMake(11, 95, 68, 50)];
        lAuthorLabel.textColor=RGB_A(255, 145, 2, 1);
        lAuthorLabel.numberOfLines=0;
        lAuthorLabel.textAlignment = UITextAlignmentCenter;
        lAuthorLabel.lineBreakMode=UILineBreakModeTailTruncation;
        lAuthorLabel.font = OpenSans_Bold(12);
        lAuthorLabel.tag=3;
        lAuthorLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lAuthorLabel];
        // time label
        
        UILabel *lTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(103, 10, 150, 30)];
        lTimeLabel.textColor = RGB_A(170, 170, 170, 1);
        lTimeLabel.numberOfLines=0;
        lTimeLabel.lineBreakMode=UILineBreakModeTailTruncation;
        lTimeLabel.font = OpenSans_Regular(12);
        lTimeLabel.tag=4;
        lTimeLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lTimeLabel];
        
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 35, 50, 50)];
        lImgView.backgroundColor = GRAY_COLOR;
        lImgView.tag = 1;
        [cell.contentView addSubview:lImgView];
        
        //Add activity on imageview
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidden = YES;
        // activityIndicator.center = CGPointMake(lImgView1.bounds.size.width / 2.0f, lImgView1.bounds.size.height / 2.0f);
        activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        activityIndicator.tag = 120;
        activityIndicator.frame = CGRectMake((lImgView.frame.size.width-20)/2,(lImgView.frame.size.height-20)/2, 20, 20);
        [lImgView addSubview:activityIndicator];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //getting instances of cell subviews and setting properties like text, image etc.,
    UILabel *lLabelInstance = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *lAuthorLabelInstance = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel *lTimeLabelInstance = (UILabel *)[cell.contentView viewWithTag:4];
    UIImageView *lImageInstance = (UIImageView *)[cell.contentView viewWithTag:1];
    // finding the geight of label through text
    lLabelInstance.text = [[mAppDelegate.mCommunityDataGetter.mPostsArray objectAtIndex:indexPath.row ] valueForKey:bodyKey];
    CGSize  size1 =  [lLabelInstance.text sizeWithFont:lLabelInstance.font constrainedToSize:CGSizeMake(lLabelInstance.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    
    lLabelInstance.frame=CGRectMake(100, 50, 175, size1.height) ;
    // assigning author name to author label
    lAuthorLabelInstance.text = [[mAppDelegate.mCommunityDataGetter.mPostsArray objectAtIndex:indexPath.row ] valueForKey:usernameKey];
    CGSize  size2 =  [lAuthorLabelInstance.text sizeWithFont:lAuthorLabelInstance.font constrainedToSize:CGSizeMake(lAuthorLabelInstance.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lAuthorLabelInstance.frame =CGRectMake(11, 95, 68, size2.height);
    
    // assigning time to the time label
    NSString *postDate = [[mAppDelegate.mCommunityDataGetter.mPostsArray objectAtIndex:indexPath.row ]valueForKey:PostDateKey];
    postDate = [postDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    lTimeLabelInstance.text = [NSString stringWithFormat:@"%@    %@",postDate,[[mAppDelegate.mCommunityDataGetter.mPostsArray objectAtIndex:indexPath.row ]valueForKey:PostTimeKey]];
    
    // assigning the image to the image view.
    
    //[lImageInstance setImage:[UIImage imageWithData:[self.imgArray objectAtIndex:indexPath.row]]];
    lImageInstance.backgroundColor=[UIColor clearColor];
    UIActivityIndicatorView *activityIndicator=(UIActivityIndicatorView*)[cell.contentView viewWithTag:120];
    activityIndicator.hidden = FALSE;
    
    AppRecord *appRecord = [[mAppDelegate.mCommunityDataGetter.mPostsArray objectAtIndex:indexPath.row] objectForKey:@"AppRecord"];
    IconDownloader *iCondownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if(iCondownloader != nil) {
        //AppRecord *appRecordInIconDownloader = iCondownloader.appRecord.appRecord;
        appRecord = iCondownloader.appRecord;
    }
    
    if (!appRecord.appIcon)
    {
        [self startIconDownload:appRecord forIndexPath:indexPath];
        [activityIndicator startAnimating];
        //this is add a dummy image initially..
        lImageInstance.image = [self imageScaledToSize:CGSizeMake(50,50) :[UIImage imageNamed:@"Icon.png"]];
    } else{
        [activityIndicator stopAnimating];
        activityIndicator.hidden = YES;
        lImageInstance.image = [self imageScaledToSize:CGSizeMake(50,50) :appRecord.appIcon];
    }
    if(appRecord.imageURLString != nil)
    {
        
    }
    else
    {
        [activityIndicator stopAnimating];
        activityIndicator.hidesWhenStopped = YES;
        UIImage *cellImage = [self imageScaledToSize:CGSizeMake(50,50) :[UIImage imageNamed:@"Icon.png"]];
        //this is to add default image if we dont get image from URL.
        lImageInstance.image = cellImage;
        
    }
    //end appRecoder
    
    //for load more..
    NSUInteger row = [indexPath row]+1;
    NSUInteger count = [mAppDelegate.mCommunityDataGetter.mPostsArray count];
    
    if (row == count) {
        int totalRecord = [[[mAppDelegate.mCommunityDataGetter.mPostsArray objectAtIndex:0] objectForKey:@"replies"] intValue];
        //totalRecord++; //This is to fix API issue.
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
}
-(void)loadMoreItems:(NSIndexPath*)index {
}


- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark AppRecord Methods
- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
		iconDownloader->_pHeightOfImage = 50;
		iconDownloader->_pWidthOfImage = 50;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        //  [iconDownloader release];
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
	[self.mTableView reloadData];
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appSingleImageDidLoad:(int)rowNumber
{
}

-(void)stopLoadingImages
{
    // if ([[tipsDirectoryDicty objectForKey:@"Table"] count] > 0)
    {
        NSArray *visiblePaths = [self.mTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
			//if(_pAppDelegate->currentResultsObtained != indexPath.row)
			{
				IconDownloader *iCondownloader = [imageDownloadsInProgress objectForKey:indexPath];
                if(iCondownloader != nil)
                {
                    if(iCondownloader.imageConnection != nil)
                    {
                        [iCondownloader cancelDownload];
                    }
                }
            }
        }
    }
}
#pragma mark - Add New Post Actions
- (IBAction)addNewPostAction:(id)sender {
    
    [mAppDelegate addTransparentViewToWindowForDisuccionForum];

    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"AddNewPost" owner:self options:nil];
    self.mAddNewPost = [array objectAtIndex:0];
    
    self.mAddNewPost.mBodyTxtView_.text = @"";
    self.mAddNewPost.mBodyTxtView_.delegate = self;
    // code for place holder in body text view
    self.mAddNewPost.mBodyTxtView_.font = OpenSans_Italic(18);
    self.mAddNewPost.mBodyTxtView_.textColor = BLACK_COLOR;
    
    [Utilities addInputViewForKeyBoard:self.mAddNewPost.mBodyTxtView_
                                 Class:self];
    UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mAddNewPost.mBodyTxtView_.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:NSLocalizedString(@"WHATS_ON_MIND", nil)];
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:OpenSans_Italic(18)];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    
    [self.mAddNewPost.mBodyTxtView_ addSubview:placeholderLabel];
    
    
    [self.mAddNewPost.mClosebtn addTarget:self action:@selector(addThreadCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mAddNewPost.mSavebtn addTarget:self action:@selector(addThreadSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mAddNewPost.mBodyTxtView_ becomeFirstResponder];
    
    CGRect lFrame = self.mAddNewPost.frame;
    lFrame.origin.y = 10;
    self.mAddNewPost.frame = lFrame;
    
    if (CURRENTDEVICEVERSION <= IOS7VERSION) {
        CGRect lFrame = self.mAddNewPost.mClosebtn.frame;
        lFrame.origin.x = 0;
        self.mAddNewPost.mClosebtn.frame = lFrame;
    }
    
    [mAppDelegate.window addSubview:self.mAddNewPost];

}
- (void)addThreadCancelAction:(id)sender {
    [self.mAddNewPost.mBodyTxtView_ resignFirstResponder];
    [self.mAddNewPost removeFromSuperview];
    [mAppDelegate removeTransparentViewFromWindow];
}
- (void)addThreadSaveAction:(id)sender {
    
    if ( [self.mAddNewPost.mBodyTxtView_.text isEqualToString:@""]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"WHATS_ON_MIND_VALIDATION_TEXT", nil)];
        return;
    }
    [self.mAddNewPost.mBodyTxtView_ resignFirstResponder];
    [self.mAddNewPost removeFromSuperview];
    [mAppDelegate removeTransparentViewFromWindow];
    
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate createLoadView];
        NSString* selectedCatogeryId = [mAppDelegate.mCommunityDataGetter.mSelectedCategoryDict valueForKey:CategoryIDKey];
        NSString* selectedForumId = [mAppDelegate.mCommunityDataGetter.mSelectedForumDict valueForKey:forumidKey];
        NSString* selectedThreadId = [mAppDelegate.mCommunityDataGetter.mSelectedThreadDict valueForKey:threadidKey];
        [mAppDelegate.mRequestMethods_ postRequestForAddNewPost:selectedCatogeryId forum:selectedForumId Thread:selectedThreadId Body:self.mAddNewPost.mBodyTxtView_.text AuthToken:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
    }else {
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
}

#pragma mark Image Scale Methods
- (UIImage*) imageScaledToSize: (CGSize) newSize :(UIImage*)largeImage {
    //DTM-1073 iPad3 Retina - The grid/thumbnail view thumbnails are too pixelated
    if ([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    //DTM-1062 Thumbnail/grid view should not stretch all images to fit into a square area
    CGRect rect = [self calculateSize:newSize:largeImage.size];
    [largeImage drawInRect:rect];
    //[largeImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
//-------------------------------------------------------------------------------
//Method-    Caluclating the frames of the controls
//-------------------------------------------------------------------------------
//DTM-1062 Thumbnail/grid view should not stretch all images to fit into a square area
-(CGRect)calculateSize :(CGSize) newSize :(CGSize)imageSize {
    
    double lScaleFactor = MIN((newSize.width)/imageSize.width, (newSize.height)/imageSize.height);
    
    if(lScaleFactor>1) {
        lScaleFactor = 1;
    }
    
    return CGRectMake(((newSize.width- lScaleFactor*imageSize.width)/2),((newSize.height-lScaleFactor*imageSize.height)/2), lScaleFactor*imageSize.width, lScaleFactor*imageSize.height);
}
#pragma mark - Text View Actions
- (void)textViewDidChange:(UITextView*)textView
{
    if(self.mAddNewPost.mBodyTxtView_.text.length == 0){
        //self.mTextView_.textColor = [UIColor lightGrayColor];
        //self.mTextView_.text = @"comment";
        //[self.mTextView_ resignFirstResponder];
        for (UIView *lview in textView.subviews) {
            if ([lview isKindOfClass:[UILabel class]]) {
                [lview removeFromSuperview];
            }
        }
        UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mAddNewPost.mBodyTxtView_.frame.size.width - 20.0, 34.0)];
        [placeholderLabel setText:NSLocalizedString(@"WHATS_ON_MIND", nil)];
        [placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [placeholderLabel setFont:OpenSans_Italic(18)];
        [placeholderLabel setTextColor:[UIColor lightGrayColor]];
        [self.mAddNewPost.mBodyTxtView_ addSubview:placeholderLabel];
        
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
        UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mAddNewPost.mBodyTxtView_.frame.size.width - 20.0, 34.0)];
        [placeholderLabel setText:NSLocalizedString(@"WHATS_ON_MIND", nil)];
        [placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [placeholderLabel setFont:OpenSans_Italic(18)];
        [placeholderLabel setTextColor:[UIColor lightGrayColor]];
        [self.mAddNewPost.mBodyTxtView_ addSubview:placeholderLabel];
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
    self.mAddNewPost.mBodyTxtView_.text = @"";
    for (UIView *lview in self.mAddNewPost.mBodyTxtView_.subviews) {
        if ([lview isKindOfClass:[UILabel class]]) {
            [lview removeFromSuperview];
        }
    }
    UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mAddNewPost.mBodyTxtView_.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:NSLocalizedString(@"WHATS_ON_MIND", nil)];
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:OpenSans_Italic(18)];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    [self.mAddNewPost.mBodyTxtView_ addSubview:placeholderLabel];
}
// done action
- (void)done_Event
{
    [self.mAddNewPost.mBodyTxtView_ resignFirstResponder];
    
}
@end
