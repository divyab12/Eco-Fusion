//
//  AddEditFoodDetailController.m
//  EHEandme
//
//  Created by Suresh on 2/18/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import "AddEditFoodDetailController.h"
#import "AsyncImageView.h"
#import "JSON.h"
#define DateFormatForRequest @"yyyy-MM-dd"

@interface AddEditFoodDetailController ()

@end

@implementation AddEditFoodDetailController
@synthesize isEdit,mActiveTxtFld,mPreview,mCategoryArr,mSaveArr,mMealTimeArr,mEditDict;
@synthesize mealType;

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
    mSaveArr = [[NSMutableArray alloc] initWithObjects:@"",@"Breakfast",@"",@"OFF",@"",nil];
    mMealTimeArr = [[NSMutableArray alloc] initWithObjects:@"Breakfast",@"Lunch",@"Dinner",@"Snacks", nil];
    
    if (isEdit) {
        //Edit case
        mCategoryArr = [[NSMutableArray alloc] initWithObjects:@"Title",@"Meal Time",@"Calories",@"Photo Preview", nil];
        NSLog(@"mEditDict %@",mEditDict);
        [mSaveArr replaceObjectAtIndex:0 withObject:[mEditDict valueForKey:@"FoodName"]];
        [mSaveArr replaceObjectAtIndex:1 withObject:mealType];
        [mSaveArr replaceObjectAtIndex:2 withObject:[mEditDict valueForKey:@"Calories"]];

    } else {
        //Add case
         mCategoryArr = [[NSMutableArray alloc] initWithObjects:@"Title",@"Meal Time",@"Calories",@"Photo Preview", nil];
        if ([mAppDelegate_.mResponseMethods_.userType intValue] == 4) {
            int coachID = [mAppDelegate_.mResponseMethods_.coachID intValue];
            if (coachID > 0) {
                mCategoryArr = [[NSMutableArray alloc] initWithObjects:@"Title",@"Meal Time",@"Calories",@"OFF",@"Photo Preview", nil];
            }
    }
       

        
    }
   
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [mAppDelegate_ hideEmptySeparators:self.mTableView];
    //for tracking
    if (mAppDelegate_.mTrackPages) {
        //self.trackedViewName=@"Meal Plan - Main View";
        if (isEdit) {
            [mAppDelegate_ trackFlurryLogEvent:@"Food Details – Add View"];
        } else {
            [mAppDelegate_ trackFlurryLogEvent:@"Food Details – Edit View"];
        }
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
    if (isEdit) {
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"EDIT_FOOD_DETAILS", nil) imageName:imgName forController:self];
    } else {
    [mAppDelegate_ setNavControllerTitle:NSLocalizedString(@"ADD_FOOD_DETAILS", nil) imageName:imgName forController:self];
    }
   
    
     [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
     
    //Add Save Button to Right Nav
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"savebtn.png"] title:nil target:self action:@selector(saveAction:) forController:self rightOrLeft:1];

}
- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveAction:(id)sender{
    
    [self doneTxtFld_Event];
    
    NSString* foodName = [mSaveArr objectAtIndex:0];
    if ([foodName isEqualToString:@""]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :@"Please enter the required fields"];
        return;
    }
    
    NSLog(@"mSaveArr %@",mSaveArr);
    
   
    
    if (isEdit) {
        [self postRequestForEditPhotoFood];
    } else {
    
        NSString *isONOFF = [mSaveArr objectAtIndex:3];
        if ([isONOFF isEqualToString:@"ON"]) {
            [self postSendMessageRequest];
        } else if ([isONOFF isEqualToString:@"OFF"]){
            [self postRequestForAddPhotoFood];
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
       return [mCategoryArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [mCategoryArr count]-1) {
        //last row - add preview
        /*if (isEdit) {
            return 60+150;
        } else {*/
            return 60+200;
        //}
    }
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
	
	if (nil==cell)
	{
		cell = [[UITableViewCell alloc]  initWithFrame:CGRectMake(0,0,0,0)] ;
		
        //Category Label
        UILabel *lCateLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 30)];
        [lCateLbl setBackgroundColor:[UIColor clearColor]];
        [lCateLbl setTextAlignment:TEXT_ALIGN_LEFT];
        [lCateLbl setFont:Bariol_Regular(17)];
        lCateLbl.tag =1;
        [lCateLbl setTextColor:RGB_A(136, 136, 136, 1)];
        [cell.contentView addSubview:lCateLbl];
        
        //static text label
        UITextField *lTextLbl=[[UITextField alloc]initWithFrame:CGRectMake(120, 13, 170, 30)];
        [lTextLbl setTextAlignment:NSTextAlignmentRight];
        [Utilities addInputViewForKeyBoardForTextFld:lTextLbl Class:self];
        lTextLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        lTextLbl.keyboardType = UIKeyboardTypeDefault;
        lTextLbl.delegate = self;
        [lTextLbl setFont:Bariol_Regular(17)];
        lTextLbl.tag = indexPath.row+ 2;
        [lTextLbl setTextColor: BLACK_COLOR];
        [lTextLbl setBackgroundColor:CLEAR_COLOR];
        /*
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 28)];
        paddingView.backgroundColor = [UIColor clearColor];
        lTextLbl.rightView = paddingView;
        lTextLbl.rightViewMode = UITextFieldViewModeAlways;*/
        
        [cell.contentView addSubview:lTextLbl];
        
        if (indexPath.row == 1) {
            //arrow image
            UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(305-8.5, 22.5-(13/2), 8.5, 13)];
            lImgView.backgroundColor = CLEAR_COLOR;
            lImgView.image = [UIImage imageNamed:@"arrowright.png"];
            lImgView.tag = 2;
            [cell.contentView addSubview:lImgView];
        }
        if (indexPath.row == 2) {
            CGRect frame = lTextLbl.frame;
            frame.size.width = 170-30;
            lTextLbl.frame = frame;
            UILabel *lsuffixLbl=[[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+frame.size.width+2, 10, 30, 25)];
            [lsuffixLbl setBackgroundColor:CLEAR_COLOR];
            [lsuffixLbl setTextAlignment:TEXT_ALIGN_LEFT];
            [lsuffixLbl setFont:Bariol_Regular(17)];
            lsuffixLbl.tag =3;
            lsuffixLbl.text = @"kcal";
            [lsuffixLbl setTextColor:BLACK_COLOR];
            [cell.contentView addSubview:lsuffixLbl];
            
        }
        
        //Send A hoto Coach
        if (indexPath.row == 3) {
            NSString *isONOFF = [mCategoryArr objectAtIndex:indexPath.row];
            if ([isONOFF isEqualToString:@"ON"] || [isONOFF isEqualToString:@"OFF"]) {
            lCateLbl.hidden = TRUE;
            lTextLbl.hidden = TRUE;
            // Share Photo with coach (Add case)
            UILabel *lCateLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 180, 25)];
            [lCateLbl setBackgroundColor:[UIColor clearColor]];
            [lCateLbl setTextAlignment:TEXT_ALIGN_LEFT];
            [lCateLbl setFont:Bariol_Regular(17)];
            lCateLbl.text = @"Send Photo to Coach";
            [lCateLbl setTextColor:RGB_A(136, 136, 136, 1)];
            [cell.contentView addSubview:lCateLbl];
            //Sub Label
            UILabel *lSubCateLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 22, 230, 25)];
            [lSubCateLbl setBackgroundColor:[UIColor clearColor]];
            [lSubCateLbl setTextAlignment:TEXT_ALIGN_LEFT];
            [lSubCateLbl setFont:Bariol_Regular(12)];
            lSubCateLbl.text = @"Photo and details will be sent to your coach";
            [lSubCateLbl setTextColor:RGB_A(136, 136, 136, 1)];
            [cell.contentView addSubview:lSubCateLbl];
            
             NSString *isON = [mCategoryArr objectAtIndex:indexPath.row];
            //UISwitch
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(220, 10, 0, 0)];//UISwitch object is not resizable, you put in the Width and Height parameters, it’s not going to change anything.
            if ([isON isEqualToString:@"ON"]) {
                [mySwitch setOn:YES];
            } else {
                [mySwitch setOn:FALSE];
            }
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            
            [cell.contentView addSubview:mySwitch];
            }
        }
        //Notes for Coach
        if (indexPath.row == 4) {
            NSString *notesFor = [mCategoryArr objectAtIndex:indexPath.row];
            if ([notesFor isEqualToString:@"Notes for Coach"]) {
                
                lCateLbl.hidden = TRUE;
                // lTextLbl.hidden = TRUE;
                // Share Photo with coach (Add case)
                UITextField *lTextLbl=[[UITextField alloc]initWithFrame:CGRectMake(15, 10+5, 290, 30)];
                [lTextLbl setTextAlignment:NSTextAlignmentLeft];
                [Utilities addInputViewForKeyBoardForTextFld:lTextLbl Class:self];
                lTextLbl.keyboardType = UIKeyboardTypeDefault;
                 lTextLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                lTextLbl.delegate = self;
                lTextLbl.tag = 50;
                lTextLbl.placeholder = @"Notes for Coach";
                [lTextLbl setFont:Bariol_Regular(17)];
                [lTextLbl setTextColor: BLACK_COLOR];
                [lTextLbl setBackgroundColor:CLEAR_COLOR];
                [cell.contentView addSubview:lTextLbl];
            }
        }
        if (indexPath.row == [mCategoryArr count]-1) {
            //last row - add preview
            lCateLbl.hidden = FALSE;
            lTextLbl.hidden = TRUE;

           /* if (isEdit) {
                AsyncImageView *AsyncImgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 150)];
                AsyncImgView.tag = 6;
                AsyncImgView.imageURL = [NSURL URLWithString:[mEditDict objectForKey:@"Image"]];
                mPreview = AsyncImgView.image;
                AsyncImgView.image = [UtilitiesLibrary imageScaledToSize:CGSizeMake(320, mPreview.size.height) :mPreview];
                //AsyncImgView.contentMode = UIViewContentModeScaleAspectFit;
                [cell.contentView addSubview:AsyncImgView];
                
            } else {*/
                UIImageView *preview = [[UIImageView alloc] initWithFrame:CGRectMake(60, 50, 200, 150)];//CGRectMake(85, 50, 150, 200)
                //preview.image = [UtilitiesLibrary imageScaledToSize:CGSizeMake(320, mPreview.size.height) :mPreview];
                preview.image = [self imageScaledToSize:CGSizeMake(200,150) :mPreview];
            preview.backgroundColor = CLEAR_COLOR;
                [cell.contentView addSubview:preview];

            //}
            /*if (isEdit) {
             
             UIImageView *preview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 50, 120, mPreview.size.height)];
             //preview.image = [UtilitiesLibrary imageScaledToSize:CGSizeMake(320, mPreview.size.height) :mPreview];
             preview.image = [self imageScaledToSize:CGSizeMake(120, mPreview.size.height) :mPreview];
             [cell.contentView addSubview:preview];
             } else {
             UIImageView *preview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, mPreview.size.height)];
             preview.image = mPreview;
             preview.contentMode = UIViewContentModeScaleAspectFit;
             [cell.contentView addSubview:preview];
             }*/
            
            cell.contentView.backgroundColor = RGB_A(233, 233, 233, 1);
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    
    UITextField *lLbl2 = (UITextField*)[cell.contentView viewWithTag:indexPath.row+2];
    lLbl2.keyboardType = UIKeyboardTypeDefault;
    if (indexPath.row+2 == 2) {
        lLbl2.text = [mSaveArr objectAtIndex:0];
        lLbl2.placeholder = @"Required";
    } else if (indexPath.row+2 == 3){
        lLbl2.text = [mSaveArr objectAtIndex:1]; //Meal Time
    } else if (indexPath.row+2 == 4){
        lLbl2.text = [NSString stringWithFormat:@"%@",[mSaveArr objectAtIndex:2]];
        lLbl2.placeholder = @"Optional";
        lLbl2.keyboardType = UIKeyboardTypeDecimalPad;

    }
    
    UILabel *lLbl1 = (UILabel*)[cell.contentView viewWithTag:1];
    lLbl1.text = [mCategoryArr objectAtIndex:indexPath.row];
   
    return cell;
}
- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        // Execute any code when the switch is ON
        NSLog(@"Switch is ON");
        [self.mSaveArr replaceObjectAtIndex:3 withObject:@"ON"];
         mCategoryArr = [[NSMutableArray alloc] initWithObjects:@"Title",@"Meal Time",@"Calories",@"ON",@"Notes for Coach",@"Photo Preview", nil];
        [self.mTableView reloadData];
    } else{
        // Execute any code when the switch is OFF
        NSLog(@"Switch is OFF");
        [self.mSaveArr replaceObjectAtIndex:3 withObject:@"OFF"];
        mCategoryArr = [[NSMutableArray alloc] initWithObjects:@"Title",@"Meal Time",@"Calories",@"OFF",@"Photo Preview", nil];
        [self.mTableView reloadData];

    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //for second row
    if (textField.tag == 3) {
        [self doneTxtFld_Event];
        [textField resignFirstResponder];
        [self displayPickerview];
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
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 50) {
        [self.mSaveArr replaceObjectAtIndex:4 withObject:textField.text];
    } else {
        int index = self.mActiveTxtFld.tag-2;
        [self.mSaveArr replaceObjectAtIndex:index withObject:textField.text];
    }

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
- (void)displayPickerview {
    
    PickerViewController *screen = [[PickerViewController alloc] init];
    NSMutableArray *rowValuesArr_=[[NSMutableArray alloc] init];
    NSMutableArray *lValues = [[NSMutableArray alloc]initWithArray:mMealTimeArr];
    [rowValuesArr_ addObject:lValues];
    screen.mRowValueintheComponent=rowValuesArr_;
    screen->mNoofComponents=[rowValuesArr_ count];
    screen.mTextDisplayedlb.text=@"Select Meal Time";
   
    for (int i =0; i<[mMealTimeArr count]; i++) {
        NSString* selectedMeal = [mSaveArr objectAtIndex:1];//Meal Time
        if ([[mMealTimeArr objectAtIndex:i] isEqualToString:selectedMeal]) {
            [screen.mViewPicker_ selectRow:i inComponent:0 animated:NO];
            [screen.mViewPicker_ reloadComponent:0];
        }
    }
    
    [screen setMPickerViewDelegate_:self];
    [mAppDelegate_.window addSubview:screen];
    
}
- (void)pickerViewController:(PickerViewController *)controller
                 didPickComp:(NSMutableArray *)valueArr
                      isDone:(BOOL)isDone{
    
    if(isDone==YES)
    {
        NSString *mSelected_=@"";
        for(int i=0;i<[valueArr count];i++){
            
            mSelected_=[mSelected_ stringByAppendingString:[valueArr objectAtIndex:i]];
        }
        NSLog(@"mSelected_ %@",mSelected_);
        [mSaveArr replaceObjectAtIndex:1 withObject:mSelected_];
        [self.mTableView reloadData];
        if([controller superview]){
			[controller removeFromSuperview];
		}
    }
    else
    {
        if([controller superview]){
            [controller removeFromSuperview];
        }
    }
}
-(void)postRequestForAddPhotoFood {
    
    NSDateFormatter *mFormatter_=[[NSDateFormatter alloc]init];
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [mFormatter_ setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    mFormatter_.locale = enLocale;
    
    [mFormatter_ setDateFormat:DateFormatForRequest];
    NSString *currentDate =[mFormatter_ stringFromDate:[NSDate date]];
    NSString *calories = [NSString stringWithFormat:@"%@",[mSaveArr objectAtIndex:2]];
    if ([calories isEqualToString:@""]) {
        calories = @"0";
    }
    CGSize size = CGSizeMake(200, 150);//CGSizeMake(240, 320);
    UIImage *scalledImg = [self imageScaledToSize:size :mPreview];//[Utilities imageWithImage:mPreview scaledToSize:size];
    /*
     * post request for Upload food photo
     */
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        [mAppDelegate_.mRequestMethods_ postRequestForUploadPhoto:currentDate MealName:[mSaveArr objectAtIndex:1] FoodName:[mSaveArr objectAtIndex:0] Calories:calories Image:scalledImg AuthToken:mAppDelegate_.mResponseMethods_.authToken SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }


}

-(void)postRequestForEditPhotoFood {
  
   
    NSString *calories = [NSString stringWithFormat:@"%@",[mSaveArr objectAtIndex:2]];
    if ([calories isEqualToString:@""]) {
        calories = @"0";
    }
    
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
        
        NSString *mRequestURL=WEBSERVICEURL;
        mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/Photo/%@?meal=%@&foodName=%@&calories=%@", MEALPLANTEXT,[mEditDict valueForKey:@"FoodLogID"],[mSaveArr objectAtIndex:1],[mSaveArr objectAtIndex:0],calories];
       
        // mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@/%@?Qty=%@&unit=%@", MEALPLANTEXT,currentDate,[mSaveArr objectAtIndex:1],[mEditDict valueForKey:@"FoodLogID"],[mSaveArr objectAtIndex:2],[mEditDict valueForKey:@"UnitID"]];

        
        mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [NSThread detachNewThreadSelector:@selector(GetResponseData:) toTarget:self withObject:mRequestURL];
        
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
    [theRequest setValue:mAppDelegate_.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate_.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"PUT"];
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"Edit Photo Food %@",json_string);
    
    if ([[json_string JSONValue] isKindOfClass:[NSMutableArray class]]) {
    } else if([[json_string JSONValue] isKindOfClass:[NSMutableDictionary class]])
    {
        NSMutableDictionary *mDict = [json_string JSONValue];
        if ([mDict objectForKey:@"Message"]!=nil ) {
            [mAppDelegate_ removeLoadView];
            [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :[mDict objectForKey:@"Message"]];
            return;
        }
    }else if ([json_string isEqualToString:@"An error occurred"]) {
        [mAppDelegate_ removeLoadView];
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"NO_RESPONSE", nil)];
        return;
    }
    
    [mAppDelegate_ removeLoadView];
    [self performSelectorOnMainThread:@selector(parseEditFood:) withObject:nil waitUntilDone:NO];
}
- (void)parseEditFood:(NSObject *) isSucces {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage*) imageScaledToSize: (CGSize) newSize :(UIImage*)largeImage {
    //DTM-1073 iPad3 Retina - The grid/thumbnail view thumbnails are too pixelated
    if ([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    //DTM-1062 Thumbnail/grid view should not stretch all images to fit into a square area
    CGRect rect = [self calculateSize:newSize:largeImage.size];
    [largeImage drawInRect:rect];
    //[largeImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//-------------------------------------------------------------------------------
//Method-    Caluclating the frames of the controls
//-------------------------------------------------------------------------------
//DTM-1062 Thumbnail/grid view should not stretch all images to fit into a square area
-(CGRect)calculateSize :(CGSize) newSize :(CGSize)imageSize {
    
    double lScaleFactor = MIN((newSize.width)/imageSize.width, (newSize.height)/imageSize.height);
    
    if(lScaleFactor>1) {
        lScaleFactor = 1;
    }
    
    return CGRectMake(((newSize.width- lScaleFactor*imageSize.width)/2),((newSize.height-lScaleFactor*imageSize.height)/2), lScaleFactor*imageSize.width, lScaleFactor*imageSize.height);
}
- (void)postSendMessageRequest {
    NSString *mType = @"1";
    if ([[NetworkMonitor instance] isNetworkAvailable]) {
        [mAppDelegate_ createLoadView];
       /* [mAppDelegate_.mRequestMethods_ postRequestToSendNewMessage:[NSString stringWithFormat:@"%d", mId]
                                                               Type:mType
                                                            Subject:@""
                                                               Body:@""
                                                          AuthToken:mAppDelegate_.mResponseMethods_.authToken
                                                       SessionToken:mAppDelegate_.mResponseMethods_.sessionToken];
        */
    
    
        NSString *mRequestURL = WEBSERVICEURL;
        
        mRequestURL = [mRequestURL stringByAppendingFormat:@"%@",MessagesTXT];
        mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *body = [NSString stringWithFormat:@"To=%@&Type=%@&Subject=%@&Body=%@", mAppDelegate_.mResponseMethods_.coachID, mType, @"Notes for Coach", @"testing"];
        
        // mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@/%@?Qty=%@&unit=%@", MEALPLANTEXT,currentDate,[mSaveArr objectAtIndex:1],[mEditDict valueForKey:@"FoodLogID"],[mSaveArr objectAtIndex:2],[mEditDict valueForKey:@"UnitID"]];
        
        
        mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:mRequestURL forKey:@"Request"];
        [dict setValue:body forKey:@"Body"];
        [NSThread detachNewThreadSelector:@selector(GetResponseMessageData:) toTarget:self withObject:dict];
    
    }else{
        [[NetworkMonitor instance] displayNetworkMonitorAlert];
    }
    
}

- (void)GetResponseMessageData:(NSObject *) myObject  {
    NSMutableDictionary *dict = (NSMutableDictionary*)myObject;
    NSString *request = [dict valueForKey:@"Request"];
    NSString *body = [dict valueForKey:@"Body"];
    
    NSURL *url1 = [NSURL URLWithString:request];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    [theRequest setValue:mAppDelegate_.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate_.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"PUT"];
    
    
    NSData *bodyData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    [theRequest setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    //[theRequest addValue:@"1000965" forHTTPHeaderField:@"userID"];
    // [theRequest addValue:@"100201" forHTTPHeaderField:@"ListId"];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:bodyData];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"GetResponseMessageData %@",json_string);
    
    if ([[json_string JSONValue] isKindOfClass:[NSMutableArray class]]) {
    } else if([[json_string JSONValue] isKindOfClass:[NSMutableDictionary class]])
    {
        NSMutableDictionary *mDict = [json_string JSONValue];
        if ([mDict objectForKey:@"ErrorMessage"]!=nil ) {
            [mAppDelegate_ removeLoadView];
            
            [mAppDelegate_ showCustomAlert:@"" Message:[mDict objectForKey:@"ErrorMessage"]];
          //  [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :[mDict objectForKey:@"ErrorMessage"]];
        }
        if ([mDict objectForKey:@"Success"]!=nil) {
            if (![[mDict objectForKey:@"Success"] boolValue]) {
               // return;
            }
        }
    }else if ([json_string isEqualToString:@"An error occurred"]) {
        [mAppDelegate_ removeLoadView];
        [mAppDelegate_ showCustomAlert:@"" Message:NSLocalizedString(@"NO_RESPONSE", nil)];
        //[UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"NO_RESPONSE", nil)];
        return;
    }
    
    [mAppDelegate_ removeLoadView];
    [self performSelectorOnMainThread:@selector(parseSendMessage:) withObject:nil waitUntilDone:NO];
}
- (void)parseSendMessage:(NSObject *) isSucces {
    [self postRequestForAddPhotoFood];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
