//
//  CategotyViewController.m
//  DietToGo
//
//  Created by Suresh on 4/14/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import "CategotyViewController.h"

@interface CategotyViewController ()

@end

@implementation CategotyViewController

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
    // for setting the view below 20px in iOS7.0.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    mAppDelegate = [AppDelegate appDelegateInstance];
    [mAppDelegate hideEmptySeparators:self.mTableView];
    
    if ( CURRENTDEVICEVERSION >= IOS7VERSION) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate.mTrackPages) {
        //self.trackedViewName = @"";
        [mAppDelegate trackFlurryLogEvent:@"Discussion Forum - Categories View"];
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
    [mAppDelegate setNavControllerTitle:NSLocalizedString(@"DISCUSSION_FORUM", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];
    
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* userName = [loginUserDefaults objectForKey:USERNAME];
    NSLog(@"userName %@",userName);
    if (userName && [userName isEqualToString:@""]) {
        [mAppDelegate addTransparentViewToWindowForDisuccionForum];
        
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"EnterUserName" owner:self options:nil];
        self.mEnterUserName = [array objectAtIndex:0];
        [self.mEnterUserName.mContinueBtn addTarget:self action:@selector(userNameContinueAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mEnterUserName.mUserNameTxt becomeFirstResponder];
        [mAppDelegate.window addSubview:self.mEnterUserName];
    }

    //[self postRequestToAddUserName:@"HelloUser"];
}
#pragma mark - EnterUserName
- (void)userNameContinueAction:(id)sender {
    NSString *userName = self.mEnterUserName.mUserNameTxt.text;
    if ([userName isEqualToString:@""]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"Username", nil)];
        return;
    }
    [self postRequestToAddUserName:userName];
}
- (void)postRequestToAddUserName:(NSString*)userName
{

    NSString *mReqStr = [NSString stringWithFormat:@"%@%@/%@?Name=%@", WEBSERVICEURL, SETTINGS, USERNAME,userName];
    mReqStr = [mReqStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mReqStr = [mReqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:mReqStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"PUT"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"json_string %@",json_string);
    if ([json_string isEqualToString:@"true"]) {
        [mAppDelegate showCustomAlert:NSLocalizedString(@"CONGRATULATIONS_TITLE", nil) Message:@"User name saved successfully."];
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        [loginUserDefaults setValue:userName forKey:USERNAME];
        [loginUserDefaults synchronize];
        mAppDelegate.mResponseMethods_.userName = userName;
        [self removeEnterUserNameView];
    }else {
        [mAppDelegate showCustomAlert:NSLocalizedString(@"ALERT_TITLE", nil) Message:@"The Provided user name already exists, Please enter a unique user name"];
    }
    
}
-(void)removeEnterUserNameView{
    [self.mEnterUserName.mUserNameTxt resignFirstResponder];
    [self.mEnterUserName removeFromSuperview];
    [mAppDelegate removeTransparentViewFromWindow];
}


- (void)menuAction:(id)sender {
    [mAppDelegate showLeftSideMenu:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mAppDelegate.mCommunityDataGetter.mcategoriesArray count];
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
	
	if (nil==cell)
	{
		cell = [[UITableViewCell alloc]  initWithFrame:CGRectMake(0,0,0,0)] ;
		
        UIView *lSelectedView_ = [[UIView alloc] init];
        lSelectedView_.backgroundColor =SELECTED_CELL_COLOR;
        cell.selectedBackgroundView = lSelectedView_;
        lSelectedView_=nil;
        
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
    lLblIns.text = [NSString stringWithFormat:@"%@",[[mAppDelegate.mCommunityDataGetter.mcategoriesArray objectAtIndex:indexPath.row ]valueForKey:@"CategoryName"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate createLoadView];
        NSString *CategoryID = [NSString stringWithFormat:@"%@",[[mAppDelegate.mCommunityDataGetter.mcategoriesArray objectAtIndex:indexPath.row ]valueForKey:@"CategoryID"]];
        
        mAppDelegate.mCommunityDataGetter.mSelectedCategoryDict = [mAppDelegate.mCommunityDataGetter.mcategoriesArray objectAtIndex:indexPath.row ];
        
        [mAppDelegate.mRequestMethods_ postRequestForforums:CategoryID AuthToken:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        
    }else {
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
    
}
@end
