//
//  WeightListViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 01/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "WeightListViewController.h"
#import "AddEditWeightViewController.h"

@interface WeightListViewController ()

@end

@implementation WeightListViewController
@synthesize mSwipeGes, mSelectdIndex, mRange;
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
    self.mSwipeGes = sgrLeft;
    [sgrLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.mTableView addGestureRecognizer:sgrLeft];
    [mAppDelegate_ hideEmptySeparators:self.mTableView];
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
    self.mWeekBtn.selected = TRUE;

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
    if (mAppDelegate_.mTrackerDataGetter_.mWeightList_.count == 0) {
        
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:WEIGHTCAMERALAYER];
        if (!isCameraLayer) {
            BOOL isTop = [loginUserDefaults boolForKey:WEIGHTTOPCAMERALAYER];
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
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:WEIGHTCAMERALAYER];//FALSE;//
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
        //self.trackedViewName=@"Weight Tracker";
        [mAppDelegate_ trackFlurryLogEvent:@"Weight Tracker"];
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"WEIGHT_TRACKER", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];//need to change to cancel button
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"addicon.png"] title:nil target:self action:@selector(addLogAction:) forController:self rightOrLeft:1];
    
}

- (void)loadGraphData
{
    //to check whether the goal is set up by the user or not
    NSMutableArray *datesArray = [[NSMutableArray alloc]init];
    NSString *goalValue;
   /* if ([mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ isKindOfClass:[NSDictionary class]]) {
        
        //to add previous day date
        if ([[mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ objectForKey:@"ChartData"] count]>0 && [[mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ objectForKey:@"ChartData"] count] == 1) {
            NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
            [GenricUI setLocaleZoneForDateFormatter:lFormatter];
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *lDate = [lFormatter dateFromString:[[[mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ objectForKey:@"ChartData"] objectAtIndex:0] objectForKey:@"StartDate"]];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                           toDate:lDate
                                                          options:0];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setValue:[lFormatter stringFromDate:yesterday] forKey:@"StartDate"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Weight"];
            [datesArray addObject:mDict];
        }
        //end
        
        //has goal
        [datesArray addObjectsFromArray:[mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ objectForKey:@"ChartData"]];
        goalValue = [NSString stringWithFormat:@"%d", [[mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ objectForKey:@"Goal"] intValue]];
    }else{
    */
        //to add previous day date
        if ([mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ count]>0 && [mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ count] == 1) {
            NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
            [GenricUI setLocaleZoneForDateFormatter:lFormatter];
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_ objectAtIndex:0] objectForKey:@"StartDate"]];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                           toDate:lDate
                                                          options:0];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setValue:[lFormatter stringFromDate:yesterday] forKey:@"StartDate"];
            [mDict setValue:self.mWeightlbl.text forKey:@"Weight"];
            [datesArray addObject:mDict];
        }
        //end

        //no goal
        [datesArray addObjectsFromArray:mAppDelegate_.mTrackerDataGetter_.mWeightChartDict_];
        goalValue = [NSString stringWithFormat:@"%d", [[mAppDelegate_.mTrackerDataGetter_.mDayStepDict_ objectForKey:@"GoalWeight"] intValue]];

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
    int yValue = 40;
    
    if ([datesArray count]!=0) {
        //to get the highest yaxis value
        yValue = [[[datesArray objectAtIndex:0] objectForKey:@"Weight"] intValue];
        for (int iCount = 1; iCount < [datesArray count]; iCount++) {
            int value = [[[datesArray objectAtIndex:iCount] objectForKey:@"Weight"] intValue];
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
        NSValue *graphPoint = [NSValue valueWithCGPoint:CGPointMake(i, [[[datesArray objectAtIndex:i] objectForKey:@"Weight"] intValue])];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TABLE VIEW DELEGATE METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    CGFloat height =0.0;
    height+= 40;
    UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 30)];
    lLabel.textColor = RGB_A(114, 105, 89, 1);
    lLabel.font = [UIFont italicSystemFontOfSize:14];
    lLabel.numberOfLines =0;
    lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    lLabel.text = [[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:indexPath.row] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    CGSize size = [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (lLabel.text.length > 0)
    {
        if (size.height < 20) {
            size.height = 20;
        }
        height+=5+size.height;
    }
    height+=15;//to last gap
    int fibitLog = [[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:indexPath.row] objectForKey:@"LogSource"] intValue];
    if (fibitLog == 3) {
        height += 15;
    }
    
    return height;
    
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mAppDelegate_.mTrackerDataGetter_.mWeightList_.count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.clearsContextBeforeDrawing=TRUE;
        
        //date Label
        UILabel *lDateLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 180, 25)];
        [lDateLbl setBackgroundColor:[UIColor clearColor]];
        [lDateLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lDateLbl setFont:Bariol_Regular(16)];
        lDateLbl.tag =1;
        [lDateLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lDateLbl];
        
        //static text label
        UILabel *lTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(115, 15, 150, 25)];
        [lTextLbl setBackgroundColor:[UIColor clearColor]];
        [lTextLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lTextLbl setFont:Bariol_Regular(16)];
        lTextLbl.tag =2;
        [lTextLbl setTextColor: RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lTextLbl];
        
        //weight label
        UILabel *lWeightLbl=[[UILabel alloc]initWithFrame:CGRectMake(215, 15, 150, 25)];
        [lWeightLbl setBackgroundColor:[UIColor clearColor]];
        [lWeightLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lWeightLbl setFont:Bariol_Bold(16)];
        lWeightLbl.tag =3;
        [lWeightLbl setTextColor:[UIColor blackColor]];
        [cell.contentView addSubview:lWeightLbl];
       
        //notes label
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 290, 20)];
        lLabel.textColor = RGB_A(114, 105, 89, 1);
        lLabel.font = [UIFont italicSystemFontOfSize:14];
        lLabel.numberOfLines =0;
        lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lLabel.tag = 4;
        [cell.contentView addSubview:lLabel];
        
        //FitBitLog label
        UILabel *lFitBitLog = [[UILabel alloc]initWithFrame:CGRectMake(40, 65, 260, 20)];
        lFitBitLog.textColor = RGB_A(114, 105, 89, 1);
        lFitBitLog.font = Bariol_Bold(14);
        lFitBitLog.numberOfLines =0;
        lFitBitLog.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lFitBitLog.tag = 5;
        lFitBitLog.backgroundColor = CLEAR_COLOR;
        [cell.contentView addSubview:lFitBitLog];
        
        UIImageView *lFitBitLogImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 65, 15, 15)];
        lFitBitLogImg.image = [UIImage imageNamed:@"fitbitLog.png"];
        lFitBitLogImg.tag = 6;
        [cell.contentView addSubview:lFitBitLogImg];
        
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    //UIImageView *limage1 = (UIImageView*)[cell.contentView viewWithTag:1];
    UILabel *lDateLblIns= (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *lTextLblIns= (UILabel*)[cell.contentView viewWithTag:2];
    UILabel *lWeightLblIns= (UILabel*)[cell.contentView viewWithTag:3];
    UILabel *lNotesLbl = (UILabel*)[cell.contentView viewWithTag:4];
    UILabel *lFitBitLog = (UILabel*)[cell.contentView viewWithTag:5];
    UIImageView *lFitBitLogImg = (UIImageView*)[cell.contentView viewWithTag:6];

    NSDateFormatter *lFormatter=[[NSDateFormatter alloc]init];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [lFormatter setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    lFormatter.locale = enLocale;
    NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:indexPath.row] objectForKey:@"StartDate"]];
    if (lDate == nil) {
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:indexPath.row] objectForKey:@"StartDate"]];
        
    }
    [lFormatter setDateFormat:@"MMMM dd, yyyy"];

    lDateLblIns.text = [lFormatter stringFromDate:lDate];
    CGSize size =  [lDateLblIns.text sizeWithFont:lDateLblIns.font constrainedToSize:CGSizeMake(lDateLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    lDateLblIns.frame = CGRectMake(15, 15, size.width, 25);
    
    lTextLblIns.text = @"Weighed in at";
    size =  [lTextLblIns.text sizeWithFont:lTextLblIns.font constrainedToSize:CGSizeMake(lTextLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];

    lTextLblIns.frame = CGRectMake(lDateLblIns.frame.origin.x+lDateLblIns.frame.size.width+3, 15, size.width, 25);
    
    //weight
    lWeightLblIns.text = [NSString stringWithFormat:@"%.1f lbs.", [[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:indexPath.row] objectForKey:@"Weight"] floatValue]];
    size =  [lWeightLblIns.text sizeWithFont:lWeightLblIns.font constrainedToSize:CGSizeMake(lWeightLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    
    lWeightLblIns.frame = CGRectMake(lTextLblIns.frame.origin.x+lTextLblIns.frame.size.width+3, 15, size.width, 25);

    lNotesLbl.text = [[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:indexPath.row] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    size = [lNotesLbl.text sizeWithFont:lNotesLbl.font constrainedToSize:CGSizeMake(lNotesLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (size.height < 20) {
        size.height = 20;
    }
    lNotesLbl.frame = CGRectMake(15, lNotesLbl.frame.origin.y, 290, size.height);
    CGFloat logYpos = lNotesLbl.frame.origin.y+lNotesLbl.frame.size.height;

    if (lNotesLbl.text.length == 0) {
        lNotesLbl.hidden = TRUE;
        logYpos -= 20;
    }else{
        lNotesLbl.hidden = FALSE;
    }
    lFitBitLog.hidden = YES; lFitBitLogImg.hidden = YES;
    int fibitLog = [[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:indexPath.row] objectForKey:@"LogSource"] intValue];
    if (fibitLog == 3) {
        lFitBitLog.hidden = NO; lFitBitLogImg.hidden = NO;
        if (lNotesLbl.text.length == 0) {
            lFitBitLog.frame = CGRectMake(35, logYpos, 260, 20);
            lFitBitLogImg.frame = CGRectMake(15, logYpos+2, 15, 15);
        }else {
            lFitBitLog.frame = CGRectMake(35, logYpos+5, 260, 20);
            lFitBitLogImg.frame = CGRectMake(15, logYpos+8, 15, 15);
        }
        lFitBitLog.text = @"from Fitbit";
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
       
        UILabel *lDateLblIns= (UILabel*)[cell.contentView viewWithTag:1];
        UILabel *lTextLblIns= (UILabel*)[cell.contentView viewWithTag:2];
        UILabel *lWeightLblIns= (UILabel*)[cell.contentView viewWithTag:3];
        UILabel *lNotesLblIns= (UILabel*)[cell.contentView viewWithTag:4];

        CGRect frame = lDateLblIns.frame;
        frame.origin.x -= 50;
        lDateLblIns.frame = frame;
        frame = lTextLblIns.frame;
        frame.origin.x -= 50;
        lTextLblIns.frame = frame;
        frame = lWeightLblIns.frame;
        frame.origin.x -= 50;
        lWeightLblIns.frame = frame;
        frame = lNotesLblIns.frame;
        frame.origin.x -= 50;
        lNotesLblIns.frame = frame;
        [UIView commitAnimations];
        
        //for view
        UIView* rightPatch = [[UIView alloc]init];
        rightPatch.frame = CGRectMake(320-50, 0, 50, cell.frame.size.height);
        [rightPatch setBackgroundColor:DTG_MAROON_COLOR];
        [cell addSubview:rightPatch];
        
        //delete Button
       
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(0, 0, 50, cell.frame.size.height);
        [deleteBtn setImage:[UIImage imageNamed:@"crossicon.png"] forState:UIControlStateNormal];
        [deleteBtn setTag:swipedIndexPath.row];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightPatch addSubview:deleteBtn];
        
    }
}
-(void)deleteBtnAction:(UIButton*)deleteBtn {
    [GenricUI showAlertWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"DELETE_WEIGHT_LOG", nil) cancelButton:@"No" delegates:self button1Titles:@"Yes" button2Titles:nil tag:400];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 400) {
        if (buttonIndex == 1) {
            //to delete the logweight
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToDeleteWeightLog:[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:self.mSelectdIndex.row] objectForKey:@"LogID"]
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
- (void)reloadContentsOftableView
{
    //to check whether has any exercise logs or not if yes display a message
    if (mAppDelegate_.mTrackerDataGetter_.mWeightList_.count == 0) {
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
        BOOL isCameraLayer = [loginUserDefaults boolForKey:WEIGHTCAMERALAYER];
        if (!isCameraLayer) {
            BOOL isTop = [loginUserDefaults boolForKey:WEIGHTTOPCAMERALAYER];
            BOOL isBottom = [loginUserDefaults boolForKey:WEIGHTBOTTOMCAMERALAYER];
            if ( isTop && !isBottom) {
                [self showCameraGuideBottom];
            }
        }
        [self AdjustControlBasedOnFitBit];
    }


}
- (void)addLogAction:(id)sender {
    AddEditWeightViewController *lVc = [[AddEditWeightViewController alloc]initWithNibName:@"AddEditWeightViewController" bundle:nil];
    lVc.isFromEdit = FALSE;
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
    [self postRequestForWeightGraph];

}

- (IBAction)monthAction:(id)sender {
    self.mMonthBtn.selected = TRUE;
    self.mWeekBtn.selected = FALSE;
    self.m3MonthsBtn.selected = FALSE;
    self.mRange = @"Month";
    [self postRequestForWeightGraph];


}

- (IBAction)weekAction:(id)sender {
    self.mMonthBtn.selected = FALSE;
    self.mWeekBtn.selected = TRUE;
    self.m3MonthsBtn.selected = FALSE;
    self.mRange = @"Week";
    [self postRequestForWeightGraph];


}
- (void)postRequestForWeightGraph{
    //to get the weight log chart data
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestToGetWeightChartData:self.mRange
                                                              AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                           SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
}
- (CGFloat)caluclateTableHeight{
    CGFloat height=0.0;
    for (int i =0; i < mAppDelegate_.mTrackerDataGetter_.mWeightList_.count; i++) {
        height+= 40;
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 30)];
        lLabel.textColor = RGB_A(114, 105, 89, 1);
        lLabel.font = [UIFont italicSystemFontOfSize:14];
        lLabel.numberOfLines =0;
        lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lLabel.text = [[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:i] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        CGSize size = [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        if (lLabel.text.length > 0)
        {
            if (size.height < 20) {
                size.height = 20;
            }
            height+=5+size.height;
        }
        height+=15;//to last gap
        int fibitLog = [[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:i] objectForKey:@"LogSource"] intValue];
        if (fibitLog == 3) {
            height += 15;
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
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        [mAppDelegate_ trackFlurryLogEventForBanners:@"Fitbit Banner – Weight Tracker"];
    }
    //end
    [mAppDelegate_ pushToFitBitViewController];
    // NSLog(@"fitBitViewBtnAction");
}
-(void)prospectViewBtnAction:(UIButton*)btn {
  //  NSLog(@"prospectViewBtnAction");
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        [mAppDelegate_ trackFlurryLogEventForBanners:@"Prospect Banner – Weight Tracker"];
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
    NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:0] objectForKey:@"StartDate"]];
    if (lDate == nil) {
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:0] objectForKey:@"StartDate"]];
        
    }
    [lFormatter setDateFormat:@"MM/dd/yy"];
    NSString *lStr = [lFormatter stringFromDate:lDate];
    self.mLastLogLbl.text = [NSString stringWithFormat:@"Last logged on %@",lStr];
    self.mWeightlbl.text = [NSString stringWithFormat:@"%.1f", [[[mAppDelegate_.mTrackerDataGetter_.mWeightList_ objectAtIndex:0] objectForKey:@"Weight"] floatValue]];
    CGSize size =  [self.mWeightlbl.text sizeWithFont:self.mWeightlbl.font constrainedToSize:CGSizeMake(150, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mWeightlbl.frame = CGRectMake(self.mWeightlbl.frame.origin.x, self.mWeightlbl.frame.origin.y, size.width, self.mWeightlbl.frame.size.height);
    self.mLbsLbl.frame = CGRectMake(self.mWeightlbl.frame.origin.x+size.width+3, 68, self.mLbsLbl.frame.size.width, 30);
    
    self.mTopView.hidden = FALSE;
    self.mTableView.hidden = FALSE;
    self.mMsgLbl.hidden = TRUE;
    self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, self.mTopView.frame.origin.y+self.mTopView.frame.size.height+35, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
    self.mLineImgView.frame = CGRectMake(self.mLineImgView.frame.origin.x, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, self.mLineImgView.frame.size.width, self.mLineImgView.frame.size.height);
    
    
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
    [loginUserDefaults setBool:YES forKey:WEIGHTCAMERALAYER];
    [loginUserDefaults synchronize];
}
-(void)cameraGuideTapActionTop:(UITapGestureRecognizer*)tap {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:WEIGHTTOPCAMERALAYER];
    [loginUserDefaults synchronize];
}
-(void)cameraGuideTapActionBottom:(UITapGestureRecognizer*)tap {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:WEIGHTBOTTOMCAMERALAYER];
    [loginUserDefaults synchronize];
    [loginUserDefaults setBool:YES forKey:WEIGHTCAMERALAYER];
    [loginUserDefaults synchronize];
}

@end
