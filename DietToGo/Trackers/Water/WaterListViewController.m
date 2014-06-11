//
//  WaterListViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 14/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "WaterListViewController.h"
#import "WaterAddEditViewController.h"
#define DateFormatServer @"yyyy-MM-dd'T'HH:mm:ss"
#define DateFormatApp @"MMM dd"
@interface WaterListViewController ()

@end

@implementation WaterListViewController
@synthesize mWaterAddEditViewController;

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
    // for setting the view below 20px in iOS7.0.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    mAppDelegate_ = [AppDelegate appDelegateInstance];
    [mAppDelegate_ hideEmptySeparators:self.self.mTableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    self.mLogLbl.font = Bariol_Regular(22);
    self.mLogLbl.textColor = RGB_A(136, 136, 136, 1);

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
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];//need to change to cancel button
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"addicon.png"] title:nil target:self action:@selector(addLogAction:) forController:self rightOrLeft:1];
    
    if ([[GenricUI instance] isiPhone5]) {
    }
}
#pragma mark - TableView Delegate methodes
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([mAppDelegate_.mTrackerDataGetter_.mWaterList_ count]>10){
        return 10;
    }else{
        return [mAppDelegate_.mTrackerDataGetter_.mWaterList_ count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
        UIView *lSelectedView_ = [[UIView alloc] init];
        lSelectedView_.backgroundColor =SELECTED_CELL_COLOR;
        //cell.selectedBackgroundView = lSelectedView_;
        
        
        /*
         * JournalLog description name label
         */
        int yposition=10;
        UIView *waterContainer=[[UIView alloc]initWithFrame:CGRectMake(5, yposition, 60, 30)];
        waterContainer.tag=1;
        waterContainer.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:waterContainer];
        
        /*
         * Date label
         */
        UILabel *datetimeLbl=[[UILabel alloc]initWithFrame:CGRectMake(245, yposition+5, 60, 20)];
        datetimeLbl.textColor=[UIColor grayColor];
        datetimeLbl.font=[UIFont boldSystemFontOfSize:16];
        datetimeLbl.backgroundColor=[UIColor clearColor];
        datetimeLbl.tag=2;
        [cell.contentView addSubview:datetimeLbl];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    //getting instances
    
    UIView *waterContainer=(UIView*)[cell.contentView viewWithTag:1];
    for(UIView *lView in waterContainer.subviews){
        [lView removeFromSuperview];
    }
    int waterCount=[[[mAppDelegate_.mTrackerDataGetter_.mWaterList_  objectAtIndex:indexPath.row] objectForKey:@"Glass"] intValue];
    int xpos=0;
    for(int i=0;i<waterCount&&i<8;i++){
        xpos=+(i*30);
        UIImageView *waterimage=[[UIImageView alloc]initWithFrame:CGRectMake(xpos, 0, 25, 30)];
        if(i==7&&((waterCount-1)>i)){//means 8th glass and total glasses more than 8
            waterimage.backgroundColor=[UIColor clearColor];
            waterimage.image=[UIImage imageNamed:@"img_water-glass-small-add.png"];
        }else{// 1 to 7 glasses
            waterimage.backgroundColor=[UIColor clearColor];
            waterimage.image=[UIImage imageNamed:@"img_water-glass-small.png"];
        }
        [waterContainer addSubview:waterimage];
    }
    
    
    NSString *lDateStr;
    NSDate *lDate=nil;
    
    NSDateFormatter *lFormatter=[[NSDateFormatter alloc]init];
    [lFormatter setDateFormat:DateFormatServer];
    [GenricUI setLocaleZoneForDateFormatter:lFormatter];
    lDateStr=[[mAppDelegate_.mTrackerDataGetter_.mWaterList_  objectAtIndex:indexPath.row] objectForKey:@"Date"];
    if(lDateStr!=nil){
        lDate=[lFormatter dateFromString:lDateStr];
    }
    [lFormatter setDateFormat:DateFormatApp];
    if(lDate!=nil){
        lDateStr=[lFormatter stringFromDate:lDate];
    }
    UILabel *lDateLblIns=(UILabel*)[cell.contentView viewWithTag:2];
    lDateLblIns.text=lDateStr;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    //to push to detail page
    WaterAddEditViewController *lWaterAddEditViewController_=[[WaterAddEditViewController alloc]initWithNibName:@"WaterAddEditViewController" bundle:nil];
    self.mWaterAddEditViewController = lWaterAddEditViewController_;
    lWaterAddEditViewController_->mWaterConsumed_=[[[mAppDelegate_.mTrackerDataGetter_.mWaterList_  objectAtIndex:indexPath.row] objectForKey:@"Glass"] intValue];
    
    lWaterAddEditViewController_->mCurrentDay=indexPath.row;
    lWaterAddEditViewController_->isFromEdit=TRUE;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:lWaterAddEditViewController_];
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:nc animated:YES completion:nil];
    } else {
        [self presentModalViewController:nc animated:YES];
        
    }


}
- (void)menuAction:(id)sender {
    [mAppDelegate_ showLeftSideMenu:self];
}
- (void)reloadContentsOftableView
{
    [self.mTableView reloadData];
    //[self.mTableView addGestureRecognizer:self.mSwipeGes];
    
}
- (void)addLogAction:(id)sender {
    WaterAddEditViewController *lLogWaterAddEditViewController_=[[WaterAddEditViewController alloc]initWithNibName:@"WaterAddEditViewController" bundle:nil];
    self.mWaterAddEditViewController = lLogWaterAddEditViewController_;
    lLogWaterAddEditViewController_->isFromEdit=FALSE;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:lLogWaterAddEditViewController_];
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
    
    [self setMLogLbl:nil];
    [self setMTableView:nil];
    [self setMLineImgView:nil];
    [super viewDidUnload];
}
@end
