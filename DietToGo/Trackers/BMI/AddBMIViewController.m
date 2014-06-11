//
//  AddBMIViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 26/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "AddBMIViewController.h"
#define Height @"0,1,2,3,4,5,6,7,8,9,10,11"
#import "LandingViewController.h"
#import "JSON.h"

#define DateFormatForRequest @"yyyy-MM-dd"

@interface AddBMIViewController ()

@end

@implementation AddBMIViewController
@synthesize mRowValuesArray, mWeightValDict_, mSelectedIndex;

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
    mRowValuesArray = [[NSMutableArray alloc] initWithObjects:@"Choose", @"Choose", nil];

    [Utilities addInputViewForKeyBoard:self.mCommentsTxtView
                                 Class:self];
    
    /*
     * to store weight picker values
     */
    mWeightValDict_=[[NSMutableDictionary alloc]init];
    
    NSMutableArray *pTempArray=[[NSMutableArray alloc]init];
    for (int i=0; i<500; i++) {
        [pTempArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.mWeightValDict_ setValue:pTempArray forKey:@"whole"];
    
    NSMutableArray *pTempArray1=[[NSMutableArray alloc]init];
    for (int i=0; i<10; i++) {
        [pTempArray1 addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.mWeightValDict_ setValue:pTempArray1 forKey:@"decimal"];

    NSMutableArray *lArr=[[NSMutableArray alloc] init];
    self.mRowValueintheComponent=lArr;
    NSArray *lRowValueArr=[Height componentsSeparatedByString:@","];
    [self.mRowValueintheComponent addObject:lRowValueArr];
    [self.mRowValueintheComponent addObject:lRowValueArr];
    //
    self.mValueLbl.font = Bariol_Regular(24);
    self.mValueLbl.textColor = BLACK_COLOR;
    self.mHealthyWtLbl.font = Bariol_Regular(17);
    self.mHealthyWtLbl.textColor = BLACK_COLOR;
    
    //for last log value
    if (mAppDelegate_.mTrackerDataGetter_.mBMIList_.count > 0) {
        NSString *mHeight = [NSString stringWithFormat:@"%d ft %d in", [[[mAppDelegate_.mTrackerDataGetter_.mBMIList_ objectAtIndex:0] objectForKey:@"HeightFt"] intValue], [[[mAppDelegate_.mTrackerDataGetter_.mBMIList_ objectAtIndex:0] objectForKey:@"HeightIn"] intValue]];
        [self.mRowValuesArray replaceObjectAtIndex:0 withObject:mHeight];
        //NSString *mWeight = [NSString stringWithFormat:@"%.1f Lbs", [[[mAppDelegate_.mTrackerDataGetter_.mBMIList_ objectAtIndex:0] objectForKey:@"Weight"] floatValue]];
        NSString *mWeight = [NSString stringWithFormat:@"%.1f Lbs", [[mAppDelegate_.mLandingViewController.mTrackerValuesDict objectForKey:@"Weight"] floatValue]];
        if (mAppDelegate_.mTrackerDataGetter_.mWeightList_.count > 0) {
            mWeight = [NSString stringWithFormat:@"%.1f Lbs", [[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:0] objectForKey:@"Weight"] floatValue]];
        }
        [self.mRowValuesArray replaceObjectAtIndex:1 withObject:mWeight];
        float BMI = [self caluclateBMI];
        self.mValueLbl.text = [NSString stringWithFormat:@"%.1f", BMI];
        self.mHealthyWtLbl.text = [self returnTheweightType:BMI];
        if (![self.mHealthyWtLbl.text isEqualToString:@"Normal Weight"]) {
            self.mHealthyWtLbl.text = [self.mHealthyWtLbl.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    }else if(mAppDelegate_.mTrackerDataGetter_.mBMIList_.count == 0){
        //Add this service hit to get the latest goal tracker weight
  
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            
            [mAppDelegate_ createLoadView];
            NSString *mCurrentDate_=@"";
            NSDateFormatter *mFormatter_=[[NSDateFormatter alloc]init];
            
            NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
            [mFormatter_ setTimeZone:gmtZone];
            NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
            mFormatter_.locale = enLocale;
            
            [mFormatter_ setDateFormat:DateFormatForRequest];
            mCurrentDate_=[mFormatter_ stringFromDate:[NSDate date]];
            
            NSString *mRequestStr = WEBSERVICEURL;
            mRequestStr = [mRequestStr stringByAppendingFormat:@"%@/%@/%@", GoalTxt, TrackersTXT,mCurrentDate_];

            
            [NSThread detachNewThreadSelector:@selector(GetResponseData:) toTarget:self withObject: mRequestStr];
            
        }else {
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
            return;
        }
    }
    [self.mTableView reloadData];

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
    }
    else
    {
        NSMutableDictionary *mDict = [json_string JSONValue];
        if ([mDict objectForKey:@"Message"]!=nil ) {
            [mAppDelegate_ removeLoadView];
            [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :[mDict objectForKey:@"Message"]];
            return;
        }
        NSLog(@"mDict %@",mDict);
        //Add latest weight value
        NSString *mWeight = [NSString stringWithFormat:@"%.1f Lbs", [[mDict objectForKey:@"Weight"] floatValue]];
        [self.mRowValuesArray replaceObjectAtIndex:1 withObject:mWeight];
        [self.mTableView reloadData];
    }
    
    [mAppDelegate_ removeLoadView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"Add New BMI";
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
    
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"LOG_BMI_ADD", nil) imageName:imgName forController:self];
    
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(doneAction:) forController:self rightOrLeft:1];
    
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollView.frame = CGRectMake(self.mScrollView.frame.origin.x, self.mScrollView.frame.origin.y, 320, 504);
        
    }
    self.mTableView.frame = CGRectMake(0, self.mTableView.frame.origin.y, 320, 50*2);
    self.mBtmView.frame = CGRectMake(0, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+15, 320, self.mBtmView.frame.size.height);
    self.mScrollView.contentSize = CGSizeMake(320, self.mBtmView.frame.origin.y+self.mBtmView.frame.size.height);
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
        UILabel *lTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 180, 50)];
        [lTextLbl setTextAlignment:TEXT_ALIGN_RIGHT];
        [lTextLbl setFont:Bariol_Regular(17)];
        lTextLbl.tag =  2;
        [lTextLbl setTextColor: BLACK_COLOR];
        [cell.contentView addSubview:lTextLbl];
        
        //arrow image
        UIImageView *lImgview = [[UIImageView alloc]initWithFrame:CGRectMake(295, 18.5, 8.5, 13)];
        lImgview.image = [UIImage imageNamed:@"arrowright.png"];
        [cell.contentView addSubview:lImgview];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lLbl1 = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *lLbl2 = (UILabel*)[cell.contentView viewWithTag:2];
    lLbl2.text = [self.mRowValuesArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
            lLbl1.text = @"Height";
            break;
        case 1:
            lLbl1.text = @"Weight";
            break;
        
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.mSelectedIndex = indexPath;
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayPickerview];
    
}
#pragma mark TextView delagate, cancel and done actions
- (void)textViewDidChange:(UITextView*)textView
{
    if(self.mCommentsTxtView.text.length == 0){
        
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
- (void)displayPickerview {
    
    PickerViewController *screen = [[PickerViewController alloc] init];
    if (self.mSelectedIndex.row == 1) {
        NSMutableArray *rowValuesArr_=[[NSMutableArray alloc] init];
        [rowValuesArr_ addObject:[self.mWeightValDict_ valueForKey:@"whole"]];
        [rowValuesArr_ addObject:[self.mWeightValDict_ valueForKey:@"decimal"]];
        screen.mRowValueintheComponent=rowValuesArr_;
        screen->mNoofComponents=[rowValuesArr_ count];
        screen.mTextDisplayedlb.text=@"Select Weight";
        
        NSString *mText = [self.mRowValuesArray objectAtIndex:self.mSelectedIndex.row];
        if (![mText isEqualToString:@"Choose"]) {
            mText = [mText stringByReplacingOccurrencesOfString:@" Lbs" withString:@""];
            NSArray *mArray = [mText componentsSeparatedByString:@"."];
            
            for (int i=0; i<[[rowValuesArr_ objectAtIndex:0] count]; i++) {
                if ([[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] isEqualToString:[mArray objectAtIndex:0]]) {
                    [screen.mViewPicker_ selectRow:i inComponent:0 animated:YES];
                    [screen.mViewPicker_ reloadComponent:0];
                }
            }
            for (int i=0; i<[[rowValuesArr_ objectAtIndex:1] count]; i++) {
                NSString *lDecimalVal=[mArray objectAtIndex:1];
                lDecimalVal = [lDecimalVal substringToIndex:1];
                if ([[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] isEqualToString:lDecimalVal]) {
                    [screen.mViewPicker_ selectRow:i inComponent:1 animated:YES];
                    [screen.mViewPicker_ reloadComponent:1];
                }
            }
        }
        
    }else{
        screen.mRowValueintheComponent=self.mRowValueintheComponent;
        screen->mNoofComponents=[self.mRowValueintheComponent count];
        screen.mTextDisplayedlb.text=@"Select Height";
        NSString *mText = [self.mRowValuesArray objectAtIndex:self.mSelectedIndex.row];
        if (![mText isEqualToString:@"Choose"]) {
            mText = [mText substringToIndex:[mText rangeOfString:@" ft"].location];
            for (int i=0; i<[[self.mRowValueintheComponent objectAtIndex:0] count]; i++) {
                if ([[[self.mRowValueintheComponent objectAtIndex:0] objectAtIndex:i] isEqualToString:mText]) {
                    [screen.mViewPicker_ selectRow:i inComponent:0 animated:YES];
                    [screen.mViewPicker_ reloadComponent:0];
                }
            }
            mText = [self.mRowValuesArray objectAtIndex:self.mSelectedIndex.row];
            mText = [mText substringFromIndex:[mText rangeOfString:@"ft "].location];
            mText = [mText stringByReplacingOccurrencesOfString:@"ft " withString:@""];
            mText = [mText stringByReplacingOccurrencesOfString:@" in" withString:@""];
            for (int i=0; i<[[self.mRowValueintheComponent objectAtIndex:1] count]; i++) {
                if ([[[self.mRowValueintheComponent objectAtIndex:1] objectAtIndex:i] isEqualToString:mText]) {
                    [screen.mViewPicker_ selectRow:i inComponent:1 animated:YES];
                    [screen.mViewPicker_ reloadComponent:1];
                }
            }
        }
        
        

    }
   
    [screen setMPickerViewDelegate_:self];
    // [screen setMSelectedTextField_:mActiveTxtFld_];
    [mAppDelegate_.window addSubview:screen];
    
}
- (void)pickerViewController:(PickerViewController *)controller
                 didPickComp:(NSMutableArray *)valueArr
                      isDone:(BOOL)isDone{
    
    if(isDone==YES)
    {
        
        NSString *mData_=@"";
        if (self.mSelectedIndex.row == 0) {
            mData_ = [valueArr objectAtIndex:0];
            mData_ = [mData_ stringByAppendingString:@" ft"];
            mData_ = [mData_ stringByAppendingString:@" "];
            mData_ = [mData_ stringByAppendingString:[valueArr objectAtIndex:1]];
            mData_ = [mData_ stringByAppendingString:@" in"];
            
        }else{
            for(int i=0;i<[valueArr count];i++){
                
                if(i==1){
                    mData_ = [mData_ stringByAppendingString:@"."];
                }
                mData_=[mData_ stringByAppendingString:[valueArr objectAtIndex:i]];
            }
            mData_ = [mData_ stringByAppendingString:@" Lbs"];
        }
        
        [self.mRowValuesArray replaceObjectAtIndex:self.mSelectedIndex.row withObject:mData_];
        [self.mTableView reloadData];

        //to load the BMI caluclated value in the screen
        if (![[self.mRowValuesArray objectAtIndex:0] isEqualToString:@"Choose"] && ![[self.mRowValuesArray objectAtIndex:1] isEqualToString:@"Choose"]) {
            
            NSString *mHtFt, *mHtIn, *mWt;
            mHtFt = [self.mRowValuesArray objectAtIndex:0];
            mHtFt = [mHtFt substringToIndex:[mHtFt rangeOfString:@" ft"].location];
            mHtIn = [self.mRowValuesArray objectAtIndex:0];
            mHtIn = [mHtIn substringFromIndex:[mHtIn rangeOfString:@"ft "].location];
            mHtIn = [mHtIn stringByReplacingOccurrencesOfString:@"ft " withString:@""];
            mHtIn = [mHtIn stringByReplacingOccurrencesOfString:@" in" withString:@""];
            mWt = [self.mRowValuesArray objectAtIndex:1];
            mWt = [mWt stringByReplacingOccurrencesOfString:@" Lbs" withString:@""];

            if ((![mHtIn isEqualToString:@"0"] || ![mHtFt isEqualToString:@"0"]) && ![mWt isEqualToString:@"0.0"] ) {
                float BMI = [self caluclateBMI];
                self.mValueLbl.text = [NSString stringWithFormat:@"%.1f", BMI];
                self.mHealthyWtLbl.text = [self returnTheweightType:BMI];
                if (![self.mHealthyWtLbl.text isEqualToString:@"Normal Weight"]) {
                    self.mHealthyWtLbl.text = [self.mHealthyWtLbl.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                }
            }
            
            
            
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
    return 2;
}

//  *************** tell the picker how many rows are available for a given component ************
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.mSelectedIndex.row == 1) {
        if (component==0)
            return [[self.mWeightValDict_ objectForKey:@"whole"] count];
        else if(component==1)
            return [[self.mWeightValDict_ objectForKey:@"decimal"] count];
        else
            return 0;

    }else{
        if (component==0)
            return [[self.mRowValueintheComponent objectAtIndex:0]  count];
        else if(component==1)
            return [[self.mRowValueintheComponent objectAtIndex:1]  count];
        else
            return 0;

    }
    
}

// ************* tell the picker the title for a given component ****************
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	
    if (self.mSelectedIndex.row == 1) {
        if (component==0)
            return [[self.mWeightValDict_ objectForKey:@"whole"] objectAtIndex:row];
        else
            return [[self.mWeightValDict_ objectForKey:@"decimal"] objectAtIndex:row];
    }else{
        if (component==0)
            return [[self.mRowValueintheComponent objectAtIndex:0] objectAtIndex:row];
        else
            return [[self.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row];
    }
   
	
    
}
- (void)removeViews{
    for (UIView *lview in mAppDelegate_.window.subviews) {
        if ([lview isKindOfClass:[PickerViewController class]]||[lview isKindOfClass:[DatePickerController class]]) {
            [lview removeFromSuperview];
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
                [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Height value is required."];
                return;
                
            }else if (i ==1){
                [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Weight value is required."];
                return;
            }
        }
    }
    NSString *mHtFt, *mHtIn, *mWt;
    mHtFt = [self.mRowValuesArray objectAtIndex:0];
    mHtFt = [mHtFt substringToIndex:[mHtFt rangeOfString:@" ft"].location];
    mHtIn = [self.mRowValuesArray objectAtIndex:0];
    mHtIn = [mHtIn substringFromIndex:[mHtIn rangeOfString:@"ft "].location];
    mHtIn = [mHtIn stringByReplacingOccurrencesOfString:@"ft " withString:@""];
    mHtIn = [mHtIn stringByReplacingOccurrencesOfString:@" in" withString:@""];
    
    mWt = [self.mRowValuesArray objectAtIndex:1];
    mWt = [mWt stringByReplacingOccurrencesOfString:@" Lbs" withString:@""];
    
    
    if ([mHtFt isEqualToString:@"0"] && [mHtIn isEqualToString:@"0"]){
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Height should be greater than 0."];
        return;
    }else if ([mWt isEqualToString:@"0.0"]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Weight should be greater than 0."];
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
        
        
        [mAppDelegate_.mRequestMethods_ postRequestToAddBMILog:[dateFormat stringFromDate:lDate]
                                                      HeightFt:mHtFt
                                                   HeightInchs:mHtIn
                                                        Weight:mWt
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
    
    [self.mCommentsTxtView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mScrollView.contentInset = contentInsets;
    self.mScrollView.scrollIndicatorInsets = contentInsets;
    [self removeViews];
    [self displayDatePicker];
    
}

- (float)caluclateBMI{
    NSString *mHtFt, *mHtIn, *mWt;
    mHtFt = [self.mRowValuesArray objectAtIndex:0];
    mHtFt = [mHtFt substringToIndex:[mHtFt rangeOfString:@" ft"].location];
    
    mHtIn = [self.mRowValuesArray objectAtIndex:0];
    mHtIn = [mHtIn substringFromIndex:[mHtIn rangeOfString:@"ft "].location];
    mHtIn = [mHtIn stringByReplacingOccurrencesOfString:@"ft " withString:@""];
    mHtIn = [mHtIn stringByReplacingOccurrencesOfString:@" in" withString:@""];
    
    mWt = [self.mRowValuesArray objectAtIndex:1];
    mWt = [mWt stringByReplacingOccurrencesOfString:@" Lbs" withString:@""];
    
    int HeightIn = [mHtFt intValue]*12;//[mHtIn intValue];
    HeightIn = HeightIn+[mHtIn intValue];
    HeightIn = HeightIn * HeightIn;
    
    float weight = [mWt floatValue];
    
    float BMI = weight/HeightIn;
    BMI = BMI * 703;
    
    return BMI;

}
- (NSString*)returnTheweightType:(float)mValue
{
    NSString *BMItype = @"";
    if (mValue < 18.5) {
        BMItype = @"Under weight";
    }else if(mValue > 18.5 && mValue < 24.9){
        BMItype = @"Normal Weight";
       // BMItype = NORMALWEIGHT;
        
    }else if(mValue > 25 && mValue < 29.9){
        BMItype = @"Over weight";
        
    }else if (mValue >30){
        BMItype = @"Obese";
    }
    return BMItype;
}

@end
