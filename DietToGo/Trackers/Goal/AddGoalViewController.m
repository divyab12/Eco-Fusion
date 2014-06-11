//
//  AddGoalViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 28/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AddGoalViewController.h"
#import "GoalListViewController.h"
#import "JSON.h"
#define ANNOTATETEXT @"Annotate Your Day"
@interface AddGoalViewController ()

@end

@implementation AddGoalViewController
@synthesize mStepID, mUserStepID, mGolaStepProgress_;
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
    mAppDelegate_ = [AppDelegate appDelegateInstance];
    self.mStepLbl.font = Bariol_Regular(17);
    self.mStepLbl.text = [[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:0] objectForKey:@"Label"];
    self.mStepLbl.textColor = BLACK_COLOR;
    self.mStepID = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:0] objectForKey:@"GoalStep"] intValue]];
    self.mUserStepID = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:0] objectForKey:@"UserStepID"] intValue]];
    self.mServingsLbl.text = [[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:0] objectForKey:@"PickerText"];

    //for step progress
    mGolaStepProgress_ = [[NSMutableDictionary alloc]init];
    //Check initially if u get annotate, Disable
    if ([self.mStepLbl.text isEqualToString:ANNOTATETEXT]) {
        //to populate the text in the label
        [self.mGoalBtn setTitle:@"1" forState:UIControlStateNormal];
        self.mMinusBtn.userInteractionEnabled = NO;
        self.mPlusBtn.userInteractionEnabled = NO;
    }else {
        [self postRequestToGoalStepProgress];

    }
    
    self.mServingsLbl.font = Bariol_Regular(17);
    self.mServingsLbl.textColor = BLACK_COLOR;
    self.mDateLbl.font = Bariol_Regular(17);
    self.mDateLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mDatetxtLbl.font = Bariol_Regular(17);
    self.mDatetxtLbl.textColor = BLACK_COLOR;
    [self.mGoalBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [self.mGoalBtn.titleLabel setFont:Bariol_Regular(25)];

    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
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
    
   

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"Add New Goal";
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"ADD_GOAL", nil) imageName:imgName forController:self];

    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(doneAction:) forController:self rightOrLeft:1];
    self.mScrollView.contentSize = CGSizeMake(320, 416-55);
    
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollView.frame = CGRectMake(self.mScrollView.frame.origin.x, self.mScrollView.frame.origin.y, 320, 504-55);
        self.mScrollView.contentSize = CGSizeMake(320, 504-55);
        
    }
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
        [placeholderLabel setFont:Bariol_Regular(17)];
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
        [placeholderLabel setFont:Bariol_Regular(17)];
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
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217-50 , 0.0);
    
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
    [placeholderLabel setFont:Bariol_Regular(17)];
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
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217 , 0.0);
    
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
        [self postRequestToGoalStepProgress];

    }
    else
    {
        if([controller superview]){
            [controller removeFromSuperview];
        }
    }
}
- (void)removeViews{
    for (UIView *lview in mAppDelegate_.window.subviews) {
        if ([lview isKindOfClass:[PickerViewController class]]||[lview isKindOfClass:[DatePickerController class]]) {
            [lview removeFromSuperview];
        }
    }
}

- (IBAction)stepAction:(UIButton *)sender {
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayPickerview];
}
- (void)viewDidUnload {
    [self setMScrollView:nil];
    [self setMServingsLbl:nil];
    [self setMBGImgView:nil];
    [self setMDateLbl:nil];
    [self setMCommentsTxtView:nil];
    [self setMDatetxtLbl:nil];
    [super viewDidUnload];
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
    //date & time
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [GenricUI setLocaleZoneForDateFormatter:dateFormat];
    [dateFormat setDateFormat:@"EEE, MM/dd/yy"];
    NSDate *lDate = [dateFormat dateFromString:self.mDatetxtLbl.text];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    //[dateFormat setDateFormat:@"yyyy-MM-dd"];
    //to get the goal value
    int value = 0;
    /*if ([[self.mGolaStepProgress_ objectForKey:@"Goal"] intValue] >= [self.mGoalBtn.currentTitle intValue]) {
        value = [[self.mGolaStepProgress_ objectForKey:@"Goal"] intValue] - [self.mGoalBtn.currentTitle intValue];
    }else{
        value = [self.mGoalBtn.currentTitle intValue] - [[self.mGolaStepProgress_ objectForKey:@"Goal"] intValue];
    }*/
    value = [self.mGoalBtn.currentTitle intValue];
    if (value == 0) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Please enter a valid Goal value."];
        return;
    }
    //to post the add goal log
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [self dismissModalViewControllerAnimated:TRUE];
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestToAddGoal:[dateFormat stringFromDate:lDate]
                                                      StepID:self.mStepID
                                                  UserStepID:self.mUserStepID
                                                       Value:[NSString stringWithFormat:@"%d", value]
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
- (void)displayPickerview {
    
    PickerViewController *screen = [[PickerViewController alloc] init];
    NSMutableArray *rowValuesArr_=[[NSMutableArray alloc] init];
    NSMutableArray *lValues = [[NSMutableArray alloc]init];
    for (int iStepCount = 0; iStepCount < mAppDelegate_.mTrackerDataGetter_.mGoalStepList_.count; iStepCount++) {
        [lValues addObject:[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"Label"]];
    }
    [rowValuesArr_ addObject:lValues];
    screen.mRowValueintheComponent=rowValuesArr_;
    screen->mNoofComponents=[rowValuesArr_ count];
    screen.mTextDisplayedlb.text=@"Select Goal Step";
    //[screen addSubview:screen.mViewPicker_];
    // *********** ************* reloading the components to the value in the particular label *************** **************
    [screen.mViewPicker_ selectRow:0 inComponent:0 animated:YES];
    [screen.mViewPicker_ reloadComponent:0];
    
    if(![self.mStepLbl.text isEqualToString:@""]){
        
        
        for (int i=0; i<[[rowValuesArr_ objectAtIndex:0] count]; i++) {
            if ([[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] isEqualToString:self.mStepLbl.text]) {
                [screen.mViewPicker_ selectRow:i inComponent:0 animated:YES];
                [screen.mViewPicker_ reloadComponent:0];
            }
        }
    }else{
        
    }
    [screen setMPickerViewDelegate_:self];
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
        }
        [self.mStepLbl setText:mData_];
        self.mMinusBtn.userInteractionEnabled = YES;
        self.mPlusBtn.userInteractionEnabled = YES;
        
       
        for (int iStepCount = 0; iStepCount < mAppDelegate_.mTrackerDataGetter_.mGoalStepList_.count; iStepCount++) {
            if ([mData_ isEqualToString:[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"Label"]]) {
                self.mStepID = [NSString stringWithFormat:@"%d",[[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"GoalStep"] intValue] ];
                self.mUserStepID = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"UserStepID"] intValue]];
                self.mServingsLbl.text = [[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"PickerText"];


            }
        }
        
        //Disable buttons (.ie "Annotate your day")
        if ([mData_ isEqualToString:ANNOTATETEXT]) {
            NSLog(@"Annotate Your Day -- row");
            if([controller superview]){
                [controller removeFromSuperview];
            }
            //to populate the text in the label
            [self.mGoalBtn setTitle:@"1" forState:UIControlStateNormal];
            self.mMinusBtn.userInteractionEnabled = NO;
            self.mPlusBtn.userInteractionEnabled = NO;
            return;
        }
        
        [self postRequestToGoalStepProgress];
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
    return 2;
}

//  *************** tell the picker how many rows are available for a given component ************
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component==0)
        return 3;
    else
        return 0;
    
}

// ************* tell the picker the title for a given component ****************
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSMutableArray *lValues = [[NSMutableArray alloc]init];
    for (int iStepCount = 0; iStepCount < mAppDelegate_.mTrackerDataGetter_.mGoalStepList_.count; iStepCount++) {
        [lValues addObject:[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"Label"]];
    }
    if (component==0)
        return [lValues objectAtIndex:row];
    else
        return @"";
	
    
}
- (void)postRequestToGoalStepProgress{
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    [lFormatter setDateFormat:@"EEE, MM/dd/yy"];

    NSDate *lDate = [lFormatter dateFromString:self.mDatetxtLbl.text];
    [lFormatter setDateFormat:@"yyyy-MM-dd"];


    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", GoalTxt, self.mUserStepID, [lFormatter stringFromDate:lDate]];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        
        [mAppDelegate_ createLoadView];
        [NSThread detachNewThreadSelector:@selector(GetResponseData:) toTarget:self withObject: mRequestURL];
        
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
    } else if([[json_string JSONValue] isKindOfClass:[NSMutableDictionary class]])
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
    }
    [self.mGolaStepProgress_ removeAllObjects];
    self.mGolaStepProgress_ = (NSMutableDictionary*)[json_string JSONValue];
    
    //to populate the text in the label
    [self.mGoalBtn setTitle:[NSString stringWithFormat:@"%d", [[self.mGolaStepProgress_ objectForKey:@"Goal"] intValue]] forState:UIControlStateNormal];
    [mAppDelegate_ removeLoadView];



}
- (IBAction)minusAction:(id)sender {
    int mvalue = 0;
    if (![self.mGoalBtn.currentTitle isEqualToString:@""]){
        mvalue = [self.mGoalBtn.currentTitle intValue];
    }
    mvalue--;
    if (mvalue >= 0) {
        [self.mGoalBtn setTitle:[NSString stringWithFormat:@"%d", mvalue] forState:UIControlStateNormal];
    }
}

- (IBAction)plusAction:(id)sender {
    int mvalue = 0;
    if (![self.mGoalBtn.currentTitle isEqualToString:@""]){
        mvalue = [self.mGoalBtn.currentTitle floatValue];
    }
    mvalue++;
    [self.mGoalBtn setTitle:[NSString stringWithFormat:@"%d", mvalue] forState:UIControlStateNormal];
   
}
@end
