//
//  AddEditFoodDetailController.h
//  EHEandme
//
//  Created by Suresh on 2/18/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface AddEditFoodDetailController : GAITrackedViewController<UITextFieldDelegate,PickerViewControllerDelegate> {
    /**
     * AppDelegate instance variable creation
     */
    AppDelegate *mAppDelegate_;
}
@property BOOL isEdit;
@property(nonatomic,retain) NSMutableArray *mCategoryArr;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property(nonatomic,retain) UITextField *mActiveTxtFld;
@property(nonatomic,retain) UIImage *mPreview;
@property(nonatomic,retain) NSMutableArray *mSaveArr;
@property(nonatomic,retain) NSMutableArray *mMealTimeArr;

//For Edit
@property(nonatomic,retain) NSMutableDictionary *mEditDict;
@property(nonatomic,retain) NSString* mealType;
@end
