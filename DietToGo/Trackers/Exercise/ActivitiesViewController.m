//
//  ActivitiesViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 19/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "AddExerciseViewController.h"
#import "SubActivitiesViewController.h"
@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController
@synthesize searchBar,searchDisplayController, mTableView_;
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
    mSearchArray_ = [[NSMutableArray alloc]init];
    [mAppDelegate_ hideEmptySeparators:self.mTableView_];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView_ setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([[GenricUI instance] isiPhone5]) {
        //self.mTableView_.frame = CGRectMake(self.mTableView_.frame.origin.x, self.mTableView_.frame.origin.y, self.mTableView_.frame.size.width, self.mTableView_.frame.size.height+78);
    }


}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Exercise List View";
        [mAppDelegate_ trackFlurryLogEvent:@"Exercise List View"];
    }
    //end
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
        imgName = @"topbar.png";
    }else{
        imgName = @"topbar1.png";
    }
    
    [mAppDelegate_ setNavControllerTitle:@"Choose Exercise" imageName:imgName forController:self];
    
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.rightBarButtonItem=nil;
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(CancelAction:) forController:self rightOrLeft:0];
    
}
- (void)CancelAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}
#pragma mark TableView datasource and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    
	return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int count = 0;
    if ([tableView
         isEqual:self.searchDisplayController.searchResultsTableView]){
        count = [mSearchArray_ count];
    }
    else{
        count = [mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_  count];
    }
    return count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier] autorelease] ;
        
        UIView *lSelectedView_ = [[UIView alloc] init];
        lSelectedView_.backgroundColor =SELECTED_CELL_COLOR;
        //cell.selectedBackgroundView = lSelectedView_;
        RELEASE_NIL(lSelectedView_);
        
        //To display the image view for all the field titles
        UIImageView *lImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 6, 32 ,32)];
        // lImgView.image=[UIImage imageNamed:@"img_bicycling.png"];
        lImgView.backgroundColor=[UIColor clearColor];
        lImgView.tag=1;
        [cell.contentView addSubview:lImgView];
        RELEASE_NIL(lImgView);
        
        //To display the titles of the fields
        UILabel *lTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 220, 44)];
        lTitleLabel.textColor=BLACK_COLOR;
        lTitleLabel.numberOfLines=0;
        lTitleLabel.lineBreakMode=UILineBreakModeWordWrap;
        lTitleLabel.font=Bariol_Regular(17);
        lTitleLabel.tag=2;
        lTitleLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lTitleLabel];
        RELEASE_NIL(lTitleLabel);
        //arrow image
        UIImageView *lArrowImgview = [[UIImageView alloc]initWithFrame:CGRectMake(295, 18.5, 8.5, 13)];
        lArrowImgview.image = [UIImage imageNamed:@"arrowright.png"];
        lArrowImgview.tag = 3;
        lArrowImgview.hidden = TRUE;
        [cell.contentView addSubview:lArrowImgview];
        RELEASE_NIL(lArrowImgview);
        
    }
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;

    //getting instances of cell subviews and setting properties like text, image etc.,
    UIImageView *lImgViewInstance=(UIImageView*)[cell.contentView viewWithTag:1];
    lImgViewInstance.backgroundColor=[UIColor clearColor];
    
    //arrow imagview
    UIImageView *larrowImg = (UIImageView*)[cell.contentView viewWithTag:3];
    
    //label
    UILabel *lLabelInstance=(UILabel*)[cell.contentView viewWithTag:2];
    
    /* Configure the cell. */
    
    
    /*
     * to check weather  from search results or not
     */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        lLabelInstance.text =
        [[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"CategoryName"];
        //to set the accessory view of exercise based on sub categories are present or not
        if ( [[[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"ActivityLUT"] intValue]==-1) {
            larrowImg.hidden = FALSE;
        }else
        {
            larrowImg.hidden = TRUE;

        }
    }
    else{
        lLabelInstance.text =[[mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ objectAtIndex:indexPath.row] objectForKey:@"CategoryName"] ;
        //to set the accessory view of exercise based on sub categories are present or not
        if ( [[[mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ objectAtIndex:indexPath.row] objectForKey:@"ActivityLUT"] intValue]==-1) {
            larrowImg.hidden = FALSE;
        }else
        {
            larrowImg.hidden = TRUE;
            
        }
               
    }
    UIImage *lImage = [UIImage imageNamed:[mAppDelegate_.mTrackerDataGetter_ readImagesFromPlist:lLabelInstance.text]];
    
    if (lImage!=nil) {
        lImgViewInstance.image = lImage;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    NSArray *lViewControllers = self.navigationController.viewControllers;
    AddExerciseViewController *lInstance = (AddExerciseViewController*)[lViewControllers objectAtIndex:0];
    NSString *mCategoryName, *mMET,*mLUT;
    NSMutableArray *mSubListArray = [[[NSMutableArray alloc]init] autorelease];
    /*
     * to check weather from search results or not
     */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        mCategoryName = [[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"CategoryName"];
        mMET = [NSString stringWithFormat:@"%f",[[[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"MET"] floatValue] ];
        mLUT = [NSString stringWithFormat:@"%d",[[[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"ActivityLUT"] intValue] ];
        if ([mMET intValue] == 0 && [mLUT intValue] < 0) {
            for (int iCount = 0; iCount < [[[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"Activities"] count]; iCount++) {
                [mSubListArray addObject:[[[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"Activities"] objectAtIndex:iCount]];
            }
            [lInstance.mSubExerciseArray removeAllObjects];
            [lInstance.mSubExerciseArray addObjectsFromArray:mSubListArray];

        }else{
            [lInstance.mSubExerciseArray removeAllObjects];
        }


    }else{
        mCategoryName = [[mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ objectAtIndex:indexPath.row] objectForKey:@"CategoryName"];
        mMET = [NSString stringWithFormat:@"%f",[[[mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ objectAtIndex:indexPath.row] objectForKey:@"MET"] floatValue] ];
        mLUT = [NSString stringWithFormat:@"%d",[[[mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ objectAtIndex:indexPath.row] objectForKey:@"ActivityLUT"] intValue] ];
        
        if ([mMET intValue] == 0 && [mLUT intValue] < 0) {
            for (int iCount = 0; iCount < [[[mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ objectAtIndex:indexPath.row] objectForKey:@"Activities"] count]; iCount++) {
                [mSubListArray addObject:[[[mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ objectAtIndex:indexPath.row] objectForKey:@"Activities"] objectAtIndex:iCount]];
            }
            [lInstance.mSubExerciseArray removeAllObjects];
            [lInstance.mSubExerciseArray addObjectsFromArray:mSubListArray];
            
        }else{
            [lInstance.mSubExerciseArray removeAllObjects];
        }
    }
    [lInstance.mRowsValueArray replaceObjectAtIndex:0 withObject:mCategoryName];
    lInstance.mMETval = mMET;
    lInstance.mActivityLUT = mLUT;
    [lInstance loadTableData];
    if ([mLUT intValue] > 0) {
        [self.navigationController popViewControllerAnimated:TRUE];

    }else{
        SubActivitiesViewController *lVc = [[SubActivitiesViewController alloc]initWithNibName:@"SubActivitiesViewController" bundle:nil];
        lVc.mNavTitleStr = mCategoryName;
        NSMutableArray *mArray = [[NSMutableArray alloc]init];
        [mArray addObjectsFromArray:mSubListArray];
        [lVc setMExercisesArray:mArray];
        [mArray release];
        [self.navigationController pushViewController:lVc animated:TRUE];
        [lVc release];
    }
}
//filter method
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	
	// Update the filtered array based on the search text and scope.
	[mSearchArray_ removeAllObjects]; // First clear the filtered array.
	
	//Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	
	int x = [mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ count];
	for(int i =0; i< x; i++) {
        NSRange titleResultsRange = [[[mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ objectAtIndex:i] objectForKey:@"CategoryName"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
		if (titleResultsRange.length > 0) {
			[mSearchArray_ addObject:[mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ objectAtIndex:i]];
            
		}
        
	}
}
#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.searchDisplayController = nil;
    self.searchBar = nil;
    self.mTableView_ = nil;
}

- (void)dealloc {
    self.mTableView_.tableHeaderView = nil;
    [searchDisplayController release];
    [searchBar release];
    [mTableView_ release];
    [super dealloc];

}

@end
