//
//  AddCholesterolViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 26/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AddCholesterolViewController.h"

@interface AddCholesterolViewController ()

@end

@implementation AddCholesterolViewController
@synthesize mRowValuesArray, mActiveTxtFld;
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
    self.mDateLbl.font = Bariol_Regular(17);
    self.mDateLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mDatetxtLbl.font = Bariol_Regular(17);
    self.mDatetxtLbl.textColor = BLACK_COLOR;
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    
    //to display the current date as default
    
    NSDate *lDate = [NSDate date];
    [lFormatter setDateFormat:@"EEE, MM/dd/yy"];
    self.mDatetxtLbl.text = [lFormatter stringFromDate:lDate];
    self.mCommentsTxtView.font = Bariol_Regular(17);
    self.mCommentsTxtView.textColor = BLACK_COLOR;
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
    mRowValuesArray = [[NSMutableArray alloc] initWithObjects:@"Choose", @"Choose", @"Choose", nil];
    if (mAppDelegate_.mTrackerDataGetter_.mCholesterolList_.count >0) {
        [self.mRowValuesArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%.1f mg/dL", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"TotalCholesterol"] floatValue]]];
        [self.mRowValuesArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%.1f mg/dL", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"LDLCholesterol"] floatValue]]];
        [self.mRowValuesArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%.1f mg/dL", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"HDLCholesterol"] floatValue]]];
    }
    [self.mTableView reloadData];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"Add New Cholesterol";
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
    
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"LOG_CHOLESTEROL_ADD", nil) imageName:imgName forController:self];
    
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(doneAction:) forController:self rightOrLeft:1];
    
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollView.frame = CGRectMake(self.mScrollView.frame.origin.x, self.mScrollView.frame.origin.y, 320, 504);
        
    }
    self.mTableView.frame = CGRectMake(0, 0, 320, 50*3);
    self.mBtmView.frame = CGRectMake(0, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+45, 320, self.mBtmView.frame.size.height);
    self.mScrollView.contentSize = CGSizeMake(320, self.mBtmView.frame.origin.y+self.mBtmView.frame.size.height+20);
}
- (void)backAction:(UIButton*)sender{
    [self dismissModalViewControllerAnimated:TRUE];
}
#pragma mark TABLE VIEW DELEGATE METHODS


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mRowValuesArray.count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.clearsContextBeforeDrawing=TRUE;
        //date Label
        UILabel *lDateLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 150, 30)];
        [lDateLbl setBackgroundColor:[UIColor clearColor]];
        [lDateLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lDateLbl setFont:Bariol_Regular(17)];
        lDateLbl.tag =1;
        [lDateLbl setTextColor:RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lDateLbl];
        
        //static text label
        UITextField *lTextLbl=[[UITextField alloc]initWithFrame:CGRectMake(100, 10+5, 180, 28)];
        [lTextLbl setTextAlignment:TEXT_ALIGN_RIGHT];
        [Utilities addInputViewForKeyBoardForTextFld:lTextLbl Class:self];
        lTextLbl.keyboardType = UIKeyboardTypeDecimalPad;
        lTextLbl.delegate = self;
        [lTextLbl setFont:Bariol_Regular(17)];
        lTextLbl.tag = indexPath.row+ 2;
        [lTextLbl setTextColor: BLACK_COLOR];
        [lTextLbl setBackgroundColor:CLEAR_COLOR];
        [cell.contentView addSubview:lTextLbl];
        
        //arrow image
        UIImageView *lImgview = [[UIImageView alloc]initWithFrame:CGRectMake(295, 18.5, 8.5, 13)];
        lImgview.image = [UIImage imageNamed:@"arrowright.png"];
        [cell.contentView addSubview:lImgview];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lLbl1 = (UILabel*)[cell.contentView viewWithTag:1];
    UITextField *lLbl2 = (UITextField*)[cell.contentView viewWithTag:indexPath.row+2];
    lLbl2.text = [self.mRowValuesArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
            lLbl1.text = @"Total Cholesterol";
            break;
        case 1:
            lLbl1.text = @"LDL Cholesterol";
            break;
        case 2:
            lLbl1.text = @"HDL Cholesterol";
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength;
    newLength = [textField.text length] + [string length] - range.length;
    
    if(newLength > 5){
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@"Choose"]) {
        textField.text = @"";
    }else{
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" mg/dL" withString:@""];
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    self.mActiveTxtFld = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        textField.text = @"Choose";
    }else{
        textField.text = [NSString stringWithFormat:@"%@ mg/dL", textField.text];
        
    }
    [self.mRowValuesArray replaceObjectAtIndex:textField.tag-2 withObject:textField.text];
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
    if (self.mActiveTxtFld.text.length == 0) {
        self.mActiveTxtFld.text = @"Choose";
    }
    [self.mRowValuesArray replaceObjectAtIndex:self.mActiveTxtFld.tag-2 withObject:self.mActiveTxtFld.text];
    
    
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
    lFrame=[self.mScrollView convertRect:self.mDatetxtLbl.bounds fromView:self.mDatetxtLbl];

    [self.mScrollView scrollRectToVisible:lFrame animated:NO];
    
    DatePickerController *screen = [[DatePickerController alloc] init];
    NSString *tempString=@"";
    tempString = self.mDatetxtLbl.text;
    [[screen mDatePicker_] setMaximumDate:[NSDate date]];

    
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
- (void)viewDidUnload {
    [self setMScrollView:nil];
    [self setMBGImgView:nil];
    [self setMDateLbl:nil];
    [self setMCommentsTxtView:nil];
    [self setMDatetxtLbl:nil];
    [self setMTableView:nil];
    [self setMBtmView:nil];
    [super viewDidUnload];
}
- (void)doneAction:(id)sender {
    if (self.mActiveTxtFld!=nil) {
        [self.mActiveTxtFld resignFirstResponder];
    }
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
    for (int i = 0; i< self.mRowValuesArray.count; i++) {
        if ([[self.mRowValuesArray objectAtIndex:i] isEqualToString:@"Choose"]) {
            if (i==0) {
                [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Total Cholesterol value is required."];
                return;
                
            }else if (i ==1){
                [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"LDL Cholesterol value is required."];
                return;
            }else {
                [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"HDL Cholesterol value is required."];
                return;
            }

        }
    }
    if ([[[self.mRowValuesArray objectAtIndex:0]stringByReplacingOccurrencesOfString:@" mg/dL" withString:@""] intValue] == 0) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Please enter a valid Total Cholesterol value."];
        return;
    }else if ([[[self.mRowValuesArray objectAtIndex:1]stringByReplacingOccurrencesOfString:@" mg/dL" withString:@""] intValue] == 0){
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Please enter a valid LDL Cholesterol value."];
        return;
    }
    else if ([[[self.mRowValuesArray objectAtIndex:2]stringByReplacingOccurrencesOfString:@" mg/dL" withString:@""] intValue] == 0){
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Please enter a valid HDL Cholesterol value."];
        return;
    }
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [self dismissModalViewControllerAnimated:TRUE];
        [mAppDelegate_ createLoadView];
        //date & time
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [GenricUI setLocaleZoneForDateFormatter:dateFormat];
        [dateFormat setDateFormat:@"EEE, MM/dd/yy"];
        NSDate *lDate = [dateFormat dateFromString:self.mDatetxtLbl.text];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        [mAppDelegate_.mRequestMethods_ postRequestToAddCholesterolLog:[dateFormat stringFromDate:lDate]
                                                        TotalCholesterol:[[self.mRowValuesArray objectAtIndex:0]stringByReplacingOccurrencesOfString:@" mg/dL" withString:@""]
                                                        LDLCholesterol:[[self.mRowValuesArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@" mg/dL" withString:@""]
                                                        HDLCholesterol:[[self.mRowValuesArray objectAtIndex:2]stringByReplacingOccurrencesOfString:@" mg/dL" withString:@""]
                                                                 Notes:self.mCommentsTxtView.text
                                                             AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                          SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dateAction:(id)sender {
    if (self.mActiveTxtFld!=nil) {
        [self.mActiveTxtFld resignFirstResponder];
    }
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

@end
