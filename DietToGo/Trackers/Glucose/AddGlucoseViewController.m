//
//  AddGlucoseViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 18/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AddGlucoseViewController.h"

@interface AddGlucoseViewController ()

@end

@implementation AddGlucoseViewController
@synthesize mSelectedTag;
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
    //[self.mGlucoseBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    //[self.mGlucoseBtn.titleLabel setFont:Bariol_Regular(25)];
    self.mLbsLbl.font = Bariol_Regular(17);
    self.mLbsLbl.textColor = BLACK_COLOR;
    self.mDateLbl.font = Bariol_Regular(17);
    self.mDateLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mDatetxtLbl.font = Bariol_Regular(17);
    self.mDatetxtLbl.textColor = BLACK_COLOR;
    self.mTimeLbl.font = Bariol_Regular(17);
    self.mTimeLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mTimeTxtLbl.font = Bariol_Regular(17);
    self.mTimeTxtLbl.textColor = BLACK_COLOR;
    self.mGlucoseTxtFld.font = Bariol_Regular(25);
    self.mGlucoseTxtFld.textColor = BLACK_COLOR;
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    NSDate *lDate = [NSDate date];
    [lFormatter setDateFormat:@"EEE, MM/dd/yy"];
    self.mDatetxtLbl.text = [lFormatter stringFromDate:lDate];
    [lFormatter setDateFormat:@"hh:mm a"];
    NSString *lTime = [lFormatter stringFromDate:lDate];
    lTime = [lTime stringByReplacingOccurrencesOfString:@"AM" withString:@"am"];
    lTime = [lTime stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
    lTime = [lTime stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
    self.mTimeTxtLbl.text = lTime;

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
    
    [Utilities addInputViewForKeyBoardForTextFld:self.mGlucoseTxtFld Class:self];
    
    //for last log value
    if (mAppDelegate_.mTrackerDataGetter_.mGlucoseList_.count >0) {
        self.mGlucoseTxtFld.text = [NSString stringWithFormat:@"%.1f", [[[mAppDelegate_.mTrackerDataGetter_.mGlucoseList_ objectAtIndex:0] objectForKey:@"BloodGlucose"] floatValue]];
    }else{
         self.mGlucoseTxtFld.text = @"0.0";
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"Add New Glucose";
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"LOG_GLUCOSE_ADD", nil) imageName:imgName forController:self];
    
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];

    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(doneAction:) forController:self rightOrLeft:1];
    self.mScrollView.contentSize = CGSizeMake(320, 416);
    
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollView.frame = CGRectMake(self.mScrollView.frame.origin.x, self.mScrollView.frame.origin.y, 320, 504);
        self.mScrollView.contentSize = CGSizeMake(320, 504);
        
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
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217 , 0.0);
    
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
    
    CGRect lFrame=[self.mScrollView convertRect:textView.bounds fromView:textView];
    
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength;
    newLength = [textField.text length] + [string length] - range.length;
    
    if(newLength > 5){
        return NO;
    }
    return YES;
}
// clear action
- (void)cancelTxtFld_Event
{
    self.mGlucoseTxtFld.text = @"";
    
    
}
// done action
- (void)doneTxtFld_Event
{
    [self.mGlucoseTxtFld resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
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
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217+55 , 0.0);
    
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
    
    CGRect lFrame=[self.mScrollView convertRect:self.mDatetxtLbl.bounds fromView:self.mDatetxtLbl];
    
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
    
    DatePickerController *screen = [[DatePickerController alloc] init];
    
    NSString *tempString=@"";
    if (self.mSelectedTag == 0) {
        tempString = self.mDatetxtLbl.text;
        [[screen mDatePicker_] setDatePickerMode:UIDatePickerModeDate];
        [[screen mDatePicker_] setMaximumDate:[NSDate date]];
        
    }else{
         NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [GenricUI setLocaleZoneForDateFormatter:df];
        [df setDateFormat:@"EEE, MM/dd/yy"];
        NSDate *lDate = [df dateFromString:self.mDatetxtLbl.text];
        [df setDateFormat:@"MM/dd/yyyyy"];
        tempString = [df stringFromDate:lDate];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@" %@", self.mTimeTxtLbl.text]];
        tempString = [tempString stringByReplacingOccurrencesOfString:@"AM" withString:@"am"];
        tempString = [tempString stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
        [[screen mDatePicker_] setDatePickerMode:UIDatePickerModeTime];
        [[screen mDatePicker_] setMaximumDate:[NSDate date]];

    }
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
        if (self.mSelectedTag == 0) {
            [df setDateFormat:@"EEE, MM/dd/yy"];
            screen.mTextDisplayedlb.text=NSLocalizedString(@"SELECT_DATE",nil);
        }else{
            [df setDateFormat:@"MM/dd/yyyy hh:mm a"];
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
        if (self.mSelectedTag == 0) {
            [lDateFormat_ setDateFormat:@"EEE, MM/dd/yy"];
            self.mDatetxtLbl.text = [NSString stringWithFormat:@"%@", [lDateFormat_ stringFromDate:date]];
            NSDate *lCurrentDate = [NSDate date];
            
            // to set the maximum time as crrent time if the day is current day
            if ([self.mDatetxtLbl.text isEqualToString:[lDateFormat_ stringFromDate:lCurrentDate]]) {
                [lDateFormat_ setDateFormat:@"hh:mm a"];
                NSString *lTime = [NSString stringWithFormat:@"%@", [lDateFormat_ stringFromDate:lCurrentDate]];
                lTime = [lTime stringByReplacingOccurrencesOfString:@"AM" withString:@"am"];
                lTime = [lTime stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
                lTime = [lTime stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
                
                self.mTimeTxtLbl.text = lTime;

            }
        }else{
            [lDateFormat_ setDateFormat:@"hh:mm a"];
            NSString *lTime = [NSString stringWithFormat:@"%@", [lDateFormat_ stringFromDate:date]];
            lTime = [lTime stringByReplacingOccurrencesOfString:@"AM" withString:@"am"];
            lTime = [lTime stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
            lTime = [lTime stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
            self.mTimeTxtLbl.text = lTime;
            
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setMScrollView:nil];
    [self setMGlucoseBtn:nil];
    [self setMLbsLbl:nil];
    [self setMBGImgView:nil];
    [self setMDateLbl:nil];
    [self setMCommentsTxtView:nil];
    [self setMDatetxtLbl:nil];
    [self setMGlucoseTxtFld:nil];
    [super viewDidUnload];
}
- (void)doneAction:(id)sender {
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    
    if ([self.mGlucoseTxtFld.text isEqualToString:@""] || self.mGlucoseTxtFld.text == nil || [self.mGlucoseTxtFld.text intValue] == 0) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Please enter a valid Glucose value."];
        return;
        
    }
    if ([self.mGlucoseTxtFld.text intValue] > 500) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Blood Glucose value should be less than 500."];
        return;
    }
    //date & time
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [GenricUI setLocaleZoneForDateFormatter:dateFormat];
    [dateFormat setDateFormat:@"EEE, MM/dd/yy hh:mm a"];
    NSString* tempString = self.mTimeTxtLbl.text;
    tempString = [tempString stringByReplacingOccurrencesOfString:@"AM" withString:@"am"];
    tempString = [tempString stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
    NSDate *lDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", self.mDatetxtLbl.text, tempString]];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    //to post the add weight log
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [self dismissModalViewControllerAnimated:TRUE];
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToAddGlucoseLog:[dateFormat stringFromDate:lDate]
                                                           Glucose:self.mGlucoseTxtFld.text
                                                             Notes:self.mCommentsTxtView.text
                                                         AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                      SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
       
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
    
}
- (void)removeViews{
    for (UIView *lview in mAppDelegate_.window.subviews) {
        if ([lview isKindOfClass:[DatePickerController class]]) {
            [lview removeFromSuperview];
        }
    }
}
- (IBAction)GlucoseAction:(id)sender {
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    
    // to show keyboard
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217+55 , 0.0);
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    CGRect lFrame=[self.mScrollView convertRect:self.mGlucoseTxtFld.bounds fromView:self.mGlucoseTxtFld];
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
    [self.mGlucoseTxtFld becomeFirstResponder];

}

- (IBAction)dateAction:(id)sender {
    UIButton *lBtn = (UIButton*)sender;
    self.mSelectedTag = lBtn.tag;
    [self.mCommentsTxtView resignFirstResponder];
    [self.mGlucoseTxtFld resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayDatePicker];
    
}

- (IBAction)minusAction:(id)sender {
    float mvalue = 0;
    if (![self.mGlucoseTxtFld.text isEqualToString:@""]){
        mvalue = [self.mGlucoseTxtFld.text floatValue];
    }
    mvalue--;
    if (mvalue >= 0) {
        [self.mGlucoseTxtFld setText:[NSString stringWithFormat:@"%.1f", mvalue] ];
    }

}

- (IBAction)plusAction:(id)sender {
    float mvalue = 0;
    if (![self.mGlucoseTxtFld.text isEqualToString:@""]){
        mvalue = [self.mGlucoseTxtFld.text floatValue];
    }
    mvalue++;
    if (mvalue <= 500) {
        [self.mGlucoseTxtFld setText:[NSString stringWithFormat:@"%.1f", mvalue] ];
    }
    

}

- (IBAction)timeAction:(id)sender {
    UIButton *lBtn = (UIButton*)sender;
    self.mSelectedTag = lBtn.tag;
    [self.mCommentsTxtView resignFirstResponder];
    [self.mGlucoseTxtFld resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayDatePicker];
}

@end
