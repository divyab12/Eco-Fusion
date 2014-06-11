//
//  PersonalSettingsViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 07/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "PersonalSettingsViewController.h"
#define gender @"Male,Female"
#define height @"0,1,2,3,4,5,6,7,8,9,10,11"
@interface PersonalSettingsViewController ()

@end

@implementation PersonalSettingsViewController
@synthesize mTitlesArray;
@synthesize mDetailsDict;
@synthesize mActiveTxtFld_,mRowValueintheComponent,mTxtFldsArray;

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
    mAppDelegate = [AppDelegate appDelegateInstance];
    [mAppDelegate hideEmptySeparators:self.mTableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    // for setting the view below 20px in iOS7.0.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif

    mTitlesArray = [[NSMutableArray alloc]initWithObjects:@"Start Weight",@"Height",@"Gender",@"Goal Weight", @"Date of Birth",@"Activity Level",@"Select a Goal", nil];
    mDetailsDict = [[NSMutableDictionary alloc]init];
    mTxtFldsArray = [[NSMutableArray alloc]init];
    
    [self loadDetails];
    [self.mTableView reloadData];
   
    NSMutableArray *lArr=[[NSMutableArray alloc] init];
    self.mRowValueintheComponent=lArr;
    



}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate.mTrackPages) {
       // self.trackedViewName=@"Personal Settings page";
        [mAppDelegate trackFlurryLogEvent:@"Personal Settings page"];
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
    [mAppDelegate setNavControllerTitle:NSLocalizedString(@"PERSONAL_SETTINGS", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(saveAction:) forController:self rightOrLeft:1];

}

- (void)loadDetails
{
    //start weight
    [mDetailsDict setValue:[NSString stringWithFormat:@"%.1f lbs",[[mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"StartWeight"] floatValue]] forKey:[mTitlesArray objectAtIndex:0]];
    
    //Height
    [mDetailsDict setValue:[NSString stringWithFormat:@"%d.%d ft", [[mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"HeightFt"] intValue], [[mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"HeightInch"] intValue]] forKey:[mTitlesArray objectAtIndex:1]];
    //Gender
    [mDetailsDict setValue:[NSString stringWithFormat:@"%d",[[mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"Gender"] intValue]] forKey:[mTitlesArray objectAtIndex:2]];
    //goal weight
    [mDetailsDict setValue:[NSString stringWithFormat:@"%.1f lbs",[[mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"GoalWeight"] floatValue]] forKey:[mTitlesArray objectAtIndex:3]];
    //date of birth
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    
    NSDate *lDate =[lFormatter dateFromString:[mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"BirthDate"]];//@"DateOfBirth"
    [lFormatter setDateFormat:@"MMM. dd, yyyy"];
    [mDetailsDict setValue:[lFormatter stringFromDate:lDate] forKey:[mTitlesArray objectAtIndex:4]];
   
    //ActivityLevel
    NSString *mStr;

    for (int iLevelCnt =0 ; iLevelCnt < mAppDelegate.mDataGetter_.mActivityLevelList_.count; iLevelCnt++) {
        if ([[[mAppDelegate.mDataGetter_.mActivityLevelList_ objectAtIndex:iLevelCnt] objectForKey:@"Code"] intValue] == [[mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"ActivityLevel"] intValue]) {
            mStr = [[mAppDelegate.mDataGetter_.mActivityLevelList_ objectAtIndex:iLevelCnt] objectForKey:@"Value"];

        }
    }
    [mDetailsDict setValue:mStr forKey:[mTitlesArray objectAtIndex:5]];
    
    //goal
    mStr = @"";
    for (int iLevelCnt =0 ; iLevelCnt < mAppDelegate.mDataGetter_.mMealGoalList_.count; iLevelCnt++) {
        if ([[[mAppDelegate.mDataGetter_.mMealGoalList_ objectAtIndex:iLevelCnt] objectForKey:@"Code"] intValue] == [[mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"MealGoal"] intValue]) {
            mStr = [[mAppDelegate.mDataGetter_.mMealGoalList_ objectAtIndex:iLevelCnt] objectForKey:@"Value"];
            
        }
    }
    [mDetailsDict setValue:mStr forKey:[mTitlesArray objectAtIndex:6]];


}
#pragma mark TableView Datasource and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.mTitlesArray.count-1; // Hide SelectGoal filed.
    //return self.mTitlesArray.count;
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
        UILabel *lLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 120, 50)];
        lLbl.textAlignment = UITextAlignmentLeft;
        lLbl.font = Bariol_Regular(17);
        lLbl.textColor = RGB_A(136, 136, 136, 1);
        lLbl.backgroundColor = CLEAR_COLOR;
        lLbl.tag = 1;
        [cell.contentView addSubview:lLbl];
        
        
        if (indexPath.row!=2) {
            UITextField *lTxtFld = [[UITextField alloc]initWithFrame:CGRectMake(285-120, 16, 120, 28)];
            lTxtFld.textAlignment = UITextAlignmentRight;
            lTxtFld.font = Bariol_Regular(17);
            lTxtFld.textColor = BLACK_COLOR;
            lTxtFld.tag = indexPath.row + 3;
            lTxtFld.backgroundColor = CLEAR_COLOR;
            lTxtFld.delegate = self;
            if (indexPath.row == 0 ||indexPath.row == 3) {
                lTxtFld.keyboardType = UIKeyboardTypeDecimalPad;
                [Utilities addInputViewForKeyBoardForTextFld:lTxtFld Class:self];
            }
            [cell.contentView addSubview:lTxtFld];

        }else{
            //lFemale btn
            UIButton *lBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(132, 10, 30, 30)];
            [lBtn1 addTarget:self action:@selector(femaleAction:) forControlEvents:UIControlEventTouchUpInside];
            lBtn1.backgroundColor = CLEAR_COLOR;

            if ([[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:indexPath.row]] intValue] == 2) {
                lBtn1.selected = TRUE;
                [lBtn1 setImage:[UIImage imageNamed:@"radiobtnactive.png"] forState:UIControlStateNormal];

            }else{
                lBtn1.selected = FALSE;
                [lBtn1 setImage:[UIImage imageNamed:@"in.png"] forState:UIControlStateNormal];

            }
            [cell.contentView addSubview:lBtn1];
            
            //label
            UILabel *lfLbl = [[UILabel alloc]initWithFrame:CGRectMake(lBtn1.frame.origin.x+lBtn1.frame.size.width+10, 15, 60, 20)];
            lfLbl.text = @"Female";
            lfLbl.textAlignment = UITextAlignmentLeft;
            lfLbl.font = Bariol_Regular(15);
            lfLbl.textColor = BLACK_COLOR;
            lfLbl.backgroundColor = CLEAR_COLOR;
            [cell.contentView addSubview:lfLbl];
            
            //male btn
            UIButton *lBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(lfLbl.frame.origin.x+lfLbl.frame.size.width+5, 10, 30, 30)];
            [lBtn2 addTarget:self action:@selector(maleAction:) forControlEvents:UIControlEventTouchUpInside];
            lBtn2.backgroundColor = CLEAR_COLOR;

            if ([[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:indexPath.row]] intValue] == 1) {
                lBtn2.selected = TRUE;
                [lBtn2 setImage:[UIImage imageNamed:@"radiobtnactive.png"] forState:UIControlStateNormal];
            }else{
                lBtn2.selected = FALSE;
                [lBtn2 setImage:[UIImage imageNamed:@"in.png"] forState:UIControlStateNormal];
            }
            [cell.contentView addSubview:lBtn2];
            
            //label
            UILabel *lmLbl = [[UILabel alloc]initWithFrame:CGRectMake(lBtn2.frame.origin.x+lBtn2.frame.size.width+10, 15, 40, 20)];
            lmLbl.text = @"Male";
            lmLbl.textAlignment = UITextAlignmentLeft;
            lmLbl.font = Bariol_Regular(15);
            lmLbl.textColor = BLACK_COLOR;
            lmLbl.backgroundColor = CLEAR_COLOR;
            [cell.contentView addSubview:lmLbl];

        }
        
        //arrow image
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(305-8.5, 25-(13/2), 8.5, 13)];
        lImgView.backgroundColor = CLEAR_COLOR;
        lImgView.image = [UIImage imageNamed:@"arrowright.png"];
        lImgView.tag = 2;

        if (indexPath.row == 2) {
            lImgView.hidden = TRUE;
        }
        [cell.contentView addSubview:lImgView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //to get the instances
    UILabel *lLblIns = (UILabel*)[cell.contentView viewWithTag:1];
    lLblIns.text = [self.mTitlesArray objectAtIndex:indexPath.row];
    
    if (indexPath.row!=2) {
        //text label
        UITextField *lValFldIns = (UITextField*)[cell.contentView viewWithTag:3+indexPath.row];
        lValFldIns.text = [self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.mTxtFldsArray addObject:lValFldIns];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row!=2) {
        //UITextField *mTxtFld = (UITextField*)[self.mTxtFldsArray objectAtIndex:indexPath.row];
        UITableViewCell* selectedCell = [self.mTableView cellForRowAtIndexPath:indexPath];
        UITextField *lLbl2 = (UITextField*)[selectedCell.contentView viewWithTag:indexPath.row+3];
        [lLbl2 becomeFirstResponder];
    }
    
}
- (void)maleAction:(UIButton*)lbtn{
    if (lbtn.selected) {
        [mDetailsDict setValue:@"2" forKey:[mTitlesArray objectAtIndex:2]];
    }else{
        [mDetailsDict setValue:@"1" forKey:[mTitlesArray objectAtIndex:2]];

    }
    [self.mTableView reloadData];
}
- (void)femaleAction:(UIButton*)lbtn{
    if (lbtn.selected) {
        [mDetailsDict setValue:@"1" forKey:[mTitlesArray objectAtIndex:2]];
    }else{
        [mDetailsDict setValue:@"2" forKey:[mTitlesArray objectAtIndex:2]];
        
    }
    [self.mTableView reloadData];
}

# pragma mark ***** TextFieldDelegatemethods *****
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    if (textField.tag-3 == 0 || textField.tag-3 ==3) {
        return YES;
    }else{
        if (self.mActiveTxtFld_!=nil) {
            [self.mActiveTxtFld_ resignFirstResponder];
        }
        self.mActiveTxtFld_ = textField;
        if (textField.tag-3 == 1) {
            mTextInToolBar=@"Select Height";
            NSArray *lRowValueArr=[height componentsSeparatedByString:@","];
            [self.mRowValueintheComponent removeAllObjects];
            [self.mRowValueintheComponent addObject:lRowValueArr];
            [self.mRowValueintheComponent addObject:lRowValueArr];
            [self displayPickerview];
        }else if(textField.tag -3 == 5){
            mTextInToolBar=@"Select how active";
            NSMutableArray *mArray = [[NSMutableArray alloc]init];
            for (int i=0; i<mAppDelegate.mDataGetter_.mActivityLevelList_.count; i++) {
                [mArray addObject:[[mAppDelegate.mDataGetter_.mActivityLevelList_ objectAtIndex:i] objectForKey:@"Value"]];
            }
            [self.mRowValueintheComponent removeAllObjects];
            [self.mRowValueintheComponent addObject:mArray];
            [self displayPickerview];


        }else if(textField.tag -3 == 6){
            mTextInToolBar=@"Select a Goal";
            NSMutableArray *mArray = [[NSMutableArray alloc]init];
            for (int i=0; i<mAppDelegate.mDataGetter_.mMealGoalList_.count; i++) {
                [mArray addObject:[[mAppDelegate.mDataGetter_.mMealGoalList_ objectAtIndex:i] objectForKey:@"Value"]];
            }
            [self.mRowValueintheComponent removeAllObjects];
            [self.mRowValueintheComponent addObject:mArray];
            [self displayPickerview];

            
        }else if(textField.tag-3 == 4){
            [self displayDatePicker];
        }
    }
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" lbs" withString:@""];
    self.mActiveTxtFld_ = textField;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength;
    newLength = [textField.text length] + [string length] - range.length;
    
    if(newLength > 5){
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length != 0) {
        textField.text = [NSString stringWithFormat:@"%.1f lbs", [textField.text floatValue]];
        
    }else{
        if (textField.tag == 3) {
            //start weight
            self.mActiveTxtFld_.text = [NSString stringWithFormat:@"%.1f lbs", [[mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"StartWeight"] floatValue]];
        }
        if (textField.tag == 6) {
            
            //goal weight
             self.mActiveTxtFld_.text = [NSString stringWithFormat:@"%.1f lbs", [[mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"GoalWeight"] floatValue]];
        }
    }
    [mDetailsDict setValue:[NSString stringWithFormat:@"%.1f lbs", [self.mActiveTxtFld_.text floatValue]] forKey:[mTitlesArray objectAtIndex:self.mActiveTxtFld_.tag-3]];
    
    
}

// clear action
- (void)cancelTxtFld_Event
{
    self.mActiveTxtFld_.text = @"";
    
    
}
// done action
- (void)doneTxtFld_Event
{
    [self.mActiveTxtFld_ resignFirstResponder];
    self.mActiveTxtFld_ = nil;
    
}

- (void)displayPickerview {
    
    PickerViewController *screen = [[PickerViewController alloc] init];
    screen.mRowValueintheComponent=self.mRowValueintheComponent;
    screen->mNoofComponents=[self.mRowValueintheComponent count];
    screen.mTextDisplayedlb.text=mTextInToolBar;
   
    // *********** ************* reloading the components to the value in the particular label *************** **************
    if (self.mActiveTxtFld_.tag -3 == 1) {
        NSString *mHeight = self.mActiveTxtFld_.text;
        mHeight = [mHeight stringByReplacingOccurrencesOfString:@" ft" withString:@""];
        NSArray *lArray = [mHeight componentsSeparatedByString:@"."];
        
        [screen.mViewPicker_ selectRow:[[lArray objectAtIndex:0] intValue] inComponent:0 animated:YES];
        [screen.mViewPicker_ reloadComponent:0];
        [screen.mViewPicker_ selectRow:[[lArray objectAtIndex:1] intValue] inComponent:1 animated:YES];
        [screen.mViewPicker_ reloadComponent:1];
    }else if(self.mActiveTxtFld_.tag -3 == 5 || self.mActiveTxtFld_.tag -3 == 6){
        for (int i =0; i<[[self.mRowValueintheComponent objectAtIndex:0]count]; i++) {
            if ([[[self.mRowValueintheComponent objectAtIndex:0] objectAtIndex:i] isEqualToString:self.mActiveTxtFld_.text]) {
                [screen.mViewPicker_ selectRow:i inComponent:0 animated:YES];
                [screen.mViewPicker_ reloadComponent:0];
            }
        }
    }
    [screen setMPickerViewDelegate_:self];
    [screen setMSelectedTextField_:mActiveTxtFld_];
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
        if ([controller mSelectedTextField_].tag -3 == 1) {
            [controller mSelectedTextField_].text = [NSString stringWithFormat:@"%@ ft",mData_];
            [mDetailsDict setValue:[NSString stringWithFormat:@"%@ ft", mData_] forKey:[mTitlesArray objectAtIndex:1]];


        }
        else{
            [controller mSelectedTextField_].text = mData_;
            [mDetailsDict setValue:mData_ forKey:[mTitlesArray objectAtIndex:controller.mSelectedTextField_.tag-3]];
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
- (void)displayDatePicker{
    
    
    DatePickerController *screen = [[DatePickerController alloc] init];
    
    NSString *tempString=@"";
    tempString = self.mActiveTxtFld_.text;
    NSDate *getDate=(NSDate *)tempString;
    
    //set the minimum date
    [[screen mDatePicker_] setMaximumDate:[NSDate date]];
    if (getDate == nil)
    {
        getDate = [NSDate date];
        
    }else {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
        [df setTimeZone:gmtZone];
        NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
        df.locale = enLocale;
        [df setDateFormat:@"MMM. dd, yyyy"];
        screen.mTextDisplayedlb.text=NSLocalizedString(@"SELECT_DATE",nil);
        getDate = [df dateFromString:tempString];
    }
    
    // Set the date current in the textField
    if ([tempString isEqualToString:@""])
    {
        [[screen mDatePicker_]setDate:[NSDate date] animated:YES];
        
    }
    else {
        [[screen mDatePicker_]setDate:getDate animated:YES];
    }
    
    [screen setMDatePickerDelegate_:self];
    [screen setMSelectedTextField_:self.mActiveTxtFld_];
    [mAppDelegate.window addSubview:screen];
    
}
- (void)datePickerController:(DatePickerController *)controller
                 didPickDate:(NSDate *)date
                      isDone:(BOOL)isDone {
   
    if(isDone==YES)
    {
		NSDateFormatter *lDateFormat_ = [[NSDateFormatter alloc] init];
        NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
        [lDateFormat_ setTimeZone:gmtZone];
        NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
        lDateFormat_.locale = enLocale;
        [lDateFormat_ setDateFormat:@"MMM. dd, yyyy"];
        controller.mSelectedTextField_.text = [NSString stringWithFormat:@"%@", [lDateFormat_ stringFromDate:date]];
        [mDetailsDict setValue:[NSString stringWithFormat:@"%@", [lDateFormat_ stringFromDate:date]] forKey:[mTitlesArray objectAtIndex:controller.mSelectedTextField_.tag-3]];

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)saveAction:(id)sender {
   // NSLog(@"%@",self.mDetailsDict);
    //for validations
    if ([[[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:0]] stringByReplacingOccurrencesOfString:@" lbs" withString:@""] isEqualToString:@"0.0"]) {
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please enter your start weight."];
        return;
    }else if ([[[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:1]] stringByReplacingOccurrencesOfString:@" ft" withString:@""] isEqualToString:@"0.0"]){
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please enter your height."];
        return;
    }else if ([[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:2]] intValue]<1){
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please select your gender."];
        return;
    }else if ([[[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:3]] stringByReplacingOccurrencesOfString:@" lbs" withString:@""] isEqualToString:@"0.0"]){
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please enter your goal weight."];
        return;
    }else if ([self.mDetailsDict objectForKey:@"Activity Level"] == nil || [[self.mDetailsDict objectForKey:@"Activity Level"] isEqualToString:@""]){
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please select your activity level."];
        return;
    }
    /*
    else if ([self.mDetailsDict objectForKey:@"Select a Goal"] == nil || [[self.mDetailsDict objectForKey:@"Select a Goal"] isEqualToString:@""]){
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Please select your goal type."];
        return;
    }*/
    //end
    NSString *mHeight = [self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:1]];
    mHeight = [mHeight stringByReplacingOccurrencesOfString:@" ft" withString:@""];
    NSArray *mArray = [mHeight componentsSeparatedByString:@"."];
   
    NSString *mDOB = [self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:4]];
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [lFormatter setDateFormat:@"MMM. dd, yyyy"];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    NSDate *lDate =[lFormatter dateFromString:mDOB];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    mDOB = [lFormatter stringFromDate:lDate];
    
    NSString *mActivity=@"7";
    for (int iLevelCnt =0 ; iLevelCnt < mAppDelegate.mDataGetter_.mActivityLevelList_.count; iLevelCnt++) {
        if ([[[mAppDelegate.mDataGetter_.mActivityLevelList_ objectAtIndex:iLevelCnt] objectForKey:@"Value"] isEqualToString: [self.mDetailsDict objectForKey:@"Activity Level"]] ) {
            mActivity = [[mAppDelegate.mDataGetter_.mActivityLevelList_ objectAtIndex:iLevelCnt] objectForKey:@"Code"];
        }
    }
     NSString *mCurrentWeight = [mAppDelegate.mDataGetter_.mPersonalSettingsDict_ objectForKey:@"CurrentWeight"];
    /*
    NSString *mGoal = [self.mDetailsDict objectForKey:@"Select a Goal"];
    for (int iLevelCnt =0 ; iLevelCnt < mAppDelegate.mDataGetter_.mMealGoalList_.count; iLevelCnt++) {
        if ([[[mAppDelegate.mDataGetter_.mMealGoalList_ objectAtIndex:iLevelCnt] objectForKey:@"Value"] isEqualToString:[self.mDetailsDict objectForKey:@"Select a Goal"]] ) {
            mGoal = [[mAppDelegate.mDataGetter_.mMealGoalList_ objectAtIndex:iLevelCnt] objectForKey:@"Code"];
        }
    }
     */

   // NSLog(@"mDetailsDict %@ /n %@",mDetailsDict,mTitlesArray);
   // return;
 
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate createLoadView];
         [mAppDelegate.mRequestMethods_ postRequestToUpdateUserPersonalSettings:mAppDelegate.mResponseMethods_.authToken
                                                                   SessionToken:mAppDelegate.mResponseMethods_.sessionToken
                                                                    StartWeight:[[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:0]] stringByReplacingOccurrencesOfString:@" lbs" withString:@""]
                                                                     GoalWeight:[[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:3]] stringByReplacingOccurrencesOfString:@" lbs" withString:@""]
                                                                   HeightInches:[mArray objectAtIndex:1]
                                                                    HeightFeets:[mArray objectAtIndex:0]
                                                                         Gender:[self.mDetailsDict objectForKey:[self.mTitlesArray objectAtIndex:2]]
                                                                  ActivityLevel:mActivity
                                                                           Goal:mCurrentWeight
                                                                            DOB:mDOB];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
}
- (void)viewDidUnload {
    [self setMTableView:nil];
    [super viewDidUnload];
}
@end
