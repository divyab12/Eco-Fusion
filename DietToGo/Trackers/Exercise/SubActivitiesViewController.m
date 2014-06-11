//
//  SubActivitiesViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 19/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "SubActivitiesViewController.h"
#import "AddExerciseViewController.h"
@interface SubActivitiesViewController ()

@end

@implementation SubActivitiesViewController
@synthesize searchBar;
@synthesize searchDisplayController;
@synthesize mTableView_;
@synthesize mNavTitleStr;
@synthesize mExercisesArray;
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
    self.mTableView_.tableHeaderView=self.searchDisplayController.searchBar;
    if ([[GenricUI instance] isiPhone5]) {
        //self.mTableView_.frame = CGRectMake(self.mTableView_.frame.origin.x, self.mTableView_.frame.origin.y, self.mTableView_.frame.size.width, self.mTableView_.frame.size.height+78);
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Exercise Category View";
        [mAppDelegate_ trackFlurryLogEvent:@"Exercise Category View"];
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
    
    [mAppDelegate_ setNavControllerTitle:self.mNavTitleStr imageName:imgName forController:self];
    
    
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
        count = [self.mExercisesArray count];
    }
    return count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier] autorelease] ;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *lSelectedView_ = [[UIView alloc] init];
        lSelectedView_.backgroundColor =SELECTED_CELL_COLOR;
        //cell.selectedBackgroundView = lSelectedView_;
        [lSelectedView_ release];
        lSelectedView_ = nil;
        //To display the image view for all the field titles
        UIImageView *lImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 32 ,32)];
        lImgView.image=[UIImage imageNamed:@"img_bicycling.png"];
        lImgView.backgroundColor=[UIColor clearColor];
        lImgView.tag=1;
        lImgView.hidden=TRUE;
        [cell.contentView addSubview:lImgView];
        RELEASE_NIL(lImgView);
        
        //To display the titles of the fields
        UILabel *lTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 250, 44)];
        lTitleLabel.textColor=[UIColor blackColor];
        lTitleLabel.numberOfLines=0;
        lTitleLabel.lineBreakMode=UILineBreakModeWordWrap;
        lTitleLabel.font=Bariol_Regular(17);
        lTitleLabel.tag=2;
        lTitleLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lTitleLabel];
        RELEASE_NIL(lTitleLabel);
        
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    //getting instances of cell subviews and setting properties like text, image etc.,
    UIImageView *lImgViewInstance=(UIImageView*)[cell.contentView viewWithTag:1];
    lImgViewInstance.backgroundColor=[UIColor clearColor];
    
    //label
    UILabel *lLabelInstance=(UILabel*)[cell.contentView viewWithTag:2];
    
    /* Configure the cell. */
    /*
     * to check weather  from search results or not
     */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        lLabelInstance.text =
        [[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"ActivityName"];
        
        
    }
    else{
        lLabelInstance.text =[[self.mExercisesArray objectAtIndex:indexPath.row] objectForKey:@"ActivityName"];;
        
        
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    NSArray *lViewControllers = self.navigationController.viewControllers;
    AddExerciseViewController *lInstance = (AddExerciseViewController*)[lViewControllers objectAtIndex:0];
    NSString *mCategoryName, *mMET,*mLUT;
    /*
     * to check weather from search results or not
     */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        mCategoryName = [[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"ActivityName"];
        mMET = [NSString stringWithFormat:@"%f",[[[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"MET"] floatValue] ];
        mLUT = [NSString stringWithFormat:@"%d",[[[mSearchArray_ objectAtIndex:indexPath.row] objectForKey:@"ActivityLUT"] intValue] ];
        
        
    }else{
        mCategoryName = [[self.mExercisesArray objectAtIndex:indexPath.row] objectForKey:@"ActivityName"];
        mMET = [NSString stringWithFormat:@"%f",[[[self.mExercisesArray objectAtIndex:indexPath.row] objectForKey:@"MET"] floatValue] ];
        mLUT = [NSString stringWithFormat:@"%d",[[[self.mExercisesArray objectAtIndex:indexPath.row] objectForKey:@"ActivityLUT"] intValue] ];
    }
    [lInstance.mRowsValueArray replaceObjectAtIndex:1 withObject:mCategoryName];
    lInstance.mMETval = mMET;
    lInstance.mActivityLUT = mLUT;
    [lInstance.mTableView reloadData];
    if ([lInstance.mMETval intValue] !=0 && lInstance.mMinBtn.currentTitle != nil) {
        float mWeightInKg=[[mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ objectForKey:@"CurrentWeight"] floatValue]*0.4546;
        float hours = [lInstance.mMinBtn.currentTitle intValue]/60.0f;
        int cal = [lInstance.mMETval floatValue]*hours*mWeightInKg;
        lInstance.mCalLbl.text = [NSString stringWithFormat:@"%d", cal];
    }

    [self.navigationController popToRootViewControllerAnimated:TRUE];

}
//filter method
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	
	// Update the filtered array based on the search text and scope.
	[mSearchArray_ removeAllObjects]; // First clear the filtered array.
	
	//Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	
	int x = [self.mExercisesArray count];
	for(int i =0; i< x; i++) {
        NSRange titleResultsRange = [[[self.mExercisesArray objectAtIndex:i] objectForKey:@"ActivityName"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
		if (titleResultsRange.length > 0) {
			[mSearchArray_ addObject:[self.mExercisesArray objectAtIndex:i]];
            
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

- (void)viewDidUnload
{
    [self setMNavTitleStr:nil];
    [self setMExercisesArray:nil];
    [self setSearchBar:nil];
    [self setSearchDisplayController:nil];
    [self setMTableView_:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    self.mTableView_.tableHeaderView = nil;
    [mSearchArray_ release];
    [searchBar release];
    [searchDisplayController release];
    [mTableView_ release];
     [mExercisesArray release];
    [super dealloc];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
