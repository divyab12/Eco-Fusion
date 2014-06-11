//
//  MealPlannerSettingsViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 30/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "MealPlannerSettingsViewController.h"
#import "LandingViewController.h"

@interface MealPlannerSettingsViewController ()

@end

@implementation MealPlannerSettingsViewController
@synthesize isFromSlider,mPlansListArray,mHelpView;
@synthesize mCaloryLevelChoices,mSeclectedPlansListArray;

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
    // for setting the view below 20px in iOS7.0.
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    // Do any additional setup after loading the view from its nib.
    mAppDelegate_=[AppDelegate appDelegateInstance];
    self.mCalLevelLbl.font = Bariol_Regular(22);
    self.mCalLevelLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mTextlbl.font = Bariol_Regular(17);
    self.mTextlbl.textColor = BLACK_COLOR;
    self.mCalRangeLbl.font = Bariol_Bold(17);
    self.mCalRangeLbl.textColor = BLACK_COLOR;
    self.mCalPerDayLbl.font = Bariol_Regular(17);
    self.mCalPerDayLbl.textColor = BLACK_COLOR;
    self.mCalSetngsLbl.font = Bariol_Regular(17);
    self.mCalSetngsLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mCalValueLbl.font = Bariol_Regular(17);
    self.mCalValueLbl.textColor = BLACK_COLOR;
    self.mSelectPlanLbl.font = Bariol_Regular(22);
    self.mSelectPlanLbl.textColor = RGB_A(136, 136, 136, 1);
    

    //to get the calorie level
    NSString *mCalStr = @"";
    mCaloryLevelChoices = [[NSMutableArray alloc]initWithArray:[mAppDelegate_.mDataGetter_.mPlansList_ valueForKey:@"CaloryLevelChoices"]];
    int selctedCaloryLevel = [[mAppDelegate_.mDataGetter_.mPlansList_ valueForKey:@"CaloryLevel"] intValue];
    for (int iCount =0; iCount < [mCaloryLevelChoices count]; iCount++) {
        if ([[[mCaloryLevelChoices objectAtIndex:iCount] objectForKey:@"Code"] intValue] == selctedCaloryLevel) {
            mCalStr = [[mCaloryLevelChoices objectAtIndex:iCount] objectForKey:@"Value"];
        }
    }
    self.mCalRangeLbl.text = [NSString stringWithFormat:@"%@", mCalStr];
    CGSize size =  [self.mCalRangeLbl.text sizeWithFont:self.mCalRangeLbl.font constrainedToSize:CGSizeMake(1000, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mCalRangeLbl.frame = CGRectMake(self.mCalRangeLbl.frame.origin.x, self.mCalRangeLbl.frame.origin.y, size.width+5, self.mCalRangeLbl.frame.size.height);
    self.mCalPerDayLbl.frame = CGRectMake(self.mCalRangeLbl.frame.origin.x+self.mCalRangeLbl.frame.size.width+3, self.mCalPerDayLbl.frame.origin.y, self.mCalPerDayLbl.frame.size.width, self.mCalPerDayLbl.frame.size.height);

    self.mCalValueLbl.text = [NSString stringWithFormat:@"%@ cal", mCalStr];

    mPlansListArray = [[NSMutableArray alloc]initWithArray:[mAppDelegate_.mDataGetter_.mPlansList_ valueForKey:@"DTGMealPlanChoices"]];
    //Construct An arry to store select/unselect values
    int selctedDTGMealPlan = [[mAppDelegate_.mDataGetter_.mPlansList_ valueForKey:@"DTGMealPlan"] intValue];
    selctedDTGMealPlan--;
    mSeclectedPlansListArray = [[NSMutableArray alloc]init];
    for (int i=0; i < [mPlansListArray count]; i++) {
        NSString* boolValue = @"false";
        if (selctedDTGMealPlan == i) {
            boolValue = @"true";
        }
        [mSeclectedPlansListArray addObject:boolValue];
    }
    /*
    for (int iCount =0; iCount<mAppDelegate_.mDataGetter_.mPlansList_.count; iCount++) {
        [self.mPlansListArray addObject:[[mAppDelegate_.mDataGetter_.mPlansList_ objectAtIndex:iCount] objectForKey:@"Selected"]];
    }*/
    
    self.mTableView.frame = CGRectMake(0, self.mTableView.frame.origin.y, 320, mPlansListArray.count*50);
    self.mTblLastImgView.frame = CGRectMake(0, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+10, 320, 1);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
       // self.trackedViewName=@"Meal Plan Settings page";
        [mAppDelegate_ trackFlurryLogEvent:@"Meal Plan Settings page"];
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"MEAL_PLAN_SETTINGS", nil) imageName:imgName forController:self];
    
    if (!self.isFromSlider) {
        [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(cancelAction:) forController:self rightOrLeft:0];

    }else{
        [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(cancelAction:) forController:self rightOrLeft:0];//need to change to cancel button

    }
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(saveAction:) forController:self rightOrLeft:1];
    
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollview.frame = CGRectMake(self.mScrollview.frame.origin.x, self.mScrollview.frame.origin.y, 320, 504);
    }
}
- (void)displayPickerview {
    NSMutableArray *mArray =[[NSMutableArray alloc]init];
    for (int iCount =0; iCount<mCaloryLevelChoices.count; iCount++) {
        [mArray addObject:[[mCaloryLevelChoices objectAtIndex:iCount] objectForKey:@"Value"]];
    }
    PickerViewController *screen = [[PickerViewController alloc] init];
    NSMutableArray *rowValuesArr_=[[NSMutableArray alloc] init];
    [rowValuesArr_ addObject:mArray];
    screen.mRowValueintheComponent=rowValuesArr_;
    screen->mNoofComponents=[rowValuesArr_ count];
    screen.mTextDisplayedlb.text=@"Select Range";
    //[screen addSubview:screen.mViewPicker_];
  
    
    //to get the range
    NSString *mCalRange = [self.mCalValueLbl.text substringToIndex:[self.mCalValueLbl.text rangeOfString:@" cal"].location];
    for (int i=0; i<[[rowValuesArr_ objectAtIndex:0] count]; i++) {
        if ([[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] isEqualToString:mCalRange]) {
            [screen.mViewPicker_ selectRow:i inComponent:0 animated:YES];
            [screen.mViewPicker_ reloadComponent:0];
        }
    }

    [screen setMPickerViewDelegate_:self];
    // [screen setMSelectedTextField_:mActiveTxtFld_];
    [mAppDelegate_.window addSubview:screen];
    
}
- (void)pickerViewController:(PickerViewController *)controller
                 didPickComp:(NSMutableArray *)valueArr
                      isDone:(BOOL)isDone{
    
    if(isDone==YES)
    {
        
        NSString *mData_=@"";
        for(int i=0;i<[valueArr count];i++){
            if(i==1){
                mData_ = [mData_ stringByAppendingString:@"."];
            }
            mData_=[mData_ stringByAppendingString:[valueArr objectAtIndex:i]];
            self.mCalValueLbl.text = [NSString stringWithFormat:@"%@ cal", mData_];
            self.mCalRangeLbl.text = [NSString stringWithFormat:@"%@", mData_];
            CGSize size =  [self.mCalRangeLbl.text sizeWithFont:self.mCalRangeLbl.font constrainedToSize:CGSizeMake(1000, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
            self.mCalRangeLbl.frame = CGRectMake(self.mCalRangeLbl.frame.origin.x, self.mCalRangeLbl.frame.origin.y, size.width+5, self.mCalRangeLbl.frame.size.height);
            self.mCalPerDayLbl.frame = CGRectMake(self.mCalRangeLbl.frame.origin.x+self.mCalRangeLbl.frame.size.width+3, self.mCalPerDayLbl.frame.origin.y, self.mCalPerDayLbl.frame.size.width, self.mCalPerDayLbl.frame.size.height);
        }
		
        if([controller superview]){
			[controller removeFromSuperview];
		}
    }
    else
    {
        if([controller superview]){
            [controller removeFromSuperview];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mPlansListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if (indexPath.row == 3) {
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 0, 240, 40)];
        lLabel.text = [[mAppDelegate_.mDataGetter_.mPlansList_ objectAtIndex:indexPath.row] objectForKey:@"MealPlanName"];
        [lLabel setFont:Bariol_Regular(15)];
        CGSize size =  [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];

        return size.height+10;
    }else*/
    {
        return 50;

    }
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.clearsContextBeforeDrawing=TRUE;
        
        //selected button
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 30, 30)];
        lBtn.tag = indexPath.row +3;
        [lBtn addTarget:self action:@selector(PlanSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:lBtn];
        
        //plan Label
        UILabel *lLbl=[[UILabel alloc]initWithFrame:CGRectMake(lBtn.frame.origin.x+lBtn.frame.size.width+15, 0, 240, 30)];
        [lLbl setBackgroundColor:CLEAR_COLOR];
        lLbl.numberOfLines = 0;
        lLbl.lineBreakMode = LINE_BREAK_WORD_WRAP;
        [lLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lLbl setFont:Bariol_Regular(17)];
        lLbl.tag =1;
        [lLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lLbl];
        
        //percentage label
        UILabel *lPerLbl = [[UILabel alloc]initWithFrame:CGRectMake(lBtn.frame.origin.x+lBtn.frame.size.width+5, 20, 240, 20)];
        [lPerLbl setBackgroundColor:CLEAR_COLOR];
        lPerLbl.numberOfLines = 0;
        lPerLbl.lineBreakMode = LINE_BREAK_WORD_WRAP;
        [lPerLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lPerLbl setFont:Bariol_Regular(17)];
        lPerLbl.tag =2;
        [lPerLbl setTextColor:BLACK_COLOR];
        if (indexPath.row  != 3) {
            [cell.contentView addSubview:lPerLbl];

        }else{
        }
        
        //selected button
        UIButton *lHelpBtn = [[UIButton alloc]initWithFrame:CGRectMake(285, 3, 25, 25)];
        lHelpBtn.tag = indexPath.row +4;
        [lHelpBtn setImage:[UIImage imageNamed:@"helpicon.png"] forState:UIControlStateNormal];
        [lHelpBtn addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.row  == 3) {
            //lLbl.frame = CGRectMake(lBtn.frame.origin.x+lBtn.frame.size.width+15, 0, 260, 80);
        }else{
            [cell.contentView addSubview:lHelpBtn];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //
    UIButton *lBtnIns = (UIButton*)[cell.contentView viewWithTag:indexPath.row+3];
    lBtnIns.backgroundColor = CLEAR_COLOR;
    
    if ([[self.mSeclectedPlansListArray objectAtIndex:indexPath.row] boolValue]) {
        lBtnIns.selected = TRUE;
        [lBtnIns setImage:[UIImage imageNamed:@"radiobtnactive.png"] forState:UIControlStateNormal];
    }else{
        lBtnIns.selected = FALSE;
        [lBtnIns setImage:[UIImage imageNamed:@"in.png"] forState:UIControlStateNormal];
    }
    
    UILabel *lPlanLblIns= (UILabel*)[cell.contentView viewWithTag:1];
    lPlanLblIns.text = [[self.mPlansListArray objectAtIndex:indexPath.row] objectForKey:@"Value"];

   

    if (indexPath.row  == 3) {
        [lPlanLblIns setFont:Bariol_Regular(17)];
        CGSize size =  [lPlanLblIns.text sizeWithFont:lPlanLblIns.font constrainedToSize:CGSizeMake(260, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lPlanLblIns.frame = CGRectMake(lBtnIns.frame.origin.x+lBtnIns.frame.size.width+15, 0, 260, size.height);
        lPlanLblIns.numberOfLines = 3;
        lPlanLblIns.backgroundColor = CLEAR_COLOR;
        lPlanLblIns.lineBreakMode = UILineBreakModeWordWrap;
    }
    if (indexPath.row!=3) {
        UILabel *lPerLblIns= (UILabel*)[cell.contentView viewWithTag:2];
        lPerLblIns.text = @"";
        //[NSString stringWithFormat:@"(%d/%d/%d)",[[[mAppDelegate_.mDataGetter_.mPlansList_ objectAtIndex:indexPath.row] objectForKey:@"CarbohydrateP"] intValue], [[[mAppDelegate_.mDataGetter_.mPlansList_ objectAtIndex:indexPath.row] objectForKey:@"ProteinP"] intValue], [[[mAppDelegate_.mDataGetter_.mPlansList_ objectAtIndex:indexPath.row] objectForKey:@"FatP"] intValue]];

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
- (void)PlanSelectedAction:(UIButton*)lBtn
{
    int tag = lBtn.tag - 3;
    if (![lBtn isSelected]) {
        [self.mSeclectedPlansListArray replaceObjectAtIndex:tag withObject:@"true"];
        //to deselect other actions
        for (int i=0 ; i<self.mSeclectedPlansListArray.count; i++) {
            if (i!=tag) {
                [self.mSeclectedPlansListArray replaceObjectAtIndex:i withObject:@"false"];
            }
        }
        [self.mTableView reloadData];
    }else {

    }

}
- (void)helpAction:(UIButton*)lBtn
{
    int tag = lBtn.tag - 4;
    for(UIView *lView in self.view.subviews) {
        if([lView isKindOfClass:[UIView class]] && lView.tag == 101) {
            [lView removeFromSuperview];
        }
    }
    
    UIView* trns = [[UIView alloc]initWithFrame:mAppDelegate_.window.frame];
    trns.tag = 101;
    [trns setBackgroundColor:[UIColor blackColor]];
    trns.alpha = 0.7f;
    [mAppDelegate_.window addSubview:trns];
    
    self.mHelpView.hidden = FALSE;
    [self.view bringSubviewToFront:self.mHelpView];
    for (UIView *lView  in mAppDelegate_.window.subviews) {
        if ([lView isKindOfClass:[MealPlannerHelpView class]]) {
            [lView removeFromSuperview];
        }
    }
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"MealPlannerHelpView" owner:self options:nil];
    
    MealPlannerHelpView *lMealPlannerHelpView = [array objectAtIndex:0];
    self.mHelpView = lMealPlannerHelpView;
    lMealPlannerHelpView.frame = CGRectMake(0, 0, 320, mAppDelegate_.window.frame.size.height);
   
    lMealPlannerHelpView.mHelptitlelbl.font = Bariol_Regular(22);
    lMealPlannerHelpView.mHelptitlelbl.textColor = RGB_A(136, 136, 136, 1);
    NSString *helpTitle = @"";
    switch (tag) {
        case 0:
            helpTitle = @"Traditional Low-Fat Diet Meal Plan";
            break;
            
        case 1:
            helpTitle = @"Vegetarian Diet Meal Plan";
            break;
        case 2:
            helpTitle = @"Low-Carb Diet Meal Plan";
            break;
        default:
            break;
    }
    lMealPlannerHelpView.mHelptitlelbl.text = helpTitle;//[[mAppDelegate_.mDataGetter_.mPlansList_ objectAtIndex:lBtn.tag-4] objectForKey:@"MealPlanName"];
    lMealPlannerHelpView.mTextView.font = Bariol_Regular(16);
    lMealPlannerHelpView.mTextView.textColor = BLACK_COLOR;
    lMealPlannerHelpView.mTextView.editable = FALSE;
    NSString *helpText = @"";
    switch (tag) {
        case 0:
            helpText = @"Balanced & Portion-Controlled Meals for Quick & Easy Weight Loss \n\nCustomer & Critic Favorite - Rated # 1 For Taste by Epicurious \n\nGenerous Portion Sizes Keep You Full Longer to Cut Back on Unhealthy Snacking";
            break;
        
        case 1:
            helpText = @"Portion Controlled Vegetarian Meals - Wide Variety of Healthy, Tasty Meals \n\nOvo-Lacto Meals - Meal Plan Contains Dairy & Eggs \n\nProper balance of protein, carbs, healthy fats & fiber - Perfect for weight loss";
            break;
        case 2:
            helpText = @"Atkins Style Low-Carb Plan - 30 Net Carbs Per Day\n\nEasiest Low-Carb Plan Available - No Carb Counting \n\nReduces Cravings by Cutting back on the Sugar Found in Carbs";
            break;
        default:
            break;
    }
    lMealPlannerHelpView.mTextView.text = helpText;//[[mAppDelegate_.mDataGetter_.mPlansList_ objectAtIndex:lBtn.tag-4] objectForKey:@"HelpText"];

    //Actions
    [lMealPlannerHelpView.mDoneBtn addTarget:self action:@selector(helpDoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [mAppDelegate_.window addSubview:lMealPlannerHelpView];

    
}
- (void)helpDoneAction:(id)sender {
    for(UIView *lView in mAppDelegate_.window.subviews) {
        if([lView isKindOfClass:[UIView class]] && lView.tag == 101) {
            [lView removeFromSuperview];
        }
    }
    for (UIView *lView  in mAppDelegate_.window.subviews) {
        if ([lView isKindOfClass:[MealPlannerHelpView class]]) {
            [lView removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMScrollview:nil];
    [self setMCalLevelLbl:nil];
    [self setMTextlbl:nil];
    [self setMCalRangeLbl:nil];
    [self setMSelectPlanLbl:nil];
    [self setMTableView:nil];
    [self setMCalSetngsLbl:nil];
    [self setMCalValueLbl:nil];
    [self setMCalImgView:nil];
    [self setMTblLastImgView:nil];
    [self setMHelpView:nil];
    [self setMCalPerDayLbl:nil];
    [super viewDidUnload];
}
- (void)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
    return;
    if (self.isFromSlider) {
        mAppDelegate_.mSlidingViewController.topViewController = mAppDelegate_.mResponseMethods_.mPrevViewOfSlider;
        [mAppDelegate_.mSlidingViewController resetTopView];

    }else{
         if ([mAppDelegate_.mRequestMethods_.mViewRefrence isKindOfClass:[SettingsViewController class]]) {
             [self.navigationController popViewControllerAnimated:TRUE];

         }else{
             mAppDelegate_.mSlidingViewController.topViewController = mAppDelegate_.mResponseMethods_.mPrevViewOfSlider;
             [mAppDelegate_.mSlidingViewController resetTopView];

         }
    }
   
}
- (void)saveAction:(id)sender {
    
    NSString *mCalRange = [self.mCalValueLbl.text substringToIndex:[self.mCalValueLbl.text rangeOfString:@" cal"].location];
    NSString *mCalLevel = @"";
    for (int iCount =0; iCount<mCaloryLevelChoices.count; iCount++) {
        if ([[[mCaloryLevelChoices objectAtIndex:iCount] objectForKey:@"Value"] isEqualToString:mCalRange]) {
            mCalLevel = [[mCaloryLevelChoices objectAtIndex:iCount] objectForKey:@"Code"];
        }
    }
    
    NSString *mChangedPlanID = @"";
    for (int iCount =0; iCount<self.mSeclectedPlansListArray.count; iCount++) {
        if ([[self.mSeclectedPlansListArray objectAtIndex:iCount] boolValue]) {
            mChangedPlanID = [[mPlansListArray objectAtIndex:iCount] objectForKey:@"Code"];
        }
    }
    NSLog(@"Selected %@ %@",mCalLevel,mChangedPlanID);
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [self postRequestToAddMealSeetingForProspectors:mCalLevel MealPlan:mChangedPlanID];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
}
- (void)postRequestToAddMealSeetingForProspectors:(NSString*)mCalories MealPlan:(NSString*)mealPlane
{
    
    NSString *mReqStr = [NSString stringWithFormat:@"%@%@/%@?Calories=%@&Plan=%@", WEBSERVICEURL, SETTINGS, DEMOPLANTXT,mCalories,mealPlane];
    mReqStr = [mReqStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mReqStr = [mReqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:mReqStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    [theRequest setValue:mAppDelegate_.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate_.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"PUT"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"json_string %@",json_string);
    [mAppDelegate_ removeLoadView];
    if ([json_string boolValue]) {
        [mAppDelegate_ showCustomAlert:@"" Message:NSLocalizedString(@"MEAL_DETAILS_UPDATE_SUCCESS", nil)];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"NO_RESPONSE", nil)];
    }
    
}

- (IBAction)rangeAction:(id)sender {
    [self displayPickerview];
}
@end
