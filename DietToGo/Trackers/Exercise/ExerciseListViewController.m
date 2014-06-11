//
//  ExerciseListViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 18/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "ExerciseListViewController.h"
#import "AddExerciseViewController.h"
#import "JSON.h"

@interface ExerciseListViewController ()

@end

@implementation ExerciseListViewController
@synthesize  mSelectdIndex, mRange;
@synthesize pagging;

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
#endif    //for swipe functionality
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
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrolView.frame = CGRectMake(self.mScrolView.frame.origin.x, self.mScrolView.frame.origin.y, 320, 504);
    }
    //Check for FiiBit State
    BOOL isShow = [mAppDelegate_ isShowFitBitBanner];
    fitBitYpos = 0;
    if (isShow) {
        fitBitYpos = 100;
    }
    int userType = [[[NSUserDefaults standardUserDefaults] objectForKey:USERTYPE] intValue];
    if ( userType == 1) {
        fitBitYpos = 100;
    }
    [self addFitBitBanner:isShow];
    //to check whether has any exercise logs or not if yes display a message
    if (mAppDelegate_.mTrackerDataGetter_.mExerciseList_.count == 0) {
        
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:EXERCISECAMERALAYER];
        if (!isCameraLayer) {
            BOOL isTop = [loginUserDefaults boolForKey:EXERCISETOPCAMERALAYER];
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
        self.mScrolView.contentSize = CGSizeMake(320, self.mMsgLbl.frame.origin.y+self.mMsgLbl.frame.size.height+20);
    }else{
        self.mWeekBtn.selected = TRUE;
        
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:EXERCISECAMERALAYER];//FALSE;//
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
        //self.trackedViewName=@"Exercise Tracker";
        [mAppDelegate_ trackFlurryLogEvent:@"Exercise Tracker"];
        
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"EXERCISE_TRACKER", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];//need to change to cancel button
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"addicon.png"] title:nil target:self action:@selector(addLogAction:) forController:self rightOrLeft:1];
    
   
}
- (void)loadGraphData
{
    //to check whether the goal is set up by the user or not
    NSMutableArray *datesArray = [[NSMutableArray alloc]init];
    NSString *goalValue;
    NSLog(@"mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ %@",mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_);
   
    //if ([mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ isKindOfClass:[NSDictionary class]]) {
        //to add previous day date
        if ([mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ count]>0 && [mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ count] == 1) {
            NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
            [GenricUI setLocaleZoneForDateFormatter:lFormatter];
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ objectAtIndex:0] objectForKey:@"StartDate"]];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                           toDate:lDate
                                                          options:0];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setValue:[lFormatter stringFromDate:yesterday] forKey:@"StartDate"];
            int index = [mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ count]-1;
            [mDict setValue:[[mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ objectAtIndex:index]objectForKey:@"Duration"] forKey:@"Duration"];
            [datesArray addObject:mDict];
        }
        //end

        //has goal
        [datesArray addObjectsFromArray:mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_];
        goalValue = [NSString stringWithFormat:@"%d", [[mAppDelegate_.mTrackerDataGetter_.mDayStepDict_ objectForKey:@"GoalExercise"] intValue]];
   /* }else{
        //to add previous day date
        if ([mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ count]>0 && [mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ count] == 1) {
            NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
            [GenricUI setLocaleZoneForDateFormatter:lFormatter];
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_ objectAtIndex:0] objectForKey:@"StartDate"]];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                           toDate:lDate
                                                          options:0];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setValue:[lFormatter stringFromDate:yesterday] forKey:@"StartDate"];
            int index = [mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_  count]-1;
            [mDict setValue:[[mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_  objectAtIndex:index]objectForKey:@"Calories"] forKey:@"Calories"];
            [datesArray addObject:mDict];
        }
        //end

        //no goal
        [datesArray addObjectsFromArray:mAppDelegate_.mTrackerDataGetter_.mExerciseChartDict_];
        goalValue = nil;
        
    }
    */
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
    //to get the highest yaxis value
    int yValue = 40;
    if ([datesArray count]!=0) {
        yValue = [[[datesArray objectAtIndex:0] objectForKey:@"Duration"] intValue];
        for (int iCount = 1; iCount < [datesArray count]; iCount++) {
            int value = [[[datesArray objectAtIndex:iCount] objectForKey:@"Duration"] intValue];
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
        NSValue *graphPoint = [NSValue valueWithCGPoint:CGPointMake(i, [[[datesArray objectAtIndex:i] objectForKey:@"Duration"] intValue])];
        [data addObject:graphPoint];
    }
    mLoadgraph = [[LoadGraph alloc] initWithHostingView:_graphHostingView andData:data xAxis:xArray yAxis:yArray];

    // for goal weight
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
    height+= 60;
    //for exercise name height
    UILabel *lExLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 60, 195, 20)];
    [lExLbl setFont:Bariol_Bold(17)];
    lExLbl.numberOfLines = 0;
    lExLbl.lineBreakMode = UILineBreakModeWordWrap;
    lExLbl.text = [[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:indexPath.row] objectForKey:@"Activity"];
    CGSize exsize = [lExLbl.text sizeWithFont:lExLbl.font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (exsize.height < 20) {
        exsize.height = 20;
    }
    if (exsize.width > lExLbl.frame.size.width) {
        height+=25;
    }
    
    height+= exsize.height;

    UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 30)];
    lLabel.textColor = RGB_A(114, 105, 89, 1);
    lLabel.font = [UIFont italicSystemFontOfSize:14];
    lLabel.numberOfLines =0;
    lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    lLabel.text = [[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:indexPath.row] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    CGSize size = [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (lLabel.text.length > 0)
    {
        if (size.height < 20) {
            size.height = 20;
        }
        height+=5+size.height;
    }
    height+=10;//to last gap
    
    int fibitLog = [[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:indexPath.row] objectForKey:@"LogSource"] intValue];
    if (fibitLog == 3) {
       // height += 15;
    }
    
    return height;
    
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mAppDelegate_.mTrackerDataGetter_.mExerciseList_.count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.clearsContextBeforeDrawing=TRUE;
        
        //date Label
        UILabel *lDateLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 180, 20)];
        [lDateLbl setBackgroundColor:[UIColor clearColor]];
        [lDateLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lDateLbl setFont:Bariol_Regular(17)];
        lDateLbl.tag =1;
        [lDateLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lDateLbl];
        
        //static text label
        UILabel *lTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 35, 150, 20)];
        [lTextLbl setBackgroundColor:[UIColor clearColor]];
        [lTextLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lTextLbl setFont:Bariol_Regular(17)];
        lTextLbl.tag =2;
        [lTextLbl setTextColor: RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lTextLbl];
        
        //claories label
        UILabel *lCalLbl=[[UILabel alloc]initWithFrame:CGRectMake(215, 35, 150, 20)];
        [lCalLbl setBackgroundColor:[UIColor clearColor]];
        [lCalLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lCalLbl setFont:Bariol_Bold(17)];
        lCalLbl.tag =3;
        [lCalLbl setTextColor:[UIColor blackColor]];
        [cell.contentView addSubview:lCalLbl];
        
        //static text label2
        UILabel *lTextLbl2=[[UILabel alloc]initWithFrame:CGRectMake(260, 35, 180, 20)];
        [lTextLbl2 setBackgroundColor:[UIColor clearColor]];
        [lTextLbl2 setTextAlignment:TEXT_ALIGN_LEFT];
        [lTextLbl2 setFont:Bariol_Regular(17)];
        lTextLbl2.tag =4;
        [lTextLbl2 setTextColor: RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lTextLbl2];
        
        //exercise label
        UILabel *lExLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 60, 195, 20)];
        [lExLbl setBackgroundColor:[UIColor clearColor]];
        [lExLbl setTextAlignment:TEXT_ALIGN_LEFT];
        lExLbl.numberOfLines = 0;
        lExLbl.lineBreakMode = UILineBreakModeWordWrap;
        [lExLbl setFont:Bariol_Bold(17)];
        lExLbl.tag =5;
        [lExLbl setTextColor:[UIColor blackColor]];
        [cell.contentView addSubview:lExLbl];
        
        //for label
        UILabel *lForLbl=[[UILabel alloc]initWithFrame:CGRectMake(215, 60, 40, 20)];
        [lForLbl setBackgroundColor:[UIColor clearColor]];
        [lForLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lForLbl setFont:Bariol_Regular(17)];
        lForLbl.tag =6;
        [lForLbl setTextColor:RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lForLbl];
        
        //duration label label
        UILabel *lDurationLbl=[[UILabel alloc]initWithFrame:CGRectMake(255, 60, 60, 20)];
        [lDurationLbl setBackgroundColor:[UIColor clearColor]];
        [lDurationLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lDurationLbl setFont:Bariol_Bold(17)];
        lDurationLbl.tag =7;
        [lDurationLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lDurationLbl];
        
        //min label
        UILabel *lMinLbl=[[UILabel alloc]initWithFrame:CGRectMake(295, 60, 80, 20)];
        [lMinLbl setBackgroundColor:[UIColor clearColor]];
        [lMinLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lMinLbl setFont:Bariol_Regular(17)];
        lMinLbl.tag =8;
        [lMinLbl setTextColor:RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lMinLbl];
        //notes label
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 85, 290, 20)];
        lLabel.textColor = RGB_A(114, 105, 89, 1);
        lLabel.font = [UIFont italicSystemFontOfSize:14];
        lLabel.numberOfLines =0;
        lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lLabel.tag = 9;
        [cell.contentView addSubview:lLabel];
        
        //FitBitLog label
        UILabel *lFitBitLog = [[UILabel alloc]initWithFrame:CGRectMake(40, 85, 260, 20)];
        lFitBitLog.textColor = RGB_A(114, 105, 89, 1);
        lFitBitLog.font = Bariol_Bold(14);
        lFitBitLog.numberOfLines =0;
        lFitBitLog.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lFitBitLog.tag = 10;
        lFitBitLog.backgroundColor = CLEAR_COLOR;
        [cell.contentView addSubview:lFitBitLog];
        
        UIImageView *lFitBitLogImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 85, 15, 15)];
        lFitBitLogImg.image = [UIImage imageNamed:@"fitbitLog.png"];
        lFitBitLogImg.tag = 11;
        [cell.contentView addSubview:lFitBitLogImg];



    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    //UIImageView *limage1 = (UIImageView*)[cell.contentView viewWithTag:1];
    UILabel *lDateLblIns= (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *lTextLblIns= (UILabel*)[cell.contentView viewWithTag:2];
    UILabel *lCalLblIns= (UILabel*)[cell.contentView viewWithTag:3];
    UILabel *lTextLbl2Ins = (UILabel*)[cell.contentView viewWithTag:4];
    UILabel *lExLblIns = (UILabel*)[cell.contentView viewWithTag:5];
    UILabel *lForLblIns = (UILabel*)[cell.contentView viewWithTag:6];
    UILabel *lDuratnLblIns = (UILabel*)[cell.contentView viewWithTag:7];
    UILabel *lMinLblIns = (UILabel*)[cell.contentView viewWithTag:8];
    UILabel *lNotesLblIns = (UILabel*)[cell.contentView viewWithTag:9];
    UILabel *lFitBitLog = (UILabel*)[cell.contentView viewWithTag:10];
    UIImageView *lFitBitLogImg = (UIImageView*)[cell.contentView viewWithTag:11];


    NSDateFormatter *lFormatter=[[NSDateFormatter alloc]init];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [lFormatter setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    lFormatter.locale = enLocale;
    NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:indexPath.row] objectForKey:@"StartDate"]];
    [lFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    lDateLblIns.text = [lFormatter stringFromDate:lDate];
    CGSize size =  [lDateLblIns.text sizeWithFont:lDateLblIns.font constrainedToSize:CGSizeMake(lDateLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lDateLblIns.frame = CGRectMake(15, lDateLblIns.frame.origin.y, size.width, 20);
    
    lTextLblIns.text = @"Burned";
    size =  [lTextLblIns.text sizeWithFont:lTextLblIns.font constrainedToSize:CGSizeMake(lTextLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    
    lTextLblIns.frame = CGRectMake(15, lTextLblIns.frame.origin.y, size.width, 20);
    
    //calories
    lCalLblIns.text = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:indexPath.row] objectForKey:@"Calories"] intValue]];
    size =  [lCalLblIns.text sizeWithFont:lCalLblIns.font constrainedToSize:CGSizeMake(lCalLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lCalLblIns.frame = CGRectMake(lTextLblIns.frame.origin.x+lTextLblIns.frame.size.width+3, lCalLblIns.frame.origin.y, size.width, 20);
    
    lTextLbl2Ins.text = @"calories by engaging in";
    lTextLbl2Ins.hidden = NO;
    size =  [lTextLbl2Ins.text sizeWithFont:lTextLbl2Ins.font constrainedToSize:CGSizeMake(lTextLbl2Ins.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lTextLbl2Ins.frame = CGRectMake(lCalLblIns.frame.origin.x+lCalLblIns.frame.size.width+3, lTextLbl2Ins.frame.origin.y, size.width, 20);

    //exercise name
    lExLblIns.text = [[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:indexPath.row] objectForKey:@"Activity"];//ActivityName
    lExLblIns.hidden = NO;
    size =  [lExLblIns.text sizeWithFont:lExLblIns.font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];

    if (size.height < 20) {
        size.height = 20;
    }
    lExLblIns.frame = CGRectMake(15, lExLblIns.frame.origin.y, size.width, size.height);
    
    lForLblIns.text = @"for";
    lForLblIns.hidden = NO;
    size =  [lForLblIns.text sizeWithFont:lForLblIns.font constrainedToSize:CGSizeMake(lForLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lForLblIns.frame = CGRectMake(lExLblIns.frame.origin.x+lExLblIns.frame.size.width+3, lForLblIns.frame.origin.y, size.width, 20);
    if (lExLblIns.frame.size.width > 195) {
        lForLblIns.frame = CGRectMake(15, lExLblIns.frame.origin.y+lExLblIns.frame.size.height+5, size.width, 20);

    }
    //duration
    lDuratnLblIns.hidden = NO;
    lDuratnLblIns.text = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:indexPath.row] objectForKey:@"Duration"] intValue]];
    size =  [lDuratnLblIns.text sizeWithFont:lDuratnLblIns.font constrainedToSize:CGSizeMake(lDuratnLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lDuratnLblIns.frame = CGRectMake(lForLblIns.frame.origin.x+lForLblIns.frame.size.width+3, lForLblIns.frame.origin.y, size.width, 20);

    //minutes label
    if ([lDuratnLblIns.text intValue] > 1) {
        lMinLblIns.text = @"minutes";

    }else{
        lMinLblIns.text = @"minute";
  
    }
    lMinLblIns.hidden = NO;
    size =  [lMinLblIns.text sizeWithFont:lMinLblIns.font constrainedToSize:CGSizeMake(lMinLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lMinLblIns.frame = CGRectMake(lDuratnLblIns.frame.origin.x+lDuratnLblIns.frame.size.width+3, lForLblIns.frame.origin.y, size.width, 20);
    
    lNotesLblIns.text = [[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:indexPath.row] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    size = [lNotesLblIns.text sizeWithFont:lNotesLblIns.font constrainedToSize:CGSizeMake(lNotesLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (size.height < 20) {
        size.height = 20;
    }
    int fibitLog = [[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:indexPath.row] objectForKey:@"LogSource"] intValue];
    if (fibitLog == 3) {
        lNotesLblIns.frame = CGRectMake(15, lExLblIns.frame.origin.y, 290, size.height);
    }else {
        lNotesLblIns.frame = CGRectMake(15, lForLblIns.frame.origin.y+lForLblIns.frame.size.height+5, 290, size.height);
    }
    CGFloat logYpos = lNotesLblIns.frame.origin.y+lNotesLblIns.frame.size.height;
    
    if (lNotesLblIns.text.length == 0) {
        lNotesLblIns.hidden = TRUE;
        logYpos -=20;
    }else{
        lNotesLblIns.hidden = FALSE;
    }
    lFitBitLog.hidden = YES; lFitBitLogImg.hidden = YES;
    
    if (fibitLog == 3) {
        lFitBitLog.hidden = NO; lFitBitLogImg.hidden = NO;
        if (lNotesLblIns.text.length == 0) {
            lFitBitLog.frame = CGRectMake(35, logYpos, 260, 20);
            lFitBitLogImg.frame = CGRectMake(15, logYpos+2, 15, 15);
        }else {
            lFitBitLog.frame = CGRectMake(35, logYpos+5, 260, 20);
            lFitBitLogImg.frame = CGRectMake(15, logYpos+8, 15, 15);
        }
        lFitBitLog.text = @"from Fitbit";
        
        // hide Fields for Fitbit logs
        lTextLbl2Ins.text = @"calories";
        lTextLbl2Ins.hidden = NO;
        lExLblIns.hidden = YES;
        lForLblIns.hidden = YES;
        lDuratnLblIns.hidden = YES;
        lMinLblIns.hidden = YES;
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
        // [self.mTableView removeGestureRecognizer:self.mSwipeGes];
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.mTableView];
        NSIndexPath *swipedIndexPath = [self.mTableView indexPathForRowAtPoint:swipeLocation];
        self.mSelectdIndex = swipedIndexPath;
        UITableViewCell* swipedCell = [self.mTableView cellForRowAtIndexPath:swipedIndexPath];
        //to move the row contents to left
        UITableViewCell *cell = (UITableViewCell *)swipedCell;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        for (int i =1; i<10; i++) {
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
        [deleteBtn setImage:[UIImage imageNamed:@"crossicon.png"] forState:UIControlStateNormal];
        [deleteBtn setTag:swipedIndexPath.row];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightPatch addSubview:deleteBtn];
        
    }
}
-(void)deleteBtnAction:(UIButton*)deleteBtn {
    [GenricUI showAlertWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"DELETE_EXERCISE_LOG", nil) cancelButton:@"No" delegates:self button1Titles:@"Yes" button2Titles:nil tag:400];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 400) {
        if (buttonIndex == 1) {
            //to delete the logweight
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToDeleteExerciseLog:[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:self.mSelectdIndex.row] objectForKey:@"LogID"]
                                                                   AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                                SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
            
            
        }
    }
}

- (void)viewDidUnload {
    
    [self setMLogLbl:nil];
    [self setMTableView:nil];
    [self setMScrolView:nil];
    [self setMLineImgView:nil];
    [super viewDidUnload];
}
- (void)menuAction:(id)sender {
    [mAppDelegate_ showLeftSideMenu:self];
}
- (void)reloadContentsOftableView
{
    //to check whether has any exercise logs or not if yes display a message
    if (mAppDelegate_.mTrackerDataGetter_.mExerciseList_.count == 0) {
        self.mTopView.hidden = TRUE;
        self.mTableView.hidden = TRUE;
        self.mMsgLbl.hidden = FALSE;
        self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, 25+fitBitYpos, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
        self.mLineImgView.frame = CGRectMake(self.mLineImgView.frame.origin.x, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, self.mLineImgView.frame.size.width, self.mLineImgView.frame.size.height);
        self.mMsgLbl.frame = CGRectMake(self.mMsgLbl.frame.origin.x, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height+10, self.mMsgLbl.frame.size.width, self.mMsgLbl.frame.size.height);
        self.mScrolView.contentSize = CGSizeMake(320, self.mMsgLbl.frame.origin.y+self.mMsgLbl.frame.size.height+20);
    }else{
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:EXERCISECAMERALAYER];
        if (!isCameraLayer) {
            BOOL isTop = [loginUserDefaults boolForKey:EXERCISETOPCAMERALAYER];
            BOOL isBottom = [loginUserDefaults boolForKey:EXERCISEBOTTOMCAMERALAYER];
            if ( isTop && !isBottom) {
                [self showCameraGuideBottom];
            }
        }
        [self AdjustControlBasedOnFitBit];
    }
    
    
}
- (void)addLogAction:(id)sender {
    
    
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
       
        /* [mAppDelegate_.mRequestMethods_ postRequestToGetUserCurrentWeight:mAppDelegate_.mResponseMethods_.authToken
                                                             SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
         */
        [self postRequestToGetPerSonalSettings];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
        
}
- (void)pushToAddPage{
    AddExerciseViewController *lVc = [[AddExerciseViewController alloc]initWithNibName:@"AddExerciseViewController" bundle:nil];
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
    [self postRequestForExerciseGraph];
    
}

- (IBAction)monthAction:(id)sender {
    self.mMonthBtn.selected = TRUE;
    self.mWeekBtn.selected = FALSE;
    self.m3MonthsBtn.selected = FALSE;
    self.mRange = @"Month";
    [self postRequestForExerciseGraph];
    
    
}

- (IBAction)weekAction:(id)sender {
    self.mMonthBtn.selected = FALSE;
    self.mWeekBtn.selected = TRUE;
    self.m3MonthsBtn.selected = FALSE;
    self.mRange = @"Week";
    [self postRequestForExerciseGraph];
    
    
}
- (void)postRequestForExerciseGraph{
    //to get the weight log chart data
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestToGetExerciseChartData:self.mRange
                                                              AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                           SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
}
- (CGFloat)caluclateTableHeight{
    CGFloat height=0.0;
    for (int i =0; i < mAppDelegate_.mTrackerDataGetter_.mExerciseList_.count; i++) {
        height += 60;
        //for exercise name height
        UILabel *lExLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 60, 195, 20)];
        [lExLbl setFont:Bariol_Bold(17)];
        lExLbl.numberOfLines = 0;
        lExLbl.lineBreakMode = UILineBreakModeWordWrap;
        lExLbl.text = [[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:i] objectForKey:@"Activity"];
        CGSize exsize = [lExLbl.text sizeWithFont:lExLbl.font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        if (exsize.height < 20) {
            exsize.height = 20;
        }
        if (exsize.width > lExLbl.frame.size.width) {
            height+=25;
        }

        height+= exsize.height;
        
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 30)];
        lLabel.textColor = RGB_A(114, 105, 89, 1);
        lLabel.font = [UIFont italicSystemFontOfSize:14];
        lLabel.numberOfLines =0;
        lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lLabel.text = [[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:i] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        CGSize size = [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        if (lLabel.text.length > 0)
        {
            if (size.height < 20) {
                size.height = 20;
            }
            height+=5+size.height;
        }
        height+=10;//to last gap
        int fibitLog = [[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:i] objectForKey:@"LogSource"] intValue];
        if (fibitLog == 3) {
           // height += 15;
        }
    }
    return height;
}
#pragma mark - FitBit Banner
-(void)addFitBitBanner:(BOOL)isShow {
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    bannerView.backgroundColor = CLEAR_COLOR;
    
    UIScrollView *bannerScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    bannerScroller.tag = FitBitBannerTag;
    bannerScroller.backgroundColor = CLEAR_COLOR;
    CGFloat ContentWidth = 0;
    [bannerView addSubview:bannerScroller];
    
    if (isShow) {
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
    }
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
        
        if (isShow) {
            //Add Page Control to Banner View
            self.pagging = [[CustomPageControl alloc] initWithFrame:CGRectMake(0, 75, 320, 20)];
            self.pagging.numberOfPages = 2;
            self.pagging.currentPage = 0;
            self.pagging.userInteractionEnabled = NO;
            [bannerView addSubview:pagging];
            ContentWidth +=320;
            bannerScroller.delegate = self;
        }
    }
    bannerScroller.pagingEnabled = YES;
    bannerScroller.showsHorizontalScrollIndicator = NO;
    bannerScroller.showsVerticalScrollIndicator = NO;
    [bannerScroller setContentSize:CGSizeMake(ContentWidth, 100)];
    [self.mScrolView addSubview:bannerView];
}
-(void)fitBitViewBtnAction:(UIButton*)btn {
    // NSLog(@"fitBitViewBtnAction");
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        [mAppDelegate_ trackFlurryLogEventForBanners:@"Fitbit Banner – Exercise Tracker"];
    }
    //end
    [mAppDelegate_ pushToFitBitViewController];
}
-(void)prospectViewBtnAction:(UIButton*)btn {
    //  NSLog(@"prospectViewBtnAction");
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        [mAppDelegate_ trackFlurryLogEventForBanners:@"Prospect Banner – Exercise Tracker"];
    }
    //end
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GETSTARTEDURL]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == FitBitBannerTag) {
        CGPoint l = scrollView.contentOffset;
        int x=(int)l.x;
        int k=x/320;
        self.pagging.currentPage = k;
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
    NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:0] objectForKey:@"StartDate"]];
    if (lDate == nil) {
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:0] objectForKey:@"StartDate"]];
        
    }
    [lFormatter setDateFormat:@"MM/dd/yy"];
    NSString *lStr = [lFormatter stringFromDate:lDate];
    self.mLastLogLbl.text = [NSString stringWithFormat:@"Last logged on %@",lStr];
    self.mWeightlbl.text = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mExerciseList_ objectAtIndex:0] objectForKey:@"Duration"] intValue]];
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
    self.mScrolView.contentSize = CGSizeMake(320, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+20);
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
    [loginUserDefaults setBool:YES forKey:EXERCISECAMERALAYER];
    [loginUserDefaults synchronize];
}
-(void)cameraGuideTapActionTop:(UITapGestureRecognizer*)tap {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:EXERCISETOPCAMERALAYER];
    [loginUserDefaults synchronize];
}
-(void)cameraGuideTapActionBottom:(UITapGestureRecognizer*)tap {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:EXERCISEBOTTOMCAMERALAYER];
    [loginUserDefaults synchronize];
    [loginUserDefaults setBool:YES forKey:EXERCISECAMERALAYER];
    [loginUserDefaults synchronize];
}

- (void)postRequestToGetPerSonalSettings{
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"%@/%@", SETTINGS, PERSONAL];
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        lcurrentWebRequest = PersonalWebRequest;
        [NSThread detachNewThreadSelector:@selector(GetResponseData:) toTarget:self withObject: mRequestStr];
        
    }else {
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
        return;
    }
    
}
- (void)postRequestToGetLookupLogsource {
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"Info/Lookup/Logsource"];
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        lcurrentWebRequest = LookupWebRequest;
        [NSThread detachNewThreadSelector:@selector(GetResponseData:) toTarget:self withObject: mRequestStr];
        
    }else {
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
        return;
    }
    
}
- (void)postRequestToGetExerciseActivities {
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"Info/Exercises"];
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        lcurrentWebRequest = ActivitiesWebRequest;
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
    
    if (lcurrentWebRequest == PersonalWebRequest) {
        if ([[json_string JSONValue] isKindOfClass:[NSMutableDictionary class]]) {
            
        [mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ removeAllObjects];
        mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_ = [json_string JSONValue];
        DLog(@"mDict %@", mAppDelegate_.mTrackerDataGetter_.mCurrentWeightDict_);
        }
        [self postRequestToGetLookupLogsource];
    } else if (lcurrentWebRequest == LookupWebRequest) {
        if ([[json_string JSONValue] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *mArr = [json_string JSONValue];
            DLog(@"mDict %@", mArr);
            for (NSMutableDictionary *tmp in mArr) {
                if ([[tmp valueForKey:@"Value"] isEqualToString:@"AppManual"]) {
                  //  DLog(@"Code %@", [tmp valueForKey:@"Code"]);
                    mAppDelegate_.mTrackerDataGetter_.mLogsourceAppManualDict_ = tmp;
                }
            }
        }
        [self postRequestToGetExerciseActivities];
    }else if (lcurrentWebRequest == ActivitiesWebRequest) {
        [mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ removeAllObjects];
        mAppDelegate_.mTrackerDataGetter_.mExActivitiesList_ = [json_string JSONValue];
        [self performSelectorOnMainThread:@selector(parseGetPersonalSettings:) withObject:nil waitUntilDone:NO];

    }
    
    
}
- (void)parseGetPersonalSettings:(NSObject *) isSucces {
    [mAppDelegate_ removeLoadView];
    [self pushToAddPage];

}

@end

