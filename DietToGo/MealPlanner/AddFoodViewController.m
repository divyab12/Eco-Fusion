//
//  AddFoodViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 29/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AddFoodViewController.h"
#import "FoodDetailsViewController.h"
#import "AddNewPrivateFoodController.h"
//#import "AsyncImageView.h"
#import "JSON.h"

@interface AddFoodViewController ()

@end

@implementation AddFoodViewController
@synthesize mFoodDetailsViewController;
@synthesize mSearchFoodArr,lAuroSearchArray;
@synthesize imageDownloadsInProgress;

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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif

      mAppDelegate_=[AppDelegate appDelegateInstance];
    
    [mAppDelegate_ hideEmptySeparators:self.mTableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    self.mLbl.font = Bariol_Regular(22);
    self.mLbl.textColor = GRAY_COLOR;
    if ([[GenricUI instance] isiPhone5]) {
        self.msearchBtn.frame = CGRectMake(self.msearchBtn.frame.origin.x, 504-60, self.msearchBtn.frame.size.width, self.msearchBtn.frame.size.height);
        self.mfavoritesBtn.frame = CGRectMake(self.mfavoritesBtn.frame.origin.x, 504-60, self.mfavoritesBtn.frame.size.width, self.mfavoritesBtn.frame.size.height);
        self.mDTGBtn.frame = CGRectMake(self.mDTGBtn.frame.origin.x, 504-60, self.mDTGBtn.frame.size.width, self.mDTGBtn.frame.size.height);
        self.mMyFoodBtn.frame = CGRectMake(self.mMyFoodBtn.frame.origin.x, 504-60, self.mMyFoodBtn.frame.size.width, self.mMyFoodBtn.frame.size.height);
        self.mTableView.frame = CGRectMake(0, 45, 320, 504-60-45);
        
        self.mCreateNewFood.frame = CGRectMake(90, 400, 150, 30);

    }
    for (UIView *lView in self.mSearchBar.subviews) {
        if ([lView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [lView removeFromSuperview];
        }
    }
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:OpenSans_Regular(18)];
//    for (UIView *subView in self.mSearchBar.subviews){
//        for (UIView *lView in subView.subviews) {
//            if ([lView isKindOfClass:[UITextField class]]) {
//                UITextField *lTxffld = (UITextField*)lView;
//                lTxffld.textColor = RED_COLOR;
//            }
//           
//        }
//    }
    //Initialize search arr
    mSearchFoodArr = [[NSMutableArray alloc] init];
    lAuroSearchArray = [[NSMutableArray alloc] init];
    isAutoSearchFoods = FALSE;
    //request for recent foods on page launch
    [self postRequestForRecentFoodItems];
    //App Record
    imageDownloadsInProgress = [[NSMutableDictionary alloc]init];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.mSearchBar resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    self.navigationController.navigationBarHidden = FALSE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Add Food - Main View";
        [mAppDelegate_ trackFlurryLogEvent:@"Add Food - Main View"];
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"ADD_FOOD", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    //This is to refresh the page when come from food detail page( Remove un-favoured items)
    if (self.mfavoritesBtn.selected) {
        [self favoritesAction:self.mfavoritesBtn];
    }
    
}
- (void)backAction:(UIButton*)sender{
    [self dismissModalViewControllerAnimated:TRUE];
}
- (void)reloadContentsOfTableView
{
    for (int i = mAppDelegate_.mDataGetter_.mFoodList_.count-1; i >= 0; i--) {
        if ([[[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:i] objectForKey:@"FoodID"] intValue] == 0) {
            [mAppDelegate_.mDataGetter_.mFoodList_ removeObjectAtIndex:i];
        }
    }
    //App Record
    [self stopLoadingImages];
    [self.imageDownloadsInProgress removeAllObjects];
    for (int j =0 ; j < [mAppDelegate_.mDataGetter_.mFoodList_ count] ; j++) {
        AppRecord *appRecord = [[AppRecord alloc] init];
        NSString* photoURl = [[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:j] objectForKey:PhotoFileNameKey];
        photoURl = [photoURl stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        photoURl = [photoURl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        photoURl = [photoURl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (photoURl) {
            if (![photoURl isEqualToString:@""]) {
                appRecord.imageURLString = photoURl;
            }else {
                appRecord.imageURLString = @"";
            }
        }else {
            appRecord.imageURLString = @"";
        }
        appRecord.appIcon = nil;
        [[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:j] setObject:appRecord forKey:@"AppRecord"];
    }
    //end App Reored
    [self.mTableView reloadData];
    self.mTableView.hidden = FALSE;
    if (self.mMyFoodBtn.selected) {
        CGSize size = self.mTableView.contentSize;
        size.height += 50;
        self.mTableView.contentSize = size;
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat hedearHeight= 1;
    if (isRecentFoods) {
        hedearHeight = 44;
    }
    return hedearHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *View_ = [[UIView alloc] initWithFrame:CGRectZero];
    if (isRecentFoods) {
        View_.frame = CGRectMake(0, 0, 320, 44);
        View_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topbar1@2x.png"]];
        UILabel *recentLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
        recentLbl.text = @"Recently Added";
        recentLbl.font = OpenSans_Light(17);
        recentLbl.textColor = DTG_GRAYTHIK_COLOR;
        [recentLbl setBackgroundColor:CLEAR_COLOR];
        [View_ addSubview:recentLbl];
    }
    return View_;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (isAutoSearchFoods) {
        if ( [lAuroSearchArray count] == 0) {
            return 1;
        }
        return [lAuroSearchArray count];
        
    } else {
        if ([mAppDelegate_.mDataGetter_.mFoodList_ count] == 0) {
            return 1;
        }
        return [mAppDelegate_.mDataGetter_.mFoodList_ count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = 44;
    if (isAutoSearchFoods) {
        if ([lAuroSearchArray count] == 0) {
            rowHeight = 60.0;
        }else if (self.mDTGBtn.selected && [[lAuroSearchArray objectAtIndex:indexPath.row] objectForKey:@"PhotoFileName"] !=[NSNull null]) {
            rowHeight= 75;
        }
    } else {
        if ([mAppDelegate_.mDataGetter_.mFoodList_ count] == 0) {
            rowHeight = 60.0;
        }else if (self.mDTGBtn.selected && [[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:@"PhotoFileName"] !=[NSNull null]) {
            rowHeight= 75;
        }
    }
   
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
        UIView *lSelectedView_ = [[UIView alloc] init];
        lSelectedView_.backgroundColor =SELECTED_CELL_COLOR;
        cell.selectedBackgroundView = lSelectedView_;
        
        UILabel *lTextLabel=[GenricUI labelWithFrame:CGRectMake(10, 2.5, 270, 40) title:@"" font:Bariol_Regular(22) color:DTG_GRAYTHIK_COLOR];
        lTextLabel.tag=1;
        lTextLabel.backgroundColor=CLEAR_COLOR;
        [cell.contentView addSubview:lTextLabel];
        
        //arrow image
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(305-8.5, 22.5-(13/2), 8.5, 13)];
        lImgView.backgroundColor = CLEAR_COLOR;
        lImgView.image = [UIImage imageNamed:@"arrowright.png"];
        lImgView.tag = 2;
        [cell.contentView addSubview:lImgView];
       // AsyncImageView *AsyncImgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, 5, 80, 60)];
        UIImageView *AsyncImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 80, 60)];
        AsyncImgView.tag = 3;
        AsyncImgView.hidden = TRUE;
        [cell.contentView addSubview:AsyncImgView];
        
        //Add activity on imageview
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidden = YES;
        activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        activityIndicator.tag = 120;
        activityIndicator.frame = CGRectMake((AsyncImgView.frame.size.width-20)/2,(AsyncImgView.frame.size.height-20)/2, 20, 20);
        [AsyncImgView addSubview:activityIndicator];

    }
    
    /*
     * to get the label instance
     */
    
    UILabel *lTextLblIns=(UILabel*)[cell.contentView viewWithTag:1];
    lTextLblIns.frame = CGRectMake(10, 2.5, 270, 40);
    lTextLblIns.hidden = FALSE;
    lTextLblIns.font = OpenSans_Regular(17);
    //lTextLblIns.numberOfLines=0;
    lTextLblIns.lineBreakMode=UILineBreakModeTailTruncation;
    UIImageView *lImgView = (UIImageView*)[cell.contentView viewWithTag:2];
   // [lImgView setBackgroundColor:RED_COLOR];
    lImgView.frame = CGRectMake(305-8.5, 22.5-(13/2), 8.5, 13);
    lImgView.hidden = FALSE;
    UIImageView *asyncImgView = (UIImageView *)[cell viewWithTag:3];
    asyncImgView.hidden = TRUE;
    UIActivityIndicatorView *activityIndicator=(UIActivityIndicatorView*)[cell.contentView viewWithTag:120];
    activityIndicator.hidden = TRUE;
    
    if (isAutoSearchFoods) {
        
        /*
         * if search results are found else show no records
         */
        if ([lAuroSearchArray count] == 0)
        {
            /* Bug-169
             UILabel *lQtyLbl=(UILabel*)[cell.contentView viewWithTag:3];
             lQtyLbl.hidden = TRUE;*/
            lTextLblIns.frame=CGRectMake(5, 7.5, 310, 30);
            if (self.msearchBtn.selected) {
                lTextLblIns.frame=CGRectMake(5, 7.5, 310, 50);
                lTextLblIns.numberOfLines = 2;
                // lTextLblIns.backgroundColor = RED_COLOR;
                if (isRecentFoods) {
                    lTextLblIns.text = NSLocalizedString(@"NO_RECENTLY_RECORDS_FOUND", nil);
                } else {
                    lTextLblIns.text = NSLocalizedString(@"NO_RECORDS_FOUND", nil);
                }
                
            }else if( self.mfavoritesBtn.selected || self.mMyFoodBtn.selected ){
                lTextLblIns.frame=CGRectMake(5, 7.5, 310, 50);
                lTextLblIns.numberOfLines = 2;
                lTextLblIns.text = NSLocalizedString(@"NO_RECORDS_FOUND", nil);
            }else if(self.mDTGBtn.selected){
                lTextLblIns.frame=CGRectMake(5, 7.5, 310, 50);
                lTextLblIns.numberOfLines = 2;
                lTextLblIns.text = NSLocalizedString(@"NO_DTGMELAS_RECORDS_FOUND", nil);
                
            }
            lImgView.hidden = TRUE;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
            
        }else {
            lTextLblIns.text=@"";
            if ([[lAuroSearchArray objectAtIndex:indexPath.row] objectForKey:@"FoodName"] !=[NSNull null]) {
                lTextLblIns.text=[[lAuroSearchArray objectAtIndex:indexPath.row] objectForKey:@"FoodName"];
                if ([[lAuroSearchArray objectAtIndex:indexPath.row] objectForKey:@"Brand"] != [NSNull null]) {
                    if ([[[lAuroSearchArray objectAtIndex:indexPath.row] objectForKey:@"Brand"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length >0) {
                        lTextLblIns.text = [lTextLblIns.text stringByAppendingString:[NSString stringWithFormat:@" (%@)", [[lAuroSearchArray objectAtIndex:indexPath.row] objectForKey:@"Brand"]]];
                    }
                }
                
            }
            
            NSString* photoURl = [[lAuroSearchArray objectAtIndex:indexPath.row] objectForKey:PhotoFileNameKey];
            if (photoURl) {
                if (![photoURl isEqualToString:@""]) {
                    asyncImgView.hidden = FALSE;
                    photoURl = [photoURl stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                    photoURl = [photoURl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    photoURl = [photoURl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                   // asyncImgView.imageURL = [NSURL URLWithString:photoURl];
                    lTextLblIns.numberOfLines = 3;
                    lTextLblIns.frame = CGRectMake(100, 3, 190, 70);
                    lImgView.frame = CGRectMake(305-8.5, 30, 8.5, 13);
                }
            }
    
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            
        }
        
        
    } else {
        
        /*
         * if search results are found else show no records
         */
        if ([mAppDelegate_.mDataGetter_.mFoodList_ count] == 0)
        {
            lTextLblIns.frame=CGRectMake(5, 7.5, 310, 30);
            if (self.msearchBtn.selected) {
                lTextLblIns.frame=CGRectMake(5, 7.5, 310, 50);
                lTextLblIns.numberOfLines = 2;
                // lTextLblIns.backgroundColor = RED_COLOR;
                if (isRecentFoods) {
                    lTextLblIns.text = NSLocalizedString(@"NO_RECENTLY_RECORDS_FOUND", nil);
                } else {
                    lTextLblIns.text = NSLocalizedString(@"NO_RECORDS_FOUND", nil);
                }
            }else if(self.mfavoritesBtn.selected){
                lTextLblIns.text = NSLocalizedString(@"NO_FAVORITE_RECORDS_FOUND", nil);
                
            }else if(self.mDTGBtn.selected){
                lTextLblIns.frame=CGRectMake(5, 7.5, 310, 50);
                lTextLblIns.numberOfLines = 2;
                if ([self.mSearchBar.text isEqualToString:@""]) {
                    lTextLblIns.text = NSLocalizedString(@"NO_DTGMELAS_RECORDS_FOUND", nil);
                } else {
                    lTextLblIns.text = NSLocalizedString(@"NO_RECORDS_FOUND", nil);
                }
                
            }else if(self.mMyFoodBtn.selected){
                lTextLblIns.frame=CGRectMake(5, 2.5, 310, 40);
                
                lTextLblIns.font = Bariol_Regular(19);
                lTextLblIns.numberOfLines=0;
                lTextLblIns.lineBreakMode=UILineBreakModeWordWrap;
                lTextLblIns.text = NSLocalizedString(@"NO_PRIVATE_RECORDS_FOUND", nil);
                
            }
            lImgView.hidden = TRUE;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
            
        }else {
            lTextLblIns.text=@"";
            if ([[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:@"FoodName"] !=[NSNull null]) {
                lTextLblIns.text=[[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:@"FoodName"];
                if ([[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:@"Brand"] != [NSNull null]) {
                    if ([[[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:@"Brand"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length >0) {
                        lTextLblIns.text = [lTextLblIns.text stringByAppendingString:[NSString stringWithFormat:@" (%@)", [[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:@"Brand"]]];
                    }
                }
                
            }
            NSString* photoURl = [[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:PhotoFileNameKey];
            if (photoURl) {
                if (![photoURl isEqualToString:@""]) {
                    asyncImgView.hidden = FALSE;
                    lTextLblIns.numberOfLines = 3;
                    lTextLblIns.frame = CGRectMake(100, 3, 190, 70);
                    lImgView.frame = CGRectMake(305-8.5, 30, 8.5, 13);
                }
            }
            
            if (!asyncImgView.hidden) {
                
                AppRecord *appRecord = [[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:@"AppRecord"];
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
                    asyncImgView.image = [self imageScaledToSize:CGSizeMake(80,60) :[UIImage imageNamed:@"Icon.png"]];
                } else{
                    [activityIndicator stopAnimating];
                    activityIndicator.hidden = YES;
                    asyncImgView.image = [self imageScaledToSize:CGSizeMake(80,60) :appRecord.appIcon];
                }
                if(appRecord.imageURLString != nil)
                {
                    
                }
                else
                {
                    [activityIndicator stopAnimating];
                    activityIndicator.hidesWhenStopped = YES;
                    UIImage *cellImage = [self imageScaledToSize:CGSizeMake(80,60) :[UIImage imageNamed:@"Icon.png"]];
                    //this is to add default image if we dont get image from URL.
                    asyncImgView.image = cellImage;
                }
                //end appRecoder
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            
        }
    }
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (isAutoSearchFoods) {
        
        if ([[lAuroSearchArray objectAtIndex:indexPath.row] objectForKey:@"FoodID"] ==[NSNull null] || [[[lAuroSearchArray objectAtIndex:indexPath.row] objectForKey:@"FoodID"] intValue] == 0) {
            [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Oops! There seem to be an issue, please try again later."];
            return;
        }
        if (lAuroSearchArray.count>0) {
            mFoodID = [[lAuroSearchArray objectAtIndex:indexPath.row] objectForKey:@"FoodID"];
            /*
             * post request for food info
             */
            if ([[NetworkMonitor instance] isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                mAppDelegate_.mRequestMethods_.mViewRefrence = self;
                [mAppDelegate_.mRequestMethods_ postRequestToGetFoodInfo:mFoodID
                                                               AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance] displayNetworkMonitorAlert];
            }
            
            
        }
        
    } else {
        
        if ([[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:@"FoodID"] ==[NSNull null] || [[[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:@"FoodID"] intValue] == 0) {
            [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Oops! There seem to be an issue, please try again later."];
            return;
        }
        if (mAppDelegate_.mDataGetter_.mFoodList_.count>0) {
            mFoodID = [[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:indexPath.row] objectForKey:@"FoodID"];
            /*
             * post request for food info
             */
            if ([[NetworkMonitor instance] isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                mAppDelegate_.mRequestMethods_.mViewRefrence = self;
                [mAppDelegate_.mRequestMethods_ postRequestToGetFoodInfo:mFoodID
                                                               AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                            SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance] displayNetworkMonitorAlert];
            }
            
            
        }
        
    }

}
#pragma mark search bar delegates
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.mSearchBar.showsCancelButton=FALSE;
    self.mSearchBar.text = @"";
    [self.mSearchBar resignFirstResponder];
    
    if (self.msearchBtn.selected) {
        [self closeDropDownView];
        [self postRequestForRecentFoodItems];
    }else if (self.mDTGBtn.selected) {
        [self closeDropDownView];
        [self postRequestForGetAvailableDTGMeals];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mSearchBar resignFirstResponder];
    
    if (self.msearchBtn.selected) {
        /*
         * post request for search food
         */
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            
            [mAppDelegate_ createLoadView];
            //Recent Food
            isRecentFoods = FALSE;
            [mAppDelegate_.mRequestMethods_ postRequestForSearchFood:self.mSearchBar.text
                                                           AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                        SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance] displayNetworkMonitorAlert];
        }
    }
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.mSearchBar.showsCancelButton=TRUE;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    isAutoSearchFoods = FALSE;
    if (self.msearchBtn.selected) {
        if (![mlastAutoSearch isEqualToString:searchText] && searchText.length >=2) {
            [self postRequestForSearchFood];
        } else if([searchText length]==0) {
            [searchBar performSelector: @selector(resignFirstResponder)
                            withObject: nil
                            afterDelay: 0.1];;
            [self postRequestForRecentFoodItems];
        }
    }else if (self.mDTGBtn.selected) {
        if (![mlastAutoSearch isEqualToString:searchText] && searchText.length >=2) {
            [self postRequestForSearchDTGFoods];
        } else if([searchText length]==0) {
            [searchBar performSelector: @selector(resignFirstResponder)
                            withObject: nil
                            afterDelay: 0.1];;
            [self postRequestForGetAvailableDTGMeals];
        }
        
    }else {
        //Auto search
        isAutoSearchFoods = TRUE;
        [lAuroSearchArray removeAllObjects];
        for (int i=0; i < [mAppDelegate_.mDataGetter_.mFoodList_ count]; i++) {
            if ([[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:i] objectForKey:@"FoodName"] !=[NSNull null]) {
                NSString* foodname = [[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:i] objectForKey:@"FoodName"];
                /*
                NSRange substringRange = [foodname rangeOfString:searchText];
                if (substringRange.location == 0) {
                    [lAuroSearchArray addObject:[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:i]];
                }*/
                NSComparisonResult result = [foodname compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
                if (result == NSOrderedSame)
                {
                    [lAuroSearchArray addObject:[mAppDelegate_.mDataGetter_.mFoodList_ objectAtIndex:i]];
                }
            }
        }
        //end Auto
        NSLog(@"lAuroSearchArray %d",[lAuroSearchArray count]);
        [self.mTableView reloadData];
    }
   
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.mSearchBar.showsCancelButton=FALSE;
    isAutoSearchFoods = FALSE;
    
}

#pragma mark -
#pragma mark DropDownViewDelegate

-(void)closeDropDownView {
    
    if (dropDownView) {
        [dropDownView.view removeFromSuperview];
        [dropDownView removeFromParentViewController];
        dropDownView = nil;
    }
}
-(void)displayDropDownView {
    
    if (dropDownView == nil) {
        dropDownView = [[DropDownView alloc] initWithArrayData:self.mSearchFoodArr cellHeight:50 heightTableView:150 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:self.mSearchBar animation:GROW openAnimationDuration:0.5 closeAnimationDuration:0.5];
        
        dropDownView.delegate = self;
        dropDownView.view.tag = 100;
        
        [self.view addSubview:dropDownView.view];
        [dropDownView openAnimation];
    }else {
        [dropDownView reloadTableView:self.mSearchFoodArr];
    
    }
	
    

}
-(void)dropDownCellSelectedIndex:(int)index AndSelectedText:(NSString *)returnString ViewController:(UIViewController *)controller {
    
    DropDownView *tmpdropDownView = (DropDownView*)controller;
    [tmpdropDownView closeAnimation];
    NSLog(@"index %d %@", index ,returnString);
    mlastAutoSearch = returnString;
    self.mSearchBar.text = returnString;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMTableView:nil];
    [self setMSearchBar:nil];
    [super viewDidUnload];
}
- (IBAction)cancelAction:(id)sender {
    [self dismissModalViewControllerAnimated:TRUE];
}
#pragma mark - Post Request for recent food iems
-(void)postRequestForRecentFoodItems {
    
    /*
     * post request for favorite food
     */
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        isRecentFoods = TRUE;
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToGetRecentFoods:mAppDelegate_.mLogMealsViewController.mMealLUT withAuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
    
}

-(void)postRequestForSearchFood {
    //Recent Food
    isRecentFoods = FALSE;
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        
        NSString *mRequestURL=WEBSERVICEURL;
        mRequestURL = [mRequestURL stringByAppendingFormat:@"%@?SearchTerm=%@", FOODTEXT,self.mSearchBar.text];
        mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [NSThread detachNewThreadSelector:@selector(GetResponseData:) toTarget:self withObject:mRequestURL];
        
    }else {
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
        return;
    }
}

- (void)GetResponseData:(NSObject *) myObject  {
    
    NSURL *url1 = [NSURL URLWithString:(NSString *)myObject];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    [theRequest setValue:mAppDelegate_.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate_.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"GET"];
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    if ([[json_string JSONValue] isKindOfClass:[NSMutableArray class]]) {
        mAppDelegate_.mDataGetter_.mFoodList_ = [json_string JSONValue];
        NSLog(@"mSearchFoodArr count %d",[mAppDelegate_.mDataGetter_.mFoodList_ count]);
        [self performSelectorOnMainThread:@selector(parseSearchData:) withObject:nil waitUntilDone:NO];
        /*
        [mSearchFoodArr removeAllObjects];
        for (int i =0; i < [tempArr count]; i++) {
            if ([[tempArr objectAtIndex:i] objectForKey:@"FoodName"] !=[NSNull null]) {
                [mSearchFoodArr addObject:[[tempArr objectAtIndex:i] objectForKey:@"FoodName"]];
            }
        }
        NSLog(@"mSearchFoodArr count %d",[self.mSearchFoodArr count]);
        if ([tempArr count] > 0 && self.mSearchBar.text.length >=2) {
            [self displayDropDownView];
        } else {
            [self closeDropDownView];
        }*/
           }/* else if([[json_string JSONValue] isKindOfClass:[NSMutableDictionary class]])
    {
        NSMutableDictionary *mDict = [json_string JSONValue];
        if ([mDict objectForKey:@"Message"]!=nil ) {
            [mAppDelegate_ removeLoadView];
            [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :[mDict objectForKey:@"Message"]];
            return;
        }
    }else if ([json_string isEqualToString:@"An error occurred"]) {
        [mAppDelegate_ removeLoadView];
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"NO_RESPONSE", nil)];
        return;
    }*/
    [mAppDelegate_ removeLoadView];
}

- (void)parseSearchData:(NSObject *) isSucces {
    if ( self.mSearchBar.text.length >=2) {
    [self reloadContentsOfTableView];
    }
}
-(void)postRequestForSearchDTGFoods {
    int mealID = 0;
    if ([mAppDelegate_.mLogMealsViewController.mMealLUT isEqualToString:@"Breakfast"]) {
        mealID = 0;
    }else if ([mAppDelegate_.mLogMealsViewController.mMealLUT isEqualToString:@"Lunch"]) {
        mealID = 1;
    }else if ([mAppDelegate_.mLogMealsViewController.mMealLUT isEqualToString:@"Dinner"]) {
        mealID = 2;
    }else if ([mAppDelegate_.mLogMealsViewController.mMealLUT isEqualToString:@"Snacks"]) {
        mealID = 3;
    }

    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        
        NSString *mRequestURL=WEBSERVICEURL;
        mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/DTG?SearchTerm=%@&Meal=%d", FOODTEXT,self.mSearchBar.text,mealID
                       ];
        mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [NSThread detachNewThreadSelector:@selector(GetResponseData:) toTarget:self withObject:mRequestURL];
        
    }else {
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
        return;
    }

}
#pragma mark - Buttom actions
- (IBAction)searchAction:(id)sender {
    self.mTableView.hidden = TRUE;

    self.msearchBtn.selected = TRUE;
    self.mfavoritesBtn.selected = FALSE;
    self.mDTGBtn.selected = FALSE;
    self.mMyFoodBtn.selected = FALSE;
    
    
    self.mSearchBar.text = @"";
    [mAppDelegate_.mDataGetter_.mFoodList_ removeAllObjects];
    //[self.mTableView reloadData];
    //[self reloadContentsOfTableView];
    //request for recent foods on page launch
    [self postRequestForRecentFoodItems];
    
    //create new button
    self.mCreateNewFood.hidden = TRUE;
}

- (IBAction)favoritesAction:(id)sender {
    self.mTableView.hidden = TRUE;
    self.mSearchBar.text = @"";

    self.msearchBtn.selected = FALSE;
    self.mfavoritesBtn.selected = TRUE;
    self.mDTGBtn.selected = FALSE;
    self.mMyFoodBtn.selected = FALSE;
    

    [mAppDelegate_.mDataGetter_.mFoodList_ removeAllObjects];
    [self.mTableView reloadData];
    //[self reloadContentsOfTableView];
   

    //create new button
    self.mCreateNewFood.hidden = TRUE;
    //Recent Food
    isRecentFoods = FALSE;
    /*
     * post request for favorite food
     */
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToGetFavoritesFoods:mAppDelegate_.mResponseMethods_.authToken
                                                    SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }

    
}

- (IBAction)DTGMealsAction:(id)sender {
    self.mTableView.hidden = TRUE;
    self.mSearchBar.text = @"";
    
    self.msearchBtn.selected = FALSE;
    self.mfavoritesBtn.selected = FALSE;
    self.mDTGBtn.selected = TRUE;
    self.mMyFoodBtn.selected = FALSE;
    
    [mAppDelegate_.mDataGetter_.mFoodList_ removeAllObjects];
    [self.mTableView reloadData];
    
    //create new button
    self.mCreateNewFood.hidden = TRUE;
    //Recent Food
    isRecentFoods = FALSE;
    
    [self postRequestForGetAvailableDTGMeals];
}

- (IBAction)myFoodsAction:(id)sender {
    self.mTableView.hidden = TRUE;
    self.mSearchBar.text = @"";

    self.msearchBtn.selected = FALSE;
    self.mfavoritesBtn.selected = FALSE;
    self.mDTGBtn.selected = FALSE;
    self.mMyFoodBtn.selected = TRUE;
  
    [mAppDelegate_.mDataGetter_.mFoodList_ removeAllObjects];
    [self.mTableView reloadData];
    //[self reloadContentsOfTableView];

    //create new button
    self.mCreateNewFood.hidden = FALSE;
    //Recent Food
    isRecentFoods = FALSE;
    /*
     * post request for private food
     */
    [self postRequestForPrivateFood];
}
-(void)postRequestForPrivateFood{
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToGetPrivateFoods:mAppDelegate_.mResponseMethods_.authToken
                                                        SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }

}
-(void)postRequestForGetAvailableDTGMeals {
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToGetAvailableDTGMeals:mAppDelegate_.mLogMealsViewController.mCurrentDate_ MealType:mAppDelegate_.mLogMealsViewController.mMealLUT withAuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
    
}
- (IBAction)createNewFoodAction:(id)sender {
    AddNewPrivateFoodController *privateFood = [[AddNewPrivateFoodController alloc] initWithNibName:@"AddNewPrivateFoodController" bundle:nil];
    [mAppDelegate_ setMAddNewPrivateFoodController:privateFood];
    [self.navigationController pushViewController:privateFood animated:YES];
}
- (void)pushToDetailPage
{
    FoodDetailsViewController *lVc = [[FoodDetailsViewController alloc] initWithNibName:@"FoodDetailsViewController" bundle:nil];
    self.mFoodDetailsViewController = lVc;
    lVc.isReported = FALSE;
    lVc.mSelectedId = mFoodID;
    [self.navigationController pushViewController:lVc animated:TRUE];
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
@end
