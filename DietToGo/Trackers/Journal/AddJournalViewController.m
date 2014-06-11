//
//  AddJournalViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 19/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AddJournalViewController.h"

@interface AddJournalViewController ()

@end

@implementation AddJournalViewController
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
    
    self.mCatLbl.font = Bariol_Regular(17);
    self.mCatLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mCatTxtLbl.font = Bariol_Regular(17);
    self.mCatTxtLbl.textColor = BLACK_COLOR;
    self.mDateLbl.font = Bariol_Regular(17);
    self.mDateLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mDateTXTLBL.font = Bariol_Regular(17);
    self.mDateTXTLBL.textColor = BLACK_COLOR;
    self.mTimeLbl.font = Bariol_Regular(17);
    self.mTimeLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mTimeTxtLbl.font = Bariol_Regular(17);
    self.mTimeTxtLbl.textColor = BLACK_COLOR;
    
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    NSDate *lDate = [NSDate date];
    [lFormatter setDateFormat:@"EEE, MM/dd/yy"];
    self.mDateTXTLBL.text = [lFormatter stringFromDate:lDate];
    [lFormatter setDateFormat:@"hh:mm a"];
    NSString *lTime = [lFormatter stringFromDate:lDate];
    lTime = [lTime stringByReplacingOccurrencesOfString:@"AM" withString:@"am"];
    lTime = [lTime stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
    lTime = [lTime stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
    self.mTimeTxtLbl.text = lTime;
    
    if (self.mCommentTxtView.text.length == 0) {
        //for placeholder
        UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mCommentTxtView.frame.size.width - 20.0, 34.0)];
        [placeholderLabel setText:NSLocalizedString(@"ADD_JOURNAL", nil)];
        [placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [placeholderLabel setFont:Bariol_Regular(18)];
        [placeholderLabel setTextColor:RGB_A(136, 136, 136, 1)];
        
        [self.mCommentTxtView addSubview:placeholderLabel];
        
    }
    
    [Utilities addInputViewForKeyBoard:self.mCommentTxtView
                                 Class:self];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"Add New Journal";
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"LOG_JOURNAL_ADD", nil) imageName:imgName forController:self];
    
    
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
    if(self.mCommentTxtView.text.length == 0){
        //self.mTextView_.textColor = [UIColor lightGrayColor];
        //self.mTextView_.text = @"comment";
        //[self.mTextView_ resignFirstResponder];
        for (UIView *lview in textView.subviews) {
            if ([lview isKindOfClass:[UILabel class]]) {
                [lview removeFromSuperview];
            }
        }
        UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mCommentTxtView.frame.size.width - 20.0, 34.0)];
        [placeholderLabel setText:NSLocalizedString(@"ADD_JOURNAL", nil)];
        [placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [placeholderLabel setFont:Bariol_Regular(18)];
        [placeholderLabel setTextColor:RGB_A(136, 136, 136, 1)];
        [self.mCommentTxtView addSubview:placeholderLabel];
        
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
        UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mCommentTxtView.frame.size.width - 20.0, 34.0)];
        [placeholderLabel setText:NSLocalizedString(@"ADD_JOURNAL", nil)];
        [placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [placeholderLabel setFont:Bariol_Regular(18)];
        [placeholderLabel setTextColor:RGB_A(136, 136, 136, 1)];
        [self.mCommentTxtView addSubview:placeholderLabel];
        
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
    self.mCommentTxtView.text = @"";
    for (UIView *lview in self.mCommentTxtView.subviews) {
        if ([lview isKindOfClass:[UILabel class]]) {
            [lview removeFromSuperview];
        }
    }
    UILabel*  placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.mCommentTxtView.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:NSLocalizedString(@"ADD_JOURNAL", nil)];
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:Bariol_Regular(18)];
    [placeholderLabel setTextColor:RGB_A(136, 136, 136, 1)];
    [self.mCommentTxtView addSubview:placeholderLabel];
    
}
// done action
- (void)done_Event
{
    [self.mCommentTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
    
}
- (void)displayPickerview {
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217+55 , 0.0);
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect lFrame=[self.mScrollView convertRect:self.mCatTxtLbl.bounds fromView:self.mCatTxtLbl];
    
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];

    PickerViewController *screen = [[PickerViewController alloc] init];
    NSMutableArray *rowValuesArr_=[[NSMutableArray alloc] init];
    NSMutableArray *mTemArray = [[NSMutableArray alloc]init];
    for (int i =0; i< mAppDelegate_.mTrackerDataGetter_.mJournalCatList_.count; i++) {
        [mTemArray addObject:[[mAppDelegate_.mTrackerDataGetter_.mJournalCatList_ objectAtIndex:i] objectForKey:@"Value"]];
    }
    [rowValuesArr_ addObject:mTemArray];
    screen.mRowValueintheComponent=rowValuesArr_;
    screen->mNoofComponents=[rowValuesArr_ count];
    screen.mTextDisplayedlb.text=@"Select Journal Category";
    //[screen addSubview:screen.mViewPicker_];
     
    if(![self.mCatTxtLbl.text isEqualToString:@"Choose"]){
        
        for (int i=0; i<[[rowValuesArr_ objectAtIndex:0] count]; i++) {
            if ([[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] isEqualToString:self.mCatTxtLbl.text]) {
                [screen.mViewPicker_ selectRow:i inComponent:0 animated:YES];
                [screen.mViewPicker_ reloadComponent:0];
            }
        }
    }else{
        
    }
    [screen setMPickerViewDelegate_:self];
    // [screen setMSelectedTextField_:mActiveTxtFld_];
    [mAppDelegate_.window addSubview:screen];


}
- (void)pickerViewController:(PickerViewController *)controller
                 didPickComp:(NSMutableArray *)valueArr
                      isDone:(BOOL)isDone {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
	
    if(isDone==YES)
    {
        
        NSString *mData_=@"";
        for(int i=0;i<[valueArr count];i++){
            mData_=[mData_ stringByAppendingString:[valueArr objectAtIndex:i]];
        }
        self.mCatTxtLbl.text = mData_;
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
        return [mAppDelegate_.mTrackerDataGetter_.mJournalCatList_  count];
   
    else
        return 0;
    
}

// ************* tell the picker the title for a given component ****************
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	
    if (component==0)
        return [[mAppDelegate_.mTrackerDataGetter_.mJournalCatList_ objectAtIndex:row] objectForKey:@"Value"];
   
	else
        return @"";
    
}

- (void)displayDatePicker{
    
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 217+55 , 0.0);
    
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    
    
    CGRect lFrame=[self.mScrollView convertRect:self.mDateTXTLBL.bounds fromView:self.mDateTXTLBL];
    
    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
    
    DatePickerController *screen = [[DatePickerController alloc] init];
    
    NSString *tempString=@"";
    if (self.mSelectedTag == 2) {
        tempString = self.mDateTXTLBL.text;
        [[screen mDatePicker_] setDatePickerMode:UIDatePickerModeDate];
        [[screen mDatePicker_] setMaximumDate:[NSDate date]];

    }else{
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [GenricUI setLocaleZoneForDateFormatter:df];
        [df setDateFormat:@"EEE, MM/dd/yy"];
        NSDate *lDate = [df dateFromString:self.mDateTXTLBL.text];
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
    if (getDate == nil)
    {
        getDate = [NSDate date];
        
    }else {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
        [df setTimeZone:gmtZone];
        NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
        df.locale = enLocale;
          if (self.mSelectedTag == 2) {
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
        if (self.mSelectedTag == 2) {
            [lDateFormat_ setDateFormat:@"EEE, MM/dd/yy"];
            self.mDateTXTLBL.text = [NSString stringWithFormat:@"%@", [lDateFormat_ stringFromDate:date]];
            NSDate *lCurrentDate = [NSDate date];
            
            // to set the maximum time as crrent time if the day is current day
            if ([self.mDateTXTLBL.text isEqualToString:[lDateFormat_ stringFromDate:lCurrentDate]]) {
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
    [self setMCommentTxtView:nil];
    [self setMCatLbl:nil];
    [self setMCatTxtLbl:nil];
    [self setMTopImgView:nil];
    [self setMBtmImgView:nil];
    [self setMDateLbl:nil];
    [self setMDateTXTLBL:nil];
    [self setMTimeLbl:nil];
    [self setMTimeTxtLbl:nil];
    [super viewDidUnload];
}
- (void)doneAction:(id)sender {
    [self.mCommentTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    if (self.mCommentTxtView.text.length == 0) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"LOG_JOURNAL_ENTRY", nil)];
        return;
    }else if([self.mCatTxtLbl.text isEqualToString:@"Choose"]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"LOG_JOURNAL_CATEGORY", nil)];
        return;
    }
    //date & time
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [GenricUI setLocaleZoneForDateFormatter:dateFormat];
    [dateFormat setDateFormat:@"EEE, MM/dd/yy hh:mm a"];
    NSString* tempString = self.mTimeTxtLbl.text;
    tempString = [tempString stringByReplacingOccurrencesOfString:@"AM" withString:@"am"];
    tempString = [tempString stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
    NSDate *lDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", self.mDateTXTLBL.text, tempString]];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSString *mCatID = [mAppDelegate_.mTrackerDataGetter_ returnTheCategoryID:self.mCatTxtLbl.text];
    //post req to add log
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [self dismissModalViewControllerAnimated:TRUE];
        [mAppDelegate_.mRequestMethods_ postRequestToAddJournalLog:[dateFormat stringFromDate:lDate]
                                                          Category:mCatID
                                                             Notes:self.mCommentTxtView.text
                                                         AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                      SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
}
- (void)removeViews{
    for (UIView *lview in mAppDelegate_.window.subviews) {
        if ([lview isKindOfClass:[PickerViewController class]]||[lview isKindOfClass:[DatePickerController class]]) {
            [lview removeFromSuperview];
        }
    }
}
- (IBAction)categoryAction:(UIButton *)sender {
    [self.mCommentTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayPickerview];
}
- (IBAction)dateAction:(UIButton *)sender {
    self.mSelectedTag = sender.tag;
    [self.mCommentTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayDatePicker];
}

- (IBAction)timeAction:(UIButton *)sender {
    self.mSelectedTag = sender.tag;
    [self.mCommentTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayDatePicker];

}
@end
