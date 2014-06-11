//
//  MyJournalListViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 19/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "MyJournalListViewController.h"
#import "AddJournalViewController.h"

@interface MyJournalListViewController ()

@end

@implementation MyJournalListViewController
@synthesize mSelectdIndex;

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
    
    [self.mTableview addGestureRecognizer:sgrLeft];
    [mAppDelegate_ hideEmptySeparators:self.self.mTableview];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    self.mMsgLbl.font = Bariol_Regular(17);
    self.mMsgLbl.textColor = [UIColor darkGrayColor];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        self.trackedViewName=@"My Journal";
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"JOURNAL_TRACKER", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];//need to change to cancel button
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"addicon.png"] title:nil target:self action:@selector(addLogAction:) forController:self rightOrLeft:1];
    
    if (mAppDelegate_.mTrackerDataGetter_.mJournalList_.count == 0) {
        self.mTableview.hidden = TRUE;
        self.mMsgLbl.hidden = FALSE;
        
    }
}
#pragma mark TABLE VIEW DELEGATE METHODS


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  65;
    UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, 290, 20)];
    lLabel.font = Bariol_Regular(17);
    lLabel.numberOfLines =0;
    lLabel.lineBreakMode = UILineBreakModeWordWrap;
    lLabel.text = [[[mAppDelegate_.mTrackerDataGetter_.mJournalList_ objectAtIndex:indexPath.row] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    CGSize size =  [lLabel.text sizeWithFont:lLabel.font constrainedToSize:CGSizeMake(lLabel.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    height+= 5+size.height+10;
    return height;

}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mAppDelegate_.mTrackerDataGetter_.mJournalList_.count;
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
        [lDateLbl setFont:Bariol_Regular(25)];
        lDateLbl.tag =1;
        [lDateLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lDateLbl];
        
        //time label
        UILabel *lTimeLbl=[[UILabel alloc]initWithFrame:CGRectMake(205, 10, 100, 30)];
        [lTimeLbl setBackgroundColor:[UIColor clearColor]];
        [lTimeLbl setTextAlignment:TEXT_ALIGN_RIGHT];
        [lTimeLbl setFont:Bariol_Regular(25)];
        lTimeLbl.tag =2;
        [lTimeLbl setTextColor:RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lTimeLbl];
        
        //category label
        UILabel *lCatLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 45, 100, 20)];
        [lCatLbl setBackgroundColor:[UIColor clearColor]];
        [lCatLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lCatLbl setFont:Bariol_Regular(17)];
        lCatLbl.tag =3;
        [lCatLbl setTextColor:RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lCatLbl];
        
        //notes label
        UILabel *lNotesLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 70, 290, 20)];
        [lNotesLbl setBackgroundColor:[UIColor clearColor]];
        [lNotesLbl setTextAlignment:TEXT_ALIGN_LEFT];
        lNotesLbl.numberOfLines = 0;
        lNotesLbl.lineBreakMode = UILineBreakModeWordWrap;
        [lNotesLbl setFont:Bariol_Regular(17)];
        lNotesLbl.tag =4;
        [lNotesLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lNotesLbl];


    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *lDateLblIns = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *lTimeLblIns = (UILabel*)[cell.contentView viewWithTag:2];
    UILabel *lCatLblIns = (UILabel*)[cell.contentView viewWithTag:3];
    UILabel *lNotesLblIns = (UILabel*)[cell.contentView viewWithTag:4];

    
    NSDateFormatter *lFormatter=[[NSDateFormatter alloc]init];
    [lFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [lFormatter setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    lFormatter.locale = enLocale;
    NSDate *lDate = [lFormatter dateFromString:[[mAppDelegate_.mTrackerDataGetter_.mJournalList_ objectAtIndex:indexPath.row] objectForKey:@"Date"]];
    [lFormatter setDateFormat:@"MMM dd, yyyy"];
    lDateLblIns.text = [lFormatter stringFromDate:lDate];
    [lFormatter setDateFormat:@"hh:mma"];
    NSString *ltime = [lFormatter stringFromDate:lDate];
    ltime = [ltime stringByReplacingOccurrencesOfString:@"AM" withString:@"am"];
    ltime = [ltime stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
    ltime = [ltime stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
    lTimeLblIns.text = ltime;
    NSString *lCatName = [mAppDelegate_.mTrackerDataGetter_ returnTheCategoryName:[NSString stringWithFormat:@"%d",[[[mAppDelegate_.mTrackerDataGetter_.mJournalList_ objectAtIndex:indexPath.row] objectForKey:@"JournalCategory"] intValue]]];
    lCatLblIns.text = lCatName;
    
    lNotesLblIns.text = [[[mAppDelegate_.mTrackerDataGetter_.mJournalList_ objectAtIndex:indexPath.row] objectForKey:@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    CGSize size =  [lNotesLblIns.text sizeWithFont:lNotesLblIns.font constrainedToSize:CGSizeMake(lNotesLblIns.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
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
    [self.mTableview reloadData];
    
    
}
-(void)cellSwipedLeft:(UIGestureRecognizer *)gestureRecognizer {
    [self.mTableview reloadData];
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // [self.mTableView removeGestureRecognizer:self.mSwipeGes];
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.mTableview];
        NSIndexPath *swipedIndexPath = [self.mTableview indexPathForRowAtPoint:swipeLocation];
        self.mSelectdIndex = swipedIndexPath;
        UITableViewCell* swipedCell = [self.mTableview cellForRowAtIndexPath:swipedIndexPath];
        //to move the row contents to left
        UITableViewCell *cell = (UITableViewCell *)swipedCell;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        
        for (int i =1; i<5; i++) {
            UILabel *lLbl = (UILabel*)[cell.contentView viewWithTag:i];
            CGRect frame = lLbl.frame;
            frame.origin.x -= 50;
            lLbl.frame = frame;
        }
        [UIView commitAnimations];
        
        //for view
        UIView* rightPatch = [[UIView alloc]init];
        rightPatch.frame = CGRectMake(320-50, 0, 100, cell.frame.size.height);
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
    [GenricUI showAlertWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"DELETE_JOURNAL_LOG", nil) cancelButton:@"No" delegates:self button1Titles:@"Yes" button2Titles:nil tag:400];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 400) {
        if (buttonIndex == 1) {
            //to delete the logweight
            if ([[NetworkMonitor instance]isNetworkAvailable]) {
                [mAppDelegate_ createLoadView];
                [mAppDelegate_.mRequestMethods_ postRequestToDeleteJournalLog:[[mAppDelegate_.mTrackerDataGetter_.mJournalList_ objectAtIndex:self.mSelectdIndex.row] objectForKey:@"LogID"]
                                                                    AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                                 SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
            }else{
                [[NetworkMonitor instance]displayNetworkMonitorAlert];
            }
            
            
        }
    }
}

- (void)menuAction:(id)sender {
    [mAppDelegate_ showLeftSideMenu:self];
}
- (void)reloadContentsOftableView
{
    if (mAppDelegate_.mTrackerDataGetter_.mJournalList_.count == 0) {
        self.mTableview.hidden = TRUE;
        self.mMsgLbl.hidden = FALSE;
        
    }else{
        [self.mTableview reloadData];
        self.mTableview.contentOffset = CGPointMake(0, 0);
        self.mTableview.hidden = FALSE;
        self.mMsgLbl.hidden = TRUE;
    }
    
}
- (void)addLogAction:(id)sender {
    AddJournalViewController *lVc = [[AddJournalViewController alloc]initWithNibName:@"AddJournalViewController" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:lVc];
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:nc animated:YES completion:nil];
    } else {
        [self presentModalViewController:nc animated:YES];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMImgView:nil];
    [self setMLineImgView:nil];
    [self setMTableview:nil];
    [self setMMsgLbl:nil];
    [super viewDidUnload];
}
@end
