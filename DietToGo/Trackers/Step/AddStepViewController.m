//
//  AddStepViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 27/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AddStepViewController.h"
#import "StepListViewController.h"

@interface AddStepViewController ()

@end

@implementation AddStepViewController

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
    self.mStepsLbl.font = Bariol_Regular(17);
    self.mStepsLbl.textColor = BLACK_COLOR;
    self.mDateLbl.font = Bariol_Regular(17);
    self.mDateLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mDatetxtLbl.font = Bariol_Regular(17);
    self.mDatetxtLbl.textColor = BLACK_COLOR;
    self.mTxtFld.font = Bariol_Regular(25);
    self.mTxtFld.textColor = BLACK_COLOR;
    
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
        
        //[self.mCommentsTxtView addSubview:placeholderLabel];
        self.mCommentsTxtView.text = @"Added Manually";
        
    }
    
    [Utilities addInputViewForKeyBoard:self.mCommentsTxtView
                                 Class:self];
    [Utilities addInputViewForKeyBoardForTextFld:self.mTxtFld Class:self];
    
    //for last log value
    if (mAppDelegate_.mTrackerDataGetter_.mStepList_.count > 0) {
        //self.mTxtFld.text = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mStepList_ objectAtIndex:0] objectForKey:@"Steps"] intValue]];
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[[[mAppDelegate_.mTrackerDataGetter_.mStepList_ objectAtIndex:0] objectForKey:@"Steps"] intValue]]];
        self.mTxtFld.text = formatted;

    }else{
        self.mTxtFld.text = @"0";
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Add New Step";
        [mAppDelegate_ trackFlurryLogEvent:@"Add New Step"];
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"STEP_ADD", nil) imageName:imgName forController:self];

    
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
        //[self.mCommentsTxtView addSubview:placeholderLabel];
        //self.mCommentsTxtView.text = @"Added Manually";

        
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
        //[self.mCommentsTxtView addSubview:placeholderLabel];
        self.mCommentsTxtView.text = @"Added Manually";

        
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
    [placeholderLabel setFont:Bariol_Regular(17)];
    [placeholderLabel setTextColor:RGB_A(136, 136, 136, 1)];
    //[self.mCommentsTxtView addSubview:placeholderLabel];
    //self.mCommentsTxtView.text = @"Added Manually";

    
}
// done action
- (void)done_Event
{
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[textField.text intValue]]];
    textField.text = formatted;

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength;
    newLength = [textField.text length] + [string length] - range.length;
    
    if(newLength > 7){
        return NO;
    }
    return YES;
}

// clear action
- (void)cancelTxtFld_Event
{
    self.mTxtFld.text = @"";
    
    
}
// done action
- (void)doneTxtFld_Event
{
    [self.mTxtFld resignFirstResponder];
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
- (void)removeViews{
    for (UIView *lview in mAppDelegate_.window.subviews) {
        if ([lview isKindOfClass:[DatePickerController class]]) {
            [lview removeFromSuperview];
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
    [self setMStepsLbl:nil];
    [self setMBGImgView:nil];
    [self setMDateLbl:nil];
    [self setMCommentsTxtView:nil];
    [self setMDatetxtLbl:nil];
    [super viewDidUnload];
}
- (void)doneAction:(id)sender {
    [self.mCommentsTxtView resignFirstResponder];
    [self.mTxtFld resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    
    if (self.mTxtFld.text.length == 0 || [self.mTxtFld.text isEqualToString:@"0"]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Steps value is required."];
        return;

    }
    //date & time
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [GenricUI setLocaleZoneForDateFormatter:dateFormat];
    [dateFormat setDateFormat:@"EEE, MM/dd/yy"];
    NSDate *lDate = [dateFormat dateFromString:self.mDatetxtLbl.text];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    //to post the add weight log
    NSString* logSource =@"";
    if (mAppDelegate_.mTrackerDataGetter_.mLogsourceAppManualDict_) {
        logSource = [mAppDelegate_.mTrackerDataGetter_.mLogsourceAppManualDict_ valueForKey:@"Code"];
    }
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [self dismissModalViewControllerAnimated:TRUE];
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToAddStepLog:[dateFormat stringFromDate:lDate] Steps:[self.mTxtFld.text stringByReplacingOccurrencesOfString:@"," withString:@""] Notes:self.mCommentsTxtView.text LogSource:logSource AuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
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

- (IBAction)minusAction:(id)sender {
    int mvalue = 0;
    self.mTxtFld.text = [self.mTxtFld.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (![self.mTxtFld.text isEqualToString:@""]){
        mvalue = [self.mTxtFld.text intValue];
    }
    mvalue--;
    if (mvalue >= 0) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:mvalue]];
        [self.mTxtFld setText:[NSString stringWithFormat:@"%@", formatted] ];    }

}

- (IBAction)plusAction:(id)sender {
    int mvalue = 0;
    self.mTxtFld.text = [self.mTxtFld.text stringByReplacingOccurrencesOfString:@"," withString:@""];

    if (![self.mTxtFld.text isEqualToString:@""]){
        mvalue = [self.mTxtFld.text intValue];
    }
    mvalue++;
    if (mvalue < 10000000) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:mvalue]];
        [self.mTxtFld setText:[NSString stringWithFormat:@"%@", formatted] ];
    }
}
@end
