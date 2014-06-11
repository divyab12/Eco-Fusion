//
//  FoodDetailsViewController.m
//  SensaApplication
//
//  Created by Valuelabs on 10/04/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import "FoodDetailsViewController.h"
#define kFoodCalorieDetail @"Total Fat,Saturated Fat,Trans Fat,Cholesterol,Sodium,Carbohydrate,Dietary Fiber,Sugars,Protein,Vitamin A,Vitamin C,Calcium,Iron"
#define KQuantityHigh @"100,200,300,400,500,600,700,800,900,1000"
#define KQuantityLow @"0.5,1,1.5,2,2.5,3,3.5,4,4.5,6,6.5,7,7.5,8,8.5,9,9.5,10"
#define KQuantityMedium @"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25"
#define KUnit @"Grams,small,Large,cup"

#define SecondsInAWeek  60 * 60 * 24
#define DateFormatServer @"MM/dd/yyyy hh:mm:ss a"
#define DateFormatApp @"EEEE, MMMM dd, yyyy"
#define DateFormatForRequest @"MM/dd/yyyy"
#define KToday @"Today"

#import "AsyncImageView.h"

@implementation FoodDetailsViewController
@synthesize mFoodNameLable_;
@synthesize mCaloriesLable_;
@synthesize mCaloriesFromFatLable_;
@synthesize mCaloriDetailTableView_;
@synthesize mFoodDetailLeftArr_;
@synthesize mFoodQtyLbl_;
@synthesize mRowValueintheComponent;
@synthesize mIsfavorite;
@synthesize percentString;

@synthesize mDisplayedDate_;
@synthesize mFormatter_;
@synthesize mCurrentDate_;

@synthesize mFoodId;
@synthesize mSelectedIndex;
@synthesize mSelectedindexpath;
@synthesize isReported;
@synthesize mSelectedId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
          mFoodDetailLeftArr_ = [[NSMutableArray alloc] initWithArray:[kFoodCalorieDetail componentsSeparatedByString:@","]];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    mAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    // for setting the view below 20px in iOS7.0.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    
    self.mFoodNameLable_.font = Bariol_Regular(40);
    self.mFoodNameLable_.textColor = BLACK_COLOR;
    self.mFoodCommentLbl_.font = Bariol_Regular(17);
    self.mFoodCommentLbl_.textColor = RGB_A(116, 185, 223, 1);
    self.mBrandNameLbl.font = Bariol_Regular(17);
    self.mBrandNameLbl.textColor = BLACK_COLOR;
    self.mFoodQtyLbl_.font = Bariol_Regular(28);
    self.mFoodQtyLbl_.textColor = BLACK_COLOR;
    self.mFoodUnitNameLbl_.font = Bariol_Regular(17);
    self.mFoodUnitNameLbl_.textColor = BLACK_COLOR;
    self.mAmountPerSerLbl_.font = Bariol_Regular(22);
    self.mAmountPerSerLbl_.textColor = RGB_A(136, 136, 136, 1);
    self.mCalLbl_.font = Bariol_Regular(22);
    self.mCalLbl_.textColor = RGB_A(136, 136, 136, 1);
    self.mCaloriesLable_.font = Bariol_Bold(22);
    self.mCaloriesLable_.textColor = BLACK_COLOR;
    self.mFatLbl_.font = Bariol_Regular(22);
    self.mFatLbl_.textColor = RGB_A(136, 136, 136, 1);
    self.mCaloriesFromFatLable_.font = Bariol_Bold(22);
    self.mCaloriesFromFatLable_.textColor = BLACK_COLOR;
    self.mdialyCalLbl.font = Bariol_Regular(22);
    self.mdialyCalLbl.textColor = RGB_A(136, 136, 136, 1);
    [self loadDetails];
    
    mFormatter_=[[NSDateFormatter alloc]init];
    self.mCaloriDetailTableView_.rowHeight=25;
    NSMutableArray* lArr=[[NSMutableArray alloc] init];
    self.mRowValueintheComponent=lArr;
    percentString = @"%";
    self.mEditQuantityBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mEditQuantityBtn.layer.borderWidth = 1.0f;


     mQuantity_ = [[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:0] valueForKey:@"Qty"] floatValue];
    
    // to store index path
    mSelectedIndex = 0;
    mSelectedindexpath =0;
    
    if (self.isReported) {
        mQuantity_ = mAppDelegate.mLogMealsViewController.mQuantity_;
        for (int i =0 ; i < [[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] count]; i++) {
            if ([mAppDelegate.mLogMealsViewController.mUnitID intValue] == [[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:i] objectForKey:@"UnitID"] intValue]) {
                mSelectedIndex = i;
                mSelectedindexpath = i;
            }
        }
        
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    
   // float test = 3.75,test1 = 3.25;
   // NSLog(@"test-round %f %f",roundf(test),roundf(test1));//4.000000 3.000000
    // NSLog(@"test-ceilf %f %f",ceilf(test),ceilf(test1));//4.000000 4.000000
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate.mTrackPages) {
       // self.trackedViewName=@"Food Details – Nutrition View";
        [mAppDelegate trackFlurryLogEvent:@"Food Details – Nutrition View"];
        
    }
    //end
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"fooddetailnavbar1.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"fooddetailnavbar.png";
    }
    [mAppDelegate setNavControllerTitle:@"" imageName:imgName forController:self];
    
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
    //right bar buttons
    CGFloat navHeight = 44, gapFromLine = 10;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        navHeight = 64;
        gapFromLine = 10;
    }
    //to set the add or delete button at the top
    if (self.isReported) {
        
        UIView *lBarbuttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, navHeight)];
        
        //delete button
        UIButton *lDeleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (navHeight/2) - (24/2), 16.5, 24)];
        [lDeleteBtn setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
        [lDeleteBtn addTarget:self action:@selector(deleteFoodAction:) forControlEvents:UIControlEventTouchUpInside];
        [lBarbuttonView addSubview:lDeleteBtn];
        
        //line image
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(lDeleteBtn.frame.origin.x+lDeleteBtn.frame.size.width+gapFromLine, (navHeight/2) - (28.5/2), 1, 28.5)];
        lImgView.image = [UIImage imageNamed:@"smallline.png"];
        [lBarbuttonView addSubview:lImgView];
        
        //favorite button
        UIButton *lFavoriteBtn = [[UIButton alloc]initWithFrame:CGRectMake(lImgView.frame.origin.x+lImgView.frame.size.width+gapFromLine, (navHeight/2) - (navHeight/2), 28.5, navHeight)];
        [lFavoriteBtn addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
        [lFavoriteBtn setImage:[UIImage imageNamed:@"favoriteblue.png"] forState:UIControlStateNormal];
        [lFavoriteBtn setImage:[UIImage imageNamed:@"favoriteorange.png"] forState:UIControlStateSelected];

        if (![[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"FavoriteYN"] boolValue]) {
            lFavoriteBtn.selected = FALSE;
        }
        else
        {
            lFavoriteBtn.selected = TRUE;
        }
        [lBarbuttonView addSubview:lFavoriteBtn];
        lBarbuttonView.frame = CGRectMake(0, 0, lFavoriteBtn.frame.origin.x+lFavoriteBtn.frame.size.width, lBarbuttonView.frame.size.height);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            lBarbuttonView.frame = CGRectMake(0, 0, lFavoriteBtn.frame.origin.x+lFavoriteBtn.frame.size.width, lBarbuttonView.frame.size.height);
            
        }
        UIBarButtonItem *lRightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:lBarbuttonView];
        self.navigationItem.rightBarButtonItem = lRightBarBtn;
        
    }else{
        UIView *lBarbuttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, navHeight)];
        
        //favorite button
        UIButton *lFavoriteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (navHeight/2) - (navHeight/2), 28.5, navHeight)];
        [lFavoriteBtn addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
        [lFavoriteBtn setImage:[UIImage imageNamed:@"favoriteblue.png"] forState:UIControlStateNormal];
        [lFavoriteBtn setImage:[UIImage imageNamed:@"favoriteorange.png"] forState:UIControlStateSelected];
        
        if (![[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"FavoriteYN"] boolValue]) {
            lFavoriteBtn.selected = FALSE;
        }
        else
        {
            lFavoriteBtn.selected = TRUE;
        }
        [lBarbuttonView addSubview:lFavoriteBtn];
        
        //add button
        UIButton *lAddBtn = [[UIButton alloc]initWithFrame:CGRectMake(lFavoriteBtn.frame.origin.x+lFavoriteBtn.frame.size.width+10, (navHeight/2) - (30/2), 75, 30)];
        [lAddBtn setImage:[UIImage imageNamed:@"addbtn.png"] forState:UIControlStateNormal];
       // [lAddBtn setImage:[UIImage imageNamed:@"addbtnselected.png"] forState:UIControlStateHighlighted];
        [lAddBtn addTarget:self action:@selector(addFoodAction:) forControlEvents:UIControlEventTouchUpInside];
        [lBarbuttonView addSubview:lAddBtn];
        lBarbuttonView.frame = CGRectMake(0, 0, lAddBtn.frame.origin.x+lAddBtn.frame.size.width, lBarbuttonView.frame.size.height);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            lBarbuttonView.frame = CGRectMake(0, 0, lAddBtn.frame.origin.x+lAddBtn.frame.size.width, lBarbuttonView.frame.size.height);

        }
        UIBarButtonItem *lRightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:lBarbuttonView];
        self.navigationItem.rightBarButtonItem = lRightBarBtn;

    }
}
- (void)backAction:(id)sender{
    if (self.isReported) {
        NSString * mUnitId=[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:mSelectedindexpath] valueForKey:@"UnitID"];
        
        NSString *  mQty;
        mQty =[NSString stringWithFormat:@"%.1f",mQuantity_];
        NSString *mfavorite = @"";
        if ([mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"FavoriteYN"]) {
            mfavorite = @"true";
        } else {
            mfavorite = @"false";
        }
        //update request
        if ([[NetworkMonitor instance] isNetworkAvailable]) {
            [mAppDelegate createLoadView];
            [mAppDelegate.mRequestMethods_ postRequestForEditLogFood:mAppDelegate.mLogMealsViewController.mCurrentDate_ MealType:mAppDelegate.mLogMealsViewController.mMealLUT FoodLogDailyId:mAppDelegate.mLogMealsViewController.mFoodLogDailyId FoodLogID:mAppDelegate.mLogMealsViewController.mFoodLogId FoodID:mAppDelegate.mLogMealsViewController.mFoodID Quantity:mQty UnitID:mUnitId Favorite:mfavorite AuthToken:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else{
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
            return;
            
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (void)deleteFoodAction:(id)sender{
    //delete req
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate createLoadView];
        mAppDelegate.mRequestMethods_.mViewRefrence = self;
        
        [mAppDelegate.mRequestMethods_ postRequestForDeleteLogFood:mAppDelegate.mLogMealsViewController.mCurrentDate_ FoodLogDailyId:mAppDelegate.mLogMealsViewController.mFoodLogDailyId FoodLogID:mAppDelegate.mLogMealsViewController.mFoodLogId AuthToken:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        
        /*
        [mAppDelegate.mRequestMethods_ postRequestForDeleteLogFood:mAppDelegate.mLogMealsViewController.mCurrentDate_
                                                          MealType:mAppDelegate.mLogMealsViewController.mMealLUT
                                                         FoodLogID:mAppDelegate.mLogMealsViewController.mFoodLogId
                                                         AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                      SessionToken:mAppDelegate.mResponseMethods_.sessionToken];*/
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
        return;
        
    }
}
- (void)favoriteAction:(UIButton*)sender{
    
    if ([sender isSelected]) {
        [sender setSelected:FALSE];
        if ([[NetworkMonitor instance] isNetworkAvailable])
        {
            [mAppDelegate createLoadView];
            [mAppDelegate.mRequestMethods_ postRequestToRemoveFoodToFavorites:self.mSelectedId AuthToken:mAppDelegate.mResponseMethods_.authToken SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else {
            
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
            return;
        }

        
    }else{
        [sender setSelected:TRUE];
        NSString * mUnitId=[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:mSelectedindexpath] valueForKey:@"UnitID"];
        
        NSString *  mQty;
        mQty =[NSString stringWithFormat:@"%.1f",mQuantity_];
        if ([[NetworkMonitor instance] isNetworkAvailable])
        {
            [mAppDelegate createLoadView];
            [mAppDelegate.mRequestMethods_ postRequestToAddFoodToFavorites:self.mSelectedId
                                                                  Quantity:mQty UnitID:mUnitId
                                                                 AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                              SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
        }else {
            
            [[NetworkMonitor instance]displayNetworkMonitorAlert];
            return;
        }


    }
}
- (void)addFoodAction:(UIButton*)sender{
    NSString *mMealType = [NSString stringWithFormat:@"%@",mAppDelegate.mLogMealsViewController.mMealLUT];
    NSString * mUnitId=[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:mSelectedindexpath] valueForKey:@"UnitID"];
    
    NSString *  mQty;
    mQty =[NSString stringWithFormat:@"%.1f",mQuantity_];
    
    //add req
    if ([[NetworkMonitor instance]isNetworkAvailable]) {
        [mAppDelegate createLoadView];
        [mAppDelegate.mRequestMethods_ postRequestForFoodAdd:mAppDelegate.mLogMealsViewController.mCurrentDate_
                                                    MealType:mMealType
                                                      FoodID:self.mSelectedId
                                                    Quantity:mQty
                                                      UnitID:mUnitId
                                                   AuthToken:mAppDelegate.mResponseMethods_.authToken
                                                SessionToken:mAppDelegate.mResponseMethods_.sessionToken];
    }else{
        [[NetworkMonitor instance]displayNetworkMonitorAlert];
        return;
        
    }
}
-(void)loadDetails{

    self.mFoodQtyLbl_.text = [NSString stringWithFormat:@"%@", [[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:0]valueForKey:@"Qty"]];
    self.mFoodUnitNameLbl_.text = [NSString stringWithFormat:@"%@", [[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:0]valueForKey:@"UnitName"]];
    
    [self adjustTheBottomUILayoutBasedOnText];

    
    CGFloat xPos = 20;
    CGFloat yPos = 15;
    CGFloat lblWidth = 0;
    NSString* mPhotoFileName= [NSString stringWithFormat:@"%@", [mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"PhotoFileName"]];
    if (mPhotoFileName && ![mPhotoFileName isEqualToString:@""]) {
        
        AsyncImageView *AsyncImgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(xPos, yPos, 170, 130)];
        mPhotoFileName = [mPhotoFileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mPhotoFileName = [mPhotoFileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        AsyncImgView.imageURL = [NSURL URLWithString:mPhotoFileName];
        AsyncImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.mScrollView addSubview:AsyncImgView];
        yPos += 140;
        yPos += 10;
        lblWidth = 290;
    }else {
        //no image case
        yPos = self.mEditQuantityBtn.frame.origin.y;// +self.mEditQuantityBtn.frame.size.height+5;
        lblWidth = 180;
    }
    
    mFoodNameLable_.text = [NSString stringWithFormat:@"%@", [mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"FoodName"]];
   // mFoodNameLable_.backgroundColor = RED_COLOR;
    CGSize size =  [self.mFoodNameLable_.text sizeWithFont:self.mFoodNameLable_.font constrainedToSize:CGSizeMake(lblWidth, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    
    self.mFoodNameLable_.frame = CGRectMake(self.mFoodNameLable_.frame.origin.x, yPos, lblWidth , size.height);
    NSString* brand = @"";
    if ( [mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Brand"] !=[NSNull null] ) {
        brand = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Brand"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    }
    if (brand.length > 0) {
        self.mBrandNameLbl.text = brand;//[NSString stringWithFormat:@"(%@)",[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Brand"]];
        size =  [self.mBrandNameLbl.text sizeWithFont:self.mBrandNameLbl.font constrainedToSize:CGSizeMake(self.mBrandNameLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        
        self.mBrandNameLbl.frame = CGRectMake(self.mBrandNameLbl.frame.origin.x, self.mFoodNameLable_.frame.origin.y+self.mFoodNameLable_.frame.size.height+3, self.mBrandNameLbl.frame.size.width, size.height);
        self.mFoodCommentLbl_.frame = CGRectMake(self.mFoodCommentLbl_.frame.origin.x, self.mBrandNameLbl.frame.origin.y+self.mBrandNameLbl.frame.size.height+3, self.mFoodCommentLbl_.frame.size.width, self.mFoodCommentLbl_.frame.size.height);
        self.mBrandNameLbl.hidden = FALSE;
    }else{
         self.mBrandNameLbl.hidden = TRUE;
         self.mFoodCommentLbl_.frame = CGRectMake(self.mFoodCommentLbl_.frame.origin.x, self.mFoodNameLable_.frame.origin.y+self.mFoodNameLable_.frame.size.height+3, self.mFoodCommentLbl_.frame.size.width, self.mFoodCommentLbl_.frame.size.height);
    }

    self.mFoodCommentLbl_.text = @""; //@"Comment";
    if ( [mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Comment"] !=[NSNull null] ) {
    //    self.mFoodCommentLbl_.text = [NSString stringWithFormat:@"%@", [mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Comment"]];
    }
    size =  [self.mFoodCommentLbl_.text sizeWithFont:self.mFoodCommentLbl_.font constrainedToSize:CGSizeMake(self.mFoodCommentLbl_.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (self.mFoodCommentLbl_.text.length == 0) {
        size.height = 0;
    }
    self.mFoodCommentLbl_.frame = CGRectMake(self.mFoodCommentLbl_.frame.origin.x, self.mFoodCommentLbl_.frame.origin.y, self.mFoodCommentLbl_.frame.size.width, size.height);
}
- (void)adjustTheBottomUILayoutBasedOnText{
    CGSize size;
    size =  [self.mFoodUnitNameLbl_.text sizeWithFont:self.mFoodUnitNameLbl_.font constrainedToSize:CGSizeMake(self.mFoodUnitNameLbl_.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mFoodUnitNameLbl_.frame = CGRectMake(self.mFoodUnitNameLbl_.frame.origin.x, self.mFoodUnitNameLbl_.frame.origin.y, self.mFoodUnitNameLbl_.frame.size.width, size.height);
    //to set the edit quantity button frame
    if (self.mFoodUnitNameLbl_.frame.origin.y+self.mFoodUnitNameLbl_.frame.size.height > 70) {
        self.mEditQuantityBtn.frame = CGRectMake(self.mEditQuantityBtn.frame.origin.x, self.mEditQuantityBtn.frame.origin.y, self.mEditQuantityBtn.frame.size.width, self.mFoodUnitNameLbl_.frame.origin.y+self.mFoodUnitNameLbl_.frame.size.height+5);
    }else{
         self.mEditQuantityBtn.frame = CGRectMake(self.mEditQuantityBtn.frame.origin.x, self.mEditQuantityBtn.frame.origin.y, self.mEditQuantityBtn.frame.size.width, 70);
    }
    
    //to check whether edit quantity frame or comment label frame is greater
    CGFloat mTopHeight = self.mFoodCommentLbl_.frame.origin.y+self.mFoodCommentLbl_.frame.size.height+20;
    self.mAmountPerSerLbl_.frame =  CGRectMake(self.mAmountPerSerLbl_.frame.origin.x,mTopHeight, self.mAmountPerSerLbl_.frame.size.width, self.mAmountPerSerLbl_.frame.size.height);
    
    
    self.mLineIImgView_.frame =  CGRectMake(self.mLineIImgView_.frame.origin.x, self.mAmountPerSerLbl_.frame.origin.y+self.mAmountPerSerLbl_.frame.size.height+5, self.mLineIImgView_.frame.size.width, self.mLineIImgView_.frame.size.height);
    self.mLine2ImgView_.frame =  CGRectMake(self.mLine2ImgView_.frame.origin.x, self.mLineIImgView_.frame.origin.y+self.mLineIImgView_.frame.size.height+90+35, self.mLine2ImgView_.frame.size.width, self.mLine2ImgView_.frame.size.height);
    if ([[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Recipe"] boolValue]) {
        self.mRecipeView.frame = CGRectMake(self.mRecipeView.frame.origin.x,  self.mLineIImgView_.frame.origin.y+self.mLineIImgView_.frame.size.height+90+35, self.mRecipeView.frame.size.width, self.mRecipeView.frame.size.height);
        self.mRecipeView.hidden = FALSE;
        //[self loadrecipeDetails];
         self.mLine2ImgView_.frame =  CGRectMake(self.mLine2ImgView_.frame.origin.x, self.mRecipeView.frame.origin.y+self.mRecipeView.frame.size.height+35, self.mLine2ImgView_.frame.size.width, self.mLine2ImgView_.frame.size.height);
    }
    
    //self.mCaloriesLable_.text = [NSString stringWithFormat:@"%.1f", [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Calories"] floatValue]];
    size =  [self.mCalLbl_.text sizeWithFont:self.mCalLbl_.font constrainedToSize:CGSizeMake(100, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mCalLbl_.frame = CGRectMake(self.mCalLbl_.frame.origin.x, self.mLineIImgView_.frame.origin.y+self.mLineIImgView_.frame.size.height+15, size.width, self.mCalLbl_.frame.size.height);
    
    size =  [self.mCaloriesLable_.text sizeWithFont:self.mCaloriesLable_.font constrainedToSize:CGSizeMake(300, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mCaloriesLable_.frame = CGRectMake(self.mCalLbl_.frame.origin.x+self.mCalLbl_.frame.size.width+5, self.mCalLbl_.frame.origin.y, size.width, self.mCaloriesLable_.frame.size.height);
    
    size =  [self.mFatLbl_.text sizeWithFont:self.mFatLbl_.font constrainedToSize:CGSizeMake(3000, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mFatLbl_.frame = CGRectMake(self.mCalLbl_.frame.origin.x, self.mCalLbl_.frame.origin.y+self.mCalLbl_.frame.size.height+10, size.width, self.mFatLbl_.frame.size.height);
    
    
    //mCaloriesFromFatLable_.text = [NSString stringWithFormat:@"%d", [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"CaloriesFromFat"]intValue]];
    size =  [self.mCaloriesFromFatLable_.text sizeWithFont:self.mCaloriesFromFatLable_.font constrainedToSize:CGSizeMake(3000, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mCaloriesFromFatLable_.frame = CGRectMake(self.mFatLbl_.frame.origin.x+self.mFatLbl_.frame.size.width+3, self.mFatLbl_.frame.origin.y, size.width, self.mCaloriesFromFatLable_.frame.size.height);
    
    self.mdialyCalLbl.frame = CGRectMake(self.mdialyCalLbl.frame.origin.x, self.mLine2ImgView_.frame.origin.y-30, self.mdialyCalLbl.frame.size.width, self.mdialyCalLbl.frame.size.height);
    self.mCaloriDetailTableView_.frame = CGRectMake(self.mCaloriDetailTableView_.frame.origin.x, self.mLine2ImgView_.frame.origin.y+1, self.mCaloriDetailTableView_.frame.size.width, self.mCaloriDetailTableView_.frame.size.height);
    
    //to caluclate table height
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollView.frame = CGRectMake(self.mScrollView.frame.origin.x, self.mScrollView.frame.origin.y, self.mScrollView.frame.size.width, 504);
    }
    self.mScrollView.contentSize = CGSizeMake(320, self.mCaloriDetailTableView_.frame.origin.y+self.mCaloriDetailTableView_.frame.size.height+20);

}
- (void)loadrecipeDetails{
    for (UIView *lView in self.mRecipeView.subviews) {
        [lView removeFromSuperview];
    }
    //ingredients label
    UILabel *lLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 25)];
    lLabel.font = Bariol_Regular(22);
    lLabel.textColor = RGB_A(136, 136, 136, 1);
    lLabel.text = @"Ingredients";
    lLabel.backgroundColor = CLEAR_COLOR;
    [self.mRecipeView addSubview:lLabel];
    
    UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 320, 1)];
    lImgView.image = [UIImage imageNamed:@"mealdivider.png"];
    [self.mRecipeView addSubview:lImgView];
    
    //load recipe ingredients
    CGFloat yPos = lImgView.frame.origin.y+lImgView.frame.size.height+15;
    for (int i =0 ; i < [[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"RecipeIngredients"] count]; i++) {
        UILabel *lNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, yPos, 180, 20)];
        lNameLbl.font = Bariol_Regular(17);
        lNameLbl.textAlignment = UITextAlignmentLeft;
        lNameLbl.text = [[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"RecipeIngredients"] objectAtIndex:i] objectForKey:@"FoodName"];
        lNameLbl.textColor = BLACK_COLOR;
        [self.mRecipeView addSubview:lNameLbl];
        
        //unit label
        UILabel *lUnitNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(195, yPos, 100, 20)];
        lUnitNameLbl.font = Bariol_Regular(17);
        lUnitNameLbl.text = [NSString stringWithFormat:@"%.1f",[[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"RecipeIngredients"] objectAtIndex:i] objectForKey:@"Qty"] floatValue] ];
        lUnitNameLbl.textAlignment = UITextAlignmentRight;
        lUnitNameLbl.text = [lUnitNameLbl.text stringByAppendingString:@" "];

        lUnitNameLbl.text = [lUnitNameLbl.text stringByAppendingString:[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"RecipeIngredients"] objectAtIndex:i] objectForKey:@"Unit"]];
        lUnitNameLbl.textColor = BLACK_COLOR;
        [self.mRecipeView addSubview:lUnitNameLbl];
        yPos+= 20+10;

    }
    yPos+=45;
    //ingredients label
    UILabel *lDirecLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, yPos, 290, 25)];
    lDirecLabel.font = Bariol_Regular(22);
    lDirecLabel.textColor = RGB_A(136, 136, 136, 1);
    lDirecLabel.text = @"Directions";
    lDirecLabel.backgroundColor = CLEAR_COLOR;
    [self.mRecipeView addSubview:lDirecLabel];
    yPos+=25+5;
    UIImageView *lImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, yPos, 320, 1)];
    lImgView2.image = [UIImage imageNamed:@"mealdivider.png"];
    [self.mRecipeView addSubview:lImgView2];
    yPos+=15;
    
    //load recipe directions
    UILabel *mDirectionsLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, yPos, 290, 20)];
    mDirectionsLbl.font  = Bariol_Regular(17);
    mDirectionsLbl.textColor = BLACK_COLOR;
    mDirectionsLbl.text = [mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"RecipeDirections"];
    CGSize size =  [mDirectionsLbl.text sizeWithFont:mDirectionsLbl.font constrainedToSize:CGSizeMake(mDirectionsLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (size.height < 20) {
        size.height = 20;
    }
    mDirectionsLbl.frame = CGRectMake(15, yPos, 290, size.height);
    [self.mRecipeView addSubview:mDirectionsLbl];
    yPos+=size.height;
    
    self.mRecipeView.frame = CGRectMake(0, self.mRecipeView.frame.origin.y, self.mRecipeView.frame.size.width, yPos+35);
}
- (IBAction)editQtyButtonAction:(id)sender {
    [self displayPickerview];

}
- (void)displayPickerview {
    
    [self getUnitToDisplay];
    PickerViewController *screen = [[PickerViewController alloc] init];
    screen.mRowValueintheComponent=self.mRowValueintheComponent;
    screen->mNoofComponents=[self.mRowValueintheComponent count];
    screen.mTextDisplayedlb.text=@"Select Quantity";
    
    //[screen addSubview:screen.mViewPicker_];
    // *********** ************* reloading the components to the value in the particular textfield *************** **************
    
    if(![self.mFoodQtyLbl_.text isEqualToString:@""]){
        //NSLog(@"mquantity_ %@",[NSString stringWithFormat:@"%.2f",mQuantity_]);
        //NSLog(@"mRowValueintheComponent %@",mRowValueintheComponent);
        for (int i=0; i<[[mRowValueintheComponent objectAtIndex:0] count]; i++) {// reload the first component
            if ([[NSString stringWithFormat:@"%.1f",[[[mRowValueintheComponent objectAtIndex:0] objectAtIndex:i] floatValue]] isEqualToString:[NSString stringWithFormat:@"%.1f",mQuantity_]]) {
                [screen.mViewPicker_ selectRow:i inComponent:0 animated:YES];
                [screen.mViewPicker_ reloadComponent:0];
            }
        }
        for (int i=0; i<[[mRowValueintheComponent objectAtIndex:1] count]; i++) {// reload the second component
            if ([[[mRowValueintheComponent objectAtIndex:1] objectAtIndex:i] isEqualToString:[[mRowValueintheComponent objectAtIndex:1] objectAtIndex:mSelectedindexpath]]) {
                [screen.mViewPicker_ selectRow:i inComponent:1 animated:YES];
                [screen.mViewPicker_ reloadComponent:1];
            }
        }
    }
    
    [screen setMPickerViewDelegate_:self];
    [screen setMSelectedTextField_:nil];
    [mAppDelegate.window addSubview:screen];
    
}
- (void)getUnitToDisplay {
    
    NSMutableArray *lRow2ValueArr=[[NSMutableArray alloc] init];
    for( int i=0 ;i<[[mAppDelegate.mDataGetter_.mFoodInfoDict_  objectForKey:@"Units"] count];i++) {
        NSString *unitName = [[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:i] objectForKey:@"UnitName"];
        unitName = (unitName!=nil)?unitName:@"";
        [lRow2ValueArr addObject:unitName];
    }
    NSArray *lRow1ValueArr;
    
    if([[lRow2ValueArr objectAtIndex:mSelectedindexpath] isEqualToString:@"grams"]||[[lRow2ValueArr objectAtIndex:mSelectedindexpath] isEqualToString:@"ml"]||[[lRow2ValueArr objectAtIndex:mSelectedindexpath] isEqualToString:@"cc"]||[[lRow2ValueArr objectAtIndex:mSelectedindexpath] isEqualToString:@"cc"]||[[lRow2ValueArr objectAtIndex:mSelectedindexpath] isEqualToString:@"gm"]||[[lRow2ValueArr objectAtIndex:mSelectedindexpath] isEqualToString:@"mg"]) {
        
        lRow1ValueArr=[KQuantityHigh componentsSeparatedByString:@","];
    } else if([[lRow2ValueArr objectAtIndex:mSelectedindexpath] isEqualToString:@"cup"]) {
        
        lRow1ValueArr=[KQuantityLow componentsSeparatedByString:@","];
        
    }else {
        
        lRow1ValueArr=[KQuantityMedium componentsSeparatedByString:@","];
        
    }
    [self.mRowValueintheComponent removeAllObjects];
    [self.mRowValueintheComponent addObject:lRow1ValueArr];
    [self.mRowValueintheComponent addObject:lRow2ValueArr];
  
    
}
- (void)getMQuantityIndex:(NSString *)quantityName {
   // int mQuantityIndex_ = 0;
    DLog(@"quantityName%@", quantityName);
    if(quantityName!=nil){
        
        for( int i=0 ;i<[[mAppDelegate.mDataGetter_.mFoodInfoDict_  objectForKey:@"Units"] count];i++) {
            NSString *unitName = [[[mAppDelegate.mDataGetter_.mFoodInfoDict_  objectForKey:@"Units"] objectAtIndex:i] objectForKey:@"UnitName"];
            if([unitName isEqualToString:quantityName]){
               // mQuantityIndex_=i;
            }
        }
    }
    
}
// *********** Custom delegate method which is fired when the picker value changed ************** //
- (void)didChangeTheRowIncomponet:(PickerViewController *)controller 
                           picker:(UIPickerView *)pickerView 
                     didSelectRow:(NSInteger)row 
                      inComponent:(NSInteger)component {
    
    if(component==1) {
        NSArray *lRow1ValueArr;
        if([[[controller.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row] isEqualToString:@"grams"]||[[[controller.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row] isEqualToString:@"ml"]||[[[controller.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row] isEqualToString:@"cc"]||[[[controller.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row] isEqualToString:@"gm"]||[[[controller.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row] isEqualToString:@"mg"]) {
            
            lRow1ValueArr=[KQuantityHigh componentsSeparatedByString:@","];
            
        } else if([[[controller.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row] isEqualToString:@"cup"]) {
            DLog(@"[[controller.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row] %@",[[controller.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row]);
            lRow1ValueArr=[KQuantityLow componentsSeparatedByString:@","];
            
        } else {
            DLog(@"[[controller.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row] %@",[[controller.mRowValueintheComponent objectAtIndex:1] objectAtIndex:row]);
            lRow1ValueArr=[KQuantityMedium componentsSeparatedByString:@","];
            
        }
        [controller.mRowValueintheComponent removeObjectAtIndex:0];
        [controller.mRowValueintheComponent insertObject:lRow1ValueArr atIndex:0];
        [controller.mViewPicker_ selectRow:0 inComponent:0 animated:YES];
        [controller.mViewPicker_ reloadComponent:0];
        
    logicToReset:{
        float quantity_ = [[[[mAppDelegate.mDataGetter_.mFoodInfoDict_  objectForKey:@"Units"] objectAtIndex:row] valueForKey:@"Qty"] floatValue];
        //NSLog(@"mquantity_ %@",[NSString stringWithFormat:@"%.0f",quantity_]);
        //NSLog(@"mRowValueintheComponent %@",mRowValueintheComponent);
        for (int i=0; i<[[mRowValueintheComponent objectAtIndex:0] count]; i++) {
            if ([[[mRowValueintheComponent objectAtIndex:0] objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%.0f",quantity_]]) {
                [controller.mViewPicker_ selectRow:i inComponent:0 animated:YES];
                [controller.mViewPicker_ reloadComponent:0];
            }
        }
    }
    } 
}

- (void)pickerViewController:(PickerViewController *)controller 
                 didPickComp:(NSMutableArray *)valueArr 
                      isDone:(BOOL)isDone {
    //int mQuantityIndex_ = 0;
    if(isDone==YES)
    {
        
        for(int i=0;i<[valueArr count];i++){
            mSelectedIndex =i;
            if (i==0) {
                mQuantity_=[[valueArr objectAtIndex:i] floatValue];

            }
            
        for (int j=0; j<[[mRowValueintheComponent objectAtIndex:1] count]; j++) {
            if ([[[mRowValueintheComponent objectAtIndex:1] objectAtIndex:j] isEqualToString:[valueArr objectAtIndex:i]]) {
                        mSelectedindexpath = j;
                        
                    }
            }
        }
        [self updateTheFoodDetailScreen];

        [self.mCaloriDetailTableView_ reloadData];
        if (self.isReported) {
            [mAppDelegate showCustomAlert:@"" Message:@"Your food quantity was updated."];

        }
          }
    if([controller superview]){
        [controller removeFromSuperview];
    }
}
//  **************      Refresh the screen  when the quantity changed      *********  //

- (void)updateTheFoodDetailScreen {
   
    float quantity=(float)mQuantity_/[[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:mSelectedindexpath] valueForKey:@"Qty"] floatValue];
    quantity = quantity * [[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:mSelectedindexpath] valueForKey:@"Factor"] floatValue];
    DLog(@"%.1f", mQuantity_);
    NSString *tempData=[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Calories"];
    if(tempData!=nil) {
        float calorieValue=[tempData floatValue]*quantity;
        //calorieValue = ceilf(calorieValue);
        tempData = [NSString stringWithFormat:@"%.1f",calorieValue];
    }
    self.mCaloriesLable_.text = tempData;
   CGSize size =  [self.mCaloriesLable_.text sizeWithFont:self.mCaloriesLable_.font constrainedToSize:CGSizeMake(300, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mCaloriesLable_.frame = CGRectMake(self.mCalLbl_.frame.origin.x+self.mCalLbl_.frame.size.width+5, self.mCalLbl_.frame.origin.y, size.width, self.mCaloriesLable_.frame.size.height);
    self.mFatLbl_.frame = CGRectMake(self.mCalLbl_.frame.origin.x, self.mCalLbl_.frame.origin.y+self.mCalLbl_.frame.size.height+10, self.mFatLbl_.frame.size.width, self.mFatLbl_.frame.size.height);

    
    tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"CaloriesFromFat"];
    
    if(tempData!=nil) {
        int calorieValue=[tempData floatValue]*quantity;
        //calorieValue = ceilf(calorieValue);
        tempData = [NSString stringWithFormat:@"%d",calorieValue];
        self.mCaloriesFromFatLable_.text = tempData;
    }
    size =  [self.mCaloriesFromFatLable_.text sizeWithFont:self.mCaloriesFromFatLable_.font constrainedToSize:CGSizeMake(3000, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    self.mCaloriesFromFatLable_.frame = CGRectMake(self.mFatLbl_.frame.origin.x+self.mFatLbl_.frame.size.width+3, self.mFatLbl_.frame.origin.y,size.width, self.mCaloriesFromFatLable_.frame.size.height);

    
    self.mFoodNameLable_.text = [mAppDelegate.mDataGetter_.mFoodInfoDict_  valueForKey:@"FoodName"];
    
    NSString *quantityName = [[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:mSelectedindexpath] valueForKey:@"UnitName"];
   
    //self.mFoodQtyLbl_.text = [NSString stringWithFormat:@"%.1f %@", mQuantity_,quantityName];
    self.mFoodQtyLbl_.text = [NSString stringWithFormat:@"%.1f", mQuantity_];
    self.mFoodUnitNameLbl_.text = quantityName;
    [self adjustTheBottomUILayoutBasedOnText];
  
}


#pragma mark - **************  TableView Delegate methods  *************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  13;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
        UIView *lSelectedView_ = [[UIView alloc] init];
        lSelectedView_.backgroundColor =SELECTED_CELL_COLOR; 
        cell.selectedBackgroundView = lSelectedView_;
       
        //for background imageview
        UIImageView *lImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        lImgView.tag = 4;
        [cell.contentView addSubview:lImgView];
        
        int yposition=5;
        /* 
         * Food Name Label
         */
        UILabel *foodNmaeLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, yposition, 150, 20)];
        foodNmaeLbl.textColor=BLACK_COLOR;
        foodNmaeLbl.font=Bariol_Regular(17);
        foodNmaeLbl.backgroundColor=CLEAR_COLOR;
        foodNmaeLbl.tag=1;
        [cell.contentView addSubview:foodNmaeLbl];
      
        
        /* 
         * Food Calorie value label
         */
        UILabel *foodCalorieLbl = [[UILabel alloc]initWithFrame:CGRectMake(165, yposition, 80, 20)];
        foodCalorieLbl.tag=2;
        foodCalorieLbl.backgroundColor=CLEAR_COLOR;
        foodCalorieLbl.textColor=BLACK_COLOR;
        foodCalorieLbl.textAlignment = UITextAlignmentRight;
        foodCalorieLbl.font=Bariol_Regular(17);
        [cell.contentView addSubview:foodCalorieLbl];
               
        /* 
         * Food Calorie Percent (%) label
         */
        UILabel *foodCaloriePercentLbl = [[UILabel alloc]initWithFrame:CGRectMake(265, yposition, 60, 20)];
        foodCaloriePercentLbl.tag=3;
        foodCaloriePercentLbl.backgroundColor=[UIColor clearColor];
        foodCaloriePercentLbl.textColor=BLACK_COLOR;
        foodCaloriePercentLbl.font=Bariol_Bold(17);
        foodCaloriePercentLbl.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:foodCaloriePercentLbl];
      
        
    }
    UIImageView *lImgView = (UIImageView*)[cell.contentView viewWithTag:4];
    lImgView.backgroundColor = CLEAR_COLOR;
    if (indexPath.row%2 == 0) {
        lImgView.image = nil;//[UIImage imageNamed:@"selectedbar1.png"];
        lImgView.backgroundColor = RGB_A(251, 242, 230, 1);

        
    }else{
        lImgView.image = nil;
        lImgView.backgroundColor = WHITE_COLOR;
    }
    
    [self updateTheFoodDetailScreen];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    [self populateFormsSectionWithIndexPath:indexPath cell:cell tableView:tableView];
    return cell;
}
// *************** Populate the data in to the cell content  ***************  //
- (void)populateFormsSectionWithIndexPath:(NSIndexPath*)indexPath 
									 cell:(UITableViewCell*)tableViewCell
								tableView:(UITableView*)tabelView {
    
    UILabel *foodCalorieLbl = (UILabel *)[tableViewCell.contentView viewWithTag:2];
    UILabel *foodCaloriePercentLbl = (UILabel *)[tableViewCell.contentView viewWithTag:3];
    
    UILabel *foodNmaeLbl = (UILabel *)[tableViewCell.contentView viewWithTag:1];
    foodNmaeLbl.text = [self.mFoodDetailLeftArr_ objectAtIndex:indexPath.row];
    
     float quantity=(float)mQuantity_/[[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:mSelectedindexpath] valueForKey:@"Qty"] floatValue];
    quantity = quantity * [[[[mAppDelegate.mDataGetter_.mFoodInfoDict_ objectForKey:@"Units"] objectAtIndex:mSelectedindexpath] valueForKey:@"Factor"] floatValue];

//    [self resetTableViews:tableViewCell];
    switch (indexPath.row) {
        case 0:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"Fat"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
               // calorieValue = roundf(calorieValue);//ceilf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.1f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@""; // **** mg for only sodium and cholesterol
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"FatPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;

            
        }
            break;

        case 1:
        {
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"SatFat"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                //calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.1f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@""; // **** mg for only sodium and cholesterol
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"SatFatPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break;

        case 2:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"TransFat"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@""; // **** mg for only sodium and cholesterol
            foodCalorieLbl.text = tempData;

            foodCaloriePercentLbl.text = @"";
            
        }
            break;

        case 3:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"]  valueForKey:@"Cholesterol"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" mg"]:@"";// **** mg for only sodium and cholesterol
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"CholesterolPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break;
        case 4:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"Sodium"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" mg"]:@""; // **** mg for only sodium and cholesterol
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"SodiumPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break;
        case 5:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"Carbohydrate"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@"";
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"CarbohydratePercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break; 
        case 6:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"Fiber"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@"";
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"FiberPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break; 
        case 7:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"Sugars"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@"";
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"SugarsPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break; 
        case 8:
        {
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"Protein"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@"";
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"ProteinPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break;
        case 9:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"VitA"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@"";
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"VitaminAPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break;
        case 10:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"VitC"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@"";
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"VitaminCPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break;
        case 11:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"Calcium"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@"";
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"CalciumPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break;
        case 12:
        {
            
            NSString *tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"Iron"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" g"]:@"";
            foodCalorieLbl.text = tempData;
            
            tempData = [[mAppDelegate.mDataGetter_.mFoodInfoDict_ valueForKey:@"Nutrition"] valueForKey:@"IronPercentage"];
            if(tempData!=nil) {
                float calorieValue=[tempData floatValue]*quantity;
                calorieValue = roundf(calorieValue);
                tempData = [NSString stringWithFormat:@"%.0f",calorieValue];
            }
            tempData = (tempData!=nil)?[tempData stringByAppendingString:@" %"]:@"";
            foodCaloriePercentLbl.text = tempData;
            
        }
            break;
            
        default:
            break;
    }
    
}
- (void)resetTableViews:(UITableViewCell*)tableViewCell {
    
	int tagCount=1;
	//reset uilabels	
    for (tagCount=1; tagCount<=3 ;tagCount++) {
        UILabel *lUILabel=(UILabel*)[tableViewCell viewWithTag:tagCount];
        lUILabel.text=nil;
	}
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
}

#pragma mark - **************  Memory Management  *************

- (void)viewDidUnload
{
    [self setMFoodNameLable_:nil];
    [self setMCaloriesLable_:nil];
    [self setMCaloriesFromFatLable_:nil];
    [self setMCaloriDetailTableView_:nil];
    [self setMFoodDetailLeftArr_:nil];

    [self setMFoodQtyLbl_:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
