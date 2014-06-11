//
//  FoodDetailsViewController.h
//  SensaApplication
//
//  Created by Valuelabs on 10/04/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PickerViewController.h"
#import "GAITrackedViewController.h"


@interface FoodDetailsViewController : GAITrackedViewController<PickerViewControllerDelegate> {
    
    /**
     * AppDelegate object creating
     */

    AppDelegate *mAppDelegate;
    
    /**
     * Variable to store the quantity of food.
     */

    float mQuantity_;
   


}
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UILabel *mFoodCommentLbl_;
@property (weak, nonatomic) IBOutlet UILabel *mFoodUnitNameLbl_;
@property (weak, nonatomic) IBOutlet UILabel *mAmountPerSerLbl_;
@property (weak, nonatomic) IBOutlet UIImageView *mLineIImgView_;
@property (weak, nonatomic) IBOutlet UIImageView *mLine2ImgView_;
@property (weak, nonatomic) IBOutlet UILabel *mCalLbl_;
@property (weak, nonatomic) IBOutlet UILabel *mFatLbl_;
@property (weak, nonatomic) IBOutlet UILabel *mdialyCalLbl;
@property (strong, nonatomic) IBOutlet UILabel *mBrandNameLbl;
- (IBAction)editQtyButtonAction:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *mFoodNameLable_;
@property (retain, nonatomic) IBOutlet UILabel *mCaloriesLable_;
@property (retain, nonatomic) IBOutlet UILabel *mCaloriesFromFatLable_;
@property (retain, nonatomic) IBOutlet UITableView *mCaloriDetailTableView_;
@property (retain, nonatomic) NSMutableArray *mFoodDetailLeftArr_;
@property (retain, nonatomic) IBOutlet UILabel *mFoodQtyLbl_;
@property (retain ,nonatomic) NSMutableArray *mRowValueintheComponent;
@property (retain, nonatomic) NSString *mIsfavorite;
@property (nonatomic) BOOL isReported;
@property (nonatomic,retain) NSString *mSelectedId;


@property (retain, nonatomic) NSString *percentString;

@property (retain, nonatomic) NSDate *mDisplayedDate_;
@property (retain, nonatomic) NSDateFormatter *mFormatter_;
@property (retain, nonatomic) NSString *mCurrentDate_;
@property (strong, nonatomic) IBOutlet UIButton *mEditQuantityBtn;
@property (strong, nonatomic) IBOutlet UIView *mRecipeView;

@property (retain, nonatomic) NSString * mFoodId;
@property( nonatomic) int mSelectedIndex;
@property (nonatomic) int mSelectedindexpath;

-(void)loadDetails;
/**
 *Populate the data in to the cell content 
 * @param indexPath which hold the indexpath for the current cell
 * @param tableViewCell which hold the cell 
 * @param tabelView which hold the table name
 */
- (void)populateFormsSectionWithIndexPath:(NSIndexPath*)indexPath 
									 cell:(UITableViewCell*)tableViewCell
								tableView:(UITableView*)tabelView;

/**
 * Displays the datepicker 
 */
- (void)displayPickerview;

/**
 * Displays units of food 
 */
- (void)getUnitToDisplay;
/**
 * Update  units of food 
 */
- (void)updateTheFoodDetailScreen;
/**
 * Method used to update the Ui layout
 */
- (void)adjustTheBottomUILayoutBasedOnText;
/*
 * method used to load recipe details if the food is a recipe type
 */
- (void)loadrecipeDetails;

@end
