//
//  EditServingViewController.m
//  EHEandme
//
//  Created by Suresh on 2/20/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import "EditServingViewController.h"

@interface EditServingViewController ()

@end

@implementation EditServingViewController
@synthesize mQuantityArr,mIncreamentArr;
@synthesize mEditServingInfo;

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
    
    mQuantityArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 500; i++) {
        [mQuantityArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    mIncreamentArr = [[NSMutableArray alloc] initWithObjects:@"0",@"1/8",@"1/4",@"1/3", @"1/2", @"2/3", @"3/4", nil];
    
    CGRect frame = CGRectMake(0, 460-240, 320,240);
     //For iPhone 5
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3)
    {
        frame = CGRectMake(0, 568-240, 320,240);
    }
    //Apply style guide
    self.mInformationForLbl.font = Bariol_Regular(18);
    self.mInformationForLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mServingLbl.font = Bariol_Regular(18);
    self.mServingLbl.textColor = BLACK_COLOR;
    self.mServingLbl.textAlignment = NSTextAlignmentRight;
    self.mLineLbl.backgroundColor = RGB_A(221, 221, 221, 1);
    
    
    
    self.mPickerView = [[UIPickerView alloc] initWithFrame:frame];
    self.mPickerView.delegate=self;
    self.mPickerView.dataSource=self;
    [self.view addSubview:self.mPickerView];
    [self.mPickerView setShowsSelectionIndicator:YES];
    

    self.mPickerView.hidden = YES;
    [self postRequestForRecentFoodItems];

}

- (void)viewWillAppear:(BOOL)animated {
    //[mAppDelegate_ hideEmptySeparators:self.mTableView];
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Meal Plan - Main View";
        [mAppDelegate_ trackFlurryLogEvent:@"Edit Serving"];
    }
    //end
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        //[self.mTableView setSeparatorInset:UIEdgeInsetsZero];
        
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
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"EDIT_SERVING", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
    //Add Save Button to Right Nav
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(saveAction:) forController:self rightOrLeft:1];
    
}
- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveAction:(id)sender{
    
    NSUInteger numComponents = [self.mPickerView  numberOfComponents];
    
    NSString * title1 = @"";
    NSString * title2 = @"";
    NSString * title3 = @"";
    int selectedUnit = -1;
    for(NSUInteger i = 0; i < numComponents; ++i) {
        NSUInteger selectedRow = [self.mPickerView selectedRowInComponent:i];
        
        switch (i) {
            case 0:
                title1 = [NSString stringWithFormat:@"%@",[mQuantityArr objectAtIndex:selectedRow]];
                break;
            case 1:
                title2 = [NSString stringWithFormat:@"%@",[mIncreamentArr objectAtIndex:selectedRow]];
                break;
            case 2:
                title3 = [NSString stringWithFormat:@"%@",[[mAppDelegate_.mDataGetter_.mFoodUnitList_ objectAtIndex:selectedRow] valueForKey:@"UnitName"]];
                selectedUnit = selectedRow;
                break;
                
            default:
                break;
        }
        
    }
    NSLog(@"selected row %@ %@ %@", title1,title2,title3);
    
    float per1 = [title1 floatValue];
    float per2 = [self returnFloatValue:title2];
    float total = per1+per2;
    NSString* Qty = [NSString stringWithFormat:@"%.1f", total];

    
    [mAppDelegate_.mDataGetter_.mEditServingDict_ setValue:[[mAppDelegate_.mDataGetter_.mFoodUnitList_ objectAtIndex:selectedUnit] valueForKey:@"UnitType"] forKey:@"UnitType"];
    [mAppDelegate_.mDataGetter_.mEditServingDict_ setValue:[[mAppDelegate_.mDataGetter_.mFoodUnitList_ objectAtIndex:selectedUnit] valueForKey:@"UnitID"] forKey:@"UnitID"];
    [mAppDelegate_.mDataGetter_.mEditServingDict_ setValue:[[mAppDelegate_.mDataGetter_.mFoodUnitList_ objectAtIndex:selectedUnit] valueForKey:@"UnitName"] forKey:@"UnitName"];
    [mAppDelegate_.mDataGetter_.mEditServingDict_ setValue:Qty forKey:@"Qty"];
    [mAppDelegate_.mDataGetter_.mEditServingDict_ setValue:title2 forKey:@"percentage"];
    /*{
     Incr = 1;
     Qty = 1;
     UnitID = "-1";
     UnitName = "User Defined";
     UnitType = 3;
     Qty
     }*/
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UIPickerDelegate methods

//  *************** tell the picker how many rows are available for a given component ************
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int count = 0;
    switch (component) {
        case 0:
            count = [mQuantityArr count];
            break;
        case 1:
            count = [mIncreamentArr count];
            break;
        case 2:
            count = [mAppDelegate_.mDataGetter_.mFoodUnitList_ count];
            break;
            
        default:
            break;
    }
    
    return count;
    
}

// ************************* tell the picker how many components it will have ******************
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// ************* tell the picker the title for a given component ****************
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	
    return @"";
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width = 80;
    if (component == 2) {
        width = 150;
    }
    return width;
}
//  *************** customize row in a picker in a component ************

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* label = (UILabel*)view;
    if (view == nil){
        label= [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 140, 40)] ;
        label.textAlignment = UITextAlignmentCenter;
    }
    label.font = Bariol_Regular(23);
    
    // label.font =[UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.numberOfLines = 0;
    label.lineBreakMode = LINE_BREAK_WORD_WRAP;
    label.textColor = RGB_A(35, 35, 35, 1);
    label.backgroundColor = CLEAR_COLOR;
    NSString *pickeValue =@"";
    switch (component) {
        case 0:
            pickeValue = [NSString stringWithFormat:@"%@",[mQuantityArr objectAtIndex:row]];
            break;
        case 1:
            pickeValue = [NSString stringWithFormat:@"%@",[mIncreamentArr objectAtIndex:row]];
            break;
        case 2:
            pickeValue = [NSString stringWithFormat:@"%@",[[mAppDelegate_.mDataGetter_.mFoodUnitList_ objectAtIndex:row] valueForKey:@"UnitName"]];
            break;
            
        default:
            break;
    }
    label.text = pickeValue;
    CGSize size =  [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (size.height > label.frame.size.height) {
        label.numberOfLines = 2;
        label.lineBreakMode = UILineBreakModeTailTruncation;
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"component %d %d",component,row);
    [self calculateServingValue];
    
}
-(void)calculateServingValue {
    
    
    NSUInteger numComponents = [self.mPickerView  numberOfComponents];
    
    NSString * title1 = @"";
    NSString * title2 = @"";
    NSString * title3 = @"";
    for(NSUInteger i = 0; i < numComponents; ++i) {
        NSUInteger selectedRow = [self.mPickerView selectedRowInComponent:i];
        
        switch (i) {
            case 0:
                title1 = [NSString stringWithFormat:@"%@",[mQuantityArr objectAtIndex:selectedRow]];
                break;
            case 1:
                title2 = [NSString stringWithFormat:@"%@",[mIncreamentArr objectAtIndex:selectedRow]];
                break;
            case 2:
                title3 = [NSString stringWithFormat:@"%@",[[mAppDelegate_.mDataGetter_.mFoodUnitList_ objectAtIndex:selectedRow] valueForKey:@"UnitName"]];
                break;
                
            default:
                break;
        }
        
    }
  //  NSLog(@"selected row %@ %@ %@", title1,title2,title3);
    float per1 = [title1 floatValue];
    float per2 = [self returnFloatValue:title2];
    float total = per1+per2;
    NSString* size = [NSString stringWithFormat:@"%.1f", total];
    self.mServingLbl.text = [NSString stringWithFormat:@"%@ %@",size,title3];
}
-(float)returnFloatValue:(NSString*)value {
//[[NSMutableArray alloc] initWithObjects:@"0",@"1/8",@"¼",@"1/3", @"½", @"2/3", @"¾", nil]
    float returnValue = 0.0;
    if ([value isEqualToString:@"0"]) {
        returnValue = 0.0;
    }else if ([value isEqualToString:@"1/8"]) {
        returnValue = 0.1;
    }else if ([value isEqualToString:@"1/4"]) {
        returnValue = 0.2;
    }else if ([value isEqualToString:@"1/3"]) {
        returnValue = 0.3;
    }else if ([value isEqualToString:@"1/2"]) {
        returnValue = 0.5;
    }else if ([value isEqualToString:@"2/3"]) {
        returnValue = 0.6;
    }else if ([value isEqualToString:@"3/4"]) {
        returnValue = 0.7;
    }
    return returnValue;
}
-(void)displayPicker {
    NSLog(@"mAppDelegate_.mDataGetter_.mFoodUnitList_ %@",mAppDelegate_.mDataGetter_.mFoodUnitList_);
    int SelecteComponentOne = 1;
    int SelecteComponentTwo = 0;
    int SelecteComponentThree = 0;
    for (int i = 0; i < [mAppDelegate_.mDataGetter_.mFoodUnitList_ count]; i++) {
        int UnitID = [[mAppDelegate_.mDataGetter_.mEditServingDict_ valueForKey:@"UnitID"] intValue];
        if ([[[mAppDelegate_.mDataGetter_.mFoodUnitList_ objectAtIndex:i] valueForKey:@"UnitID"] intValue] == UnitID) {
            SelecteComponentThree = i;
        }
    
    }
    NSString* QtyString = [mAppDelegate_.mDataGetter_.mEditServingDict_ valueForKey:@"Qty"];
    if (QtyString != NULL) {
    int Qty = [QtyString intValue];
    for (int i = 0; i < [mQuantityArr count]; i++) {
        int qtyValue = [[mQuantityArr objectAtIndex:i] intValue];
        if (Qty == qtyValue) {
            SelecteComponentOne = i;
        }
    }
    }
    NSString* percentage = [mAppDelegate_.mDataGetter_.mEditServingDict_ valueForKey:@"percentage"];
    for (int i = 0; i < [mIncreamentArr count]; i++) {
        if ([[mIncreamentArr objectAtIndex:i] isEqualToString:percentage]) {
            SelecteComponentTwo = i;
        }
    }
    
    [self.mPickerView selectRow:SelecteComponentOne inComponent:0 animated:NO];
    [self.mPickerView selectRow:SelecteComponentTwo inComponent:1 animated:NO];
    [self.mPickerView selectRow:SelecteComponentThree inComponent:2 animated:NO];
    [self.mPickerView reloadAllComponents];
    self.mPickerView.hidden = FALSE;

    [self calculateServingValue];
    /*{
     Incr = 1;
     Qty = 1;
     UnitID = "-1";
     UnitName = "User Defined";
     UnitType = 3;
     }*/
}
#pragma mark - Post Request for food units
-(void)postRequestForRecentFoodItems {
    
    /*
     * post request for favorite food
     */
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestToGetFoodUnits:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
