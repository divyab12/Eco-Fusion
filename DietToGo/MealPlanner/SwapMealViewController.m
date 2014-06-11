//
//  SwapMealViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 29/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "SwapMealViewController.h"
#import "AsyncImageView.h"

@interface SwapMealViewController ()

@end

@implementation SwapMealViewController
@synthesize mNoofRowsInSectionArray_;

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
    mAppDelegate_=[AppDelegate appDelegateInstance];
    // for setting the view below 20px in iOS7.0.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    [mAppDelegate_ hideEmptySeparators:self.mtableview];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mtableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    mNoofRowsInSectionArray_=[[NSMutableDictionary alloc]init];
    /*
     * to store the number of rows in each section as zero
     */
    for (int i=0; i<mAppDelegate_.mDataGetter_.mMealsList_.count; i++) {
        [self.mNoofRowsInSectionArray_ setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
    }


}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Swap Meal - Main View";
        [mAppDelegate_ trackFlurryLogEvent:@"Swap Meal - Main View"];
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"SWAP_MEAL",nil) imageName:imgName forController:self];
    
    //[[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"swapcancel.png"] title:nil target:self action:@selector(cancelAction:) forController:self rightOrLeft:1];
}
- (void)menuAction:(id)sender {
    [mAppDelegate_ showLeftSideMenu:self];
    
}
- (void)cancelAction:(id)sender{
    [self dismissModalViewControllerAnimated:TRUE];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (mAppDelegate_.mDataGetter_.mMealsList_.count == 0) {
        return 1;
    }
    return mAppDelegate_.mDataGetter_.mMealsList_.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (mAppDelegate_.mDataGetter_.mMealsList_.count == 0) {
        return 1;
    }
    return [[self.mNoofRowsInSectionArray_ objectForKey:[NSString stringWithFormat:@"%d",section]] intValue] ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (mAppDelegate_.mDataGetter_.mMealsList_.count == 0) {
        return 0;
    }
    return 75;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (mAppDelegate_.mDataGetter_.mMealsList_.count == 0) {
        return 50;
    }
    NSString* photoURl = [[mAppDelegate_.mDataGetter_.mMealsList_ objectAtIndex:indexPath.section] objectForKey:@"PhotoFileName"];
    if (photoURl) {
        if (![photoURl isEqualToString:@""]) {
            return 170;
        }
    }
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (mAppDelegate_.mDataGetter_.mMealsList_.count == 0) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,75)];
    headerView.backgroundColor = WHITE_COLOR;
    //for top and botton lines
    UIImageView *lImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    lImgView.backgroundColor = RGB_A(204, 204, 204, 1);
    [headerView addSubview:lImgView];
    UIImageView *lImgView1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 74, 320, 1)];
    lImgView1.backgroundColor = RGB_A(204, 204, 204, 1);
   // [headerView addSubview:lImgView1];

    //for arrow image
    UIImageView *larrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (75/2)-5, 13/2, 20/2)];
    if ([[self.mNoofRowsInSectionArray_ objectForKey:[NSString stringWithFormat:@"%d",section]] intValue] == 0) {
        larrowImgView.image = [UIImage imageNamed:@"sidearrow.png"];

    }else{
        larrowImgView.image = [UIImage imageNamed:@"dropdownarrow.png"];
        larrowImgView.frame = CGRectMake(15, (75/2)-6, 19/2, 12/2);

    }
    [headerView addSubview:larrowImgView];
    
    /*
     * for title label
     */
    UILabel *lTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 4, 150, 70)];
    lTitleLabel.textColor=BLACK_COLOR;
    lTitleLabel.font=Bariol_Bold(17);
    lTitleLabel.lineBreakMode=UILineBreakModeWordWrap;
    lTitleLabel.numberOfLines=0;
    lTitleLabel.text=[[mAppDelegate_.mDataGetter_.mMealsList_ objectAtIndex:section] objectForKey:@"FoodName"];
    lTitleLabel.userInteractionEnabled=TRUE;
    lTitleLabel.backgroundColor=[UIColor clearColor];
    [headerView addSubview:lTitleLabel];
    
    /*
     * for calorie label
     */
    UILabel *lCalLabel=[[UILabel alloc]initWithFrame:CGRectMake(200, 25, 60, 25)];
    lCalLabel.textColor=BLACK_COLOR;
    lCalLabel.font=Bariol_Regular(22);
    lCalLabel.lineBreakMode=UILineBreakModeWordWrap;
    lCalLabel.numberOfLines=0;
    lCalLabel.text=[NSString stringWithFormat:@"%d",[[[mAppDelegate_.mDataGetter_.mMealsList_ objectAtIndex:section] objectForKey:@"Calories"] intValue]];
    lCalLabel.userInteractionEnabled=TRUE;
    lCalLabel.backgroundColor=CLEAR_COLOR;
    [headerView addSubview:lCalLabel];
    CGSize size =  [lCalLabel.text sizeWithFont:lCalLabel.font constrainedToSize:CGSizeMake(lCalLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lCalLabel.frame = CGRectMake(lCalLabel.frame.origin.x, lCalLabel.frame.origin.y, size.width, lCalLabel.frame.size.height);
    
    //Claories text label
    UILabel *lCalTxtLabel = [[UILabel alloc]initWithFrame:CGRectMake(lCalLabel.frame.size.width+lCalLabel.frame.origin.x+5, 27.5+3, 50, 20) ];
    [lCalTxtLabel setNumberOfLines:0];
    [lCalTxtLabel setText:@"cal."];
    [lCalTxtLabel setBackgroundColor:CLEAR_COLOR];
    [lCalTxtLabel setTextColor:BLACK_COLOR];
    [lCalTxtLabel setFont:Bariol_Regular(14)];
    [headerView addSubview:lCalTxtLabel];

    /*
     * for swap button 
     */
    UIButton *lButton=[[UIButton alloc]initWithFrame:CGRectMake(280, 22.5, 30, 30)];
    lButton.backgroundColor=CLEAR_COLOR;
    [lButton setImage:[UIImage imageNamed:@"refreshincircle.png"] forState:UIControlStateNormal];
    [lButton setImage:[UIImage imageNamed:@"refreshincircleselected.png"] forState:UIControlStateHighlighted];
    [lButton addTarget:self action:@selector(swapFood:) forControlEvents:UIControlEventTouchUpInside];
    lButton.tag=section;
    [headerView addSubview:lButton];
    
    /*
     * for back button
     */
    UIButton *lBackButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 230, headerView.frame.size.height)];
    lBackButton.backgroundColor=[UIColor clearColor];
    [lBackButton addTarget:self action:@selector(showItems:) forControlEvents:UIControlEventTouchUpInside];
    lBackButton.tag=section;
    [headerView addSubview:lBackButton];
    
    return headerView;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
        UIView *lSelectedView_ = [[UIView alloc] init];
        lSelectedView_.backgroundColor =SELECTED_CELL_COLOR;
        //cell.selectedBackgroundView = lSelectedView_;
        lSelectedView_=nil;
        
        UILabel *lTextLabel=[GenricUI labelWithFrame:CGRectMake(30, 5, 200, 20) title:@"" font:Bariol_Regular(17) color:[UIColor blackColor]];
        lTextLabel.tag=1;
        lTextLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lTextLabel];
        
        AsyncImageView *AsyncImgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(45, 5, 200, 150)];
        AsyncImgView.tag = 2;
        [cell.contentView addSubview:AsyncImgView];
    }
    
    /*
     
     * to get the label instance
     */
    
    UILabel *lTextLblIns=(UILabel*)[cell.contentView viewWithTag:1];
    lTextLblIns.hidden = TRUE;
    if (mAppDelegate_.mDataGetter_.mMealsList_.count == 0) {
        lTextLblIns.hidden = FALSE;
        lTextLblIns.lineBreakMode=UILineBreakModeWordWrap;
        lTextLblIns.numberOfLines = 2;
        lTextLblIns.text = NSLocalizedString(@"NO_SWAP_RECORDS_FOUND", nil);
        //@"Since you have not selected any suggested meal plan; no swap options are available.";
        lTextLblIns.frame = CGRectMake(15, 4, 290, 44);
        return cell;
    }
    AsyncImageView *AsyncImgView = (AsyncImageView *)[cell viewWithTag:2];
    AsyncImgView.hidden = TRUE;
    NSString* photoURl = [[mAppDelegate_.mDataGetter_.mMealsList_ objectAtIndex:indexPath.section] objectForKey:@"PhotoFileName"];
    if (photoURl) {
        if (![photoURl isEqualToString:@""]) {
            AsyncImgView.hidden = FALSE;
            photoURl = [photoURl stringByReplacingOccurrencesOfString:@"+" withString:@" "];
           photoURl = [photoURl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            photoURl = [photoURl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            AsyncImgView.imageURL = [NSURL URLWithString:photoURl];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)swapFood:(UIButton*)lBtn{
    //swap mel request
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToSwapMeal:mAppDelegate_.mLogMealsViewController.mCurrentDate_
                                                         Meal:mAppDelegate_.mLogMealsViewController.mMealLUT
                                                       MealID:[[mAppDelegate_.mDataGetter_.mMealsList_ objectAtIndex:lBtn.tag] objectForKey:@"FoodID"]
                                                       AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                 SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
    
}
- (void)showItems:(UIButton*)lBtn{
    for (int i=0; i<mAppDelegate_.mDataGetter_.mMealsList_.count; i++) {
        [self.mNoofRowsInSectionArray_ setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    [self.mNoofRowsInSectionArray_ setValue:@"1" forKey:[NSString stringWithFormat:@"%d", lBtn.tag]];
    [self.mtableview reloadData];
    /*
     * to scrool the tableview to the selected index
     */
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:lBtn.tag];
    [self.mtableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMtableview:nil];
    [super viewDidUnload];
}

@end
