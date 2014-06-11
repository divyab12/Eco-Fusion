//
//  WaterAddEditViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 14/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "WaterAddEditViewController.h"
#import "JSON.h"

#define kMaxWaterGlass 99
#define SecondsInAWeek  60 * 60 * 24
#define DateFormatServer @"yyyy-MM-dd'T'HH:mm:ss"
#define DateFormatApp @"EEEE, MMMM dd, yyyy"
#define DateFormatForRequest @"yyyy-MM-dd"
#define KToday @"Today"

@interface WaterAddEditViewController ()

@end

@implementation WaterAddEditViewController
@synthesize mCurrentDate_;
@synthesize mDisplayedDate_;
@synthesize mFormatter_;
@synthesize mLogWaterDataList_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mAppDelegate_ = [AppDelegate appDelegateInstance];
        mWaterConsumed_=0;
        mCurrentDay=0;
        mCurrentDate_=@"";
        mFormatter_=[[NSDateFormatter alloc]init];
        [GenricUI setLocaleZoneForDateFormatter:mFormatter_];
       // mLogWaterDataList_ = [[NSMutableArray alloc]init];
        //[self.mLogWaterDataList_ addObjectsFromArray:mAppDelegate_.mTrackerDataGetter_.mWaterList_];
        mLogWaterDataList_ = [mAppDelegate_.mTrackerDataGetter_.mWaterList_ mutableCopy];
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
    self.mWaterGlassesScrollVie_.layer.cornerRadius=8;
	self.mWaterGlassesScrollVie_.layer.borderColor = RGB_A(96, 145, 185, 1).CGColor;
	self.mWaterGlassesScrollVie_.layer.borderWidth = 2;
    
    mTotalwaterGlasses_=8;
    mCurrentGlass_=0;


}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"WATER_TRACKER", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];//need to change to cancel button
    self.navigationItem.rightBarButtonItem=nil;

    
    if(isFromEdit){    // for edit the water log ********
        
        [self displayDateFortheHeader];
        [self dispalyTheWaterGlasses];
        
    }else{      // for new water log ***********
        
        [self addNewWaterLog];
        [self dispalyTheWaterGlasses];
        
    }
    if ([[GenricUI instance] isiPhone5]) {
        self.mWaterGlassesScrollVie_.frame = CGRectMake(self.mWaterGlassesScrollVie_.frame.origin.x, self.mWaterGlassesScrollVie_.frame.origin.y, self.mWaterGlassesScrollVie_.frame.size.width, self.mWaterGlassesScrollVie_.frame.size.height+78);
    }

}
- (void)backAction:(UIButton*)lBtn
{
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = mAppDelegate_.mWaterListViewController;
        [mAppDelegate_.mRequestMethods_ postRequestToGetWaterLogs:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
}
#pragma Mark *********** Actions ****************

// *************** Method used to pop viewcontroller **********************

- (void)backButtonAction:(UIButton*)sender {
    /*[mAppDelegate_ createLoadView];
    [mAppDelegate.mRequestMethods_ postRequestForLogWaterGet:mAppDelegate.mResponseMethods_.mUserId
                                                       Token:mAppDelegate.mResponseMethods_.mUserToken
                                                  RecordsNum:10];*/
    [self.navigationController popViewControllerAnimated:TRUE];
}
// ************ make the water glasses as Reported or as unReported  logic ***********

- (void)waterGlassButtonAction:(id)sender {
    
    UIButton *waterGlass=(UIButton*)sender;
    
    if ([waterGlass isSelected]) {
        
        // presently no need of the below line
        //[waterGlass setSelected:NO];
        if(waterGlass.tag<=8){
            mCurrentGlass_--;
            mWaterConsumed_=mCurrentGlass_;
        } else {
            mTotalwaterGlasses_=mTotalwaterGlasses_-1;
            mWaterConsumed_=mWaterConsumed_-1;
        }
        // The below Request is used to delete the water glass
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            NSString *mRequestStr=[NSString stringWithFormat:@"%@%@/%@/%@?Glass=%@",WEBSERVICEURL, TrackersTXT, WaterTxt, mCurrentDate_,[NSString stringWithFormat:@"%d", mWaterConsumed_]];
            //[mAppDelegate createLoadView];
            [NSThread detachNewThreadSelector:@selector(AddWaterClick:) toTarget:self withObject: mRequestStr];
            
            [self dispalyTheWaterGlasses];
        }else {
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
            return;
        }
        
        
    }else {
        // presently no need of the below line
        // [waterGlass setSelected:YES];
        if(mCurrentGlass_<kMaxWaterGlass) {
            
            if(waterGlass.tag<=8){
                mCurrentGlass_++;
                mWaterConsumed_=mCurrentGlass_;
            } else {
                mWaterConsumed_=mTotalwaterGlasses_;
                mTotalwaterGlasses_=mTotalwaterGlasses_+1;
            }
            // The below Request is used to add the water glass
            if ([[NetworkMonitor instance] isNetworkAvailable]) {
                
                NSString *mRequestStr=[NSString stringWithFormat:@"%@%@/%@/%@?Glass=%@",WEBSERVICEURL, TrackersTXT, WaterTxt, mCurrentDate_,[NSString stringWithFormat:@"%d", mWaterConsumed_]];
                //[mAppDelegate createLoadView];
                [NSThread detachNewThreadSelector:@selector(AddWaterClick:) toTarget:self withObject: mRequestStr];
                
                [self dispalyTheWaterGlasses];
            }else {
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
                return;
            }
        } else {
            [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"You have reached max count of Water"];
            
        }
    }
    
}
#pragma Mark ************* Methods *************

- (void)dispalyTheWaterGlasses {
    
    if(mWaterConsumed_>=8){
        mTotalwaterGlasses_=mWaterConsumed_+1;
    }else {
        mTotalwaterGlasses_=8;
    }
    
    for (UIView *lview in self.mWaterGlassesScrollVie_.subviews) {
        [lview removeFromSuperview];
    }
    int xPos=6;
    int yPos=10;
    
    for(int i=0;i<mTotalwaterGlasses_;i++){
        if((i%4)==0&&i!=0){
            xPos=6;
            xPos++;
            yPos+=100;
        }
        xPos=((i%4)*42)+((i%4)*35)+6;// width + space between two glasses
        
        // adding check box  with label commment
        UIImage *reportedImg = [UIImage imageNamed:@"img_glass-fill.png"];
        UIImage *unReportedImg=[UIImage imageNamed:@"img_glass-add.png"];
        UIButton *waterGlassButton=[[UIButton alloc]init];
        [waterGlassButton setFrame:CGRectMake(xPos,yPos,42,50)];
        [waterGlassButton setBackgroundImage:unReportedImg forState:UIControlStateNormal];
        [waterGlassButton setBackgroundImage:reportedImg forState:UIControlStateSelected];
        [waterGlassButton addTarget:self action:@selector(waterGlassButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [waterGlassButton setTag:i+1];
        if(i<mWaterConsumed_){
            [waterGlassButton setSelected:YES];
            mCurrentGlass_=i+1;
        }else{
            [waterGlassButton setSelected:NO];
            [waterGlassButton setFrame:CGRectMake(xPos,yPos,50,50)];
        }
        [self.mWaterGlassesScrollVie_ addSubview:waterGlassButton];
        if(i==(mTotalwaterGlasses_-1)){// Set the content size and the automatically scroll to the last Water Glass
            [self.mWaterGlassesScrollVie_ setContentSize:CGSizeMake(290,yPos+100)];
            CGRect lFrame=[self.mWaterGlassesScrollVie_ convertRect:waterGlassButton.bounds fromView:waterGlassButton];
            lFrame.origin.y=lFrame.origin.y+10;
            [self.mWaterGlassesScrollVie_ scrollRectToVisible:lFrame animated:YES];
        }
    }
    
}

// *********** Send the request by using multithreading ************** //

-(void) AddWaterClick: (NSObject *) myObject {
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:(NSString *)myObject]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:mAppDelegate_.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [request setValue:mAppDelegate_.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];

    NSData *response = [NSURLConnection
                        sendSynchronousRequest:request
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    NSMutableArray *ltmep= [json_string JSONValue];
    if (mShowLogs) {
        NSLog(@"%@",ltmep);
    }
     [self.mLogWaterDataList_ removeAllObjects];
     self.mLogWaterDataList_=[json_string JSONValue];
    [self performSelectorOnMainThread:@selector(removeLoadView) withObject:nil waitUntilDone:NO];
    
}
-(void) getRefreshLogWaterData: (NSObject *) myObject {
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:(NSString *)myObject]
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
    NSMutableDictionary *mDict= [json_string JSONValue];
    mWaterConsumed_ = [[mDict objectForKey:@"Glass"] intValue];

    mTotalwaterGlasses_=8;
    mCurrentGlass_=0;
    [self dispalyTheWaterGlasses];
    
    [self performSelectorOnMainThread:@selector(removeLoadView) withObject:nil waitUntilDone:NO];
    
}

- (void)removeLoadView {
    
    [mAppDelegate_ removeLoadView];
}
// ********** Search wheater the particular date in the previous list or not ***********

- (BOOL) searchPreviousList:(NSDate *)searchDate {
    
    DLog(@"%@",self.mLogWaterDataList_);
	for (int i=0; i<[self.mLogWaterDataList_ count]; i++)
	{
        NSDate *lDate=nil;
        NSString *lDateStr=nil;
        NSString *lSearchDateStr=nil;
        [mFormatter_ setDateFormat:DateFormatServer];
        lDateStr=[[self.mLogWaterDataList_  objectAtIndex:i] objectForKey:@"Date"];
        
        if(lDateStr!=nil){
            lDate=[mFormatter_ dateFromString:lDateStr];
            [mFormatter_ setDateFormat:DateFormatForRequest];
            lDateStr=[mFormatter_ stringFromDate:lDate];
            lSearchDateStr=[mFormatter_ stringFromDate:searchDate];
            if([lDateStr isEqualToString:lSearchDateStr]){
                mCurrentDay=i;
                return YES;
            }
        }
    }
    return NO;
}

- (void)displayDateFortheHeader {
    
    NSDate *lDate=nil ;
    NSString *lDateStr=nil;
    [mFormatter_ setDateFormat:DateFormatServer];
    lDateStr=[[self.mLogWaterDataList_  objectAtIndex:mCurrentDay] objectForKey:@"Date"];
    
    if(lDateStr!=nil){
        lDate=[mFormatter_ dateFromString:lDateStr];
        self.mDisplayedDate_=lDate;
    }
    [mFormatter_ setDateFormat:DateFormatApp];
    if(lDate!=nil){
        if([lDateStr isEqualToString:[mFormatter_ stringFromDate:[NSDate date]]]){
            lDateStr=KToday;
        } else{
            lDateStr=[mFormatter_ stringFromDate:lDate];
        }
    }
    [mFormatter_ setDateFormat:DateFormatForRequest];
    if(lDate!=nil){
        self.mCurrentDate_=[mFormatter_ stringFromDate:lDate];
    }
    
    self.mTitleLbl_.text=lDateStr;
    
}


///************ Logic for the Add new water log in which it calls the search **********

- (void)addNewWaterLog {
    
    NSDate *lDate=nil;
    NSString *lDateStr=nil;
    
    if([self searchPreviousList:[NSDate date]]){
        
        [mFormatter_ setDateFormat:DateFormatServer];
        lDateStr=[[self.mLogWaterDataList_  objectAtIndex:mCurrentDay] objectForKey:@"Date"];
        if(lDateStr!=nil){
            lDate=[mFormatter_ dateFromString:lDateStr];
        }
        [mFormatter_ setDateFormat:DateFormatApp];
        mWaterConsumed_=[[[self.mLogWaterDataList_  objectAtIndex:mCurrentDay] objectForKey:@"Glass"] intValue];
        self.mDisplayedDate_=lDate;
        lDateStr=[mFormatter_ stringFromDate:lDate];
        if([lDateStr isEqualToString:[mFormatter_ stringFromDate:[NSDate date]]]){
            lDateStr=KToday;
            
        }
    }else{
        
        mWaterConsumed_=0;
        lDate= [NSDate date];
        self.mDisplayedDate_=lDate;
        [mFormatter_ setDateFormat:DateFormatApp];
        lDateStr=[mFormatter_ stringFromDate:lDate];
        if([lDateStr isEqualToString:[mFormatter_ stringFromDate:[NSDate date]]]){
            lDateStr=KToday;
        }
        
    }
    
    [mFormatter_ setDateFormat:DateFormatForRequest];
    if(lDate!=nil){
        self.mCurrentDate_=[mFormatter_ stringFromDate:lDate];
    }
    
    self.mTitleLbl_.text=lDateStr;
    mTotalwaterGlasses_=8;
    mCurrentGlass_=0;
    
    /* if(mCurrentDay==0){ // Logic to disable the prev button limit present not provided
     UIButton *prevBtn=(UIButton *)sender;
     [prevBtn setEnabled:NO];
     }*/
    
}
#pragma Mark *********** Button Actions ***********

// ************ Previous day button Action **********

- (IBAction)prevDayBtnAction:(id)sender {
    
    if ([mShowLogs isEqualToString:@"TRUE"])
        NSLog(@"%d",mCurrentDay);
    NSDate *lDate=nil;
    NSString *lDateStr=nil;
    
    if([self searchPreviousList:[NSDate dateWithTimeInterval:-SecondsInAWeek sinceDate:self.mDisplayedDate_]]){
        
        [mFormatter_ setDateFormat:DateFormatServer];
        lDateStr=[[self.mLogWaterDataList_ objectAtIndex:mCurrentDay] objectForKey:@"Date"];
        if(lDateStr!=nil){
            lDate=[mFormatter_ dateFromString:lDateStr];
        }
        [mFormatter_ setDateFormat:DateFormatApp];
        
        mWaterConsumed_=[[[self.mLogWaterDataList_ objectAtIndex:mCurrentDay] objectForKey:@"Glass"] intValue];
        self.mDisplayedDate_=lDate;
        lDateStr=[mFormatter_ stringFromDate:lDate];
        if([lDateStr isEqualToString:[mFormatter_ stringFromDate:[NSDate date]]]){
            lDateStr=KToday;
        }
        [mFormatter_ setDateFormat:DateFormatForRequest];
        if(lDate!=nil){
            self.mCurrentDate_=[mFormatter_ stringFromDate:lDate];
        }
        
        self.mTitleLbl_.text=lDateStr;
        mTotalwaterGlasses_=8;
        mCurrentGlass_=0;
        [self dispalyTheWaterGlasses];
        
    }else{
        
        mWaterConsumed_=0;
        lDate= [NSDate dateWithTimeInterval:-SecondsInAWeek sinceDate:self.mDisplayedDate_];
        self.mDisplayedDate_=lDate;
        [mFormatter_ setDateFormat:DateFormatApp];
        lDateStr=[mFormatter_ stringFromDate:lDate];
        if([lDateStr isEqualToString:[mFormatter_ stringFromDate:[NSDate date]]]){
            lDateStr=KToday;
        }
        [mFormatter_ setDateFormat:DateFormatForRequest];
        if(lDate!=nil){
            self.mCurrentDate_=[mFormatter_ stringFromDate:lDate];
        }
        
        self.mTitleLbl_.text=lDateStr;
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            
            [mAppDelegate_ createLoadView];
            NSString *mRequestStr=[NSString stringWithFormat:@"%@%@/%@/%@",WEBSERVICEURL,TrackersTXT, WaterTxt, mCurrentDate_];
            [NSThread detachNewThreadSelector:@selector(getRefreshLogWaterData:) toTarget:self withObject: mRequestStr];
        }else {
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
            return;
        }

        
    }
    

    
    /* if(mCurrentDay==0){ // Logic to disable the prev button limit present not provided
     UIButton *prevBtn=(UIButton *)sender;
     [prevBtn setEnabled:NO];
     }*/
    
    
}

// ************ Next day button Action **********

- (IBAction)nextDayBtnAction:(id)sender {
    
    NSDate *lDate=nil;
    NSString *lDateStr=nil;
    
    if([self searchPreviousList:[NSDate dateWithTimeInterval:SecondsInAWeek sinceDate:self.mDisplayedDate_]]){
        
        [mFormatter_ setDateFormat:DateFormatServer];
        lDateStr=[[self.mLogWaterDataList_ objectAtIndex:mCurrentDay] objectForKey:@"Date"];
        if(lDateStr!=nil){
            lDate=[mFormatter_ dateFromString:lDateStr];
        }
        [mFormatter_ setDateFormat:DateFormatApp];
        
        mWaterConsumed_=[[[self.mLogWaterDataList_ objectAtIndex:mCurrentDay] objectForKey:@"Glass"] intValue];
        self.mDisplayedDate_=lDate;
        lDateStr=[mFormatter_ stringFromDate:lDate];
        if([lDateStr isEqualToString:[mFormatter_ stringFromDate:[NSDate date]]]){
            lDateStr=KToday;
        }
        [mFormatter_ setDateFormat:DateFormatForRequest];
        if(lDate!=nil){
            self.mCurrentDate_=[mFormatter_ stringFromDate:lDate];
        }
        
        self.mTitleLbl_.text=lDateStr;
        mTotalwaterGlasses_=8;
        mCurrentGlass_=0;
        
        [self dispalyTheWaterGlasses];

    }else{
        
        mWaterConsumed_=0;
        lDate= [NSDate dateWithTimeInterval:SecondsInAWeek sinceDate:self.mDisplayedDate_];
        self.mDisplayedDate_=lDate;
        [mFormatter_ setDateFormat:DateFormatApp];
        lDateStr=[mFormatter_ stringFromDate:lDate];
        if([lDateStr isEqualToString:[mFormatter_ stringFromDate:[NSDate date]]]){
            lDateStr=KToday;
        }
        [mFormatter_ setDateFormat:DateFormatForRequest];
        if(lDate!=nil){
            self.mCurrentDate_=[mFormatter_ stringFromDate:lDate];
        }
        
        self.mTitleLbl_.text=lDateStr;
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            
            [mAppDelegate_ createLoadView];
            NSString *mRequestStr=[NSString stringWithFormat:@"%@%@/%@/%@",WEBSERVICEURL,TrackersTXT, WaterTxt, mCurrentDate_];
            [NSThread detachNewThreadSelector:@selector(getRefreshLogWaterData:) toTarget:self withObject: mRequestStr];
        }else {
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
            return;
        }

        
    }
    
        
    /* if(mCurrentDay==0){ // Logic to disable the prev button limit present not provided
     UIButton *prevBtn=(UIButton *)sender;
     [prevBtn setEnabled:NO];
     }*/
    
    
}



- (void)viewDidUnload
{
    [self setMWaterGlassesScrollVie_:nil];
    [self setMTitleLbl_:nil];
    [self setMPrevBtn_:nil];
    [self setMNextBtn_:nil];
    [self setMFormatter_:nil];
    [self setMLogWaterDataList_:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
