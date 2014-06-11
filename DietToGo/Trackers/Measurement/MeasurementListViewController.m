//
//  MeasurementListViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 06/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "MeasurementListViewController.h"
#import "AddEditMeasurementViewController.h"
@interface MeasurementListViewController ()

@end

@implementation MeasurementListViewController
@synthesize mRange;

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
    // for setting the view below 20px in iOS7.0.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    //for swipe functionality
    //swipe
    UISwipeGestureRecognizer *sgrLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedLeft:)];
    [sgrLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.mTableView addGestureRecognizer:sgrLeft];
    
    [mAppDelegate_ hideEmptySeparators:self.self.mTableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    self.mLogLbl.font = OpenSans_Regular(22);
    self.mLogLbl.textColor = DTG_MAROON_COLOR;
    self.mLastLogLbl.font = Bariol_Regular(17);
    self.mLastLogLbl.textColor = RGB_A(102, 102, 102, 1);
    self.mMsgLbl.font = Bariol_Regular(17);
    self.mMsgLbl.textColor = [UIColor darkGrayColor];
    self.mRange = @"Week";
    self.mWeightlbl.font = Bariol_Regular(40);
    self.mWeightlbl.textColor = RGB_A(51, 51, 51, 1);
    self.mLbsLbl.font = Bariol_Regular(18);
    self.mLbsLbl.textColor = RGB_A(51, 51, 51, 1);
    self.mTypeLbl.font = Bariol_Regular(17);
    self.mTypeLbl.text = @"Arms";
    self.mWeekBtn.selected = TRUE;
    
    self.mTopGrayImgView.backgroundColor = RGB_A(241, 241, 241, 1);

    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollview.frame = CGRectMake(self.mScrollview.frame.origin.x, self.mScrollview.frame.origin.y, 320, 504);
    }
    //Check for FiiBit State - No fitBit View for Measurement tracker.
   // BOOL isShow = [mAppDelegate_ isShowFitBitBanner];
    fitBitYpos = 0;
   // if (isShow) {
   //     fitBitYpos = 100;
   // }
    int userType = [[[NSUserDefaults standardUserDefaults] objectForKey:USERTYPE] intValue];
    if ( userType == 1) {
        fitBitYpos = 100;
    }
    [self addFitBitBanner];
    //to check whether has any exercise logs or not if yes display a message
    if (mAppDelegate_.mTrackerDataGetter_.mMeasurementList_.count == 0) {
        
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:MEASUREMENTCAMERALAYER];
        if (!isCameraLayer) {
            BOOL isTop = [loginUserDefaults boolForKey:MEASUREMENTTOPCAMERALAYER];
            if (!isTop) {
                [self showCameraGuideTop];
            }
        }
        
        self.mTopView.hidden = TRUE;
        self.mTableView.hidden = TRUE;
        self.mMsgLbl.hidden = FALSE;
        self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, 25+fitBitYpos, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
        self.mLineImgView.frame = CGRectMake(self.mLineImgView.frame.origin.x, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, self.mLineImgView.frame.size.width, self.mLineImgView.frame.size.height);
        self.mMsgLbl.frame = CGRectMake(self.mMsgLbl.frame.origin.x, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height+10, self.mMsgLbl.frame.size.width, self.mMsgLbl.frame.size.height);
        self.mScrollview.contentSize = CGSizeMake(320, self.mMsgLbl.frame.origin.y+self.mMsgLbl.frame.size.height+20);
    }else{
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:MEASUREMENTCAMERALAYER];//FALSE;//
        if (!isCameraLayer) {
            [self showCameraGuide];
        }
        [self AdjustControlBasedOnFitBit];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Measurement Tracker";
        [mAppDelegate_ trackFlurryLogEvent:@"Measurement Tracker"];
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"MEASUREMENT_TRACKER", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];//need to change to cancel button
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"addicon.png"] title:nil target:self action:@selector(addLogAction:) forController:self rightOrLeft:1];
    
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollview.frame = CGRectMake(self.mScrollview.frame.origin.x, self.mScrollview.frame.origin.y, 320, 504);
    }
    
}

- (void)loadGraphData
{
    self.mWeightlbl.text = [NSString stringWithFormat:@"%.1f", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:0] objectForKey:self.mTypeLbl.text] floatValue]];
    CGSize size =  [self.mWeightlbl.text sizeWithFont:self.mWeightlbl.font constrainedToSize:CGSizeMake(self.mWeightlbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mWeightlbl.frame = CGRectMake(self.mWeightlbl.frame.origin.x, self.mWeightlbl.frame.origin.y, size.width, self.mWeightlbl.frame.size.height);
    self.mLbsLbl.frame = CGRectMake(self.mWeightlbl.frame.origin.x+size.width+3, self.mLbsLbl.frame.origin.y, self.mLbsLbl.frame.size.width, self.mLbsLbl.frame.size.height);

    //to check whether the goal is set up by the user or not
    NSMutableArray *datesArray = [[NSMutableArray alloc]init];
    NSString *goalValue;
    /*
    if ([mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ isKindOfClass:[NSDictionary class]]) {
        //to add previous day date
        if ([[mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ objectForKey:@"ChartData"] count]>0 && [[mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ objectForKey:@"ChartData"] count] == 1) {
            NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
            [GenricUI setLocaleZoneForDateFormatter:lFormatter];
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *lDate = [lFormatter dateFromString:[[[mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ objectForKey:@"ChartData"] objectAtIndex:0] objectForKey:@"StartDate"]];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                           toDate:lDate
                                                          options:0];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setValue:[lFormatter stringFromDate:yesterday] forKey:@"StartDate"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Arms"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Chest"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Waist"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Hips"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Thighs"];
            [datesArray addObject:mDict];
        }
        //end

        //has goal
        [datesArray addObjectsFromArray:[mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ objectForKey:@"ChartData"]];
        goalValue = [NSString stringWithFormat:@"%d", [[mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ objectForKey:@"Goal"] intValue]];
    }else{ */
        
        //to add previous day date
        if ([mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ count]>0 && [mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ count] == 1) {
            NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
            [GenricUI setLocaleZoneForDateFormatter:lFormatter];
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_ objectAtIndex:0] objectForKey:@"StartDate"]];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                           toDate:lDate
                                                          options:0];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setValue:[lFormatter stringFromDate:yesterday] forKey:@"StartDate"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Arms"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Chest"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Waist"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Hips"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Thighs"];
            [datesArray addObject:mDict];
        }
        //end

        //no goal
        [datesArray addObjectsFromArray:mAppDelegate_.mTrackerDataGetter_.mMeasurementChartDict_];
        goalValue = nil;
        
   // }
    if (datesArray.count >20) {
        NSMutableArray *mTemparray = [NSMutableArray arrayWithArray:datesArray];
        [datesArray removeAllObjects];
        datesArray = [mAppDelegate_.mTrackerDataGetter_ returnOnly20RecordsForGraph:mTemparray];
    }
    //Used to load the xaxis
    NSMutableArray *xArray = [[NSMutableArray alloc]init];
    for (int i= 0; i < [datesArray count]; i++) {
        NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
        [GenricUI setLocaleZoneForDateFormatter:lFormatter];
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *lDate = [lFormatter dateFromString:[[datesArray objectAtIndex:i] objectForKey:@"StartDate"]];
        if ([self.mRange isEqualToString:@"Week"]) {
            [lFormatter setDateFormat:@"EEE"];
            NSString *lStr = [lFormatter stringFromDate:lDate];
            [xArray addObject:lStr];
        }else
        {
            [lFormatter setDateFormat:@"MM/dd/yy"];
            NSString *lStr = [lFormatter stringFromDate:lDate];
            [xArray addObject:lStr];
        }
    }
    int yValue = 0;
    
    if ([datesArray count]!=0) {
        //to get the highest yaxis value
        yValue = [[[datesArray objectAtIndex:0] objectForKey:self.mTypeLbl.text] intValue];
        for (int iCount = 1; iCount < [datesArray count]; iCount++) {
            int value = [[[datesArray objectAtIndex:iCount] objectForKey:self.mTypeLbl.text] intValue];
            if (value>yValue) {
                yValue = value;
            }
        }
        
    }
    // to check whether the goal weight is greater than y value
    if ( goalValue != nil && [goalValue intValue] > yValue) {
        yValue = [goalValue intValue];
    }
    yValue +=10; //as suggested by client we are adding 10 points to y value so that the highest log is shown correctly

    //As four regions are fixed for yaxis divide the yvalue in four equal intevals
    int remainder = yValue%4;
    if (remainder == 0) {
        yValue+=remainder;
        
    }else{
        int Quotient = yValue/4;
        Quotient++;
        yValue = Quotient*4;
        
    }
    
    int ActualValue = yValue/4;
    NSMutableArray *yArray = [[NSMutableArray alloc]init];
    int addYObj;
    addYObj = ActualValue;
    
    for (int i =0; i<4; i++) {
        [yArray addObject:[NSString stringWithFormat:@"%d", addYObj]];
        addYObj+=ActualValue;
    }
    NSLog(@"yarray is%@",yArray);
    
    //to frame the points on the graph
    NSMutableArray *data = [NSMutableArray array];
    for (int i =0 ; i <[datesArray count]; i++) {
        NSValue *graphPoint = [NSValue valueWithCGPoint:CGPointMake(i, [[[datesArray objectAtIndex:i] objectForKey:self.mTypeLbl.text] intValue])];
        [data addObject:graphPoint];
    }
    
   
    // send request for drawing graph
    
    mLoadgraph = [[LoadGraph alloc] initWithHostingView:_graphHostingView andData:data xAxis:xArray yAxis:yArray];
    
    if (goalValue != nil) {
        // for goal weight
        NSMutableArray *goalData = [NSMutableArray array];
        
        NSValue *graphPoint = [NSValue valueWithCGPoint:CGPointMake([xArray count], [goalValue intValue])];
        [goalData addObject:graphPoint];
        
        [mLoadgraph goalData:goalData];
    }
    mLoadgraph.mParentClass = self;

    
    [mLoadgraph initialisePlot];
    
}

#pragma mark TABLE VIEW DELEGATE METHODS


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =0.0;
    height+= 160;
    UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 30)];
    lLabel.textColor = RGB_A(114, 105, 89, 1);
    lLabel.font = [UIFont italicSystemFontOfSize:14];
    lLabel.numberOfLines =0;
    lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    lLabel.text = [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:indexPath.row] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    CGSize size = [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (lLabel.text.length > 0)
    {
        if (size.height<20) {
            size.height = 20;
        }
        height+=5+size.height;
    }
    height+=15;//to last gap
    return height;

}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mAppDelegate_.mTrackerDataGetter_.mMeasurementList_.count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.clearsContextBeforeDrawing=TRUE;
        
        //date Label
        UILabel *lDateLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 150, 20)];
        [lDateLbl setBackgroundColor:[UIColor clearColor]];
        [lDateLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lDateLbl setFont:Bariol_Regular(17)];
        lDateLbl.tag =1;
        [lDateLbl setTextColor:[UIColor blackColor]];
        [cell.contentView addSubview:lDateLbl];
        
        
        //upper arms text label
        UILabel *lUpperLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 40, 100, 20)];
        [lUpperLbl setBackgroundColor:[UIColor clearColor]];
        lUpperLbl.text = @"Upper arms";
        [lUpperLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lUpperLbl setFont:Bariol_Regular(17)];
        lUpperLbl.tag =2;
        [lUpperLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lUpperLbl];
        CGSize size = [lUpperLbl.text sizeWithFont:lUpperLbl.font constrainedToSize:CGSizeMake(lUpperLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lUpperLbl.frame = CGRectMake(15, lUpperLbl.frame.origin.y, size.width, lUpperLbl.frame.size.height);

        //text label
        UILabel *lUpperArmsTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(lUpperLbl.frame.origin.x+lUpperLbl.frame.size.width+3, 40, 200, 20)];
        [lUpperArmsTextLbl setBackgroundColor:[UIColor clearColor]];
        lUpperArmsTextLbl.text = @"measured at";
        [lUpperArmsTextLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lUpperArmsTextLbl setFont:Bariol_Regular(17)];
        lUpperArmsTextLbl.tag =3;
        [lUpperArmsTextLbl setTextColor:RGB_A(136, 136, 136, 1)];
        size =  [lUpperArmsTextLbl.text sizeWithFont:lUpperArmsTextLbl.font constrainedToSize:CGSizeMake(lUpperArmsTextLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lUpperArmsTextLbl.frame = CGRectMake(lUpperLbl.frame.origin.x+lUpperLbl.frame.size.width+3, lUpperArmsTextLbl.frame.origin.y, size.width, lUpperArmsTextLbl.frame.size.height);
        [cell.contentView addSubview:lUpperArmsTextLbl];
        
        //upper arms value label
        UILabel *lUpperArmsLbl=[[UILabel alloc]initWithFrame:CGRectMake(lUpperArmsTextLbl.frame.size.width+lUpperArmsTextLbl.frame.origin.x+3, 40, 100, 20)];
        [lUpperArmsLbl setBackgroundColor:[UIColor clearColor]];
        [lUpperArmsLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lUpperArmsLbl setFont:Bariol_Bold(17)];
        lUpperArmsLbl.tag =4;
        [lUpperArmsLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lUpperArmsLbl];

        //Chest arms text label
        UILabel *lChesLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 65, 200, 20)];
        [lChesLbl setBackgroundColor:[UIColor clearColor]];
        lChesLbl.text = @"Chest";
        [lChesLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lChesLbl setFont:Bariol_Regular(17)];
        lChesLbl.tag =5;
        [lChesLbl setTextColor:BLACK_COLOR];
        size =  [lChesLbl.text sizeWithFont:lChesLbl.font constrainedToSize:CGSizeMake(lChesLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lChesLbl.frame = CGRectMake(15, 65, size.width, 20);
        [cell.contentView addSubview:lChesLbl];

        //text label
        UILabel *lChestTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(lChesLbl.frame.origin.x+lChesLbl.frame.size.width+3, 65, 200, 20)];
        [lChestTextLbl setBackgroundColor:[UIColor clearColor]];
        lChestTextLbl.text = @"measured at";
        [lChestTextLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lChestTextLbl setFont:Bariol_Regular(17)];
        lChestTextLbl.tag =6;
        [lChestTextLbl setTextColor:RGB_A(136, 136, 136, 1)];
        size =  [lChestTextLbl.text sizeWithFont:lChestTextLbl.font constrainedToSize:CGSizeMake(lChestTextLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lChestTextLbl.frame = CGRectMake(lChesLbl.frame.origin.x+lChesLbl.frame.size.width+3, 65, size.width, 20);
        [cell.contentView addSubview:lChestTextLbl];
        
        //chest value label
        UILabel *lChestLbl=[[UILabel alloc]initWithFrame:CGRectMake(lChestTextLbl.frame.size.width+lChestTextLbl.frame.origin.x+3, 65, 100, 20)];
        [lChestLbl setBackgroundColor:[UIColor clearColor]];
        [lChestLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lChestLbl setFont:Bariol_Bold(17)];
        lChestLbl.tag =7;
        [lChestLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lChestLbl];
        
        //waist text label
        UILabel *lWaisLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 90, 200, 20)];
        [lWaisLbl setBackgroundColor:[UIColor clearColor]];
        lWaisLbl.text = @"Waist";
        [lWaisLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lWaisLbl setFont:Bariol_Regular(17)];
        lWaisLbl.tag =8;
        [lWaisLbl setTextColor:BLACK_COLOR];
        size =  [lWaisLbl.text sizeWithFont:lWaisLbl.font constrainedToSize:CGSizeMake(lWaisLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lWaisLbl.frame = CGRectMake(15, 90, size.width, 20);
        [cell.contentView addSubview:lWaisLbl];

        //text label
        UILabel *lWaistTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(lWaisLbl.frame.size.width+lWaisLbl.frame.origin.x+3, 90, 200, 20)];
        [lWaistTextLbl setBackgroundColor:[UIColor clearColor]];
        lWaistTextLbl.text = @"measured at";
        [lWaistTextLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lWaistTextLbl setFont:Bariol_Regular(17)];
        lWaistTextLbl.tag =9;
        [lWaistTextLbl setTextColor:RGB_A(136, 136, 136, 1)];
        size =  [lWaistTextLbl.text sizeWithFont:lWaistTextLbl.font constrainedToSize:CGSizeMake(lWaistTextLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lWaistTextLbl.frame = CGRectMake(lWaisLbl.frame.size.width+lWaisLbl.frame.origin.x+3, 90, size.width, 20);
        [cell.contentView addSubview:lWaistTextLbl];
        
        //waist value label
        UILabel *lWaistLbl=[[UILabel alloc]initWithFrame:CGRectMake(lWaistTextLbl.frame.size.width+lWaistTextLbl.frame.origin.x+3, 90, 110, 20)];
        [lWaistLbl setBackgroundColor:[UIColor clearColor]];
        [lWaistLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lWaistLbl setFont:Bariol_Bold(17)];
        lWaistLbl.tag =10;
        [lWaistLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lWaistLbl];
        
        //Hips text label
        UILabel *lHipTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 115, 200, 20)];
        [lHipTextLbl setBackgroundColor:[UIColor clearColor]];
        lHipTextLbl.text = @"Hips";
        [lHipTextLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lHipTextLbl setFont:Bariol_Regular(17)];
        lHipTextLbl.tag =11;
        [lHipTextLbl setTextColor:BLACK_COLOR];
        size =  [lHipTextLbl.text sizeWithFont:lHipTextLbl.font constrainedToSize:CGSizeMake(lHipTextLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lHipTextLbl.frame = CGRectMake(15, 115, size.width, 20);
        [cell.contentView addSubview:lHipTextLbl];

        //text label
        UILabel *lHipsTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 115, 200, 20)];
        [lHipsTextLbl setBackgroundColor:[UIColor clearColor]];
        lHipsTextLbl.text = @"measured at";
        [lHipsTextLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lHipsTextLbl setFont:Bariol_Regular(17)];
        lHipsTextLbl.tag =12;
        [lHipsTextLbl setTextColor:RGB_A(136, 136, 136, 1)];
        size =  [lHipsTextLbl.text sizeWithFont:lHipsTextLbl.font constrainedToSize:CGSizeMake(lHipsTextLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lHipsTextLbl.frame = CGRectMake(lHipTextLbl.frame.origin.x+lHipTextLbl.frame.size.width+3, 115, size.width, 20);
        [cell.contentView addSubview:lHipsTextLbl];
        
        //hips value label
        UILabel *lHipstLbl=[[UILabel alloc]initWithFrame:CGRectMake(lHipsTextLbl.frame.size.width+lHipsTextLbl.frame.origin.x+3, 115, 100, 20)];
        [lHipstLbl setBackgroundColor:[UIColor clearColor]];
        [lHipstLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lHipstLbl setFont:Bariol_Bold(17)];
        lHipstLbl.tag =13;
        [lHipstLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lHipstLbl];
        
        //Thighs text label
        UILabel *lThightLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 140, 200, 20)];
        [lThightLbl setBackgroundColor:[UIColor clearColor]];
        lThightLbl.text = @"Thighs";
        [lThightLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lThightLbl setFont:Bariol_Regular(17)];
        lThightLbl.tag =14;
        [lThightLbl setTextColor:BLACK_COLOR];
        size =  [lThightLbl.text sizeWithFont:lThightLbl.font constrainedToSize:CGSizeMake(lThightLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lThightLbl.frame = CGRectMake(15, 140, size.width, 20);
        [cell.contentView addSubview:lThightLbl];

        //text label
        UILabel *lThighsTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(lThightLbl.frame.origin.x+lThightLbl.frame.size.width+3, 140, 200, 20)];
        [lThighsTextLbl setBackgroundColor:[UIColor clearColor]];
        lThighsTextLbl.text = @"measured at";
        [lThighsTextLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lThighsTextLbl setFont:Bariol_Regular(17)];
        lThighsTextLbl.tag =15;
        [lThighsTextLbl setTextColor:RGB_A(136, 136, 136, 1)];
        size =  [lThighsTextLbl.text sizeWithFont:lThighsTextLbl.font constrainedToSize:CGSizeMake(lThighsTextLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lThighsTextLbl.frame = CGRectMake(lThightLbl.frame.origin.x+lThightLbl.frame.size.width+3, 140, size.width, 20);
        [cell.contentView addSubview:lThighsTextLbl];
        
        //Thighs value label
        UILabel *lThighstLbl=[[UILabel alloc]initWithFrame:CGRectMake(lThighsTextLbl.frame.size.width+lThighsTextLbl.frame.origin.x+3, 140, 100, 20)];
        [lThighstLbl setBackgroundColor:[UIColor clearColor]];
        [lThighstLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lThighstLbl setFont:Bariol_Bold(17)];
        lThighstLbl.tag =16;
        [lThighstLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lThighstLbl];
        
        //notes label
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 165, 290, 20)];
        lLabel.textColor = RGB_A(114, 105, 89, 1);
        lLabel.font = [UIFont italicSystemFontOfSize:14];
        lLabel.numberOfLines =0;
        lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lLabel.tag = 17;
        [cell.contentView addSubview:lLabel];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lDateLblIns= (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *lUpperArmnsLblIns= (UILabel*)[cell.contentView viewWithTag:4];
    UILabel *lChestLblIns= (UILabel*)[cell.contentView viewWithTag:7];
    UILabel *lWaistLblIns= (UILabel*)[cell.contentView viewWithTag:10];
    UILabel *lHipsLblIns= (UILabel*)[cell.contentView viewWithTag:13];
    UILabel *lthighsLblIns= (UILabel*)[cell.contentView viewWithTag:16];
    UILabel *lNotesLbl = (UILabel*)[cell.contentView viewWithTag:17];
    
    
    NSDateFormatter *lFormatter=[[NSDateFormatter alloc]init];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [lFormatter setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    lFormatter.locale = enLocale;
    NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:indexPath.row] objectForKey:@"StartDate"]];
    if (lDate == nil) {
         [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:indexPath.row] objectForKey:@"StartDate"]];
    }
    [lFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    lDateLblIns.text = [lFormatter stringFromDate:lDate];
   
    lUpperArmnsLblIns.text = [NSString stringWithFormat:@"%.1f in.", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:indexPath.row] objectForKey:@"Arms"] floatValue]];
    lChestLblIns.text = [NSString stringWithFormat:@"%.1f in.", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:indexPath.row] objectForKey:@"Chest"] floatValue]];
    lWaistLblIns.text = [NSString stringWithFormat:@"%.1f in.", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:indexPath.row] objectForKey:@"Waist"] floatValue]];
    lHipsLblIns.text = [NSString stringWithFormat:@"%.1f in.", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:indexPath.row] objectForKey:@"Hips"] floatValue]];
    lthighsLblIns.text = [NSString stringWithFormat:@"%.1f in.", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:indexPath.row] objectForKey:@"Thighs"] floatValue]];

    lNotesLbl.text = [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:indexPath.row] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    CGSize size = [lNotesLbl.text sizeWithFont:lNotesLbl.font constrainedToSize:CGSizeMake(lNotesLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (size.height < 20) {
        size.height = 20;
    }
    lNotesLbl.frame = CGRectMake(15, lNotesLbl.frame.origin.y, 290, size.height);
    if (lNotesLbl.text.length == 0) {
        lNotesLbl.hidden = TRUE;
    }else{
        lNotesLbl.hidden = FALSE;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.mTableView reloadData];

}
-(void)cellSwipedLeft:(UIGestureRecognizer *)gestureRecognizer {
    [self.mTableView reloadData];
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.mTableView];
        NSIndexPath *swipedIndexPath = [self.mTableView indexPathForRowAtPoint:swipeLocation];
        self.mSelectdIndex = swipedIndexPath;

        UITableViewCell* swipedCell = [self.mTableView cellForRowAtIndexPath:swipedIndexPath];
        //to move the row contents to left
        UITableViewCell *cell = (UITableViewCell *)swipedCell;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        
        for (int i =1; i<18; i++) {
            UILabel *lLbl = (UILabel*)[cell.contentView viewWithTag:i];
            CGRect frame = lLbl.frame;
            frame.origin.x -= 50;
            lLbl.frame = frame;
        }
        [UIView commitAnimations];
        
        //for view
        UIView* rightPatch = [[UIView alloc]init];
        rightPatch.frame = CGRectMake(320-50, 0, 50, cell.frame.size.height);
        [rightPatch setBackgroundColor:DTG_MAROON_COLOR];
        [cell addSubview:rightPatch];
        
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(0, 0, 50, cell.frame.size.height);
        [deleteBtn setTag:swipedIndexPath.row];
        [deleteBtn setImage:[UIImage imageNamed:@"crossicon.png"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightPatch addSubview:deleteBtn];
        
    }
}
- (void)reloadContentsOftableView
{
    //to check whether has any exercise logs or not if yes display a message
    if (mAppDelegate_.mTrackerDataGetter_.mMeasurementList_.count == 0) {
        self.mTopView.hidden = TRUE;
        self.mTableView.hidden = TRUE;
        self.mMsgLbl.hidden = FALSE;
        self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, 25+fitBitYpos, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
        self.mLineImgView.frame = CGRectMake(self.mLineImgView.frame.origin.x, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, self.mLineImgView.frame.size.width, self.mLineImgView.frame.size.height);
        self.mMsgLbl.frame = CGRectMake(self.mMsgLbl.frame.origin.x, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height+10, self.mMsgLbl.frame.size.width, self.mMsgLbl.frame.size.height);
        self.mScrollview.contentSize = CGSizeMake(320, self.mMsgLbl.frame.origin.y+self.mMsgLbl.frame.size.height+20);
    }else{
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:MEASUREMENTCAMERALAYER];
        if (!isCameraLayer) {
            BOOL isTop = [loginUserDefaults boolForKey:MEASUREMENTTOPCAMERALAYER];
            BOOL isBottom = [loginUserDefaults boolForKey:MEASUREMENTBOTTOMCAMERALAYER];
            if ( isTop && !isBottom) {
                [self showCameraGuideBottom];
            }
        }
        
        [self AdjustControlBasedOnFitBit];
    }
    
    
}
- (CGFloat)caluclateTableHeight{
    CGFloat height=0.0;
    for (int i =0; i < mAppDelegate_.mTrackerDataGetter_.mMeasurementList_.count; i++) {
        height+= 160;
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 30)];
        lLabel.textColor = RGB_A(114, 105, 89, 1);
        lLabel.font = [UIFont italicSystemFontOfSize:14];
        lLabel.numberOfLines =0;
        lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lLabel.text = [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:i] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        CGSize size = [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        if (lLabel.text.length > 0) {
            if (size.height < 20) {
                size.height = 20;
            }
            height+=5+size.height;
        }
        height+=15;//to last gap
    }
    return height;
}
-(void)deleteBtnAction:(UIButton*)deleteBtn {
    [GenricUI showAlertWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"DELETE_MEASUREMENT_LOG", nil) cancelButton:@"No" delegates:self button1Titles:@"Yes" button2Titles:nil tag:400];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 400) {
        if (buttonIndex == 1) {
            //to delete the log
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToDeleteMeasurementLog:[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:self.mSelectdIndex.row] objectForKey:@"LogID"]
                                                                   AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                                SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }

            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    
    [self setMLogLbl:nil];
    [self setMTableView:nil];
    [self setMScrollview:nil];
    [self setMLineImgView:nil];
    [self setMLastLogLbl:nil];
    [self setMTopView:nil];
    [self setMMsgLbl:nil];
    [self setMWeekBtn:nil];
    [self setMMonthBtn:nil];
    [self setM3MonthsBtn:nil];
    [self setMWeightimgView:nil];
    [self setMWeightlbl:nil];
    [self setMLbsLbl:nil];
    [super viewDidUnload];
}
- (void)menuAction:(id)sender {
    [mAppDelegate_ showLeftSideMenu:self];
}

- (void)addLogAction:(id)sender {
    AddEditMeasurementViewController *lVc = [[AddEditMeasurementViewController alloc]initWithNibName:@"AddEditMeasurementViewController" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:lVc];
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:nc animated:YES completion:nil];
    } else {
        [self presentModalViewController:nc animated:YES];
        
    }

        
}
- (IBAction)MonthsAction:(UIButton *)sender {
    self.mMonthBtn.selected = FALSE;
    self.mWeekBtn.selected = FALSE;
    self.m3MonthsBtn.selected = TRUE;
    self.mRange = @"Quarter";
    [self postRequestForMeasurementGraph];
    
}

- (IBAction)monthAction:(id)sender {
    self.mMonthBtn.selected = TRUE;
    self.mWeekBtn.selected = FALSE;
    self.m3MonthsBtn.selected = FALSE;
    self.mRange = @"Month";
    [self postRequestForMeasurementGraph];
    
    
}

- (IBAction)weekAction:(id)sender {
    self.mMonthBtn.selected = FALSE;
    self.mWeekBtn.selected = TRUE;
    self.m3MonthsBtn.selected = FALSE;
    self.mRange = @"Week";
    [self postRequestForMeasurementGraph];
    
    
}
- (void)postRequestForMeasurementGraph{
    //to get the weight log chart data
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestToGetMeasurementChartData:self.mRange
                                                              AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                           SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
}

- (IBAction)typeAction:(id)sender {
    [self displayPickerview];

}
- (void)displayPickerview {
    
    PickerViewController *screen = [[PickerViewController alloc] init];
    NSMutableArray *rowValuesArr_=[[NSMutableArray alloc] init];
    NSMutableArray *lValues = [[NSMutableArray alloc]initWithObjects:@"Arms",@"Chest",@"Waist", @"Hips", @"Thighs", nil];
    [rowValuesArr_ addObject:lValues];
    screen.mRowValueintheComponent=rowValuesArr_;
    screen->mNoofComponents=[rowValuesArr_ count];
    screen.mTextDisplayedlb.text=@"Select Measurement";
    //[screen addSubview:screen.mViewPicker_];
    // *********** ************* reloading the components to the value in the particular label *************** **************
    [screen.mViewPicker_ selectRow:0 inComponent:0 animated:YES];
    [screen.mViewPicker_ reloadComponent:0];
    
    if(![self.mTypeLbl.text isEqualToString:@""]){
        
        
        for (int i=0; i<[[rowValuesArr_ objectAtIndex:0] count]; i++) {
            if ([[[rowValuesArr_ objectAtIndex:0] objectAtIndex:i] isEqualToString:self.mTypeLbl.text]) {
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
        [self.mTypeLbl setText:mData_];
        if([controller superview]){
			[controller removeFromSuperview];
		}
        [self reloadContentsOftableView];
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
    NSMutableArray *lValues = [[NSMutableArray alloc]initWithObjects:@"Arms",@"Chest",@"Waist", @"Hips", @"Thighs", nil];
    if (component==0)
        return [lValues objectAtIndex:row];
    else
        return @"";
	
    
}
#pragma mark - FitBit Banner
-(void)addFitBitBanner {
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, fitBitYpos)];
    bannerView.backgroundColor = CLEAR_COLOR;
    
    UIScrollView *bannerScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, fitBitYpos)];
    bannerScroller.tag = FitBitBannerTag;
    bannerScroller.backgroundColor = CLEAR_COLOR;
    CGFloat ContentWidth = 0;
    [bannerView addSubview:bannerScroller];
    /* //No fitBit View for Measurement tracker.
    if (fitBitYpos == 100) {
        ContentWidth = 320;
        UIView *fitBit = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 90)];
        fitBit.backgroundColor = RGB_A(69, 194, 197, 1);
        fitBit.layer.cornerRadius = 5;
        [bannerScroller addSubview:fitBit];
        
        UIImageView *patternImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 25, 45, 47)];
        patternImg.image = [UIImage imageNamed:@"patternimage.png"];
        [fitBit addSubview:patternImg];
        
        UILabel *fitBitText = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 240, 75)];
        fitBitText.text = @"Sync your fitbit device to your\nDiet-to-Go account to automatically update your progress. Sync Now!";
        fitBitText.numberOfLines = 3;
        fitBitText.font =  OpenSans_Regular(13); // OpenSans_Light(14);
        fitBitText.textColor = WHITE_COLOR;
        fitBitText.backgroundColor = CLEAR_COLOR;
        [fitBit addSubview:fitBitText];
        
        UIButton *fitBitViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 90)];
        [fitBitViewBtn setBackgroundColor:CLEAR_COLOR];
        [fitBitViewBtn addTarget:self action:@selector(fitBitViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [fitBit addSubview:fitBitViewBtn];
    }*/
    int userType = [[[NSUserDefaults standardUserDefaults] objectForKey:USERTYPE] intValue];
    if ( userType == 1) {
        
        UIView *prospectView = [[UIView alloc] initWithFrame:CGRectMake(ContentWidth+10, 5, 300, 90)];
        [prospectView setBackgroundColor:RGB_A(227, 226, 227, 1)];
        prospectView.layer.cornerRadius = 5;
        [bannerScroller addSubview:prospectView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 270, 45)];
        title.text = @"Diet-to-Go is easy!";
        title.font =  OpenSans_Light(30);
        title.textColor = DTG_MAROON_COLOR;
        title.backgroundColor = CLEAR_COLOR;
        title.textAlignment = TEXT_ALIGN_CENTER;
        [prospectView addSubview:title];
        
        UILabel *lMealMenu = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 270, 25)];
        lMealMenu.textColor = RGB_A(100, 150, 41, 1); //649629
        lMealMenu.font = OpenSans_Regular(17);
        lMealMenu.text = @"Choose from 3 Delicious Menus";
        lMealMenu.backgroundColor = CLEAR_COLOR;
        lMealMenu.textAlignment = TEXT_ALIGN_CENTER;
        [prospectView addSubview:lMealMenu];
        
        UIButton *prospectViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 90)];
        [prospectViewBtn setBackgroundColor:CLEAR_COLOR];
        [prospectViewBtn addTarget:self action:@selector(prospectViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [prospectView addSubview:prospectViewBtn];
        /*
        if (fitBitYpos == 100) {
            //Add Page Control to Banner View
            pagging = [[CustomPageControl alloc] initWithFrame:CGRectMake(0, 75, 320, 20)];
            pagging.currentPage = 0;
            pagging.numberOfPages = 2;
            pagging.userInteractionEnabled = NO;
            [bannerView addSubview:pagging];
            ContentWidth +=320;
            bannerScroller.delegate = self;
        }*/
    }
    bannerScroller.pagingEnabled = YES;
    bannerScroller.showsHorizontalScrollIndicator = NO;
    bannerScroller.showsVerticalScrollIndicator = NO;
    [bannerScroller setContentSize:CGSizeMake(ContentWidth, 100)];
    [self.mScrollview addSubview:bannerView];
}
-(void)fitBitViewBtnAction:(UIButton*)btn {
   // NSLog(@"fitBitViewBtnAction");
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        [mAppDelegate_ trackFlurryLogEventForBanners:@"Fitbit Banner – Measurement Tracker"];
    }
    //end
    [mAppDelegate_ pushToFitBitViewController];
}
-(void)prospectViewBtnAction:(UIButton*)btn {
    //  NSLog(@"prospectViewBtnAction");
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        [mAppDelegate_ trackFlurryLogEventForBanners:@"Prospect Banner – Measurement Tracker"];
    }
    //end
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GETSTARTEDURL]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == FitBitBannerTag) {
        CGPoint l = scrollView.contentOffset;
        int x=(int)l.x;
        int k=x/320;
        pagging.currentPage = k;
    }
}
-(void)AdjustControlBasedOnFitBit {
    
    CGFloat yPos = 0;
    if ([self.mRange isEqualToString:@"Week"]) {
        yPos = 270;
    }else{
        yPos = 295;
    }
    self.mWeekBtn.frame = CGRectMake(self.mWeekBtn.frame.origin.x, yPos, self.mWeekBtn.frame.size.width, self.mWeekBtn.frame.size.height);
    self.mMonthBtn.frame = CGRectMake(self.mMonthBtn.frame.origin.x, yPos, self.mMonthBtn.frame.size.width, self.mMonthBtn.frame.size.height);
    self.m3MonthsBtn.frame = CGRectMake(self.m3MonthsBtn.frame.origin.x, yPos, self.m3MonthsBtn.frame.size.width, self.m3MonthsBtn.frame.size.height);
    self.mTopView.frame = CGRectMake(self.mTopView.frame.origin.x, fitBitYpos, self.mTopView.frame.size.width, yPos+30+5);
    
    
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:0] objectForKey:@"StartDate"]];
    if (lDate == nil) {
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:0] objectForKey:@"StartDate"]];
        
    }
    [lFormatter setDateFormat:@"MM/dd/yy"];
    NSString *lStr = [lFormatter stringFromDate:lDate];
    self.mLastLogLbl.text = [NSString stringWithFormat:@"Last logged on %@",lStr];
    self.mWeightlbl.text = [NSString stringWithFormat:@"%.1f", [[[mAppDelegate_.mTrackerDataGetter_.mMeasurementList_ objectAtIndex:0] objectForKey:self.mTypeLbl.text] floatValue]];
    CGSize size =  [self.mWeightlbl.text sizeWithFont:self.mWeightlbl.font constrainedToSize:CGSizeMake(150, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mWeightlbl.frame = CGRectMake(self.mWeightlbl.frame.origin.x, self.mWeightlbl.frame.origin.y, size.width, self.mWeightlbl.frame.size.height);
    self.mLbsLbl.frame = CGRectMake(self.mWeightlbl.frame.origin.x+size.width+3, self.mLbsLbl.frame.origin.y, self.mLbsLbl.frame.size.width, self.mLbsLbl.frame.size.height);
    
    
    self.mTopView.hidden = FALSE;
    self.mTableView.hidden = FALSE;
    self.mMsgLbl.hidden = TRUE;
    
    [self loadGraphData];
    self.mTopView.hidden = FALSE;
    self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, self.mTopView.frame.origin.y+self.mTopView.frame.size.height+35, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
    self.mLineImgView.frame = CGRectMake(0, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, 320, 1);
    self.mTableView.frame = CGRectMake(0, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height, 320, self.mTableView.frame.size.height);
    
    [self.mTableView reloadData];
    self.mTableView.contentOffset = CGPointMake(0, 0);
    self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height, 320, [self caluclateTableHeight]);
    self.mScrollview.contentSize = CGSizeMake(320, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+20);
}
#pragma mark - Camera Guide
-(void)showCameraGuide {
    [mAppDelegate_ addTransparentViewToWindow];
    //if there are food items show the share view
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TrackerCameraGuide" owner:self options:nil];
    mCameraGuide = [array objectAtIndex:0];
    mCameraGuide.topViewLbl.font = Bariol_Regular(18);
    mCameraGuide.bottomViewLbl.font = Bariol_Regular(18);
    [self adjustCameraBottomViewFrame];
    
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraGuideTapAction:)];
    [firstTap setNumberOfTapsRequired:1];
    [mCameraGuide addGestureRecognizer:firstTap];
    [mAppDelegate_.window addSubview:mCameraGuide];
}
-(void)showCameraGuideTop {
    [mAppDelegate_ addTransparentViewToWindow];
    //if there are food items show the share view
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TrackerCameraGuide" owner:self options:nil];
    mCameraGuide = [array objectAtIndex:0];
    mCameraGuide.topViewLbl.font = Bariol_Regular(18);
    mCameraGuide.bottomViewLbl.font = Bariol_Regular(18);
    mCameraGuide.bottomView.hidden = YES;
    [self adjustCameraBottomViewFrame];
    
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraGuideTapActionTop:)];
    [firstTap setNumberOfTapsRequired:1];
    [mCameraGuide addGestureRecognizer:firstTap];
    [mAppDelegate_.window addSubview:mCameraGuide];
}
-(void)showCameraGuideBottom {
    [mAppDelegate_ addTransparentViewToWindow];
    //if there are food items show the share view
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TrackerCameraGuide" owner:self options:nil];
    mCameraGuide = [array objectAtIndex:0];
    mCameraGuide.topViewLbl.font = Bariol_Regular(18);
    mCameraGuide.bottomViewLbl.font = Bariol_Regular(18);
    mCameraGuide.topView.hidden = YES;
    [self adjustCameraBottomViewFrame];
    
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraGuideTapActionBottom:)];
    [firstTap setNumberOfTapsRequired:1];
    [mCameraGuide addGestureRecognizer:firstTap];
    [mAppDelegate_.window addSubview:mCameraGuide];
}
-(void)adjustCameraBottomViewFrame {
    CGRect lFrame = mCameraGuide.bottomView.frame;
    lFrame.origin.y = lFrame.origin.y + fitBitYpos +5;
    mCameraGuide.bottomView.frame = lFrame;
}
-(void)cameraGuideTapAction:(UITapGestureRecognizer*)tap {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:MEASUREMENTCAMERALAYER];
    [loginUserDefaults synchronize];
}
-(void)cameraGuideTapActionTop:(UITapGestureRecognizer*)tap {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:MEASUREMENTTOPCAMERALAYER];
    [loginUserDefaults synchronize];
}
-(void)cameraGuideTapActionBottom:(UITapGestureRecognizer*)tap {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:MEASUREMENTBOTTOMCAMERALAYER];
    [loginUserDefaults synchronize];
    [loginUserDefaults setBool:YES forKey:MEASUREMENTCAMERALAYER];
    [loginUserDefaults synchronize];
}

@end
