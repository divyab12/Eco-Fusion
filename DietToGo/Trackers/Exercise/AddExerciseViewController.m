//
//  AddExerciseViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 18/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AddExerciseViewController.h"
#import "ActivitiesViewController.h"
#import "SubActivitiesViewController.h"
@interface AddExerciseViewController ()

@end

@implementation AddExerciseViewController
@synthesize mRowsArray,mRowsValueArray, mMETval, mActivityLUT, mSubExerciseArray;

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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    self.mMinLbl.font = Bariol_Regular(17);
    self.mMinLbl.textColor = BLACK_COLOR;
    [self.mMinBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [self.mMinBtn.titleLabel setFont:Bariol_Regular(25)];
    
    self.mDateLbl.font = Bariol_Regular(17);
    self.mDateLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mCalBurnedLbl.font = Bariol_Regular(17);
    self.mCalBurnedLbl.textColor = RGB_A(136, 136, 136, 1);

    self.mDatetxtLbl.font = Bariol_Regular(17);
    self.mDatetxtLbl.textColor = BLACK_COLOR;
    self.mCalLbl.font = Bariol_Regular(25);
    self.mCalLbl.textColor = BLACK_COLOR;
    
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    
    //to display the current date as default
  
    NSDate *lDate = [NSDate date];
    [lFormatter setDateFormat:@"EEE, MM/dd/yy"];
    self.mDatetxtLbl.text = [lFormatter stringFromDate:lDate];
    
    if (self.mCommentsTxtView.text.length == 0) {
        //for placeholder
        UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mCommentsTxtView.frame.size.width - 20.0, 34.0)];
        [placeholderLabel setText:NSLocalizedString(@"ADD_COMMENTS", nil)];
        [placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [placeholderLabel setFont:Bariol_Regular(17)];
        [placeholderLabel setTextColor:RGB_A(136, 136, 136, 1)];
        
        [self.mCommentsTxtView addSubview:placeholderLabel];
        
    }
    
    [Utilities addInputViewForKeyBoard:self.mCommentsTxtView
                                 Class:self];
    mRowsArray = [[NSMutableArray alloc]initWithObjects:@"Exercise", nil];
    mRowsValueArray = [[NSMutableArray alloc]initWithObjects:@"Choose", nil];
    mSubExerciseArray = [[NSMutableArray alloc]init];
    [self.mTableView reloadData];
    
    //for last log value
    if (mAppDelegate_.mTrackerDataGetter_.mExerciseList_.count > 0) {
        [self.mMinBtn setTitle:[NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:0] objectForKey:@"Duration"] intValue]] forState:UIControlStateNormal];
    }else{
        [self.mMinBtn setTitle:@"0" forState:UIControlStateNormal];
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
       // self.trackedViewName=@"Add New Exercise";
        [mAppDelegate_ trackFlurryLogEvent:@"Add New Exercise"];
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
    
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"LOG_EXERCISE_ADD", nil) imageName:imgName forController:self];
    
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];

    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(doneAction:) forController:self rightOrLeft:1];
    
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollView.frame = CGRectMake(self.mScrollView.frame.origin.x, self.mScrollView.frame.origin.y, 320, 504);
        
    }
    self.mTableView.frame = CGRectMake(0, 0, 320, 50*self.mRowsArray.count);
    self.mBtmView.frame = CGRectMake(0, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+35, 320, self.mBtmView.frame.size.height);
    self.mScrollView.contentSize = CGSizeMake(320, self.mBtmView.frame.origin.y+self.mBtmView.frame.size.height+40);
}
- (void)backAction:(UIButton*)sender{
    [self dismissModalViewControllerAnimated:TRUE];
}
- (void)loadTableData{
    DLog(@"%@", self.mSubExerciseArray);

    if ([self.mMETval intValue] == 0 && [self.mActivityLUT intValue] < 0) {
        [self.mRowsArray removeAllObjects];
        [self.mRowsArray addObject:@"Exercise"];
        [self.mRowsArray addObject:@"Category"];
        if (self.mRowsValueArray.count ==2) {
            [self.mRowsValueArray replaceObjectAtIndex:1 withObject:@"Choose"];
        }else if (self.mRowsValueArray.count ==1){
            [self.mRowsValueArray addObject:@"Choose"];
        }

    }else{
        [self.mRowsArray removeAllObjects];
        [self.mRowsArray addObject:@"Exercise"];
        if (self.mRowsValueArray.count > 1) {
            [self.mRowsValueArray removeObjectAtIndex:[self.mRowsValueArray count]-1];
        }
    }
    self.mTableView.frame = CGRectMake(0, 0, 320, 50*self.mRowsArray.count);
    self.mBtmView.frame = CGRectMake(0, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+35, 320, self.mBtmView.frame.size.height);
    self.mScrollView.contentSize = CGSizeMake(320, self.mBtmView.frame.origin.y+self.mBtmView.frame.size.height+20);
    [self.mTableView reloadData];
    if ([self.mMETval intValue] !=0 && self.mMinBtn.currentTitle != nil) {
        float mWeightInKg=[[mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ objectForKey:@"CurrentWeight"] floatValue]*0.4546;
        float hours = [self.mMinBtn.currentTitle intValue]/60.0f;
        int cal = [self.mMETval floatValue]*hours*mWeightInKg;
        self.mCalLbl.text = [NSString stringWithFormat:@"%d", cal];
    }

}
#pragma mark TABLE VIEW DELEGATE METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mRowsArray.count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.clearsContextBeforeDrawing=TRUE;
        
        //date Label
        UILabel *lDateLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 30)];
        [lDateLbl setBackgroundColor:[UIColor clearColor]];
        [lDateLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lDateLbl setFont:Bariol_Regular(17)];
        lDateLbl.tag =1;
        [lDateLbl setTextColor:RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lDateLbl];
        
        //static text label
        UILabel *lTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 180, 50)];
        [lTextLbl setBackgroundColor:[UIColor clearColor]];
        [lTextLbl setTextAlignment:TEXT_ALIGN_RIGHT];
        lTextLbl.numberOfLines = 0;
        lTextLbl.lineBreakMode = UILineBreakModeWordWrap;
        [lTextLbl setFont:Bariol_Regular(17)];
        lTextLbl.tag =2;
        [lTextLbl setTextColor: BLACK_COLOR];
        [cell.contentView addSubview:lTextLbl];
        
        //arrow image
        UIImageView *lImgview = [[UIImageView alloc]initWithFrame:CGRectMake(295, 18.5, 8.5, 13)];
        lImgview.image = [UIImage imageNamed:@"arrowright.png"];//[UIImage imageNamed:@"next(orange).png"]
        [cell.contentView addSubview:lImgview];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lLbl1 = (UILabel*)[cell.contentView viewWithTag:1];
    lLbl1.text = [self.mRowsArray objectAtIndex:indexPath.row];
    UILabel *lLbl2 = (UILabel*)[cell.contentView viewWithTag:2];
    lLbl2.text = [self.mRowsValueArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    if (indexPath.row == 0) {
        ActivitiesViewController *lVc = [[ActivitiesViewController alloc]initWithNibName:@"ActivitiesViewController" bundle:nil];
        [self.navigationController pushViewController:lVc animated:TRUE];
    }else if (indexPath.row == 1){
        SubActivitiesViewController *lVc = [[SubActivitiesViewController alloc]initWithNibName:@"SubActivitiesViewController" bundle:nil];
        lVc.mNavTitleStr = [self.mRowsValueArray objectAtIndex:0];
        NSMutableArray *mArray = [[NSMutableArray alloc]init];
        [mArray addObjectsFromArray:self.mSubExerciseArray];
        [lVc setMExercisesArray:mArray];
        [self.navigationController pushViewController:lVc animated:TRUE];
    }
}
#pragma mark TextView delagate, cancel and done actions
- (void)textViewDidChange:(UITextView*)textView
{
    if(self.mCommentsTxtView.text.length == 0){
        //self.mTextView_.textColor = [UIColor lightGrayColor];
        //self.mTextView_.text = @"comment";
        //[self.mTextView_ resignFirstResponder];
        for (UIView *lview in textView.subviews) {
            if ([lview isKindOfClass:[UILabel class]]) {
                [lview removeFromSuperview];
            }
        }
        UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mCommentsTxtView.frame.size.width - 20.0, 34.0)];
        [placeholderLabel setText:NSLocalizedString(@"ADD_COMMENTS", nil)];
        [placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [placeholderLabel setFont:Bariol_Regular(18)];
        [placeholderLabel setTextColor:RGB_A(136, 136, 136, 1)];
        [self.mCommentsTxtView addSubview:placeholderLabel];
        
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
        UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mCommentsTxtView.frame.size.width - 20.0, 34.0)];
        [placeholderLabel setText:NSLocalizedString(@"ADD_COMMENTS", nil)];
        [placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [placeholderLabel setFont:Bariol_Regular(18)];
        [placeholderLabel setTextColor:RGB_A(136, 136, 136, 1)];
        [self.mCommentsTxtView addSubview:placeholderLabel];
        
    }else {
        for (UIView *lview in textView.subviews) {
            if ([lview isKindOfClass:[UILabel class]]) {
                [lview removeFromSuperview];
            }
        }
        
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217 , 0.0);
    
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
    
    CGRect lFrame=[self.mScrollView convertRect:textView.bounds fromView:textView];
    
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
}
// clear action
- (void)cancel_Event
{
    self.mCommentsTxtView.text = @"";
    for (UIView *lview in self.mCommentsTxtView.subviews) {
        if ([lview isKindOfClass:[UILabel class]]) {
            [lview removeFromSuperview];
        }
    }
    UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mCommentsTxtView.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:NSLocalizedString(@"ADD_COMMENTS", nil)];
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:Bariol_Regular(18)];
    [placeholderLabel setTextColor:RGB_A(136, 136, 136, 1)];
    [self.mCommentsTxtView addSubview:placeholderLabel];
    
}
// done action
- (void)done_Event
{
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
    
}
- (void)displayDatePicker{
    
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217+55 , 0.0);
    
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    CGRect lFrame;
    if (selectedBtn == 1) {
        lFrame=[self.mScrollView convertRect:self.mMinBtn.bounds fromView:self.mMinBtn];
    }else{
        lFrame=[self.mScrollView convertRect:self.mDatetxtLbl.bounds fromView:self.mDatetxtLbl];

    }
    
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
    
    DatePickerController *screen = [[DatePickerController alloc] init];
    NSString *tempString=@"";
    tempString = self.mDatetxtLbl.text;

    if (selectedBtn == 1) {
        [[screen mDatePicker_] setDatePickerMode:UIDatePickerModeCountDownTimer];
        NSString *mTime = self.mMinBtn.currentTitle;
        int Hours = [mTime intValue]/60;
        int minutes = [mTime intValue]%60;
        tempString = [NSString stringWithFormat:@"%d:%d", Hours, minutes];
    }else{
        [[screen mDatePicker_] setMaximumDate:[NSDate date]];

    }
    NSDate *getDate=(NSDate *)tempString;
    
    //set the minimum date
    if (getDate == nil)
    {
        getDate = [NSDate date];
        
    }else {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
        [df setTimeZone:gmtZone];
        NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
        df.locale = enLocale;
        if (selectedBtn == 2) {
            [df setDateFormat:@"EEE, MM/dd/yy"];
            screen.mTextDisplayedlb.text=NSLocalizedString(@"SELECT_DATE",nil);

        }else{
            [df setDateFormat:@"HH:mm"];
            screen.mTextDisplayedlb.text=NSLocalizedString(@"SELECT_TIME",nil);
        }
        
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
    //[screen setMSelectedTextField_:mActiveTxtFld_];
    [mAppDelegate_.window addSubview:screen];
    
}


- (void)datePickerController:(DatePickerController *)controller
                 didPickDate:(NSDate *)date
                      isDone:(BOOL)isDone {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    if(isDone==YES)
    {
		NSDateFormatter *lDateFormat_ = [[NSDateFormatter alloc] init];
        NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
        [lDateFormat_ setTimeZone:gmtZone];
        NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
        lDateFormat_.locale = enLocale;
        if (selectedBtn == 1) {
            NSString *lHours, *lMin;
            [lDateFormat_ setDateFormat:@"HH"];
            lHours=[lDateFormat_ stringFromDate:date];
            [lDateFormat_ setDateFormat:@"mm"];
            lMin=[lDateFormat_ stringFromDate:date];
            int hours = [lHours intValue];
            int minutes = (hours*60)+[lMin intValue];
            [self.mMinBtn setTitle:[NSString stringWithFormat:@"%d",minutes] forState:UIControlStateNormal];
            if ([self.mMETval intValue] !=0) {
                float hours = [self.mMinBtn.currentTitle intValue]/60.0f;
                int cal = [self.mMETval floatValue]*hours*[[mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ objectForKey:@"CurrentWeight"] floatValue]*0.4546;
                self.mCalLbl.text = [NSString stringWithFormat:@"%d", cal];
            }


        }else{
            [lDateFormat_ setDateFormat:@"EEE, MM/dd/yy"];
            self.mDatetxtLbl.text = [NSString stringWithFormat:@"%@", [lDateFormat_ stringFromDate:date]];
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
- (void)viewDidUnload {
    [self setMScrollView:nil];
    [self setMBGImgView:nil];
    [self setMDateLbl:nil];
    [self setMCommentsTxtView:nil];
    [self setMDatetxtLbl:nil];
    [self setMMinLbl:nil];
    [self setMTableView:nil];
    [self setMCalBurnedLbl:nil];
    [self setMCalLbl:nil];
    [self setMBtmView:nil];
    [self setMMinBtn:nil];
    [super viewDidUnload];
}
- (void)doneAction:(id)sender {
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    for (UIView *lview in mAppDelegate_.window.subviews) {
        if ([lview isKindOfClass:[DatePickerController class]]) {
            [lview removeFromSuperview];
        }
    }
    //validations
    for (int i =0; i < self.mRowsValueArray.count; i++) {
        if ([[self.mRowsValueArray objectAtIndex:i] isEqualToString:@"Choose"]) {
            if (i==0) {
                [UtilitiesLibrary showAlertViewWithTitle:@"" :@"Please select an exercise."];
                return;

            }else if (i==1){
                [UtilitiesLibrary showAlertViewWithTitle:@"" :@"Please select a category."];
                return;
            }
        }
    }
    if (self.mMinBtn.currentTitle == nil || [self.mMinBtn.currentTitle isEqualToString:@"0"]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Please enter the duration."];
        return;
    }
    // to caluclate calories
    float mWeightInKg=[[mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ objectForKey:@"CurrentWeight"] floatValue]*0.4546;
    float hours = [self.mMinBtn.currentTitle intValue]/60.0f;
    //int cal = [self.mMETval floatValue]*[self.mMinBtn.currentTitle intValue]*[[mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ objectForKey:@"CurrentWeight"] floatValue];
    int cal = [self.mMETval floatValue]*hours*mWeightInKg;
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [self dismissModalViewControllerAnimated:TRUE];
        [mAppDelegate_ createLoadView];
        //date & time
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [GenricUI setLocaleZoneForDateFormatter:dateFormat];
        [dateFormat setDateFormat:@"EEE, MM/dd/yy"];
        NSDate *lDate = [dateFormat dateFromString:self.mDatetxtLbl.text];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString* logSource =@"";
        if (mAppDelegate_.mTrackerDataGetter_.mLogsourceAppManualDict_) {
            logSource = [mAppDelegate_.mTrackerDataGetter_.mLogsourceAppManualDict_ valueForKey:@"Code"];
        }
        [mAppDelegate_.mRequestMethods_ postRequestToAddExerciseLog:[dateFormat stringFromDate:lDate] Activity:self.mActivityLUT Duration:self.mMinBtn.currentTitle Calories:[NSString stringWithFormat:@"%d", cal] Notes:self.mCommentsTxtView.text LogSource:logSource AuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
    

    
}
- (IBAction)dateAction:(id)sender {
    UIButton*lBtn  = (UIButton*)sender;
    selectedBtn = lBtn.tag;
    
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    for (UIView *lview in mAppDelegate_.window.subviews) {
        if ([lview isKindOfClass:[DatePickerController class]]) {
            [lview removeFromSuperview];
        }
    }
    [self displayDatePicker];
    
}

- (IBAction)minuteAction:(id)sender {
    UIButton*lBtn  = (UIButton*)sender;
    selectedBtn = lBtn.tag;
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    for (UIView *lview in mAppDelegate_.window.subviews) {
        if ([lview isKindOfClass:[DatePickerController class]]) {
            [lview removeFromSuperview];
        }
    }
    [self displayDatePicker];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)minusAction:(id)sender {
    int mvalue = 0;
    if (![self.mMinBtn.currentTitle isEqualToString:@""]){
        mvalue = [self.mMinBtn.currentTitle intValue];
    }
    mvalue--;
    if (mvalue >= 0) {
        [self.mMinBtn setTitle:[NSString stringWithFormat:@"%d", mvalue] forState:UIControlStateNormal];
        if ([self.mMETval intValue] !=0) {
            float hours = [self.mMinBtn.currentTitle intValue]/60.0f;
            int cal = [self.mMETval floatValue]*hours*[[mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ objectForKey:@"CurrentWeight"] floatValue]*0.4546;
            self.mCalLbl.text = [NSString stringWithFormat:@"%d", cal];
        }

    }

}

- (IBAction)plusAction:(id)sender {
    int mvalue = 0;
    if (![self.mMinBtn.currentTitle isEqualToString:@""]){
        mvalue = [self.mMinBtn.currentTitle intValue];
    }
    mvalue++;
    if (mvalue < 1440) {
        [self.mMinBtn setTitle:[NSString stringWithFormat:@"%d", mvalue] forState:UIControlStateNormal];
        if ([self.mMETval intValue] !=0) {
            float hours = [self.mMinBtn.currentTitle intValue]/60.0f;
            int cal = [self.mMETval floatValue]*hours*[[mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ objectForKey:@"CurrentWeight"] floatValue]*0.4546;
            self.mCalLbl.text = [NSString stringWithFormat:@"%d", cal];
        }

    }

}
@end
