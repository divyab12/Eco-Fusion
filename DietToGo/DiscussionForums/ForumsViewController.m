//
//  ForumsViewController.m
//  DietToGo
//
//  Created by Suresh on 4/14/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import "ForumsViewController.h"

@interface ForumsViewController ()

@end

@implementation ForumsViewController

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

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
   
    //for tracking
    if (mAppDelegate.mTrackPages) {
        //self.trackedViewName = @"";
        [mAppDelegate trackFlurryLogEvent:@"Discussion Forum - Forum View"];
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
    NSString* selectedCatogeryName = [mAppDelegate.mCommunityDataGetter.mSelectedCategoryDict valueForKey:CategoryNameKey];
    [mAppDelegate setNavControllerTitle:selectedCatogeryName imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];

}
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
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
    return [mAppDelegate.mCommunityDataGetter.mForumsArray count];
    
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
    lLblIns.text = [NSString stringWithFormat:@"%@",[[mAppDelegate.mCommunityDataGetter.mForumsArray objectAtIndex:indexPath.row ]valueForKey:forumNameKey]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate createLoadView];
        NSString* selectedCatogeryId = [mAppDelegate.mCommunityDataGetter.mSelectedCategoryDict valueForKey:CategoryIDKey];
        
        NSString *forumId = [[mAppDelegate.mCommunityDataGetter.mForumsArray objectAtIndex:indexPath.row ]valueForKey:forumidKey];
        
        mAppDelegate.mCommunityDataGetter.mSelectedForumDict = [mAppDelegate.mCommunityDataGetter.mForumsArray objectAtIndex:indexPath.row ];
        
        [mAppDelegate.mRequestMethods_ postRequestForThreads:selectedCatogeryId forum:forumId page:@"1" AuthToken:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        
    }else {
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
    
}

@end
