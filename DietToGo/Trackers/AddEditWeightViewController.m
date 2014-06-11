//
//  AddEditWeightViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 04/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AddEditWeightViewController.h"
#import "WeightListViewController.h"

@interface AddEditWeightViewController ()

@end

@implementation AddEditWeightViewController
@synthesize isFromEdit;

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
    [self.mWeightTxtFld setTextColor:BLACK_COLOR];
    [self.mWeightTxtFld setFont:Bariol_Regular(25)];
    self.mLbsLbl.font = Bariol_Regular(18);
    self.mLbsLbl.textColor = BLACK_COLOR;
    self.mDateLbl.font = Bariol_Regular(18);
    self.mDateLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mDatetxtLbl.font = Bariol_Regular(18);
    self.mDatetxtLbl.textColor = BLACK_COLOR;
    
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];

    //to display the current date as default
    if (!isFromEdit) {
        NSDate *lDate = [NSDate date];
        [lFormatter setDateFormat:@"EEE, MM/dd/yy"];
        self.mDatetxtLbl.text = [lFormatter stringFromDate:lDate];
    }else{
       
    }
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
    [Utilities addInputViewForKeyBoardForTextFld:self.mWeightTxtFld
                                           Class:self];
    
    mLogWeightValuesDict_=[[NSMutableDictionary alloc]init];
    
    //to set the last logged value in add weight screen
    if (mAppDelegate_.mTrackerDataGetter_.mWeightList_.count >0) {
        self.mWeightTxtFld.text = [NSString stringWithFormat:@"%.1f", [[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:0] objectForKey:@"Weight"] floatValue]];
    }else{
        [self.mWeightTxtFld setText:@"0.0"];

    }


}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        // self.trackedViewName=@"Add New Weight";
        [mAppDelegate_ trackFlurryLogEvent:@"Add New Weight"];
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
    if (isFromEdit) {
        [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"LOG_WEIGHT_EDIT", nil) imageName:imgName forController:self];
    }else {
        [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"LOG_WEIGHT_ADD", nil) imageName:imgName forController:self];
    }
    
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
#pragma mark ----
#pragma mark textfield delegate methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength;
    newLength = [textField.text length] + [string length] - range.length;
    
    if(newLength > 5){
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
}
- (void)textFiledDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        textField.text = @"0.0";
        
    }else{
        textField.text = [NSString stringWithFormat:@"%.1f", [textField.text floatValue]];

    }
}
#pragma mark ----
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
// clear action
- (void)cancelTxtFld_Event
{
    self.mWeightTxtFld.text = @"";
    
}
// done action
- (void)doneTxtFld_Event
{
    if (self.mWeightTxtFld.text.length == 0) {
        self.mWeightTxtFld.text = @"0.0";

    }else{
        
        self.mWeightTxtFld.text = [NSString stringWithFormat:@"%.1f", [self.mWeightTxtFld.text floatValue]];

    }
    [self.mWeightTxtFld resignFirstResponder];

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
    [self setMLbsLbl:nil];
    [self setMBGImgView:nil];
    [self setMDateLbl:nil];
    [self setMCommentsTxtView:nil];
    [self setMDatetxtLbl:nil];
    [super viewDidUnload];
}
- (void)doneAction:(id)sender {
    [self.mCommentsTxtView resignFirstResponder];
    [self.mWeightTxtFld resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];

    if ([self.mWeightTxtFld.text isEqualToString:@""] || self.mWeightTxtFld.text == nil || [self.mWeightTxtFld.text isEqualToString:@"0.0"]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Please enter a valid weight value."];
        return;

    }
    if (!isFromEdit) {
        //date & time
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [GenricUI setLocaleZoneForDateFormatter:dateFormat];
        [dateFormat setDateFormat:@"EEE, MM/dd/yy"];
        NSDate *lDate = [dateFormat dateFromString:self.mDatetxtLbl.text];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        //to post the add weight log
        if ([[NetworkMonitor instance]isNetworkAvailable]) {
            [self dismissModalViewControllerAnimated:TRUE];
            [mAppDelegate_ createLoadView];
            [mAppDelegate_.mRequestMethods_ postRequestToAddWeightLog:[dateFormat stringFromDate:lDate]
                                                               Weight:self.mWeightTxtFld.text
                                                                Notes:self.mCommentsTxtView.text
                                                            AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                         SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
        }

    }else{
        [self dismissModalViewControllerAnimated:TRUE];

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

- (IBAction)minusAction:(UIButton *)sender {
    float mvalue = 0;
    if (![self.mWeightTxtFld.text isEqualToString:@""]){
        mvalue = [self.mWeightTxtFld.text floatValue];
    }
    mvalue--;
    if (mvalue >= 0) {
        [self.mWeightTxtFld setText:[NSString stringWithFormat:@"%.1f", mvalue]];
    }
   
}

- (IBAction)plusAction:(UIButton *)sender {
    float mvalue = 0;
    if (![self.mWeightTxtFld.text isEqualToString:@""]){
        mvalue = [self.mWeightTxtFld.text floatValue];
    }
    mvalue++;
    if (mvalue < 99999) {
        [self.mWeightTxtFld setText:[NSString stringWithFormat:@"%.1f", mvalue]];
    }
}
@end
