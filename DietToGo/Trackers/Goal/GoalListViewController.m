//
//  GoalListViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 28/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "GoalListViewController.h"
#import "AddGoalViewController.h"

#define ANNOTATETEXT @"Annotate Your Day"
@interface GoalListViewController ()

@end

@implementation GoalListViewController
@synthesize mRange, mGoalsDict, mStepID, mUserStepID;
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
    mGoalsDict = [[NSMutableDictionary alloc]init];

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
    self.mLastLogLbl.font = Bariol_Regular(14);
    self.mLastLogLbl.textColor = RGB_A(102, 102, 102, 1);
    self.mMsgLbl.font = Bariol_Regular(17);
    self.mMsgLbl.textColor = [UIColor darkGrayColor];
    self.mRange = @"Week";
    self.mWeightlbl.font = Bariol_Regular(40);
    self.mWeightlbl.textColor = RGB_A(51, 51, 51, 1);
    self.mLbsLbl.font = Bariol_Regular(24);
    self.mLbsLbl.textColor = RGB_A(51, 51, 51, 1);
    self.mTypeLbl.font = Bariol_Regular(17);
    self.mTypeLbl.text = [[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:0] objectForKey:@"Label"];
    
    if ([self.mTypeLbl.text isEqualToString:@""]) {
        self.mTypeLbl.text =@"";
    }
    self.mTypeLbl.textColor = BLACK_COLOR;
    self.mStepID = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:0] objectForKey:@"GoalStep"] intValue]];
    self.mUserStepID = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:0] objectForKey:@"UserStepID"] intValue]];
    
   
    //negative goals
    if ([[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Category"] intValue] < 0) {
        float goalValue = [[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Achievement"] intValue]* [[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Goal"] floatValue];
        goalValue = goalValue/100.0f;
        //under limit
        if (goalValue < [[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Goal"] intValue]) {
            self.mLbsLbl.text = @"Under limit";
        }
        //at limit
        else if (goalValue == [[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Goal"] intValue]) {
            self.mLbsLbl.text = @"At limit";
            
        }//Over limit
        else if (goalValue > [[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Goal"] intValue]) {
            self.mLbsLbl.text = @"Over limit";
            
        }
        self.mWeightimgView.hidden  = FALSE;


    }//positive goals
    else if ([[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Category"] intValue] > 0) {
        self.mLbsLbl.text = [NSString stringWithFormat:@"%d",[[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Achievement"] intValue]];
        self.mLbsLbl.text = [self.mLbsLbl.text stringByAppendingString:@"%"];
        self.mWeightimgView.hidden  = FALSE;

        
    }
    //free form goals
    else if ([[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Category"] intValue] == 0) {
        self.mLbsLbl.text = @"";
        self.mWeightimgView.hidden  = TRUE;
    }
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollview.frame = CGRectMake(self.mScrollview.frame.origin.x, self.mScrollview.frame.origin.y, 320, 504);
    }
    //to check whether has any exercise logs or not if yes display a message
    if (mAppDelegate_.mTrackerDataGetter_.mGoalList_.count == 0) {
        self.mTopView.hidden = TRUE;
        self.mTableView.hidden = TRUE;
        self.mMsgLbl.hidden = FALSE;
        self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, 25, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
        self.mLineImgView.frame = CGRectMake(self.mLineImgView.frame.origin.x, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, self.mLineImgView.frame.size.width, self.mLineImgView.frame.size.height);
        self.mMsgLbl.frame = CGRectMake(self.mMsgLbl.frame.origin.x, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height+10, self.mMsgLbl.frame.size.width, self.mMsgLbl.frame.size.height);
        self.mScrollview.contentSize = CGSizeMake(320, self.mMsgLbl.frame.origin.y+self.mMsgLbl.frame.size.height+20);
    }else{
        self.mWeekBtn.selected = TRUE;
        [self categorizeGoalsByDate];
        [self loadGraphData];
        self.mTopView.hidden = FALSE;
        self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, self.mTopView.frame.origin.y+self.mTopView.frame.size.height+35, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
        self.mLineImgView.frame = CGRectMake(0, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, 320, 1);
        self.mTableView.frame = CGRectMake(0, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height, 320, self.mTableView.frame.size.height);
        
        
        NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
        [GenricUI setLocaleZoneForDateFormatter:lFormatter];
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:0] objectForKey:@"Date"]];
        if (lDate == nil) {
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:0] objectForKey:@"Date"]];
            
        }
        [lFormatter setDateFormat:@"MM/dd/yy"];
        NSString *lStr = [lFormatter stringFromDate:lDate];
        self.mLastLogLbl.text = [NSString stringWithFormat:@"Last logged on %@",lStr];
        
        self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mTableView.frame.origin.y, 320, [self caluclateTableHeight]);
        self.mScrollview.contentSize = CGSizeMake(320, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+20);
        [self.mTableView reloadData];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"Goals List View";
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"GOAL_TRACKER", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];//need to change to cancel button
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"addicon.png"] title:nil target:self action:@selector(addLogAction:) forController:self rightOrLeft:1];
    
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollview.frame = CGRectMake(self.mScrollview.frame.origin.x, self.mScrollview.frame.origin.y, 320, 504);
    }
    
}
- (void)categorizeGoalsByDate{
    [self.mGoalsDict removeAllObjects];
    for (int i = 0; i < mAppDelegate_.mTrackerDataGetter_.mGoalList_.count; i++) {
        NSString *mDate = [[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:i] objectForKey:@"Date"];
        
        //to check whether already the particular date objects are added or not
        BOOL flag = TRUE;
        NSArray *KeysArray = [self.mGoalsDict allKeys];
        if (KeysArray.count >0) {
            for (int keyCount = 0; keyCount < KeysArray.count; keyCount++) {
                
                NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
                [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                [GenricUI setLocaleZoneForDateFormatter:lFormatter];
                NSDate *lDate1 = [lFormatter dateFromString:mDate];
                
                [lFormatter setDateFormat:@"MM/dd/yy"];
                NSString *lStrComp1 = [lFormatter stringFromDate:lDate1];
                
                NSString *tmpDate = [KeysArray objectAtIndex:keyCount];
                [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSDate *lDate2 = [lFormatter dateFromString:tmpDate];
                
                [lFormatter setDateFormat:@"MM/dd/yy"];
                NSString *lStrComp2 = [lFormatter stringFromDate:lDate2];

                
                if ([lStrComp1 isEqualToString:lStrComp2] && flag) {
                    flag = FALSE;
                }
            }
        }
        //to retrieve the objects for particular dates and load into the dictionary
        if (flag) {
            NSMutableArray *mTemarray = [[NSMutableArray alloc] init];
            
            for (int j = 0; j < mAppDelegate_.mTrackerDataGetter_.mGoalList_.count; j++) {
                
                NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
                [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                [GenricUI setLocaleZoneForDateFormatter:lFormatter];
                NSDate *lDate1 = [lFormatter dateFromString:mDate];
                
                [lFormatter setDateFormat:@"MM/dd/yy"];
                NSString *lStrComp1 = [lFormatter stringFromDate:lDate1];
                
               NSString *tmpDate = [[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:j] objectForKey:@"Date"];
                [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSDate *lDate2 = [lFormatter dateFromString:tmpDate];
                
                [lFormatter setDateFormat:@"MM/dd/yy"];
                NSString *lStrComp2 = [lFormatter stringFromDate:lDate2];
                
                if ([lStrComp1 isEqualToString:lStrComp2]) {
                    [mTemarray addObject:[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:j]];
                }
            }
            [self.mGoalsDict setValue:mTemarray forKey:mDate];
        }
    }
    [self compareTheDatesandSortTheresponse];
    
}
/* Back up
 - (void)categorizeGoalsByDate{
 [self.mGoalsDict removeAllObjects];
 for (int i = 0; i < mAppDelegate_.mTrackerDataGetter_.mGoalList_.count; i++) {
 NSString *mDate = [[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:i] objectForKey:@"Date"];
 
 //to check whether already the particular date objects are added or not
 BOOL flag = TRUE;
 NSArray *KeysArray = [self.mGoalsDict allKeys];
 if (KeysArray.count >0) {
 for (int keyCount = 0; keyCount < KeysArray.count; keyCount++) {
 if ([[KeysArray objectAtIndex:keyCount] isEqualToString:mDate] && flag) {
 flag = FALSE;
 }
 }
 }
 //to retrieve the objects for particular dates and load into the dictionary
 if (flag) {
 NSMutableArray *mTemarray = [[NSMutableArray alloc] init];
 
 for (int j = 0; j < mAppDelegate_.mTrackerDataGetter_.mGoalList_.count; j++) {
 if ([[[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:j] objectForKey:@"Date"] isEqualToString:mDate]) {
 [mTemarray addObject:[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:j]];
 }
 }
 [self.mGoalsDict setValue:mTemarray forKey:mDate];
 }
 }
 [self compareTheDatesandSortTheresponse];
 
 }
*/
- (NSMutableArray*)compareTheDatesandSortTheresponse{
    NSArray *keys = [self.mGoalsDict allKeys];
    NSMutableArray *allKeys = [[NSMutableArray alloc]initWithArray:keys];
    if (allKeys.count>1) {
        NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init];
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        [GenricUI setLocaleZoneForDateFormatter:lFormatter];
        for (int i =0; i < allKeys.count-1; i++) {
      
            NSDate *lDate1 = [lFormatter dateFromString:[allKeys objectAtIndex:i]];
            for (int j = i+1; j < allKeys.count; j++) {
                NSDate *lDate2 = [lFormatter dateFromString:[allKeys objectAtIndex:j]];
                NSComparisonResult result = [lDate1 compare:lDate2];
                
                if(result==NSOrderedAscending){
                }
                else if(result==NSOrderedDescending){
                    [allKeys exchangeObjectAtIndex:i withObjectAtIndex:j];
                    
                }

            }
                              
        }
    }
    NSArray *reverseArray = [[allKeys reverseObjectEnumerator] allObjects];
    allKeys = [NSMutableArray arrayWithArray:reverseArray];
    return allKeys;
}
- (void)loadGraphData
{
    
    //to check whether the goal is set up by the user or not
    NSMutableArray *datesArray = [[NSMutableArray alloc]init];
    NSString *goalValue;
    if ([mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ isKindOfClass:[NSDictionary class]]) {
        //to add previous day date
        if ([[mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ objectForKey:@"ChartData"] count]>0 && [[mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ objectForKey:@"ChartData"] count] == 1) {
            NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
            [GenricUI setLocaleZoneForDateFormatter:lFormatter];
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *lDate = [lFormatter dateFromString:[[[mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ objectForKey:@"ChartData"] objectAtIndex:0] objectForKey:@"Date"]];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                           toDate:lDate
                                                          options:0];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setValue:[lFormatter stringFromDate:yesterday] forKey:@"Date"];
            int index = [[mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ objectForKey:@"ChartData"] count]-1;
            [mDict setValue:[[[mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ objectForKey:@"ChartData"] objectAtIndex:index]objectForKey:@"Value"] forKey:@"Value"];
            [datesArray addObject:mDict];
        }
        //end

        //has goal
        [datesArray addObjectsFromArray:[mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ objectForKey:@"ChartData"]];
        goalValue = [NSString stringWithFormat:@"%d", [[mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ objectForKey:@"Goal"] intValue]];
    }else{
        //to add previous day date
        if ([mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_  count]>0 && [mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_  count] == 1) {
            NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
            [GenricUI setLocaleZoneForDateFormatter:lFormatter];
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ objectAtIndex:0] objectForKey:@"Date"]];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                           toDate:lDate
                                                          options:0];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setValue:[lFormatter stringFromDate:yesterday] forKey:@"Date"];
            int index = [mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_  count]-1;
            [mDict setValue:[[mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ objectAtIndex:index]objectForKey:@"Value"] forKey:@"Value"];
            [datesArray addObject:mDict];
        }
        //end

        //no goal
        [datesArray addObjectsFromArray:mAppDelegate_.mTrackerDataGetter_.mGoalChartDict_ ];
        goalValue = nil;
        
    }
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
        NSDate *lDate = [lFormatter dateFromString:[[datesArray objectAtIndex:i] objectForKey:@"Date"]];
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
        yValue = [[[datesArray objectAtIndex:0] objectForKey:@"Value"] intValue];
        for (int iCount = 1; iCount < [datesArray count]; iCount++) {
            int value = [[[datesArray objectAtIndex:iCount] objectForKey:@"Value"] intValue];
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
        NSValue *graphPoint = [NSValue valueWithCGPoint:CGPointMake(i, [[[datesArray objectAtIndex:i] objectForKey:@"Value"] intValue])];
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
    return [[self compareTheDatesandSortTheresponse] count];
    //return 1;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }else{
        return 70;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat height;
    if (section == 0) {
        height = 40;
    }else{
        height = 70;
    }
    
    UIView *lheaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    NSMutableArray *allKeys = [self compareTheDatesandSortTheresponse];
    
    //date label
    UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, lheaderView.frame.size.height -25 -5, 200, 25)];//height and gap
    lLabel.font = Bariol_Regular(17);
    lLabel.textColor = LIGHT_GRAY_COLOR;
    NSDateFormatter *ldateformatter = [[NSDateFormatter alloc]init];
    [GenricUI setLocaleZoneForDateFormatter:ldateformatter];
    [ldateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *lDate = [ldateformatter dateFromString:[allKeys objectAtIndex:section]];
    if (lDate == nil) {
        [ldateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        lDate = [ldateformatter dateFromString:[allKeys objectAtIndex:section]];
        
    }
    [ldateformatter setDateFormat:@"MMM dd, yyyy"];
    lLabel.text = [ldateformatter stringFromDate:lDate];
    [lheaderView addSubview:lLabel];
    
    //line img
    UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, lheaderView.frame.size.height-1, 320, 1)];
    lImgView.image = [UIImage imageNamed:@"divider1.png"];
    lImgView.backgroundColor = CLEAR_COLOR;
    [lheaderView addSubview:lImgView];
    
    return lheaderView;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *allKeys = [self compareTheDatesandSortTheresponse];
    int rowsCount = [[self.mGoalsDict objectForKey:[allKeys objectAtIndex:section]] count];
    return rowsCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height =0.0;
    UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 260-15, 50)];
    lLabel.textColor = BLACK_COLOR;
    lLabel.font = Bariol_Regular(17);
    lLabel.numberOfLines =0;
    lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    NSMutableArray *allKeys = [self compareTheDatesandSortTheresponse];
    lLabel.text = [[[self.mGoalsDict objectForKey:[allKeys objectAtIndex:indexPath.section]]  objectAtIndex:indexPath.row] objectForKey:@"Label"];
    
    CGSize size = [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (lLabel.text.length > 0)
    {
        if (size.height < 50) {
            size.height = 50;
        }
    }
    
    //note label
    UILabel *noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 260-15, 0)];
    noteLabel.font = Bariol_Regular(17);
    noteLabel.numberOfLines =0;
    noteLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    NSString *noteStr = [[[self.mGoalsDict objectForKey:[allKeys objectAtIndex:indexPath.section]]  objectAtIndex:indexPath.row] objectForKey:@"Notes"];
    CGFloat noteHeight =0.0;
    if (noteStr && ![noteStr isEqualToString:@""]) {
        noteLabel.text = noteStr;
       CGSize noteSize = [noteLabel.text sizeWithFont:noteLabel.font constrainedToSize:CGSizeMake(noteLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        noteHeight = noteSize.height;
    }


    
    height = height+ size.height + noteHeight +15;
    return height;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.clearsContextBeforeDrawing=TRUE;
        
        //imgview
        
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15/2, 35, 35)];
        lImgView.backgroundColor = CLEAR_COLOR;
        lImgView.contentMode = UIViewContentModeScaleAspectFit;
        [lImgView setTag:1];
        [cell.contentView addSubview:lImgView];
        
        //goal label
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 260-15, 40)];
        lLabel.textColor = BLACK_COLOR;
        lLabel.font = Bariol_Regular(17);
        lLabel.numberOfLines =0;
        lLabel.backgroundColor = CLEAR_COLOR;
        lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lLabel.tag = 2;
        [cell.contentView addSubview:lLabel];
        
        //note label
        UILabel *noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 260-15, 0)];
        noteLabel.textColor = RGB_A(136, 136, 136, 1);
        noteLabel.font = Bariol_Regular(17);
        noteLabel.numberOfLines =0;
        noteLabel.backgroundColor = CLEAR_COLOR;
        noteLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        noteLabel.tag = 3;
        [cell.contentView addSubview:noteLabel];
        
        //line image
        UIImageView *lImgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
        lImgView2.backgroundColor = RGB_A(204, 204, 204, 1);
        lImgView2.tag = 4;
        [cell.contentView addSubview:lImgView2];
        
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *limage1 = (UIImageView*)[cell.contentView viewWithTag:1];
    UILabel *lTextLblIns= (UILabel*)[cell.contentView viewWithTag:2];
    limage1.image = [UIImage imageNamed:@"goal.png"];
    
    NSMutableArray *allKeys = [self compareTheDatesandSortTheresponse];

    lTextLblIns.text = [[[self.mGoalsDict objectForKey:[allKeys objectAtIndex:indexPath.section]]  objectAtIndex:indexPath.row] objectForKey:@"Label"];
   CGSize size = [lTextLblIns.text sizeWithFont:lTextLblIns.font constrainedToSize:CGSizeMake(lTextLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (size.height < 50) {
        size.height = 50;
    }
    lTextLblIns.frame = CGRectMake(lTextLblIns.frame.origin.x, lTextLblIns.frame.origin.y, lTextLblIns.frame.size.width, size.height);
    
    //note label
     UILabel *lNoteLblIns= (UILabel*)[cell.contentView viewWithTag:3];
    NSString *noteStr = [[[self.mGoalsDict objectForKey:[allKeys objectAtIndex:indexPath.section]]  objectAtIndex:indexPath.row] objectForKey:@"Notes"];
    if (noteStr && ![noteStr isEqualToString:@""]) {
        NSLog(@"noteStr: %@",noteStr);
        lNoteLblIns.text = noteStr;
        size = [lNoteLblIns.text sizeWithFont:lNoteLblIns.font constrainedToSize:CGSizeMake(lNoteLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        lNoteLblIns.frame = CGRectMake(lNoteLblIns.frame.origin.x, lTextLblIns.frame.origin.y+lTextLblIns.frame.size.height+5, lNoteLblIns.frame.size.width, size.height);
    }
    
    //line image
    UIImageView *limage2 = (UIImageView*)[cell.contentView viewWithTag:4];
    limage2.frame = CGRectMake(limage2.frame.origin.x, lTextLblIns.frame.size.height+lNoteLblIns.frame.size.height+15-1, limage2.frame.size.width, limage2.frame.size.height);
    
    limage1.frame = CGRectMake(limage1.frame.origin.x, (lTextLblIns.frame.size.height+10-limage1.frame.size.height)/2, limage1.frame.size.width, limage1.frame.size.height);

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
    [GenricUI showAlertWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"DELETE_GOAL_LOG", nil) cancelButton:@"No" delegates:self button1Titles:@"Yes" button2Titles:nil tag:400];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 400) {
        if (buttonIndex == 1) {
            NSMutableArray *allKeys = [self compareTheDatesandSortTheresponse];
            NSString *mLogId = [NSString stringWithFormat:@"%d", [[[[self.mGoalsDict objectForKey:[allKeys objectAtIndex:self.mSelectdIndex.section]]  objectAtIndex:self.mSelectdIndex.row] objectForKey:@"LogID"] intValue]];
            //to delete the logweight
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                mAppDelegate_.mRequestMethods_.mViewRefrence = self;
                [mAppDelegate_.mRequestMethods_ postRequestToDeleteGoal:mLogId
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
- (void)reloadContentsOftableView
{
    //to check whether has any exercise logs or not if yes display a message
    if (mAppDelegate_.mTrackerDataGetter_.mGoalList_.count == 0) {
        self.mTopView.hidden = TRUE;
        self.mTableView.hidden = TRUE;
        self.mMsgLbl.hidden = FALSE;
        self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, 25, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
        self.mLineImgView.frame = CGRectMake(self.mLineImgView.frame.origin.x, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, self.mLineImgView.frame.size.width, self.mLineImgView.frame.size.height);
        self.mMsgLbl.frame = CGRectMake(self.mMsgLbl.frame.origin.x, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height+10, self.mMsgLbl.frame.size.width, self.mMsgLbl.frame.size.height);
        self.mScrollview.contentSize = CGSizeMake(320, self.mMsgLbl.frame.origin.y+self.mMsgLbl.frame.size.height+20);
    }else{
        CGFloat yPos = 0;
        if ([self.mRange isEqualToString:@"Week"]) {
            yPos = 270;
        }else{
            yPos = 295;
        }
        self.mWeekBtn.frame = CGRectMake(self.mWeekBtn.frame.origin.x, yPos, self.mWeekBtn.frame.size.width, self.mWeekBtn.frame.size.height);
        self.mMonthBtn.frame = CGRectMake(self.mMonthBtn.frame.origin.x, yPos, self.mMonthBtn.frame.size.width, self.mMonthBtn.frame.size.height);
        self.m3MonthsBtn.frame = CGRectMake(self.m3MonthsBtn.frame.origin.x, yPos, self.m3MonthsBtn.frame.size.width, self.m3MonthsBtn.frame.size.height);
        self.mTopView.frame = CGRectMake(self.mTopView.frame.origin.x, 0, self.mTopView.frame.size.width, yPos+30+5);
        
        
        NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
        [GenricUI setLocaleZoneForDateFormatter:lFormatter];
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:0] objectForKey:@"Date"]];
        if (lDate == nil) {
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:0] objectForKey:@"Date"]];
            
        }
        [lFormatter setDateFormat:@"MM/dd/yy"];
        NSString *lStr = [lFormatter stringFromDate:lDate];
        self.mLastLogLbl.text = [NSString stringWithFormat:@"Last logged on %@",lStr];
        //negative goals
        if ([[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Category"] intValue] < 0) {
            float goalValue = [[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Achievement"] intValue]* [[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Goal"] floatValue];
            goalValue = goalValue/100.0f;
            //under limit
            if (goalValue < [[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Goal"] intValue]) {
                self.mLbsLbl.text = @"Under limit";
            }
            //at limit
            else if (goalValue == [[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Goal"] intValue]) {
                self.mLbsLbl.text = @"At limit";
                
            }//Over limit
            else if (goalValue > [[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Goal"] intValue]) {
                self.mLbsLbl.text = @"Over limit";
                
            }
            self.mWeightimgView.hidden  = FALSE;

            
        }//positive goals
        else if ([[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Category"] intValue] > 0) {
            self.mLbsLbl.text = [NSString stringWithFormat:@"%d",[[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Achievement"] intValue]];
            self.mLbsLbl.text = [self.mLbsLbl.text stringByAppendingString:@"%"];
            self.mWeightimgView.hidden  = FALSE;

            
        }
        //free form goals
        else if ([[mAppDelegate_.mTrackerDataGetter_.mGoalStepProgressDict__ objectForKey:@"Category"] intValue] == 0) {
            self.mLbsLbl.text = @"";
            self.mWeightimgView.hidden  = TRUE;

        }

        
        self.mTopView.hidden = FALSE;
        self.mTableView.hidden = FALSE;
        self.mMsgLbl.hidden = TRUE;
        
        [self categorizeGoalsByDate];
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
    
    
}
- (void)addLogAction:(id)sender {
    AddGoalViewController *lVc = [[AddGoalViewController alloc]initWithNibName:@"AddGoalViewController" bundle:nil];
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
    [self postRequestForGaolGraph];
    
}

- (IBAction)monthAction:(id)sender {
    self.mMonthBtn.selected = TRUE;
    self.mWeekBtn.selected = FALSE;
    self.m3MonthsBtn.selected = FALSE;
    self.mRange = @"Month";
    [self postRequestForGaolGraph];
    
    
}

- (IBAction)weekAction:(id)sender {
    self.mMonthBtn.selected = FALSE;
    self.mWeekBtn.selected = TRUE;
    self.m3MonthsBtn.selected = FALSE;
    self.mRange = @"Week";
    [self postRequestForGaolGraph];
    
    
}
- (void)postRequestForGaolGraph{
    //to get the weight log chart data
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        mAppDelegate_.mRequestMethods_.mViewRefrence = self;
        [mAppDelegate_.mRequestMethods_ postRequestToGetGoalChartData:self.mStepID
                                                                Range:self.mRange
                                                            AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                         SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
}

- (CGFloat)caluclateTableHeight{
    int sectionsCount = [[self.mGoalsDict allKeys] count];
    CGFloat height = 40;//first section height
    height += (sectionsCount -1)*70; //for all headers
    
   // int rowsCount = mAppDelegate_.mTrackerDataGetter_.mGoalList_.count;
    //height += rowsCount*50; //each row height =50;
    
    for (int i =0; i < mAppDelegate_.mTrackerDataGetter_.mGoalList_.count; i++) {
        height+= 5;
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 260-15, 50)];
        lLabel.textColor = BLACK_COLOR;
        lLabel.font = Bariol_Regular(17);
        lLabel.numberOfLines =0;
        lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lLabel.text = [[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:i] objectForKey:@"Label"];
        CGSize size = [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        if (lLabel.text.length > 0)
        {
            if (size.height < 50) {
                size.height = 50;
            }
            height+=size.height;
        }
        
        
        //note label
        UILabel *noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 260-15, 0)];
        noteLabel.font = Bariol_Regular(17);
        noteLabel.numberOfLines =0;
        noteLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        NSString *noteStr = [[mAppDelegate_.mTrackerDataGetter_.mGoalList_ objectAtIndex:i] objectForKey:@"Notes"];
        CGFloat noteHeight = 0.0;
        if (noteStr && ![noteStr isEqualToString:@""]) {
            noteLabel.text = noteStr;
            CGSize noteSize = [noteLabel.text sizeWithFont:noteLabel.font constrainedToSize:CGSizeMake(noteLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
            noteHeight = noteSize.height;
        }
        
        height = height + noteHeight + 10;//last gap
    }

    return height;
    
}
- (IBAction)typeAction:(id)sender {
    [self displayPickerview];
    
}
- (void)displayPickerview {
    
    PickerViewController *screen = [[PickerViewController alloc] init];
    NSMutableArray *rowValuesArr_=[[NSMutableArray alloc] init];
    NSMutableArray *lValues = [[NSMutableArray alloc]init];
    for (int iStepCount = 0; iStepCount < mAppDelegate_.mTrackerDataGetter_.mGoalStepList_.count; iStepCount++) {
        
        NSString* lblName = [[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"Label"];
        if (![lblName isEqualToString:ANNOTATETEXT]) {
            [lValues addObject:lblName];
        }
    }
    [rowValuesArr_ addObject:lValues];
    screen.mRowValueintheComponent=rowValuesArr_;
    screen->mNoofComponents=[rowValuesArr_ count];
    screen.mTextDisplayedlb.text=@"Select Goal Step";
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
        for (int iStepCount = 0; iStepCount < mAppDelegate_.mTrackerDataGetter_.mGoalStepList_.count; iStepCount++) {
            if ([mData_ isEqualToString:[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"Label"]]) {
                self.mStepID = [NSString stringWithFormat:@"%d",[[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"GoalStep"] intValue] ];
                self.mUserStepID = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"UserStepID"] intValue]];

            }
        }
        if([controller superview]){
			[controller removeFromSuperview];
		}
        //[self reloadContentsOftableView];
        [self postRequestForGaolGraph];
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
    NSMutableArray *lValues = [[NSMutableArray alloc]init];
    for (int iStepCount = 0; iStepCount < mAppDelegate_.mTrackerDataGetter_.mGoalStepList_.count; iStepCount++) {
        [lValues addObject:[[mAppDelegate_.mTrackerDataGetter_.mGoalStepList_ objectAtIndex:iStepCount] objectForKey:@"Label"]];
    }
    if (component==0)
        return [lValues objectAtIndex:row];
    else
        return @"";
	
    
}

@end

