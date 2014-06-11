//
//  DailyGoalsSettingViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 12/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "DailyGoalsSettingViewController.h"
#import "JSON.h"
#import "SettingsViewController.h"
#import "StepListViewController.h"
#import "WebEngine.h"
@interface DailyGoalsSettingViewController ()

@end

@implementation DailyGoalsSettingViewController
@synthesize mTitlesArray, mValuesArray,methodName, mSelectedRow, mActiveTxtFld, mCalCode, mMealPlanID, mRowValuesArray;
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mFitnessTblView setSeparatorInset:UIEdgeInsetsZero];
        [self.mNutritionTableView setSeparatorInset:UIEdgeInsetsZero];

        
    }
    mAppDelegate = [AppDelegate appDelegateInstance];
    self.mNutrnLbl.font = Bariol_Regular(22);
    self.mNutrnLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mFitnessLbl.font = Bariol_Regular(22);
    self.mFitnessLbl.textColor = RGB_A(136, 136, 136, 1);
    mTitlesArray = [[NSMutableArray alloc]initWithObjects:@"Calories",@"Water",@"Steps",@"Exercise",@"Weight", nil];
    mValuesArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"", nil];
    mRowValuesArray = [[NSMutableArray alloc]init];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate.mTrackPages) {
       // self.trackedViewName=@"Daily Goals Settings page";
        [mAppDelegate trackFlurryLogEvent:@"Daily Goals Settings page"];
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
    [mAppDelegate setNavControllerTitle:NSLocalizedString(@"DAILY_GOALS", nil) imageName:imgName forController:self];

    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(saveAction:) forController:self rightOrLeft:1];

    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollView.frame = CGRectMake(0, 0, 320, 504);
    }
    self.mScrollView.contentSize = CGSizeMake(320, self.mFitnessTblView.frame.origin.x+self.mFitnessTblView.frame.size.height+20);
     //to retrieve the user tracker goals
     if ([[NetworkMonitor instance]isNetworkAvailable]) {
         [mAppDelegate createLoadView];
         mAppDelegate.mRequestMethods_.mViewRefrence = self;
         [mAppDelegate.mRequestMethods_ postRequestToGetTrackerGoals:mAppDelegate.mResponseMethods_.authToken
                                                        SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
     }else{
         [[NetworkMonitor instance]displayNetworkMonitorAlert];
     }

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   /* if ([mAppDelegate.mDataGetter_.mDailyGoalsDict_ count] > 0 && [mAppDelegate.mDataGetter_.mCalLevelList_ count] > 0 ) {
    } else {
        [self.navigationController popViewControllerAnimated:NO];
        [mAppDelegate showCustomAlert:NSLocalizedString(@"ERROR", nil) Message:NSLocalizedString(@"NO_RESPONSE", nil)];
        return;
    }*/
}
- (void)loadData{
    [self.mValuesArray removeAllObjects];
    if ([mAppDelegate.mDataGetter_.mDailyGoalsDict_ count] > 0 && [mAppDelegate.mDataGetter_.mCalLevelList_ count] > 0 ) {
        
    //Set calories value
    mCalCode = mAppDelegate.mTrackerDataGetter_.mRecommendedCalorie;
    int RecommendedCalorie =  [mAppDelegate.mTrackerDataGetter_.mRecommendedCalorie intValue];
    NSString *CaloryRange = @"";
    for (int j=0; j< [mAppDelegate.mDataGetter_.mCalLevelList_ count]; j++) {
        if ([[[mAppDelegate.mDataGetter_.mCalLevelList_ objectAtIndex:j] valueForKey:@"Code"] intValue] == RecommendedCalorie) {
            CaloryRange = [[mAppDelegate.mDataGetter_.mCalLevelList_ objectAtIndex:j] valueForKey:@"Value"];
        }
    }
    NSString *mLowerRange = [CaloryRange substringToIndex:[CaloryRange rangeOfString:@" -"].location];
    NSString *mHigherRange = [CaloryRange substringFromIndex:[CaloryRange rangeOfString:@"- "].location];
    mHigherRange = [mHigherRange stringByReplacingOccurrencesOfString:@"- " withString:@""];
    mHigherRange = [mHigherRange stringByReplacingOccurrencesOfString:@"," withString:@""];
    mLowerRange = [mLowerRange stringByReplacingOccurrencesOfString:@"," withString:@""];
    int mRange = [mLowerRange intValue] + [mHigherRange intValue];
    mRange = mRange/2;
    [self.mValuesArray addObject:[NSString stringWithFormat:@"%d cal", mRange]];
    //end calories value
    
    //[self.mValuesArray addObject:[NSString stringWithFormat:@"%d cal", [[mAppDelegate.mDataGetter_.mDailyGoalsDict_ objectForKey:@"CaloriesGoal"] intValue]]]
    
    //May13: GoalWater from local DB.
    //[self.mValuesArray addObject:[NSString stringWithFormat:@"%d glasses", [[mAppDelegate.mDataGetter_.mDailyGoalsDict_ objectForKey:@"GoalWater"] intValue]]];//WaterGoal to GoalWater
    NSString* mExternalUserID = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALUSERID];
    NSMutableDictionary *dict = [mAppDelegate.mGenericDataBase_ getWaterGoalFormUser:mExternalUserID];
    NSString* GoalWater = @"";
    if ([dict count] > 0) {
        GoalWater = [dict objectForKey:@"GoalWater"];
    }
    [self.mValuesArray addObject:[NSString stringWithFormat:@"%@ glasses", GoalWater]];
        
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[[mAppDelegate.mDataGetter_.mDailyGoalsDict_ objectForKey:@"GoalSteps"] intValue]]];//StepsGoal

    [self.mValuesArray addObject:[NSString stringWithFormat:@"%@ steps", formatted]];
    [self.mValuesArray addObject:[NSString stringWithFormat:@"%d min", [[mAppDelegate.mDataGetter_.mDailyGoalsDict_ objectForKey:@"GoalExercise"] intValue]]];//ExerciseGoal
    [self.mValuesArray addObject:[NSString stringWithFormat:@"%.1f lbs", [[mAppDelegate.mDataGetter_.mDailyGoalsDict_ objectForKey:@"GoalWeight"] floatValue]]];
    self.mFitnessTblView.userInteractionEnabled = YES;
    self.mNutritionTableView.userInteractionEnabled = YES;
    [self.mFitnessTblView reloadData];
    [self.mNutritionTableView reloadData];
    }else {
    self.mFitnessTblView.userInteractionEnabled = NO;
    self.mNutritionTableView.userInteractionEnabled = NO;
    }
}
#pragma mark TableView Datasource and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mNutritionTableView) {
        return 2;
    }else{
        return 3;
    }
    return 0;
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
        //cell.selectedBackgroundView = lSelectedView_;
        lSelectedView_=nil;
        
        //TITLE LABEL
        UILabel *lLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 120, 20)];
        lLbl.textAlignment = UITextAlignmentLeft;
        lLbl.font = Bariol_Regular(18);
        lLbl.textColor = RGB_A(136, 136, 136, 1);
        lLbl.backgroundColor = CLEAR_COLOR;
        lLbl.tag = 1;
        [cell.contentView addSubview:lLbl];
        
        
        if (tableView == self.mFitnessTblView) {
            //static text label
            UITextField *lTextLbl=[[UITextField alloc]initWithFrame:CGRectMake(150, 10+5, 135, 28)];
            [lTextLbl setTextAlignment:TEXT_ALIGN_RIGHT];
            [Utilities addInputViewForKeyBoardForTextFld:lTextLbl Class:self];
            if (indexPath.row == 2) {
                lTextLbl.keyboardType = UIKeyboardTypeDecimalPad;
            }else{
                lTextLbl.keyboardType = UIKeyboardTypeNumberPad;

            }
            lTextLbl.delegate = self;
            [lTextLbl setFont:Bariol_Regular(18)];
            lTextLbl.tag = indexPath.row+2;
            [lTextLbl setTextColor: BLACK_COLOR];
            [lTextLbl setBackgroundColor:CLEAR_COLOR];
            [cell.contentView addSubview:lTextLbl];

        }else{
            //value label
            UILabel *lValueLbl = [[UILabel alloc]initWithFrame:CGRectMake(150, 15, 135, 20)];
            lValueLbl.textColor = BLACK_COLOR;
            lValueLbl.backgroundColor = CLEAR_COLOR;
            lValueLbl.tag=2;
            lValueLbl.textAlignment = UITextAlignmentRight;
            lValueLbl.font = Bariol_Regular(18);
            [cell.contentView addSubview:lValueLbl];

        }

        //arrow image
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(305-8.5, 25-(13/2), 8.5, 13)];
        lImgView.backgroundColor = CLEAR_COLOR;
        lImgView.image = [UIImage imageNamed:@"arrowright.png"];
        lImgView.tag = 3;
        [cell.contentView addSubview:lImgView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //to get the instances
    UILabel *lLblIns = (UILabel*)[cell.contentView viewWithTag:1];
    if (tableView == self.mFitnessTblView) {
        UITextField *lTxfFld = (UITextField*)[cell.contentView viewWithTag:indexPath.row+2];
        lTxfFld.text = [self.mValuesArray objectAtIndex:indexPath.row+2];
    }else{
        UILabel *lLblIns2 = (UILabel*)[cell.contentView viewWithTag:2];
        lLblIns2.text = [self.mValuesArray objectAtIndex:indexPath.row];

    }

    if (tableView == self.mFitnessTblView) {
        lLblIns.text = [self.mTitlesArray objectAtIndex:indexPath.row+2];

    }else{
        lLblIns.text = [self.mTitlesArray objectAtIndex:indexPath.row];

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.mActiveTxtFld != nil) {
        [self.mActiveTxtFld resignFirstResponder];
    }
    if (tableView == self.mFitnessTblView) {
    }else{
        self.mSelectedRow = indexPath.row;
        switch (indexPath.row) {
            case 0:
            {
                isFromSave = FALSE;
                [self removeViews];
                [self displayPickerview];
            }
                break;
            case 1:
                [self removeViews];
                [self displayPickerview];
                break;
                
            default:
                break;
        }
    }

}
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)saveAction:(UIButton*)sender{
    isFromSave = TRUE;
    if (self.mActiveTxtFld!=nil) {
        [self.mActiveTxtFld resignFirstResponder];
    }
    //NSLog(@"mValuesArray %@",mValuesArray);
    int RecommendedCalorie =  [mAppDelegate.mTrackerDataGetter_.mRecommendedCalorie intValue];
    if ([mCalCode intValue] == RecommendedCalorie) {
        //i.e calories not modified.
        [self postRequestTosaveDailyGoals];
    }else {
        [self postRequestToSaveRecommendeCalorie];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMNutrnLbl:nil];
    [self setMNutritionTableView:nil];
    [self setMFitnessLbl:nil];
    [self setMFitnessTblView:nil];
    [super viewDidUnload];
}
- (void)displayPickerview {
    
    PickerViewController *screen = [[PickerViewController alloc] init];
    NSMutableArray *rowValuesArr_=[[NSMutableArray alloc] init];
    
    if (self.mSelectedRow == 0) {
        
        NSMutableArray *mTempArray = [[NSMutableArray alloc]init];
        for (int i =0 ; i< mAppDelegate.mDataGetter_.mCalLevelList_.count; i++) {
            [mTempArray addObject:[[mAppDelegate.mDataGetter_.mCalLevelList_ objectAtIndex:i] objectForKey:@"Value"]];
        }
        [rowValuesArr_ addObject:mTempArray];
        screen.mTextDisplayedlb.text=@"Select Goal Calories";
 
    }
    else if(self.mSelectedRow == 1){
        NSArray *mValues = [[NSArray alloc]initWithObjects:@"1", @"2", @"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
        [rowValuesArr_ addObject:mValues];
        screen.mTextDisplayedlb.text=@"Select Goal Water";
    }
    [self.mRowValuesArray removeAllObjects];
    [self.mRowValuesArray addObjectsFromArray:rowValuesArr_];
    screen.mRowValueintheComponent=rowValuesArr_;
    screen->mNoofComponents=[rowValuesArr_ count];
   
    //for reloading the picker view based on the type of the picker
    if (self.mSelectedRow == 0) {
         if(![[self.mValuesArray objectAtIndex:0] isEqualToString:@""]){
             NSString *mVal = [[self.mValuesArray objectAtIndex:0] stringByReplacingOccurrencesOfString:@" cal" withString:@""];
             mVal = [mVal stringByReplacingOccurrencesOfString:@"," withString:@""];

             for (int i=0; i<[[rowValuesArr_ objectAtIndex:0] count]; i++) {
                 NSString *mLowerRange = [[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] substringToIndex:[[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] rangeOfString:@" -"].location];
                 NSString *mHigherRange = [[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] substringFromIndex:[[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] rangeOfString:@"- "].location];
                 mHigherRange = [mHigherRange stringByReplacingOccurrencesOfString:@"- " withString:@""];
                 mHigherRange = [mHigherRange stringByReplacingOccurrencesOfString:@"," withString:@""];
                 mLowerRange = [mLowerRange stringByReplacingOccurrencesOfString:@"," withString:@""];

                 int mRange = [mLowerRange intValue] + [mHigherRange intValue];
                 mRange = mRange/2;
                 if (mRange == [mVal intValue]) {
                     self.mCalCode = [NSString stringWithFormat:@"%d", [[[mAppDelegate.mDataGetter_.mCalLevelList_ objectAtIndex:i] objectForKey:@"Code"] intValue]];
                     [screen.mViewPicker_ selectRow:i inComponent:0 animated:NO];//Fixed crash issue by putting to NO.Means show the selected row immediately..
                    [screen.mViewPicker_ reloadComponent:0];

                 }
             }
         }
    }
    else if (self.mSelectedRow == 1){
        if(![[self.mValuesArray objectAtIndex:1] isEqualToString:@""]){
            NSString *mVal = [[self.mValuesArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@" glasses" withString:@""];
            for (int i=0; i<[[rowValuesArr_ objectAtIndex:0] count]; i++) {
                if ([[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] isEqualToString:mVal]) {
                    [screen.mViewPicker_ selectRow:i inComponent:0 animated:NO];
                    [screen.mViewPicker_ reloadComponent:0];
                }
            }
        }
    }
    [screen setMPickerViewDelegate_:self];
    // [screen setMSelectedTextField_:mActiveTxtFld_];
    [mAppDelegate.window addSubview:screen];
    
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
        }
        if (self.mSelectedRow == 0) {
            
            for (int i = 0 ; i < mAppDelegate.mDataGetter_.mCalLevelList_.count; i++) {
                if ([[[mAppDelegate.mDataGetter_.mCalLevelList_ objectAtIndex:i] objectForKey:@"Value"] isEqualToString:mData_]) {
                    self.mCalCode = [NSString stringWithFormat:@"%d", [[[mAppDelegate.mDataGetter_.mCalLevelList_ objectAtIndex:i] objectForKey:@"Code"] intValue]];

                }
            }
            NSString *mLowerRange = [mData_ substringToIndex:[mData_ rangeOfString:@" -"].location];
            NSString *mHigherRange = [mData_ substringFromIndex:[mData_ rangeOfString:@"- "].location];
            mHigherRange = [mHigherRange stringByReplacingOccurrencesOfString:@"- " withString:@""];
            mHigherRange = [mHigherRange stringByReplacingOccurrencesOfString:@"," withString:@""];
            mLowerRange = [mLowerRange stringByReplacingOccurrencesOfString:@"," withString:@""];
            int mRange = [mLowerRange intValue] + [mHigherRange intValue];
            mRange = mRange/2;
            [self.mValuesArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d cal", mRange]];
            [self.mNutritionTableView reloadData];

        }
		 else if (self.mSelectedRow == 1){
             [self.mValuesArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@ glasses", mData_]];
             [self.mNutritionTableView reloadData];


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
#pragma mark UIPickerDelegate methods

// ************************* tell the picker how many components it will have ******************
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.mRowValuesArray.count;
}

//  *************** tell the picker how many rows are available for a given component ************
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self.mRowValuesArray objectAtIndex:component] count];

}

// ************* tell the picker the title for a given component ****************
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	
    return [[self.mRowValuesArray objectAtIndex:component] objectAtIndex:row] ;

}
- (void)removeViews{
    for (UIView *lview in mAppDelegate.window.subviews) {
        if ([lview isKindOfClass:[PickerViewController class]]) {
            [lview removeFromSuperview];
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217+55 , 0.0);
    
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    CGRect lFrame;
    lFrame=[self.mScrollView convertRect:textField.bounds fromView:textField];
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
    if ([textField.text floatValue] == 0) {
        textField.text = @"";
    }
    if (textField.tag == 2) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" steps" withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];

    }else if (textField.tag == 3){
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" min" withString:@""];

    }else if (textField.tag == 4)
    {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" lbs" withString:@""];

    }
    self.mActiveTxtFld = textField;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength;
    newLength = [textField.text length] + [string length] - range.length;
    
    if (textField.tag == 2) {
        return YES;

    }
    if(newLength > 5){
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length != 0) {
        if (textField.tag == 2) {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
            
            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[textField.text intValue]]];
            
            textField.text = [NSString stringWithFormat:@"%@ steps", formatted];

        }else if (textField.tag == 3){
            textField.text = [NSString stringWithFormat:@"%@ min", textField.text];

        }else if (textField.tag == 4){
            textField.text = [NSString stringWithFormat:@"%.1f lbs", [textField.text floatValue]];

        }
    }else{
        textField.text = @"0";
        if (textField.tag == 2) {
            textField.text = [NSString stringWithFormat:@"%@ steps", textField.text];
            
        }else if(textField.tag == 3){
            textField.text = [NSString stringWithFormat:@"%@ min", textField.text];
            
        }else if (textField.tag == 4){
            textField.text = [NSString stringWithFormat:@"%.1f lbs", [textField.text floatValue]];
            
        }

    }
    [self.mValuesArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;

}
// clear action
- (void)cancelTxtFld_Event
{
    self.mActiveTxtFld.text = @"";
    
}
// done action
- (void)doneTxtFld_Event
{
    [self.mActiveTxtFld resignFirstResponder];
   
    
}


#pragma mark multithreading requests
- (void)postRequestToSaveRecommendeCalorie {
   
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"%@/%@?caloriesLevel=%@",SETTINGS,CALORIESTXT,mCalCode];
    NSURL *url1 = [NSURL URLWithString:mRequestStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:60.0];
        //[theRequest valueForHTTPHeaderField:body];
        [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
        [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
        [theRequest setHTTPMethod:@"POST"];
        
        NSData *response = [NSURLConnection
                            sendSynchronousRequest:theRequest
                            returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc]
                                 initWithData:response encoding:NSUTF8StringEncoding];
        DLog(@"json_string: Save Recommended level %@", json_string);
    if ([json_string boolValue]) {
        [self postRequestTosaveDailyGoals];
    } else {
        [mAppDelegate showCustomAlert:@"" Message:NSLocalizedString(@"AN_ERROR_OCCURED", nil)];
    }
}
- (void)postRequestTosaveDailyGoals{
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"%@/%@", SETTINGS, GoalTxt];
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        
        [mAppDelegate createLoadView];
        [NSThread detachNewThreadSelector:@selector(GetResponseDataDailyGoals:) toTarget:self withObject: mRequestStr];
        
    }else {
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
        return;
    }
}
- (void)GetResponseDataDailyGoals:(NSObject *) myObject  {
    
    NSURL *url1 = [NSURL URLWithString:(NSString *)myObject];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    
    NSString* mWeight = [[self.mValuesArray objectAtIndex:4] stringByReplacingOccurrencesOfString:@" lbs" withString:@""];
    
    NSString* mWater = [[self.mValuesArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@" glasses" withString:@""];
    
    NSString* mSteps = [[self.mValuesArray objectAtIndex:2] stringByReplacingOccurrencesOfString:@" steps" withString:@""];
    mSteps = [mSteps stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString* mExercise = [[self.mValuesArray objectAtIndex:3] stringByReplacingOccurrencesOfString:@" min" withString:@""];
        
        
    
    NSString *body = [NSString stringWithFormat:@"GoalWeight=%@&GoalExercise=%@&GoalSteps=%@&GoalWater=%@",mWeight,mExercise,mSteps,mWater];
    NSData *bodyData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    [theRequest setHTTPMethod:@"PUT"];
    [theRequest setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:bodyData];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    
    NSLog(@"json_string %@",json_string);
    if ([json_string isEqualToString:@"true"]) {
        
    NSString* mExternalUserID = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALUSERID];
    [mAppDelegate.mGenericDataBase_ updateWaterGoalFormUser:mWater UserId:mExternalUserID];
    
    dispatch_async(dispatch_get_main_queue(), ^{
            [mAppDelegate showCustomAlert:@"" Message:@"Daily goals updated successfully."];
        });
        
      
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [mAppDelegate showCustomAlert:@"" Message:NSLocalizedString(@"AN_ERROR_OCCURED", nil)];
        }); 
    }
    
    [mAppDelegate removeLoadView];
    [self.navigationController popViewControllerAnimated:TRUE];
    if ([self.mParentClass isKindOfClass:[StepListViewController class]]) {
        [mAppDelegate.mStepListViewController refreshTodayView];
    }
    
    
    
}

@end
