//
//  CholesterolListViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 19/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "CholesterolListViewController.h"
#import "AddCholesterolViewController.h"
@interface CholesterolListViewController ()

@end

@implementation CholesterolListViewController

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
    self.mSwipeGes = sgrLeft;
    [sgrLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.mTableView addGestureRecognizer:sgrLeft];
    [mAppDelegate_ hideEmptySeparators:self.self.mTableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];

    }

    self.mLogLbl.font = Bariol_Regular(22);
    self.mLogLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mLastLogLbl.font = Bariol_Regular(14);
    self.mLastLogLbl.textColor = RGB_A(102, 102, 102, 1);
    self.mMsgLbl.font = Bariol_Regular(17);
    self.mMsgLbl.textColor = [UIColor darkGrayColor];
    self.mRange = @"Week";
    self.mCholeslbl.font = Bariol_Regular(40);
    self.mCholeslbl.textColor = RGB_A(51, 51, 51, 1);
    self.mMgLbl.font = Bariol_Regular(18);
    self.mMgLbl.textColor = RGB_A(51, 51, 51, 1);
    self.mTypeLbl.font = Bariol_Regular(17);
    self.mTypeLbl.text = @"Total Cholesterol";
    self.mWeekBtn.selected = TRUE;

    if ([[GenricUI instance] isiPhone5]) {
        self.mScrolView.frame = CGRectMake(self.mScrolView.frame.origin.x, self.mScrolView.frame.origin.y, 320, 504);
    }
    if (mAppDelegate_.mTrackerDataGetter_.mCholesterolList_.count == 0) {
        
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:CHOLESTREOLCAMERALAYER];
        if (!isCameraLayer) {
            BOOL isTop = [loginUserDefaults boolForKey:CHOLESTREOLTOPCAMERALAYER];
            if (!isTop) {
                [self showCameraGuideTop];
            }
        }
        self.mTopView.hidden = TRUE;
        self.mTableView.hidden = TRUE;
        self.mMsgLbl.hidden = FALSE;
        self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, 25, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
        self.mLineImgView.frame = CGRectMake(self.mLineImgView.frame.origin.x, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, self.mLineImgView.frame.size.width, self.mLineImgView.frame.size.height);
        self.mMsgLbl.frame = CGRectMake(self.mMsgLbl.frame.origin.x, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height+10, self.mMsgLbl.frame.size.width, self.mMsgLbl.frame.size.height);
        self.mScrolView.contentSize = CGSizeMake(320, self.mMsgLbl.frame.origin.y+self.mMsgLbl.frame.size.height+20);
    }else{
        
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:CHOLESTREOLCAMERALAYER];//FALSE;//
        if (!isCameraLayer) {
            [self showCameraGuide];
        }
        NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
        [GenricUI setLocaleZoneForDateFormatter:lFormatter];
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"Date"]];
        if (lDate == nil) {
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"Date"]];
            
        }
        [lFormatter setDateFormat:@"MM/dd/yy"];
        NSString *lStr = [lFormatter stringFromDate:lDate];
        self.mLastLogLbl.text = [NSString stringWithFormat:@"Last logged on %@",lStr];
        
        self.mCholeslbl.text = [NSString stringWithFormat:@"%.1f", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"TotalCholesterol"] floatValue]];
        NSString* mText = [self.mCholeslbl.text substringFromIndex:[self.mCholeslbl.text rangeOfString:@"."].location];
        mText = [mText stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([mText intValue] == 0) {
            self.mCholeslbl.text = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"TotalCholesterol"] intValue]];
        }

        CGSize size =  [self.mCholeslbl.text sizeWithFont:self.mCholeslbl.font constrainedToSize:CGSizeMake(self.mCholeslbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        self.mCholeslbl.frame = CGRectMake(self.mCholeslbl.frame.origin.x, self.mCholeslbl.frame.origin.y, size.width, self.mCholeslbl.frame.size.height);
        self.mMgLbl.frame = CGRectMake(self.mCholeslbl.frame.origin.x+size.width+3, self.mMgLbl.frame.origin.y, self.mMgLbl.frame.size.width, self.mMgLbl.frame.size.height);
        [self loadGraphData];

        self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, self.mTopView.frame.origin.y+self.mTopView.frame.size.height+35, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
        self.mLineImgView.frame = CGRectMake(self.mLineImgView.frame.origin.x, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, self.mLineImgView.frame.size.width, self.mLineImgView.frame.size.height);
        self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height, 320, [self caluclateTableHeight]);
        self.mScrolView.contentSize = CGSizeMake(320, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+20);
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"Cholesterol Tracker";
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"CHOLESTEROL_TRACKER", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];//need to change to cancel button
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"addicon.png"] title:nil target:self action:@selector(addLogAction:) forController:self rightOrLeft:1];
    
}

- (void)loadGraphData
{

    NSString *mKeyValue =@"";
    if ([self.mTypeLbl.text isEqualToString:@"Total Cholesterol"]) {
        mKeyValue = @"TotalCholesterol";
    }else if ([self.mTypeLbl.text isEqualToString:@"LDL Cholesterol"]) {
        mKeyValue = @"LDLCholesterol";
    }else{
        mKeyValue = @"HDLCholesterol";

    }
    //to check whether the goal is set up by the user or not
    NSMutableArray *datesArray = [[NSMutableArray alloc]init];
    NSString *goalValue;
    if ([mAppDelegate_.mTrackerDataGetter_.mCholChartDict_ isKindOfClass:[NSDictionary class]]) {
        //to add previous day date
        if ([[mAppDelegate_.mTrackerDataGetter_.mCholChartDict_ objectForKey:@"ChartData"] count]>0 && [[mAppDelegate_.mTrackerDataGetter_.mCholChartDict_ objectForKey:@"ChartData"] count] == 1) {
            NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
            [GenricUI setLocaleZoneForDateFormatter:lFormatter];
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *lDate = [lFormatter dateFromString:[[[mAppDelegate_.mTrackerDataGetter_.mCholChartDict_ objectForKey:@"ChartData"] objectAtIndex:0] objectForKey:@"Date"]];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                           toDate:lDate
                                                          options:0];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setValue:[lFormatter stringFromDate:yesterday] forKey:@"Date"];
            [mDict setValue:self.mCholeslbl.text forKey:@"TotalCholesterol"];
            [mDict setValue:self.mCholeslbl.text forKey:@"LDLCholesterol"];
            [mDict setValue:self.mCholeslbl.text forKey:@"HDLCholesterol"];

            [datesArray addObject:mDict];
        }
        //end

        //has goal
        [datesArray addObjectsFromArray:[mAppDelegate_.mTrackerDataGetter_.mCholChartDict_ objectForKey:@"ChartData"]];
        goalValue = [NSString stringWithFormat:@"%d", [[mAppDelegate_.mTrackerDataGetter_.mCholChartDict_ objectForKey:@"Goal"] intValue]];
    }else{
        //to add previous day date
        if ([mAppDelegate_.mTrackerDataGetter_.mCholChartDict_  count]>0 && [mAppDelegate_.mTrackerDataGetter_.mCholChartDict_  count] == 1) {
            NSDateFormatter *lFormatter = [[NSDateFormatter alloc] init];
            [GenricUI setLocaleZoneForDateFormatter:lFormatter];
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mCholChartDict_ objectAtIndex:0] objectForKey:@"Date"]];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                           toDate:lDate
                                                          options:0];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setValue:[lFormatter stringFromDate:yesterday] forKey:@"Date"];
            [mDict setValue:self.mCholeslbl.text forKey:@"TotalCholesterol"];
            [mDict setValue:self.mCholeslbl.text forKey:@"LDLCholesterol"];
            [mDict setValue:self.mCholeslbl.text forKey:@"HDLCholesterol"];
            
            [datesArray addObject:mDict];
        }
        //end

        //no goal
        [datesArray addObjectsFromArray:mAppDelegate_.mTrackerDataGetter_.mCholChartDict_ ];
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
    //to get the highest yaxis value
    int yValue = 0;
    
    if ([datesArray count]!=0) {
        //to get the highest yaxis value
        yValue = [[[datesArray objectAtIndex:0] objectForKey:mKeyValue] intValue];
        for (int iCount = 1; iCount < [datesArray count]; iCount++) {
            int value = [[[datesArray objectAtIndex:iCount] objectForKey:mKeyValue] intValue];
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
        NSValue *graphPoint = [NSValue valueWithCGPoint:CGPointMake(i, [[[datesArray objectAtIndex:i] objectForKey:mKeyValue] intValue])];
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
    height+= 145;
    UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 30)];
    lLabel.textColor = RGB_A(114, 105, 89, 1);
    lLabel.font = [UIFont italicSystemFontOfSize:14];
    lLabel.numberOfLines =0;
    lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    lLabel.text = [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:indexPath.row] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    CGSize size = [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (lLabel.text.length > 0)
    {
        if (size.height < 20) {
            size.height = 20;
        }
        height+=5+size.height;
    }
    height+=10;//to last gap
    return height;
    
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mAppDelegate_.mTrackerDataGetter_.mCholesterolList_.count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.clearsContextBeforeDrawing=TRUE;
        
        //date Label
        UILabel *lDateLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 180, 30)];
        [lDateLbl setBackgroundColor:[UIColor clearColor]];
        [lDateLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lDateLbl setFont:Bariol_Regular(17)];
        lDateLbl.tag =1;
        [lDateLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lDateLbl];
        
        int tag =2;
        CGFloat yPos = 10+30+5;
        for (int i =0; i < 3; i++) {
            //static text label
            UILabel *lTextlbl = [[UILabel alloc]initWithFrame:CGRectMake(15, yPos, 200, 30)];
            lTextlbl.font = Bariol_Regular(17);
            lTextlbl.textColor = BLACK_COLOR;
            lTextlbl.tag = tag;
            tag++;
            lTextlbl.backgroundColor = CLEAR_COLOR;
            if (i == 0) {
                lTextlbl.text = @"Total Cholesterol";
            }else if(i == 1){
                lTextlbl.text = @"LDL Cholesterol";

            }else{
                lTextlbl.text = @"HDL Cholesterol";
                
            }
            CGSize size =  [lTextlbl.text sizeWithFont:lTextlbl.font constrainedToSize:CGSizeMake(lTextlbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
            lTextlbl.frame = CGRectMake(lTextlbl.frame.origin.x, lTextlbl.frame.origin.y, size.width, lTextlbl.frame.size.height);
            [cell.contentView addSubview:lTextlbl];
            
            //measured at label
            UILabel *lLbl = [[UILabel alloc]initWithFrame:CGRectMake(lTextlbl.frame.size.width+lTextlbl.frame.origin.x+3, yPos, 200, 30)];
            lLbl.font = Bariol_Regular(17);
            lLbl.textColor = RGB_A(136, 136, 136, 1);
            lLbl.tag = tag;
            lLbl.text = @"measured at";
            tag++;
            lLbl.backgroundColor = CLEAR_COLOR;
            size =  [lLbl.text sizeWithFont:lLbl.font constrainedToSize:CGSizeMake(lLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
            lLbl.frame = CGRectMake(lLbl.frame.origin.x, lLbl.frame.origin.y, size.width, lLbl.frame.size.height);
            [cell.contentView addSubview:lLbl];
            
            //value label
            UILabel *lValueLbl = [[UILabel alloc]initWithFrame:CGRectMake(lLbl.frame.size.width+lLbl.frame.origin.x+3, yPos, 260, 30)];
            lValueLbl.font = Bariol_Bold(17);
            lValueLbl.textColor = BLACK_COLOR;
            lValueLbl.tag = tag;
            lValueLbl.text = @"190 mg/dL";
            tag++;
            lValueLbl.backgroundColor = CLEAR_COLOR;
            [cell.contentView addSubview:lValueLbl];
            yPos+=30+5;

        }
        //notes label
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, yPos, 290, 20)];
        lLabel.textColor = RGB_A(114, 105, 89, 1);
        lLabel.font = [UIFont italicSystemFontOfSize:14];
        lLabel.numberOfLines =0;
        lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lLabel.tag = tag;
        [cell.contentView addSubview:lLabel];
              
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    //UIImageView *limage1 = (UIImageView*)[cell.contentView viewWithTag:1];
    UILabel *lDateLblIns= (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *lTotalLblIns= (UILabel*)[cell.contentView viewWithTag:4];
    UILabel *lLDLLblIns= (UILabel*)[cell.contentView viewWithTag:7];
    UILabel *lHDLLblIns= (UILabel*)[cell.contentView viewWithTag:10];
    UILabel *lNotesLblIns = (UILabel*)[cell.contentView viewWithTag:11];

    NSDateFormatter *lFormatter=[[NSDateFormatter alloc]init];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [lFormatter setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    lFormatter.locale = enLocale;
    NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:indexPath.row] objectForKey:@"Date"]];
    if (lDate == nil) {
        [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:indexPath.row] objectForKey:@"Date"]];
        
    }
    [lFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    lDateLblIns.text = [lFormatter stringFromDate:lDate];
   
    lTotalLblIns.text = [NSString stringWithFormat:@"%.1f mg/dL", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:indexPath.row] objectForKey:@"TotalCholesterol"] floatValue]];
    lLDLLblIns.text = [NSString stringWithFormat:@"%.1f mg/dL", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:indexPath.row] objectForKey:@"LDLCholesterol"] floatValue]];
    lHDLLblIns.text = [NSString stringWithFormat:@"%.1f mg/dL", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:indexPath.row] objectForKey:@"HDLCholesterol"] floatValue]];

    lNotesLblIns.text = [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:indexPath.row] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    CGSize size = [lNotesLblIns.text sizeWithFont:lNotesLblIns.font constrainedToSize:CGSizeMake(lNotesLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (size.height < 20) {
        size.height = 20;
    }
    lNotesLblIns.frame = CGRectMake(15, lNotesLblIns.frame.origin.y, 290, size.height);
    if (lNotesLblIns.text.length == 0) {
        lNotesLblIns.hidden = TRUE;
    }else{
        lNotesLblIns.hidden = FALSE;
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
        for (int i =1; i<12; i++) {
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
    [GenricUI showAlertWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"DELETE_CHOLESTEROL_LOG", nil) cancelButton:@"No" delegates:self button1Titles:@"Yes" button2Titles:nil tag:400];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 400) {
        if (buttonIndex == 1) {
            //to delete the logweight
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToDeleteCholesterolLog:[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:self.mSelectdIndex.row] objectForKey:@"LogID"]
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
    [self setMCholesterolimgView:nil];
    [self setMCholeslbl:nil];
    [self setMMgLbl:nil];
    [self setMTopGrayImgView:nil];
    [self setMTypeLbl:nil];
    [super viewDidUnload];
}
- (void)menuAction:(id)sender {
    [mAppDelegate_ showLeftSideMenu:self];
}
- (IBAction)cholesterolAction:(UIButton *)sender {
    [self displayPickerview];
}

- (void)reloadContentsOftableView
{
    if (mAppDelegate_.mTrackerDataGetter_.mCholesterolList_.count == 0) {
        self.mTopView.hidden = TRUE;
        self.mTableView.hidden = TRUE;
        self.mMsgLbl.hidden = FALSE;
        self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, 25, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
        self.mLineImgView.frame = CGRectMake(self.mLineImgView.frame.origin.x, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, self.mLineImgView.frame.size.width, self.mLineImgView.frame.size.height);
        self.mMsgLbl.frame = CGRectMake(self.mMsgLbl.frame.origin.x, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height+10, self.mMsgLbl.frame.size.width, self.mMsgLbl.frame.size.height);
        self.mScrolView.contentSize = CGSizeMake(320, self.mMsgLbl.frame.origin.y+self.mMsgLbl.frame.size.height+20);
    }else{
        //Camera Guide code
        NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isCameraLayer = [loginUserDefaults boolForKey:CHOLESTREOLCAMERALAYER];
        if (!isCameraLayer) {
            BOOL isTop = [loginUserDefaults boolForKey:CHOLESTREOLTOPCAMERALAYER];
            BOOL isBottom = [loginUserDefaults boolForKey:CHOLESTREOLBOTTOMCAMERALAYER];
            if ( isTop && !isBottom) {
                [self showCameraGuideBottom];
            }
        }
        
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
        NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"Date"]];
        if (lDate == nil) {
            [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"Date"]];
            
        }
        [lFormatter setDateFormat:@"MM/dd/yy"];
        NSString *lStr = [lFormatter stringFromDate:lDate];
        self.mLastLogLbl.text = [NSString stringWithFormat:@"Last logged on %@",lStr];
        
        // to set the cholesterol text based on type of cholesterol
        if ([self.mTypeLbl.text isEqualToString:@"Total Cholesterol"]) {
            self.mCholeslbl.text = [NSString stringWithFormat:@"%.1f", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"TotalCholesterol"] floatValue]];

        }else if ([self.mTypeLbl.text isEqualToString:@"LDL Cholesterol"]) {
            self.mCholeslbl.text = [NSString stringWithFormat:@"%.1f", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"LDLCholesterol"] floatValue]];
            
        }else  {
            self.mCholeslbl.text = [NSString stringWithFormat:@"%.1f", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"HDLCholesterol"] floatValue]];
            
        }
        NSString* mText = [self.mCholeslbl.text substringFromIndex:[self.mCholeslbl.text rangeOfString:@"."].location];
        mText = [mText stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([mText intValue] == 0) {
            if ([self.mTypeLbl.text isEqualToString:@"Total Cholesterol"]) {
                self.mCholeslbl.text = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"TotalCholesterol"] intValue]];
                
            }else if ([self.mTypeLbl.text isEqualToString:@"LDL Cholesterol"]) {
                self.mCholeslbl.text = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"LDLCholesterol"] intValue]];
                
            }else  {
                self.mCholeslbl.text = [NSString stringWithFormat:@"%d", [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:0] objectForKey:@"HDLCholesterol"] intValue]];
                
            }

        }

        CGSize size =  [self.mCholeslbl.text sizeWithFont:self.mCholeslbl.font constrainedToSize:CGSizeMake(150, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        self.mCholeslbl.frame = CGRectMake(self.mCholeslbl.frame.origin.x, self.mCholeslbl.frame.origin.y, size.width, self.mCholeslbl.frame.size.height);
        self.mMgLbl.frame = CGRectMake(self.mCholeslbl.frame.origin.x+size.width+3, self.mMgLbl.frame.origin.y, self.mMgLbl.frame.size.width, self.mMgLbl.frame.size.height);
        
        
        self.mTopView.hidden = FALSE;
        self.mTableView.hidden = FALSE;
        self.mMsgLbl.hidden = TRUE;
        self.mLogLbl.frame = CGRectMake(self.mLogLbl.frame.origin.x, self.mTopView.frame.origin.y+self.mTopView.frame.size.height+35, self.mLogLbl.frame.size.width, self.mLogLbl.frame.size.height);
        self.mLineImgView.frame = CGRectMake(self.mLineImgView.frame.origin.x, self.mLogLbl.frame.origin.y+self.mLogLbl.frame.size.height+5, self.mLineImgView.frame.size.width, self.mLineImgView.frame.size.height);
        [self loadGraphData];

        [self.mTableView reloadData];
        self.mTableView.contentOffset = CGPointMake(0, 0);
        self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mLineImgView.frame.origin.y+self.mLineImgView.frame.size.height, 320, [self caluclateTableHeight]);
        self.mScrolView.contentSize = CGSizeMake(320, self.mTableView.frame.origin.y+self.mTableView.frame.size.height+20);
    }
    
    
}
- (void)addLogAction:(id)sender {
    AddCholesterolViewController *lVc = [[AddCholesterolViewController alloc]initWithNibName:@"AddCholesterolViewController" bundle:nil];
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
        [mAppDelegate_.mRequestMethods_ postRequestToGetCholesterolChartData:self.mRange
                                                              AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                           SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
    }
}
- (void)displayPickerview {
    
    PickerViewController *screen = [[PickerViewController alloc] init];
    NSMutableArray *rowValuesArr_=[[NSMutableArray alloc] init];
    NSMutableArray *lValues = [[NSMutableArray alloc]initWithObjects:@"Total Cholesterol",@"LDL Cholesterol",@"HDL Cholesterol", nil];
    [rowValuesArr_ addObject:lValues];
    screen.mRowValueintheComponent=rowValuesArr_;
    screen->mNoofComponents=[rowValuesArr_ count];
    screen.mTextDisplayedlb.text=@"Select Cholesterol";
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
        if([controller superview]){
			[controller removeFromSuperview];
		}
        [self.mTypeLbl setText:mData_];
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
    NSMutableArray *lValues = [[NSMutableArray alloc]initWithObjects:@"Total Cholesterol",@"LDL Cholesterol",@"HDL Cholesterol", nil];
    if (component==0)
        return [lValues objectAtIndex:row];
    else
        return @"";
	
    
}
- (CGFloat)caluclateTableHeight{
    CGFloat height=0.0;
    for (int i =0; i < mAppDelegate_.mTrackerDataGetter_.mCholesterolList_.count; i++) {
        height+= 145;
        UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 30)];
        lLabel.textColor = RGB_A(114, 105, 89, 1);
        lLabel.font = [UIFont italicSystemFontOfSize:14];
        lLabel.numberOfLines =0;
        lLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lLabel.text = [[[mAppDelegate_.mTrackerDataGetter_.mCholesterolList_ objectAtIndex:i] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        CGSize size = [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        if (lLabel.text.length > 0)
        {
            if (size.height < 20) {
                size.height = 20;
            }
            height+=5+size.height;
        }
        height+=10;//to last gap
    }
    return height;
}
#pragma mark - Camera Guide
-(void)showCameraGuide {
    [mAppDelegate_ addTransparentViewToWindow];
    //if there are food items show the share view
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TrackerCameraGuide" owner:self options:nil];
    mCameraGuide = [array objectAtIndex:0];
    mCameraGuide.topViewLbl.font = Bariol_Regular(18);
    mCameraGuide.bottomViewLbl.font = Bariol_Regular(18);
    
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
    
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraGuideTapActionBottom:)];
    [firstTap setNumberOfTapsRequired:1];
    [mCameraGuide addGestureRecognizer:firstTap];
    [mAppDelegate_.window addSubview:mCameraGuide];
}
-(void)cameraGuideTapAction:(UITapGestureRecognizer*)tap {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:CHOLESTREOLCAMERALAYER];
    [loginUserDefaults synchronize];
}
-(void)cameraGuideTapActionTop:(UITapGestureRecognizer*)tap {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:CHOLESTREOLTOPCAMERALAYER];
    [loginUserDefaults synchronize];
}
-(void)cameraGuideTapActionBottom:(UITapGestureRecognizer*)tap {
    mCameraGuide.hidden = YES;
    [mAppDelegate_ removeTransparentViewFromWindow];
    NSUserDefaults *loginUserDefaults = [NSUserDefaults standardUserDefaults];
    [loginUserDefaults setBool:YES forKey:CHOLESTREOLBOTTOMCAMERALAYER];
    [loginUserDefaults synchronize];
    [loginUserDefaults setBool:YES forKey:CHOLESTREOLCAMERALAYER];
    [loginUserDefaults synchronize];
}

@end
