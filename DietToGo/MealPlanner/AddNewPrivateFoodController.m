//
//  AddNewPrivateFoodController.m
//  EHEandme
//
//  Created by Suresh on 2/18/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import "AddNewPrivateFoodController.h"
#import "EditServingViewController.h"

@interface AddNewPrivateFoodController ()

@end

@implementation AddNewPrivateFoodController
@synthesize mCategoryArr,mSuffixArr,mSaveArr,mActiveTxtFld;

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
    mAppDelegate_=[AppDelegate appDelegateInstance];
     mCategoryArr = [[NSMutableArray alloc] initWithObjects:@"Food name",@"Information is for",@"Calories",@"Total Fat",@"Saturated Fat",@"Trans Fat",@"Cholesterol",@"Vitamin A",@"Calcium",@"Vitamin D",@"Sodium",@"Total Carbohydrate",@"Dietary Fiber",@"Sugars",@"Protein",@"Vitamin C",@"Iron", nil];
    mSuffixArr = [[NSMutableArray alloc] initWithObjects:@"",@"",@"kcal",@"g",@"g",@"g",@"mg",@"%",@"%",@"%",@"mg",@"g",@"g",@"g",@"g",@"%",@"%", nil];
    mSaveArr = [[NSMutableArray alloc] initWithObjects:@"",@"",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [mAppDelegate_.mDataGetter_.mEditServingDict_ removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated {
    [mAppDelegate_ hideEmptySeparators:self.mTableView];
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Meal Plan - Main View";
        [mAppDelegate_ trackFlurryLogEvent:@"Create New Private Food"];
    }
    //end
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    self.navigationController.navigationBarHidden = FALSE;
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"CREATE_NEW_FOOD", nil) imageName:imgName forController:self];
        
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
    //Add Save Button to Right Nav
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(saveAction:) forController:self rightOrLeft:1];
    [self.mTableView reloadData];
    
}
- (void)backAction:(id)sender{
    [mAppDelegate_.mDataGetter_.mEditServingDict_ removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveAction:(id)sender{
    [self doneTxtFld_Event];

    NSLog(@"mSaveArr %@",self.mSaveArr);
    
    NSString* foodName = [mSaveArr objectAtIndex:0];
    if ([foodName isEqualToString:@""]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Please enter the required fields"];
        return;
    }
    NSString* QtyString = [mAppDelegate_.mDataGetter_.mEditServingDict_ valueForKey:@"Qty"];
    if (QtyString == NULL || [QtyString isEqualToString:@""]) {
        QtyString = @"";
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Please enter the required fields"];
        return;
    }
    NSString* UnitType = [mAppDelegate_.mDataGetter_.mEditServingDict_ valueForKey:@"UnitType"];
    if (QtyString == NULL) {
        UnitType = @"";
    }
    NSString* UnitID = [mAppDelegate_.mDataGetter_.mEditServingDict_ valueForKey:@"UnitID"];
    if (QtyString == NULL) {
        UnitID = @"";
    }
    NSString* body = [NSString stringWithFormat:@"FoodName=%@&Calories=%@&Fat=%@&SatFat=%@&TransFat=%@&Cholesterol=%@&VitA=%@&Calcium=%@&VitD=%@&Sodium=%@&Carbohydrate=%@&Fiber=%@&Sugars=%@&Protein=%@&VitC=%@&Iron=%@&Qty=%@&UnitID=%@&UnitType=%@",[mSaveArr objectAtIndex:0],[mSaveArr objectAtIndex:2],[mSaveArr objectAtIndex:3],[mSaveArr objectAtIndex:4],[mSaveArr objectAtIndex:5],[mSaveArr objectAtIndex:6],[mSaveArr objectAtIndex:7],[mSaveArr objectAtIndex:8],[mSaveArr objectAtIndex:9],[mSaveArr objectAtIndex:10],[mSaveArr objectAtIndex:11],[mSaveArr objectAtIndex:12],[mSaveArr objectAtIndex:13],[mSaveArr objectAtIndex:14],[mSaveArr objectAtIndex:15],[mSaveArr objectAtIndex:16],QtyString,UnitID,UnitType];
      NSLog(@"mSaveArr %d \n %@",[self.mSaveArr count],body);
    //@"FoodName=TESTSameple&Calories=2.1&Protein=3.1&Carbohydrate=4.1&Fat=5.1&SatFat=6.1&TransFat=7.1&Cholesterol=8.1&Fiber=9.1&Sugars=10.1&VitA=11.1&VitC=12.1&VitD=13.1&Calcium=14.1&Iron=15.1&Sodium=16.1&Qty=17.1&UnitID=1&UnitType=2";
    /*
     * post request for save  private food
     */
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToSavePrivateFood:body withAuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
         }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }

    
}

#pragma mark - Tableview Delagate and DataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [mCategoryArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
	
	if (nil==cell)
	{
		cell = [[UITableViewCell alloc]  initWithFrame:CGRectMake(0,0,0,0)] ;
		/*
        UIView *lSelectedView_ = [[UIView alloc] init];
        lSelectedView_.backgroundColor =SELECTED_CELL_COLOR;
        cell.selectedBackgroundView = lSelectedView_;
        lSelectedView_=nil;
         */
        
        //Category Label
        UILabel *lCateLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 170, 30)];
        [lCateLbl setBackgroundColor:CLEAR_COLOR];
        [lCateLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lCateLbl setFont:Bariol_Regular(22)];
        lCateLbl.tag =1;
        [lCateLbl setTextColor:RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lCateLbl];
        
        //CAlculate size
        NSString* suffix = [mSuffixArr objectAtIndex:indexPath.row];
        CGSize  size =  [suffix sizeWithFont:Bariol_Regular(17) constrainedToSize:CGSizeMake(30, 10000) lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"size %f",size.width);

        //TextField label
        UITextField *lTextLbl=[[UITextField alloc]initWithFrame:CGRectMake(185, 13, 105-size.width, 30)];
        [lTextLbl setTextAlignment:NSTextAlignmentRight];
        [Utilities addInputViewForKeyBoardForTextFld:lTextLbl Class:self];
        lTextLbl.keyboardType = UIKeyboardTypeDefault;
         lTextLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        lTextLbl.delegate = self;
        [lTextLbl setFont:Bariol_Regular(22)];
        lTextLbl.tag = indexPath.row+ 2;
        [lTextLbl setTextColor: BLACK_COLOR];
        [lTextLbl setBackgroundColor:CLEAR_COLOR];
        [cell.contentView addSubview:lTextLbl];

        
        //suffix Label
        UILabel *lsuffixLbl=[[UILabel alloc]initWithFrame:CGRectMake(290-size.width, 10, size.width, 30)];
        [lsuffixLbl setBackgroundColor:CLEAR_COLOR];
        [lsuffixLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lsuffixLbl setFont:Bariol_Regular(14)];
        lsuffixLbl.tag =3;
        lsuffixLbl.text = suffix;
        [lsuffixLbl setTextColor:BLACK_COLOR];
        [cell.contentView addSubview:lsuffixLbl];
       
        if (indexPath.row == 0 || indexPath.row == 1) {
            lsuffixLbl.hidden = TRUE;
        }
        
       
        
        //arrow image
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(305-10, 22.5-(13/2), 10, 15)];
        lImgView.backgroundColor = CLEAR_COLOR;
        lImgView.image = [UIImage imageNamed:@"arrowright.png"];
        lImgView.tag = 4;
        [cell.contentView addSubview:lImgView];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    UILabel *lsuffixLbl = (UILabel*)[cell.contentView viewWithTag:3];
    CGRect frame = lsuffixLbl.frame;
    frame.origin.y = 10;
    if (indexPath.row == 2 ) {
        frame.origin.y = 12;
    }
    lsuffixLbl.frame = frame;

    UILabel *lLbl1 = (UILabel*)[cell.contentView viewWithTag:1];
    lLbl1.text = [mCategoryArr objectAtIndex:indexPath.row];
    
    
    UITextField *lLbl2 = (UITextField*)[cell.contentView viewWithTag:indexPath.row+2];
    lLbl2.keyboardType = UIKeyboardTypeDecimalPad;
    lLbl2.text = [NSString stringWithFormat:@"%@",[mSaveArr objectAtIndex:indexPath.row]];
    if (indexPath.row == 0 || indexPath.row ==1 ) {
        lLbl2.placeholder = @"Required";
        lLbl2.keyboardType = UIKeyboardTypeDefault;
        
    }
    if (indexPath.row == 1) {
        NSString *Qty =[mAppDelegate_.mDataGetter_.mEditServingDict_ valueForKey:@"Qty"];
        NSString *UnitName =[mAppDelegate_.mDataGetter_.mEditServingDict_ valueForKey:@"UnitName"];
        if (Qty != NULL) {
            lLbl2.text = [NSString stringWithFormat:@"%@ %@",Qty,UnitName];
        }
    }
    //Decimal Key board
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell* selectedCell = [self.mTableView cellForRowAtIndexPath:indexPath];
    UITextField *lLbl2 = (UITextField*)[selectedCell.contentView viewWithTag:indexPath.row+2];
    [lLbl2 becomeFirstResponder];
}

#pragma mark - TextField Delagets
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //for second row
    if (textField.tag == 3) {
        [self doneTxtFld_Event];
        [textField resignFirstResponder];
        [self pushToEditServingView];
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSString* text = textField.text;
    if ([text isEqualToString:@"0"]) {
        textField.text = @"";
    }
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (osVersion >= 7.0) {
        self.mTableView.contentInset=UIEdgeInsetsMake(0,0,270,0);

    }else {
        
        self.mTableView.contentInset=UIEdgeInsetsMake(0,0,270,0);
        UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
        [self.mTableView scrollToRowAtIndexPath:[self.mTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    self.mActiveTxtFld = textField;
}
//-(void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    self.mTableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
//}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    int index = self.mActiveTxtFld.tag-2;
    if ([textField.text isEqualToString:@""] && (index !=0)) {
        textField.text = @"0";
    }
    [self.mSaveArr replaceObjectAtIndex:index withObject:textField.text];
   // self.mTableView.contentInset=UIEdgeInsetsMake(0,0,0,0);
}

// clear action
- (void)cancelTxtFld_Event
{
    self.mActiveTxtFld.text = @"";
}
// done action
- (void)doneTxtFld_Event
{
   
    self.mTableView.contentInset=UIEdgeInsetsMake(0,0,0,0);
    [self.mActiveTxtFld resignFirstResponder];
    self.mActiveTxtFld = nil;
    
}
-(void)pushToEditServingView {
    EditServingViewController *editServing = [[EditServingViewController alloc] initWithNibName:@"EditServingViewController" bundle:nil];
    [mAppDelegate_ setMEditServingViewController:editServing];
    [self.navigationController pushViewController:editServing animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
