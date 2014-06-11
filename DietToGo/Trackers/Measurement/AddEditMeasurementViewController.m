//
//  AddEditMeasurementViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 06/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AddEditMeasurementViewController.h"
#import "MeasurementListViewController.h"
#import "JSON.h"
@interface AddEditMeasurementViewController ()

@end

@implementation AddEditMeasurementViewController
@synthesize mSelectedBtn;
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
    mAppDelegate_ = [AppDelegate appDelegateInstance];
  
    self.mDateLbl.font = Bariol_Regular(18);
    self.mDateLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mDatetxtLbl.font = Bariol_Regular(18);
    self.mDatetxtLbl.textColor = BLACK_COLOR;
    self.mArmsLbl.font = Bariol_Regular(22);
    self.mArmsLbl.textColor = BLACK_COLOR;
    self.mHipsLbl.font = Bariol_Regular(22);
    self.mHipsLbl.textColor = BLACK_COLOR;
    self.mChestLbl.font = Bariol_Regular(22);
    self.mChestLbl.textColor = BLACK_COLOR;
    self.mWaistLbl.font = Bariol_Regular(22);
    self.mWaistLbl.textColor = BLACK_COLOR;
    self.mThighsLbl.font = Bariol_Regular(22);
    self.mThighsLbl.textColor = BLACK_COLOR;

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
        [placeholderLabel setFont:Bariol_Regular(18)];
        [placeholderLabel setTextColor:RGB_A(136, 136, 136, 1)];
        
        [self.mCommentsTxtView addSubview:placeholderLabel];
        
    }
    
    [Utilities addInputViewForKeyBoard:self.mCommentsTxtView
                                 Class:self];
    if (mAppDelegate_.mTrackerDataGetter_.mMeasurementList_.count >0) {
        self.mChestLbl.text = [NSString stringWithFormat:@"%.1f in.", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:0] objectForKey:@"Chest"] floatValue]];
        self.mWaistLbl.text = [NSString stringWithFormat:@"%.1f in.", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:0] objectForKey:@"Waist"] floatValue]];
        self.mThighsLbl.text = [NSString stringWithFormat:@"%.1f in.", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:0] objectForKey:@"Thighs"] floatValue]];
        self.mHipsLbl.text = [NSString stringWithFormat:@"%.1f in.", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:0] objectForKey:@"Hips"] floatValue]];
        self.mArmsLbl.text = [NSString stringWithFormat:@"%.1f in.", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:0] objectForKey:@"Arms"] floatValue]];

    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
       // self.trackedViewName=@"Add New Measurement";
        [mAppDelegate_ trackFlurryLogEvent:@"Add New Measurement"];
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"LOG_MEASUREMENT_ADD", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(doneAction:) forController:self rightOrLeft:1];
    
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollView.frame = CGRectMake(self.mScrollView.frame.origin.x, self.mScrollView.frame.origin.y, 320, 504);
        
    }
    self.mScrollView.contentSize = CGSizeMake(320, self.mBGImgView.frame.origin.y+self.mBGImgView.frame.size.height+20);
    [self postRequestToGetPerSonalSettings];

}
- (void)backAction:(UIButton*)sender{
    [self dismissModalViewControllerAnimated:TRUE];
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
- (void)displayPickerview {
    NSString *title = @"";
    NSString *mPickerText = @"";

    switch (self.mSelectedBtn) {
        case 1:
            title = @"Upper Arm";
            mPickerText = self.mArmsLbl.text;
            break;
        case 2:
            title = @"Chest";
            mPickerText = self.mChestLbl.text;
            break;
        case 3:
            title = @"Waist";
            mPickerText = self.mWaistLbl.text;
            break;
            
        case 4:
            title = @"Hips";
            mPickerText = self.mHipsLbl.text;

            break;
        case 5:
            title = @"Thighs";
            mPickerText = self.mThighsLbl.text;

            break;
   
        default:
            break;
    }
    mPickerText = [mPickerText stringByReplacingOccurrencesOfString:@" in." withString:@""];
    
    NSString *lPickerTitle = [NSString stringWithFormat:@"Select %@ in inches.",title];
    PickerViewController *screen = [[PickerViewController alloc] init];
    NSMutableArray *rowValuesArr_=[[NSMutableArray alloc] init];
    NSMutableArray *lPickerFirstComponent = [[NSMutableArray alloc] init];
    NSMutableArray *lPickerSecondComponent = [[NSMutableArray alloc] init];
    for (int i = 0; i<=199; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [lPickerFirstComponent addObject:str];
    }
    for (int i = 0; i<=9; i++) {
        NSString *str = [NSString stringWithFormat:@".%d",i];
        [lPickerSecondComponent addObject:str];
    }

    [rowValuesArr_ addObject:lPickerFirstComponent];
    [rowValuesArr_ addObject:lPickerSecondComponent];
    screen.mRowValueintheComponent=rowValuesArr_;
    screen->mNoofComponents=[rowValuesArr_ count];
    screen.mTextDisplayedlb.text=lPickerTitle;
    
    // *********** ************* reloading the components to the value in the particular label *************** **************
    if(![mPickerText isEqualToString:@""]){
        NSArray *lArr_=[mPickerText componentsSeparatedByString:@"."];
        for (int i=0; i<[[rowValuesArr_ objectAtIndex:0] count]; i++) {
            if ([[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] isEqualToString:[lArr_ objectAtIndex:0]]) {
                [screen.mViewPicker_ selectRow:i inComponent:0 animated:YES];
                [screen.mViewPicker_ reloadComponent:0];
            }
        }
        for (int i=0; i<[[rowValuesArr_ objectAtIndex:1] count]; i++) {
            NSString *lDecimalVal=[lArr_ objectAtIndex:1];
            lDecimalVal = [lDecimalVal substringToIndex:1];
            if ([[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] isEqualToString:lDecimalVal]) {
                [screen.mViewPicker_ selectRow:i inComponent:1 animated:YES];
                [screen.mViewPicker_ reloadComponent:1];
            }
        }

    }
    
    [screen setMPickerViewDelegate_:self];
    // [screen setMSelectedTextField_:mActiveTxtFld_];
    [mAppDelegate_.window addSubview:screen];
    
}
#pragma mark UIPickerDelegate methods

// ************************* tell the picker how many components it will have ******************
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//  *************** tell the picker how many rows are available for a given component ************
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSMutableArray *lPickerFirstComponent = [[NSMutableArray alloc] init];
    NSMutableArray *lPickerSecondComponent = [[NSMutableArray alloc] init];
    for (int i = 0; i<=199; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [lPickerFirstComponent addObject:str];
    }
    for (int i = 0; i<=9; i++) {
        NSString *str = [NSString stringWithFormat:@".%d",i];
        [lPickerSecondComponent addObject:str];
    }
    if (component==0)
        return [lPickerFirstComponent count];
    else if(component==1)
        return [lPickerSecondComponent count];
    else
        return 0;
    
}

// ************* tell the picker the title for a given component ****************
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSMutableArray *lPickerFirstComponent = [[NSMutableArray alloc] init];
    NSMutableArray *lPickerSecondComponent = [[NSMutableArray alloc] init];
    for (int i = 0; i<=199; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [lPickerFirstComponent addObject:str];
    }
    for (int i = 0; i<=9; i++) {
        NSString *str = [NSString stringWithFormat:@".%d",i];
        [lPickerSecondComponent addObject:str];
    }
    if (component==0)
        return [lPickerFirstComponent objectAtIndex:row];
    else
        return [lPickerSecondComponent objectAtIndex:row];
	
    
}

- (void)pickerViewController:(PickerViewController *)controller
                 didPickComp:(NSMutableArray *)valueArr
                      isDone:(BOOL)isDone{
    
    if(isDone==YES)
    {
        
        NSString *mData_=@"";
        for(int i=0;i<[valueArr count];i++){
            if(i==1){
                //mData_ = [mData_ stringByAppendingString:@"."];
            }
            mData_=[mData_ stringByAppendingString:[valueArr objectAtIndex:i]];
        }
        //to display the text in labels
        switch (self.mSelectedBtn) {
            case 1:
                self.mArmsLbl.text = [NSString stringWithFormat:@"%@ in.",mData_];
                break;
            case 2:
                self.mChestLbl.text = [NSString stringWithFormat:@"%@ in.",mData_];
                break;
            case 3:
                self.mWaistLbl.text = [NSString stringWithFormat:@"%@ in.",mData_];
                break;
                
            case 4:
                self.mHipsLbl.text = [NSString stringWithFormat:@"%@ in.",mData_];
                break;
            case 5:
                self.mThighsLbl.text = [NSString stringWithFormat:@"%@ in.",mData_];
                break;
                
            default:
                break;
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
    
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217+55 , 0.0);
    
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
    
    CGRect lFrame=[self.mScrollView convertRect:self.mDatetxtLbl.bounds fromView:self.mDatetxtLbl];
    
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
    
    DatePickerController *screen = [[DatePickerController alloc] init];
    
    NSString *tempString=@"";
    tempString = self.mDatetxtLbl.text;
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
        [df setDateFormat:@"EEE, MM/dd/yy"];
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
        [lDateFormat_ setDateFormat:@"EEE, MM/dd/yy"];
        self.mDatetxtLbl.text = [NSString stringWithFormat:@"%@", [lDateFormat_ stringFromDate:date]];
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
- (void)doneAction:(id)sender {
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    
    //for validations
    
    if(([self.mArmsLbl.text isEqualToString:@""] || [[self.mArmsLbl.text stringByReplacingOccurrencesOfString:@" in." withString:@""] isEqualToString:@"0.0"]) &&( [self.mHipsLbl.text isEqualToString:@""] || [[self.mHipsLbl.text stringByReplacingOccurrencesOfString:@" in." withString:@""] isEqualToString:@"0.0"])&& ([self.mThighsLbl.text isEqualToString:@""] || [[self.mThighsLbl.text stringByReplacingOccurrencesOfString:@" in." withString:@""] isEqualToString:@"0.0"]) && ([self.mChestLbl.text isEqualToString:@""] || [[self.mChestLbl.text stringByReplacingOccurrencesOfString:@" in." withString:@""] isEqualToString:@"0.0"]) && ([self.mWaistLbl.text isEqualToString:@""] || [[self.mWaistLbl.text stringByReplacingOccurrencesOfString:@" in." withString:@""] isEqualToString:@"0.0"])) {
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"You must enter a value greater than zero."];
        return;
    }
    //date & time
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [GenricUI setLocaleZoneForDateFormatter:dateFormat];
    [dateFormat setDateFormat:@"EEE, MM/dd/yy"];
    NSDate *lDate = [dateFormat dateFromString:self.mDatetxtLbl.text];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSString *mArms, *mChest, *mWaist, *mHips, *mThighs;
    mArms = [self.mArmsLbl.text stringByReplacingOccurrencesOfString:@" in." withString:@""];
    if ([mArms isEqualToString:@""]) {
        mArms = @"0.0";
    }
    mChest = [self.mChestLbl.text stringByReplacingOccurrencesOfString:@" in." withString:@""];
    if ([mChest isEqualToString:@""]) {
        mChest = @"0.0";
    }
    mWaist = [self.mWaistLbl.text stringByReplacingOccurrencesOfString:@" in." withString:@""];
    if ([mWaist isEqualToString:@""]) {
        mWaist = @"0.0";
    }
    mHips = [self.mHipsLbl.text stringByReplacingOccurrencesOfString:@" in." withString:@""];
    if ([mHips isEqualToString:@""]) {
        mHips = @"0.0";
    }
    mThighs = [self.mThighsLbl.text stringByReplacingOccurrencesOfString:@" in." withString:@""];
    if ([mThighs isEqualToString:@""]) {
        mThighs = @"0.0";
    }
    
    //to post the add measurement log
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [self dismissModalViewControllerAnimated:TRUE];
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToAddMeasurementLog:[dateFormat stringFromDate:lDate]
                                                                  Arms:mArms
                                                                 Chest:mChest
                                                                 Waist:mWaist
                                                                  Hips:mHips
                                                                Thighs:mThighs
                                                                 Notes:self.mCommentsTxtView.text
                                                             AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }


}
- (IBAction)dateAction:(id)sender {
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayDatePicker];
    
}
- (void)removeViews{
    for (UIView *lview in mAppDelegate_.window.subviews) {
        if ([lview isKindOfClass:[PickerViewController class]]||[lview isKindOfClass:[DatePickerController class]]) {
            [lview removeFromSuperview];
        }
    }
}

- (IBAction)armAction:(UIButton *)sender {
    self.mSelectedBtn = sender.tag;
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayPickerview];
}

- (IBAction)chestAction:(UIButton *)sender {
    self.mSelectedBtn = sender.tag;
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayPickerview];

}

- (IBAction)thighsAction:(UIButton *)sender {
    self.mSelectedBtn = sender.tag;
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayPickerview];

}

- (IBAction)hipsAction:(UIButton *)sender {
    self.mSelectedBtn = sender.tag;
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayPickerview];

}

- (IBAction)waistAction:(UIButton *)sender {
    self.mSelectedBtn = sender.tag;
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayPickerview];

}
- (void)viewDidUnload {
    [self setMScrollView:nil];
    [self setMBGImgView:nil];
    [self setMDateLbl:nil];
    [self setMCommentsTxtView:nil];
    [self setMDatetxtLbl:nil];
    [super viewDidUnload];
}
- (void)postRequestToGetPerSonalSettings{
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"%@/%@", SETTINGS, PERSONAL];
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        
        [mAppDelegate_ createLoadView];
        [NSThread detachNewThreadSelector:@selector(GetResponseData:) toTarget:self withObject: mRequestStr];
        
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
    //[theRequest valueForHTTPHeaderField:body];
    [theRequest setValue:mAppDelegate_.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate_.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"GET"];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    DLog(@"%@", json_string);
    NSMutableDictionary *mDict = [json_string JSONValue];
    if ([[mDict objectForKey:@"Gender"] intValue] == 2) {
        self.mBodyImgView.image = [UIImage imageNamed:@"female.png"];
    }else{
        self.mBodyImgView.image = [UIImage imageNamed:@"body.png"];

    }
    self.mScrollView.hidden = FALSE;
    [mAppDelegate_ removeLoadView];
}
@end
