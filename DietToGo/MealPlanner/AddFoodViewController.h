//
//  AddFoodViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 29/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "DropDownView.h"
#import "IconDownloader.h"
@class AppDelegate;
@class FoodDetailsViewController;

@interface AddFoodViewController : GAITrackedViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,DropDownViewDelegate,IconDownloaderDelegate>
{
    /**
     * AppDelegate instance variable creation
     */
    AppDelegate *mAppDelegate_;
    NSString *mFoodID;
    
    //Recent Foods
    BOOL isRecentFoods;
    //Auto Search Foods
    BOOL isAutoSearchFoods;
    //DropDownView
    DropDownView *dropDownView;
    //Auto Search
    NSString *mlastAutoSearch;
}
//App Recored
@property (strong, nonatomic) NSMutableDictionary *imageDownloadsInProgress;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *msearchBtn;
@property (weak, nonatomic) IBOutlet UIButton *mfavoritesBtn;
@property (strong, nonatomic) IBOutlet UIButton *mDTGBtn;
@property (weak, nonatomic) IBOutlet UIButton *mMyFoodBtn;
@property (weak, nonatomic) IBOutlet UIImageView *mImgView;
@property (weak, nonatomic) IBOutlet UILabel *mLbl;
@property (nonatomic,retain) FoodDetailsViewController *mFoodDetailsViewController;
@property (nonatomic,retain) NSMutableArray *mSearchFoodArr;
@property (nonatomic,retain) NSMutableArray *lAuroSearchArray;

- (IBAction)searchAction:(id)sender;
- (IBAction)favoritesAction:(id)sender;
- (IBAction)DTGMealsAction:(id)sender;
- (IBAction)myFoodsAction:(id)sender;
- (IBAction)createNewFoodAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *mCreateNewFood;
-(void)postRequestForPrivateFood;
/*
 * method to reload table data
 */
- (void)reloadContentsOfTableView;
/*
 * method to push to detail page
 */
- (void)pushToDetailPage;
@end
